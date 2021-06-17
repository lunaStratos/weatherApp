
/**
 * 기상청 현재날씨 (실황)
 * */
class KmaNowDomain{
  String kma_point_id;
  String rect_id;
  String targetDate;
  String targetTime;
  String rainfallAmount;
  int rainfallRate;
  String temperature;
  String weatherConditions;
  String weatherConditionsKeyword;
  String windStrength;
  String windStrengthCode;
  String windStrengthCodeDescription;
  String humidity;
  int kmaX;
  int kmaY;

  KmaNowDomain({
    required this.kma_point_id,
    required this.rect_id,
    required this.targetDate,
    required this.targetTime,
    required this.rainfallAmount,
    required this.rainfallRate,
    required this.temperature,
    required this.weatherConditions,
    required this.weatherConditionsKeyword,
    required this.windStrength,
    required this.windStrengthCode,
    required this.windStrengthCodeDescription,
    required this.humidity,
    required this.kmaX,
    required this.kmaY,
  });

  factory KmaNowDomain.fromJson(Map<String, dynamic> json){
    return new KmaNowDomain(
      kma_point_id :  json['kma_point_id'] ?? "",
      rect_id: json['rect_id']?? "",
      targetDate: json['targetDate']?? "",
      targetTime: json['targetTime']?? "",
      rainfallAmount: json['rainfall_amount']?? "",
      rainfallRate: json['rainfallRate']?? 0,
      temperature:json['temperature']?? "",
      weatherConditions: json['weatherConditions']?? "",
      weatherConditionsKeyword: json['weatherConditionsKeyword']?? "",
      windStrength: json['windStrength']?? "",
      windStrengthCode: json['windStrengthCode']?? "",
      windStrengthCodeDescription : json['windStrengthCodeDescription']?? "",
      humidity: json['humidity']?? "54",
      kmaX: json['kmaX']?? 60,
      kmaY: json['kmaY']?? 127,

    );
  }


  Map<String, dynamic> toJson(){
    return {
      'kma_point_id' : this.kma_point_id,
      'rect_id' : this.rect_id,
      'targetDate' : this.targetDate,
      'targetTime' : this.targetTime,
      'rainfallAmount' : this.rainfallAmount,
      'rainfallRate' : this.rainfallRate,
      'temperature' : this.temperature,
      'weatherConditions' : this.weatherConditions,
      'weatherConditionsKeyword' : this.weatherConditionsKeyword,
      'windStrength' : this.windStrength,
      'windStrengthCode' : this.windStrengthCode,
      'windStrengthCodeDescription' : this.windStrengthCodeDescription,
      'humidity' : this.humidity,
      'kmaX' : this.kmaX,
      'kmaY' : this.kmaY,
    };
  }


}