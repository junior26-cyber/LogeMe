from rest_framework.permissions import BasePermission
from apps.users.models import User


class IsOwnerOrAgency(BasePermission):
    def has_permission(self, request, view):
        return request.user.role in [User.Role.OWNER, User.Role.AGENCY]


class IsListingOwner(BasePermission):
    def has_object_permission(self, request, view, obj):
        return obj.owner_id == request.user.id
