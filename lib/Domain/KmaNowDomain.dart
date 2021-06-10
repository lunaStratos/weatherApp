
class KmaNowDomain{
  String kma_point_id;
  String rect_id;
  String target_time;
  String rainfall_amount;
  int rainfall_rate;
  String temperature;
  String weather_conditions;
  String weather_conditions_keyword;
  String wind_strength;
  String wind_strength_code;
  String wind_strength_code_description;
  int humidity;
  String kmaX;
  String kmaY;

  KmaNowDomain({
    required this.kma_point_id,
    required this.rect_id,
    required this.target_time,
    required this.rainfall_amount,
    required this.rainfall_rate,
    required this.temperature,
    required this.weather_conditions,
    required this.weather_conditions_keyword,
    required this.wind_strength,
    required this.wind_strength_code,
    required this.wind_strength_code_description,
    required this.humidity,
    required this.kmaX,
    required this.kmaY,
  });

  factory KmaNowDomain.fromJson(Map<String, dynamic> json){
    return new KmaNowDomain(
      kma_point_id :  json['kma_point_id'] ?? "",
      rect_id: json['rect_id']?? "",
      target_time: json['target_time']?? "",
      rainfall_amount: json['rainfall_amount']?? "",
      rainfall_rate: json['rainfall_rate']?? 0,
      temperature:json['temperature']?? "",
      weather_conditions: json['weather_conditions']?? "",
      weather_conditions_keyword: json['weather_conditions_keyword']?? "",
      wind_strength: json['wind_strength']?? "",
      wind_strength_code: json['wind_strength_code']?? "",
      wind_strength_code_description : json['wind_strength_code_description']?? "",
      humidity: json['humidity']?? 0,
      kmaX: json['kmaX']?? "",
      kmaY: json['kmaY']?? "",

    );
  }


  Map<String, dynamic> toJson(){
    return {
      'kma_point_id' : this.kma_point_id,
      'rect_id' : this.rect_id,
      'rainfall_amount' : this.rainfall_amount,
      'rainfall_rate' : this.rainfall_rate,
      'temperature' : this.temperature,
      'weather_conditions' : this.weather_conditions,
      'weather_conditions_keyword' : this.weather_conditions_keyword,
      'wind_strength' : this.wind_strength,
      'wind_strength_code' : this.wind_strength_code,
      'wind_strength_code_description' : this.wind_strength_code_description,
      'humidity' : this.humidity,
      'kmaX' : this.kmaX,
      'kmaY' : this.kmaY,
    };
  }


}