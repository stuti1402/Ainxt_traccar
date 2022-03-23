class Event {
  final int id;
  final String type;
  final String serverTime;
  final int deviceId;
  final int positionId;
  final int maintenanceId;
  final int geofenceId;

  EventAttributes attributes;
  Event({
    required this.id,
    required this.deviceId,
    required this.maintenanceId,
    required this.geofenceId,
    required this.positionId,
    required this.serverTime,
    required this.type,
    required this.attributes,
  });

  factory Event.fromJson(Map<String, dynamic> data) {
    return Event(
        id: data["id"],
        type: data["type"],
        serverTime: data["serverTime"],
        deviceId: data["deviceId"],
        positionId: data["positionId"],
        maintenanceId: data["maintenanceId"],
        geofenceId: data["geofenceId"],
        // attributes: DeviceAttributes.fromJson(data['attributes']));
        attributes: EventAttributes.fromJson(data['attributes']));
  }
}

/*
class DeviceAttributes {
  final fuelDropThreshold;
  final double? speedLimit;
  DeviceAttributes({this.fuelDropThreshold, this.speedLimit});
  factory DeviceAttributes.fromJson(Map<String, dynamic> attributes) {
    //  var attrs = attributes["attributes"];
    return DeviceAttributes(
        fuelDropThreshold: attributes['fuelDropThreshold'],
        speedLimit: attributes['speedLimit']);
  }
}
*/
class EventAttributes {
  String? seen;

  EventAttributes({
    this.seen,
  });
  factory EventAttributes.fromJson(Map<String, dynamic> attributes) {
    //  var attrs = attributes["attributes"];
    return EventAttributes(seen: attributes['seen']);
  }
}
