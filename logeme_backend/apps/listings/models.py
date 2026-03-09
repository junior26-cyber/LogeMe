from django.conf import settings
from django.db import models


class Listing(models.Model):
    class ListingType(models.TextChoices):
        STUDIO = 'studio', 'Studio'
        APARTMENT = 'apartment', 'Appartement'
        ROOM = 'room', 'Chambre'
        VILLA = 'villa', 'Villa'
        LAND = 'land', 'Terrain'

    owner = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='listings')
    title = models.CharField(max_length=255)
    description = models.TextField()
    price = models.PositiveIntegerField()
    type = models.CharField(max_length=20, choices=ListingType.choices)
    neighborhood = models.CharField(max_length=120)
    city = models.CharField(max_length=100, default='Lomé')
    country = models.CharField(max_length=100, default='Togo')
    gps_latitude = models.DecimalField(max_digits=10, decimal_places=7)
    gps_longitude = models.DecimalField(max_digits=10, decimal_places=7)
    is_verified = models.BooleanField(default=False)
    is_active = models.BooleanField(default=True)
    view_count = models.PositiveIntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ['-created_at']


class ListingPhoto(models.Model):
    listing = models.ForeignKey(Listing, on_delete=models.CASCADE, related_name='photos')
    image = models.ImageField(upload_to='listings/')
    created_at = models.DateTimeField(auto_now_add=True)
