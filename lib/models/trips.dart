class Trips {
  final deviceId;
  final deviceName;
  final maxSpeed;
  final averageSpeed;
  final distance;
  final spentFuel;
  final duration;
  final startTime;
  final endTime;

  final startAddress;
  final endAddress;

  final startLon;
  final startLat;
  final endtLon;
  final endLat;
  final driverUniqueId;
  final driverName;

  Trips(
      {required this.deviceId,
      required this.averageSpeed,
      required this.deviceName,
      required this.duration,
      required this.spentFuel,
      required this.endTime,
      required this.distance,
      required this.driverName,
      required this.driverUniqueId,
      required this.startTime,
      required this.endAddress,
      required this.endLat,
      required this.endtLon,
      required this.maxSpeed,
      required this.startAddress,
      required this.startLat,
      required this.startLon});

  factory Trips.fromJson(Map<String, dynamic> data) {
    return Trips(
      deviceId: data["deviceId"],
      deviceName: data["deviceName"],
      averageSpeed: data["averageSpeed"],
      duration: data["duration"],
      spentFuel: data["spentFuel"],
      endTime: data["endTime"],
      // attributes: DeviceAttributes.fromJson(data['attributes']));
      distance: data['distance'],
      driverName: data['driverName'],
      driverUniqueId: data['driverUniqueId'],
      startTime: data['startTime'],
      startLon: data['startLon'],
      startLat: data['startLat'],
      startAddress: data['startAddress'],
      maxSpeed: data['maxSpeed'],
      endtLon: data['endtLon'],
      endLat: data['endLat'],
      endAddress: data['endAddress'],
    );
  }
}
