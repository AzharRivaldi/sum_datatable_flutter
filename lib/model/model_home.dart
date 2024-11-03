class ModelHome {
  final String name;
  final String price;
  final String region;

  ModelHome({required this.name, required this.price, required this.region});

  factory ModelHome.fromJson(Map<String, dynamic> json) {
    return ModelHome(
      name: json['name'],
      price: json['price'].toString(),
      region: json['region'],
    );
  }
}