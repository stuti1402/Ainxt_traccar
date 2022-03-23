class Maintenances {
  final int id;
  final String type;
  final String name;
  final double start;
  final double period;
  final attributes;
  Maintenances({
    required this.id,
    required this.start,
    required this.period,
    required this.name,
    required this.type,
    required MaintenanceAttributes this.attributes,
  });

  factory Maintenances.fromJson(Map<String, dynamic> data) {
    return Maintenances(
        id: data["id"],
        type: data["type"],
        name: data["name"],
        start: data["start"],
        period: data["period"],
        attributes:  MaintenanceAttributes.fromJson(data['attributes']),);
  }
}
class MaintenanceAttributes {
  int? deviceId;

  MaintenanceAttributes(
      {this.deviceId,
      });
  factory MaintenanceAttributes.fromJson(Map<String, dynamic> attributes) {
    //  var attrs = attributes["attributes"];
    return MaintenanceAttributes(
     
      deviceId: attributes['deviceId'],
    );
  }
}
