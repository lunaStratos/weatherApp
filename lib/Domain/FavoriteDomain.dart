
/**
 * 관심지역 리스트 - 다양한 곳에서 사용.
 * */
class FavoriteDomain{
  final String address;
  final String dongName;
  final String longitude;
  final String latitude;
  final String kmaX;
  final String kmaY;
  final String rect_id;
  final String kma_point_id;
  String weatherDescription;
  String weatherConditions;
  String rainfallAmount;
  String celsius;
  String imgSrc;
  String alarmTime;
  String utcAlarmTime;
  bool use;
  bool isTrue;

  FavoriteDomain({
    required this.address,
    required this.dongName,
    required this.longitude,
    required this.latitude,
    required this.kmaX,
    required this.kmaY,
    required this.rect_id,
    required this.kma_point_id,
    required this.weatherDescription,
    required this.weatherConditions,
    required this.rainfallAmount,
    required this.celsius,
    required this.imgSrc,
    required this.alarmTime,
    required this.utcAlarmTime,
    required this.use,
    required this.isTrue,
  });

  factory FavoriteDomain.fromJson(Map<String, dynamic> json){
    return new FavoriteDomain(
        address : json['address'] ?? "",
        dongName : json['dongName'] ?? "",
        longitude : json['longitude'] ?? "",
        latitude : json['latitude'] ?? "",
        kmaX : json['kmaX'] ?? "",
        kmaY : json['kmaY'] ?? "",
        rect_id : json['rect_id'] ?? "",
        kma_point_id : json['kma_point_id'] ?? "",
        weatherDescription : json['weatherDescription']?? "",
        weatherConditions : json['weatherConditions']?? "",
        rainfallAmount : json['rainfallAmount']?? "",
        celsius : json['celsius']?? "",
        imgSrc : json['imgSrc']?? "",
        alarmTime : json['alarmTime'] ?? "",
        utcAlarmTime : json['utcAlarmTime'] ?? "",
        use : json['use'] ?? false,
        isTrue: json['isTrue'] ?? true,
    );
  }


  Map<String, dynamic> toJson(){
    return {
      'address': this.address,
      'dongName': this.dongName,
      'longitude': this.longitude,
      'latitude': this.latitude,
      'kmaX': this.kmaX,
      'kmaY': this.kmaY,
      'rect_id': this.rect_id,
      'kma_point_id': this.kma_point_id,
      'weatherDescription': this.weatherDescription,
      'weatherConditions': this.weatherConditions,
      'rainfallAmount': this.rainfallAmount,
      'celsius': this.celsius,
      'imgSrc': this.imgSrc,
      'alarmTime' : this.alarmTime,
      'utcAlarmTime' :this.utcAlarmTime,
      'use' : this.use,
      'isTrue' : this.isTrue,
    };
  }


}