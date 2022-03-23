class Session {
  late int id;
  late String name;
  late String email;
  late String ? phone;
  late bool readonly;
  late bool administrator;
  late String ? map;
  late double latitude;
  late double longitude;
  late int zoom;
  late String ? password;
  late bool twelveHourFormat;
  late String ? coordinateFormat;
  late bool disabled;
  late String ? expirationTime;
  late int deviceLimit;
  late int userLimit;
  late bool deviceReadonly;
  late bool limitCommands;
  late String ? poiLayer;
  late String ? token;
  late dynamic attributes;

  Session(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.readonly,
      required this.administrator,
      required this.map,
      required this.latitude,
      required this.longitude,
      required this.zoom,
      required this.password,
      required this.twelveHourFormat,
      required this.coordinateFormat,
      required this.disabled,
      required this.expirationTime,
      required this.deviceLimit,
      required this.userLimit,
      required this.deviceReadonly,
      required this.limitCommands,
      required this.poiLayer,
       required this.token,
      required this.attributes});

  Session.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    readonly = json['readonly'];
    administrator = json['administrator'];
    map = json['map'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    zoom = json['zoom'];
    password = json['password'];
    twelveHourFormat = json['twelveHourFormat'];
    coordinateFormat = json['coordinateFormat'];
    disabled = json['disabled'];
    expirationTime = json['expirationTime'];
    deviceLimit = json['deviceLimit'];
    userLimit = json['userLimit'];
    deviceReadonly = json['deviceReadonly'];
    limitCommands = json['limitCommands'];
    poiLayer = json['poiLayer'];
    token = json['token'];
    attributes = json['attributes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['readonly'] = this.readonly;
    data['administrator'] = this.administrator;
    data['map'] = this.map;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['zoom'] = this.zoom;
    data['password'] = this.password;
    data['twelveHourFormat'] = this.twelveHourFormat;
    data['coordinateFormat'] = this.coordinateFormat;
    data['disabled'] = this.disabled;
    data['expirationTime'] = this.expirationTime;
    data['deviceLimit'] = this.deviceLimit;
    data['userLimit'] = this.userLimit;
    data['deviceReadonly'] = this.deviceReadonly;
    data['limitCommands'] = this.limitCommands;
    data['poiLayer'] = this.poiLayer;
    data['token'] = this.token;
    data['attributes'] = this.attributes;
    return data;
  }


}
