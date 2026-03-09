from rest_framework import serializers

from .models import Listing, ListingPhoto


class ListingPhotoSerializer(serializers.ModelSerializer):
    class Meta:
        model = ListingPhoto
        fields = ['id', 'image']


class ListingSerializer(serializers.ModelSerializer):
    photos = ListingPhotoSerializer(many=True, read_only=True)
    owner_name = serializers.CharField(source='owner.full_name', read_only=True)
    owner_phone = serializers.CharField(source='owner.phone', read_only=True)

    class Meta:
        model = Listing
        fields = [
            'id', 'title', 'description', 'price', 'type', 'neighborhood', 'city', 'country',
            'gps_latitude', 'gps_longitude', 'photos', 'owner', 'owner_name', 'owner_phone',
            'is_verified', 'is_active', 'view_count', 'created_at', 'updated_at'
        ]
        read_only_fields = ['owner', 'is_verified', 'view_count', 'created_at', 'updated_at']


class ListingCreateUpdateSerializer(serializers.ModelSerializer):
    uploaded_photos = serializers.ListField(
        child=serializers.ImageField(),
        write_only=True,
        required=False,
    )

    class Meta:
        model = Listing
        exclude = ['owner', 'is_verified', 'view_count', 'created_at', 'updated_at']

    def create(self, validated_data):
        photos = validated_data.pop('uploaded_photos', [])
        listing = Listing.objects.create(**validated_data)
        for image in photos:
            ListingPhoto.objects.create(listing=listing, image=image)
        return listing

    def update(self, instance, validated_data):
        photos = validated_data.pop('uploaded_photos', None)
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()
        if photos is not None:
            for image in photos:
                ListingPhoto.objects.create(listing=instance, image=image)
        return instance
