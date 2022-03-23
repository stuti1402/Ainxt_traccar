class Position {
  final int id;
  final int deviceId;
  // Null type;
  final String? protocol;
  final String? serverTime;
  final String? deviceTime;
  final String? fixTime;
  final bool outdated;
  final bool valid;
  final double latitude;
  final double longitude;
  final double altitude;
  final double speed;
  final double? course;
  final String? address;
  final double? accuracy;
  final String? network;
  PositionAttributes attributes;

  Position(
      {required this.deviceId,
      this.protocol,
      this.serverTime,
      this.deviceTime,
      this.fixTime,
      required this.outdated,
      required this.valid,
      required this.latitude,
      required this.longitude,
      required this.altitude,
      required this.speed,
      required this.course,
      this.address,
      this.accuracy,
      this.network,
      required this.id,
      required this.attributes});

  factory Position.fromJson(Map<String, dynamic> data) {
    //data["attributes"]["batteryLevel"] = 0;
    var attr = data[''];

    return Position(
        id: data["id"],
        attributes: PositionAttributes.fromJson(data['attributes']),
        accuracy: data['accurancy'],
        altitude: data['altitude'],
        deviceTime: data['deviceTime'],
        course: data['course'],
        longitude: data['longitude'],
        valid: data['valid'],
        serverTime: data['serverTime'],
        outdated: data['outdated'],
        protocol: data['protocol'],
        latitude: data['latitude'],
        fixTime: data['fixTime'],
        speed: data['speed'],
        deviceId: data['deviceId'],
        address: data['address']);
  }
}

class PositionAttributes {
  int? priority;
  int? sat;
  int? event;
  bool? ignition;
  bool? motion;
  int? rssi;
  int? gpsStatus;

  double? pdop;
  double? hdop;
  double? power;
  double? battery;

  int? door;
  double? coolantTemp;
  int? operator;
  int? odometer;

  double? distance;
  double? totalDistance;
  int? hours;
  int? fuel;
  int? rpm;
  int? trailerStatus;

  PositionAttributes(
      {this.battery,
      this.coolantTemp,
      this.distance,
      this.door,
      this.event,
      this.fuel,
      this.gpsStatus,
      this.hdop,
      this.hours,
      this.ignition,
      this.motion,
      this.odometer,
      this.operator,
      this.pdop,
      this.power,
      this.priority,
      this.rssi,
      this.sat,
      this.totalDistance,
      this.rpm,
      this.trailerStatus});
  factory PositionAttributes.fromJson(Map<String, dynamic> attributes) {
    //  var attrs = attributes["attributes"];
    return PositionAttributes(
      battery: attributes['battery'],
      coolantTemp: attributes['coolantTemp'],
      distance: attributes['distance'],
      door: attributes['door'],
      event: attributes['event'],
      fuel: attributes['fuel'],
      gpsStatus: attributes['gpsStatus'],
      hdop: attributes['hdop'],
      hours: attributes['hours'],
      ignition: attributes['ignition'],
      motion: attributes['motion'],
      odometer: attributes['odometer'],
      operator: attributes['operator'],
      pdop: attributes['pdop'],
      power: attributes['power'],
      priority: attributes['priority'],
      rssi: attributes['rssi'],
      sat: attributes['sat'],
      totalDistance: attributes['totalDistance'],
      rpm: attributes['io85'],
      trailerStatus: attributes['io6']
    );
  }
}
