class SummaryModel {
  final int deviceId;
  final String deviceName;
  final maxSpeed;
  final averageSpeed;
  final distance;
  final engineHours;
  final spentFuel;
  SummaryModel({
    required this.deviceId,
    required this.averageSpeed,
    required this.deviceName,
    required this.distance,
    required this.spentFuel,
    required this.maxSpeed,
    required this.engineHours,
  });

  factory SummaryModel.fromJson(Map<String, dynamic> data) {
    return SummaryModel(
      deviceId: data["deviceId"],
      deviceName: data["deviceName"],
      averageSpeed: data["averageSpeed"],
      distance: data["distance"],
      spentFuel: data["spentFuel"],
      maxSpeed: data["maxSpeed"],
      // attributes: DeviceAttributes.fromJson(data['attributes']));
      engineHours: data['engineHours'],
    );
  }
}
