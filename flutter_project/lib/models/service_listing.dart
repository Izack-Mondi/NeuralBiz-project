class ServiceListing {
  const ServiceListing({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.location,
    required this.price,
    required this.availability,
    required this.experience,
    this.imagePath,
    this.videoUrl,
    required this.provider,
  });

  final String id;
  final String name;
  final String category;
  final String description;
  final String location;
  final String price;
  final String availability;
  final String experience;
  final String? imagePath;
  final String? videoUrl;
  final String provider;

  factory ServiceListing.fromJson(Map<String, dynamic> json) {
    return ServiceListing(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Service',
      category: json['category'] as String? ?? 'General',
      description: json['description'] as String? ?? 'Professional service',
      location: json['location'] as String? ?? 'Kenya',
      price: json['price'] as String? ?? 'Price negotiable',
      availability: json['availability'] as String? ?? 'Flexible',
      experience: json['experience'] as String? ?? 'Experienced provider',
      imagePath: json['imagePath'] as String?,
      videoUrl: json['videoUrl'] as String?,
      provider: json['provider'] as String? ?? 'Service provider',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'description': description,
      'location': location,
      'price': price,
      'availability': availability,
      'experience': experience,
      'imagePath': imagePath,
      'videoUrl': videoUrl,
      'provider': provider,
    };
  }
}
