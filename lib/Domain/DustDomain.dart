
class DustDomain{
  String pm25;
  String pm10;
  String pm25Grade;
  String pm10Grade;

  DustDomain({
    required this.pm25,
    required this.pm10,
    required this.pm25Grade,
    required this.pm10Grade,
  });

  factory DustDomain.fromJson(Map<String, dynamic> json){
    return new DustDomain(
      pm25 :  json['pm25'] ?? "",
      pm10: json['pm10']?? "",
      pm25Grade: json['pm25Grade']?? "",
      pm10Grade: json['pm10Grade']?? "",
    );
  }


  Map<String, dynamic> toJson(){
    return {
      'pm25' : this.pm25,
      'pm10' : this.pm10,
      'pm25Grade' : this.pm25Grade,
      'pm10Grade' : this.pm10Grade,
    };
  }


}