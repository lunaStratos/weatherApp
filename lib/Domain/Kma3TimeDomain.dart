
/**
 * 동네예보(1시간 예보)
 * */
class Kma3TimeDomain{
  String target_date;
  String target_time;
  String rainfall_type;
  String rainfall_mm;
  String weather_type_description;
  String rainfall_rate;
  String weather_type;
  String rainfall_type_description;
  String temperature;


  Kma3TimeDomain({
    required this.target_date,
    required this.target_time,
    required this.rainfall_type,
    required this.rainfall_mm,
    required this.weather_type_description,
    required this.rainfall_rate,
    required this.weather_type,
    required this.rainfall_type_description,
    required this.temperature,
  });

  factory Kma3TimeDomain.fromJson(Map<String, dynamic> json){
    return new Kma3TimeDomain(
      target_date : json['target_date'] ?? "",
      target_time : json['target_time'] ?? "",
      rainfall_type : json['rainfall_type'] ?? "",
      rainfall_mm : json['rainfall_mm']?? "",
      weather_type_description : json['weather_type_description'] ?? "",
      rainfall_rate : json['rainfall_rate'] ?? "",
      weather_type : json['weather_type'] ?? "",
      rainfall_type_description : json['rainfall_type_description'] ?? "",
      temperature : json['temperature'] ?? "",
    );
  }


  Map<String, dynamic> toJson(){
    return {
      'target_date': this.target_date,
      'target_time': this.target_time,
      'rainfall_type': this.rainfall_type,
      'rainfall_mm': this.rainfall_mm,
      'weather_type_description': this.weather_type_description,
      'rainfall_rate': this.rainfall_rate,
      'weather_type': this.weather_type,
      'rainfall_type_description': this.rainfall_type_description,
      'temperature': this.temperature,
    };
  }


}