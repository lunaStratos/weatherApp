
class AlarmDomain{
  final String address;
  final String alarmTime;
  final bool   yn;


  AlarmDomain({
    required this.address,
    required this.alarmTime,
    required this.yn
  });

  factory AlarmDomain.fromJson(Map<String, dynamic> json){
    return new AlarmDomain(
        address : json['address'] ?? "",
      alarmTime : json['alarmTime']?? "",
        yn : json['yn']?? false,
    );
  }


  Map<String, dynamic> toJson(){
    return {
      'address': this.address,
      'alarmTime': this.alarmTime,
      'yn': this.yn,
    };
  }


}