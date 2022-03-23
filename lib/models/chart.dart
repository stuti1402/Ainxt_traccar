class Chart {
  final int deviceId;
  //final String address;
  final double bluecointemp1;
  final double bluecointemp2;
  final double fuel;
 // final DateTime serverTime;
  final double speed;
  final double temperature;
  final double longitude;
  final double latitude;
 // final double positionId;
  Chart({
    //required this.address,
    required this.bluecointemp1,
    required this.bluecointemp2,
    required this.fuel,
    //required this.serverTime,
    required this.speed,
    required this.temperature,
    required this.longitude,
    required this.latitude,
   // required this.positionId,
    required this.deviceId,
  });

  factory Chart.fromJson(Map<String, dynamic> data) {
    return Chart(
      deviceId: data["deviceId"],
      //address: data["address"],
      bluecointemp1: data["bluecointemp1"],
      bluecointemp2: data["bluecointemp2"],
      fuel: data["fuel"],
    // serverTime: data['serverTime'],
      speed: data["speed"],
      temperature: data["temperature"],
      longitude: data["longitude"],
      latitude: data['latitude'],
     // positionId: data["positionId"],
    );
  }
}


