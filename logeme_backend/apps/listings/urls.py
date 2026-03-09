from django.urls import path
from .views import AgencyStatsView, ListingListCreateView, ListingRetrieveUpdateDeleteView, MyListingsView

urlpatterns = [
    path('', ListingListCreateView.as_view()),
    path('my/', MyListingsView.as_view()),
    path('stats/', AgencyStatsView.as_view()),
    path('<int:pk>/', ListingRetrieveUpdateDeleteView.as_view()),
]
