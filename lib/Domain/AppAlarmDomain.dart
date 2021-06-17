
class AppAlarmDomain{

  String kma_point_id;
  String rect_id;
  String latitude;
  String longitude;
  String kmaX;
  String kmaY;
  String address;
  String time;
  String fcmToken;


  AppAlarmDomain({
    required this.kma_point_id,
    required this.rect_id,
    required this.latitude,
    required this.longitude,
    required this.kmaX,
    required this.kmaY,
    required this.address,
    required this.time,
    required this.fcmToken,
  });

  factory AppAlarmDomain.fromJson(Map<String, dynamic> json){
    return new AppAlarmDomain(
      kma_point_id : json['kma_point_id'] ?? "",
      rect_id : json['rect_id']?? "",
        latitude : json['latitude']?? "",
        longitude : json['longitude']?? "",
        kmaX : json['kmaX']?? "",
        kmaY : json['kmaY']?? "",
      address : json['address']?? "",
      time : json['time']?? "",
      fcmToken : json['fcmToken']?? "",

    );
  }


  Map<String, dynamic> toJson(){
    return {
      'kma_point_id': this.kma_point_id,
      'rect_id': this.rect_id,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'kmaX': this.kmaX,
      'kmaY': this.kmaY,
      'address': this.address,
      'time': this.time,
      'fcmToken': this.fcmToken,
    };
  }


}