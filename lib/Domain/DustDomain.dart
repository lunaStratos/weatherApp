
/**
 * 미세먼지
 * */
class DustDomain{
  String pm25;
  String pm10;
  String pm25grade;
  String pm10grade;

  DustDomain({
    required this.pm25,
    required this.pm10,
    required this.pm25grade,
    required this.pm10grade,
  });

  factory DustDomain.fromJson(Map<String, dynamic> json){
    return new DustDomain(
      pm25 :  json['pm25'] ?? "",
      pm10: json['pm10']?? "",
      pm25grade: json['pm25grade']?? "",
      pm10grade: json['pm10grade']?? "",
    );
  }


  Map<String, dynamic> toJson(){
    return {
      'pm25' : this.pm25,
      'pm10' : this.pm10,
      'pm25grade' : this.pm25grade,
      'pm10grade' : this.pm10grade,
    };
  }


}