class Vehicle {
  final int id_auto;
  final String name;
  final String brand;
  final String model;
  final int year;
  final String imageUrl;
  final String description;
  final double price;

  Vehicle({
    required this.id_auto,
    required this.name,
    required this.brand,
    required this.model,
    required this.year,
    required this.imageUrl,
    required this.description,
    required this.price,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id_auto: json['id_auto'],
      name: json['name'],
      brand: json['brand'],
      model: json['model'],
      year: json['year'],
      imageUrl: json['imageUrl'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson({bool includeId = false}) {
    final data = {
      'name': name,
      'brand': brand,
      'model': model,
      'year': year,
      'imageUrl': imageUrl,
      'description': description,
      'price': price,
    };
    if (includeId) {
      data['id_auto'] = id_auto;
    }
    return data;
  }
}