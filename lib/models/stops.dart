class Stops {
  final  deviceId;
  final  deviceName;
  final longitude;
  final latitude;
  final duration;
  final engineHours;
  final address;
  final startTime;
  final endTime;
  final spentFuel;
  Stops(
      {required this.deviceId,
      required this.address,
      required this.deviceName,
      required this.duration,
      required this.spentFuel,
      required this.endTime,
      required this.engineHours,
      required this.latitude,
      required this.longitude,
      required this.startTime});

  factory Stops.fromJson(Map<String, dynamic> data) {
    return Stops(
      deviceId: data["deviceId"],
      deviceName: data["deviceName"],
      address: data["address"]!,
      duration: data["duration"],
      spentFuel: data["spentFuel"],
      endTime: data["endTime"],
      // attributes: DeviceAttributes.fromJson(data['attributes']));
      engineHours: data['engineHours'],
      latitude: data['latitude'],
      longitude: data['longitude'],
      startTime: data['startTime'],
    );
  }
}
