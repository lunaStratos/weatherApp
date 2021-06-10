
class FavoriteJsonDomain{
  final String address;
  final String dongName;
  final String latitude;
  final String longitude;
  final String kmaX;
  final String kmaY;
  final String kma_point_id;
  final String rect_id;


  FavoriteJsonDomain({
    required this.address,
    required this.dongName,
    required this.latitude,
    required this.longitude,
    required this.kmaX,
    required this.kmaY,
    required this.kma_point_id,
    required this.rect_id,

  });

  factory FavoriteJsonDomain.fromJson(Map<String, dynamic> json){
    return new FavoriteJsonDomain(
        address : json['address'] ?? "",
        dongName : json['dongName']?? "",
        latitude : json['latitude']?? "",
        longitude : json['longitude']?? "",
        kmaX : json['kmaX']?? "",
        kmaY : json['kmaY']?? "",
        kma_point_id : json['kma_point_id']?? "",
        rect_id : json['rect_id']?? "",

    );
  }


  Map<String, dynamic> toJson(){
    return {
      'address': this.address,
      'dongName': this.dongName,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'kmaX': this.kmaX,
      'kmaY': this.kmaY,
      'kma_point_id': this.kma_point_id,
      'rect_id': this.rect_id,

    };
  }


}