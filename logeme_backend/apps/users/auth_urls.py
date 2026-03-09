from django.urls import path
from .views import ForgotPasswordView, LoginView, LogoutView, RegisterView, VerifyEmailView

urlpatterns = [
    path('register/', RegisterView.as_view()),
    path('login/', LoginView.as_view()),
    path('logout/', LogoutView.as_view()),
    path('verify-email/', VerifyEmailView.as_view()),
    path('forgot-password/', ForgotPasswordView.as_view()),
]
