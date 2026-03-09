import '../../core/constants/api_constants.dart';

class ListingModel {
  final int id;
  final int ownerId;
  final String title;
  final String description;
  final int price;
  final String type;
  final String neighborhood;
  final String city;
  final double lat;
  final double lng;
  final String ownerName;
  final String ownerPhone;
  final List<String> photos;

  ListingModel({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.price,
    required this.type,
    required this.neighborhood,
    required this.city,
    required this.lat,
    required this.lng,
    required this.ownerName,
    required this.ownerPhone,
    required this.photos,
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    final rawPhotos = (json['photos'] as List?) ?? [];
    return ListingModel(
      id: json['id'] ?? 0,
      ownerId: json['owner'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: json['price'] ?? 0,
      type: json['type'] ?? '',
      neighborhood: json['neighborhood'] ?? '',
      city: json['city'] ?? 'Lomé',
      lat: double.tryParse((json['gps_latitude'] ?? '0').toString()) ?? 0,
      lng: double.tryParse((json['gps_longitude'] ?? '0').toString()) ?? 0,
      ownerName: json['owner_name'] ?? '',
      ownerPhone: json['owner_phone'] ?? '',
      photos: rawPhotos
          .map((p) => (p is Map<String, dynamic> ? p['image'] : null) ?? '')
          .whereType<String>()
          .where((url) => url.isNotEmpty)
          .map((url) => url.startsWith('http') ? url : '${ApiConstants.baseUrl}$url')
          .toList(),
    );
  }
}
