from django.db.models import F, Sum
from rest_framework import generics, permissions
from rest_framework.exceptions import PermissionDenied
from rest_framework.parsers import FormParser, MultiPartParser
from rest_framework.response import Response

from .models import Listing
from .permissions import IsListingOwner, IsOwnerOrAgency
from .serializers import ListingCreateUpdateSerializer, ListingSerializer


class ListingListCreateView(generics.ListCreateAPIView):
    queryset = Listing.objects.filter(is_active=True).select_related('owner').prefetch_related('photos')
    serializer_class = ListingSerializer
    parser_classes = [MultiPartParser, FormParser]

    def get_permissions(self):
        if self.request.method == 'POST':
            return [permissions.IsAuthenticated(), IsOwnerOrAgency()]
        return [permissions.AllowAny()]

    def get_serializer_class(self):
        if self.request.method == 'POST':
            return ListingCreateUpdateSerializer
        return ListingSerializer

    def get_queryset(self):
        queryset = self.queryset
        params = self.request.query_params
        if params.get('price_min'):
            queryset = queryset.filter(price__gte=params['price_min'])
        if params.get('price_max'):
            queryset = queryset.filter(price__lte=params['price_max'])
        if params.get('neighborhood'):
            queryset = queryset.filter(neighborhood__icontains=params['neighborhood'])
        if params.get('type'):
            queryset = queryset.filter(type=params['type'])
        if params.get('city'):
            queryset = queryset.filter(city__icontains=params['city'])
        return queryset

    def perform_create(self, serializer):
        if self.request.user.role in ['owner', 'agency'] and not self.request.user.id_document:
            raise PermissionDenied(
                'Pièce d’identité obligatoire pour publier une annonce.'
            )
        if self.request.user.role in ['owner', 'agency']:
            self.request.user.pending_verification = True
            self.request.user.save(update_fields=['pending_verification'])
        serializer.save(owner=self.request.user)


class ListingRetrieveUpdateDeleteView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Listing.objects.select_related('owner').prefetch_related('photos')

    def get_permissions(self):
        if self.request.method in ['PUT', 'PATCH', 'DELETE']:
            return [permissions.IsAuthenticated(), IsOwnerOrAgency(), IsListingOwner()]
        return [permissions.AllowAny()]

    def get_serializer_class(self):
        if self.request.method in ['PUT', 'PATCH']:
            return ListingCreateUpdateSerializer
        return ListingSerializer

    def retrieve(self, request, *args, **kwargs):
        instance = self.get_object()
        Listing.objects.filter(pk=instance.pk).update(view_count=F('view_count') + 1)
        instance.refresh_from_db()
        serializer = self.get_serializer(instance)
        return Response(serializer.data)


class MyListingsView(generics.ListAPIView):
    serializer_class = ListingSerializer
    permission_classes = [permissions.IsAuthenticated, IsOwnerOrAgency]

    def get_queryset(self):
        return Listing.objects.filter(owner=self.request.user).select_related('owner').prefetch_related('photos')


class AgencyStatsView(generics.GenericAPIView):
    permission_classes = [permissions.IsAuthenticated, IsOwnerOrAgency]

    def get(self, request):
        listings = Listing.objects.filter(owner=request.user)
        total_listings = listings.count()
        total_views = listings.aggregate(total=Sum('view_count')).get('total') or 0
        contacts_received = total_views
        return Response(
            {
                'total_listings': total_listings,
                'total_views': total_views,
                'contacts_received': contacts_received,
            }
        )
