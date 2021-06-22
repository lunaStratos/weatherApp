
/**
 * 레인보우 kma 그래프용
 * */
class RainvowKma1TimeDomain{
  String target_date;
  String target_time;
  String rect_id;
  String id;
  String rainfallrateRainvow;
  String rainfallrateKma;
  String rainfallAmountRainvow;
  String rainfallAmountKma;
  String created_at;
  String updated_at;



  RainvowKma1TimeDomain({
    required this.target_date,
    required this.target_time,
    required this.rect_id,
    required this.id,
    required this.rainfallrateRainvow,
    required this.rainfallrateKma,
    required this.rainfallAmountRainvow,
    required this.rainfallAmountKma,
    required this.created_at,
    required this.updated_at,

  });

  factory RainvowKma1TimeDomain.fromJson(Map<String, dynamic> json){
    return new RainvowKma1TimeDomain(
      target_date : json['target_date'] ?? "",
      target_time : json['target_time'] ?? "",
      rect_id : json['rect_id'] ?? "",
      id : json['id']?? "",
      rainfallrateRainvow : json['rainfallrateRainvow'] ?? "",
      rainfallrateKma : json['rainfallrateKma'] ?? "",
      rainfallAmountRainvow : json['rainfallAmountRainvow'] ?? "",
      rainfallAmountKma : json['rainfallAmountKma'] ?? "",
      created_at : json['created_at'] ?? "",
      updated_at : json['updated_at'] ?? "",
    );
  }


  Map<String, dynamic> toJson(){
    return {
      'target_date': this.target_date,
      'target_time': this.target_time,
      'rect_id': this.rect_id,
      'id': this.id,
      'rainfallrateRainvow': this.rainfallrateRainvow,
      'rainfallrateKma': this.rainfallrateKma,
      'rainfallAmountRainvow': this.rainfallAmountRainvow,
      'rainfallAmountKma': this.rainfallAmountKma,
      'created_at': this.created_at,
      'updated_at': this.updated_at,
    };
  }


}