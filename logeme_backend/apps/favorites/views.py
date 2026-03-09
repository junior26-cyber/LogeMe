from rest_framework import generics, permissions

from apps.users.models import User
from .models import Favorite
from .serializers import FavoriteSerializer


class IsTenant(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user.role == User.Role.TENANT


class FavoriteListCreateView(generics.ListCreateAPIView):
    serializer_class = FavoriteSerializer
    permission_classes = [permissions.IsAuthenticated, IsTenant]

    def get_queryset(self):
        return Favorite.objects.filter(tenant=self.request.user).select_related('listing', 'listing__owner')

    def perform_create(self, serializer):
        serializer.save(tenant=self.request.user)


class FavoriteDeleteView(generics.DestroyAPIView):
    serializer_class = FavoriteSerializer
    permission_classes = [permissions.IsAuthenticated, IsTenant]

    def get_queryset(self):
        return Favorite.objects.filter(tenant=self.request.user)
