from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView
from .views import (
    ForgotPasswordView,
    LoginView,
    LogoutView,
    RegisterView,
    RequestEmailVerificationView,
    ResetPasswordConfirmView,
    VerifyEmailView,
)

urlpatterns = [
    path('register/', RegisterView.as_view()),
    path('login/', LoginView.as_view()),
    path('refresh/', TokenRefreshView.as_view()),
    path('logout/', LogoutView.as_view()),
    path('request-email-verification/', RequestEmailVerificationView.as_view()),
    path('verify-email/', VerifyEmailView.as_view()),
    path('forgot-password/', ForgotPasswordView.as_view()),
    path('reset-password-confirm/', ResetPasswordConfirmView.as_view()),
]
