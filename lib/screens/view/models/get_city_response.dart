class GetCityResponse {
  String? responseCode;
  String? msg;
  List<CityDataLsit>? data;

  GetCityResponse({this.responseCode, this.msg, this.data});

  GetCityResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <CityDataLsit>[];
      json['data'].forEach((v) {
        data!.add(new CityDataLsit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['msg'] = this.msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CityDataLsit {
  String? id;
  String? name;
  String? image;
  String? description;
  String? countryId;
  String? stateId;
  String? createdAt;
  String? updatedAt;

  CityDataLsit(
      {this.id,
        this.name,
        this.image,
        this.description,
        this.countryId,
        this.stateId,
        this.createdAt,
        this.updatedAt});

  CityDataLsit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    description = json['description'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['description'] = this.description;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
