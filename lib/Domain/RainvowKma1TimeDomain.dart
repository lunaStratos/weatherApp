
/**
 * 레인보우 kma 그래프용
 * */
class RainvowKma1TimeDomain{
  num id;
  num rect_id;
  String target_date;
  String target_time;
  int rainfallRateRainvow;
  int rainfallRateKma;
  double rainfallAmountRainvow;
  double rainfallAmountKma;
  String created_at;
  String updated_at;



  RainvowKma1TimeDomain({
    required this.target_date,
    required this.target_time,
    required this.rect_id,
    required this.id,
    required this.rainfallRateRainvow,
    required this.rainfallRateKma,
    required this.rainfallAmountRainvow,
    required this.rainfallAmountKma,
    required this.created_at,
    required this.updated_at,

  });

  factory RainvowKma1TimeDomain.fromJson(Map<String, dynamic> json){
    return new RainvowKma1TimeDomain(
      id : json['id']?? 0,
      rect_id : json['rect_id'] ?? 0,
      target_date : json['target_date'] ?? "",
      target_time : json['target_time'] ?? "",
      rainfallRateRainvow : json['rainfallRateRainvow'] ?? 0,
      rainfallRateKma : json['rainfallRateKma'] ?? 0,
      rainfallAmountRainvow : json['rainfallAmountRainvow'] ?? 0.0,
      rainfallAmountKma : json['rainfallAmountKma'] ?? 0.0,
      created_at : json['created_at'] ?? "",
      updated_at : json['updated_at'] ?? "",
    );
  }


  Map<String, dynamic> toJson(){
    return {
      'id': this.id,
      'rect_id': this.rect_id,
      'target_date': this.target_date,
      'target_time': this.target_time,
      'rainfallRateRainvow': this.rainfallRateRainvow,
      'rainfallRateKma': this.rainfallRateKma,
      'rainfallAmountRainvow': this.rainfallAmountRainvow,
      'rainfallAmountKma': this.rainfallAmountKma,
      'created_at': this.created_at,
      'updated_at': this.updated_at,
    };
  }


}