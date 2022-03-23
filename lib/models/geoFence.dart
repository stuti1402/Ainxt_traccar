class GeoFence {
  final int id;
  final String name;
  final String description;
  final String area;
  final GeoFenceAttributes? attributes;
  GeoFence({
    required this.name,
    required this.description,
    required this.area,
    required this.id,
    this.attributes
  });

  factory GeoFence.fromJson(Map<String, dynamic> data) {
    return GeoFence(
      id: data["id"],
      name: data["name"],
      description: data["description"],
      area: data["area"],
      attributes: GeoFenceAttributes.fromJson(data['attributes']),
    );
  }
}

class GeoFenceAttributes {
  String? color;

  GeoFenceAttributes({
    this.color,
  });
  factory GeoFenceAttributes.fromJson(Map<String, dynamic> attributes) {
    //  var attrs = attributes["attributes"];
    return GeoFenceAttributes(
      color: attributes['color'],
    );
  }
}
