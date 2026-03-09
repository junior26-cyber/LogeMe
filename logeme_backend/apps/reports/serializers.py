from rest_framework import serializers

from .models import Report


class ReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = Report
        fields = ['id', 'reporter', 'listing', 'reason', 'created_at']
        read_only_fields = ['reporter', 'created_at']
