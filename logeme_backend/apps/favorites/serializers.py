from rest_framework import serializers

from apps.listings.serializers import ListingSerializer
from .models import Favorite


class FavoriteSerializer(serializers.ModelSerializer):
    listing_data = ListingSerializer(source='listing', read_only=True)

    class Meta:
        model = Favorite
        fields = ['id', 'tenant', 'listing', 'listing_data', 'created_at']
        read_only_fields = ['tenant', 'created_at']
