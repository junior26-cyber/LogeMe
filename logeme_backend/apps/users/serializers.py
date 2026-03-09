from django.contrib.auth import authenticate
from rest_framework import serializers
from rest_framework_simplejwt.tokens import RefreshToken

from .models import User


class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            'id', 'full_name', 'email', 'phone', 'role', 'profile_photo',
            'is_email_verified', 'is_phone_verified', 'pending_verification', 'created_at'
        ]
        read_only_fields = ['id', 'is_email_verified', 'is_phone_verified', 'pending_verification', 'created_at']


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)

    class Meta:
        model = User
        fields = ['full_name', 'email', 'phone', 'password', 'role', 'id_document']

    def create(self, validated_data):
        role = validated_data.get('role')
        if role in [User.Role.OWNER, User.Role.AGENCY] and validated_data.get('id_document'):
            validated_data['pending_verification'] = True
        user = User.objects.create_user(**validated_data)
        return user


class LoginSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)

    def validate(self, attrs):
        user = authenticate(email=attrs.get('email'), password=attrs.get('password'))
        if not user:
            raise serializers.ValidationError('Identifiants invalides.')
        if not user.is_email_verified:
            raise serializers.ValidationError('Email non vérifié. Veuillez confirmer votre email.')
        attrs['user'] = user
        return attrs


class TokenSerializer(serializers.Serializer):
    access = serializers.CharField()
    refresh = serializers.CharField()
    user = UserSerializer()


class ForgotPasswordSerializer(serializers.Serializer):
    email = serializers.EmailField()


class VerifyEmailSerializer(serializers.Serializer):
    email = serializers.EmailField()


class UserUpdateSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['full_name', 'email', 'phone', 'profile_photo']


def build_auth_response(user):
    refresh = RefreshToken.for_user(user)
    return {
        'access': str(refresh.access_token),
        'refresh': str(refresh),
        'user': UserSerializer(user).data,
    }
