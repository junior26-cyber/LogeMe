from rest_framework import generics, permissions

from apps.users.models import User
from .models import Report
from .serializers import ReportSerializer


class IsTenant(permissions.BasePermission):
    def has_permission(self, request, view):
        return request.user.role == User.Role.TENANT


class ReportCreateView(generics.CreateAPIView):
    serializer_class = ReportSerializer
    permission_classes = [permissions.IsAuthenticated, IsTenant]
    queryset = Report.objects.all()

    def perform_create(self, serializer):
        serializer.save(reporter=self.request.user)
