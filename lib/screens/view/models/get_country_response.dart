class GetCountryResponse {
  String? responseCode;
  String? msg;
  List<CountryData>? data;

  GetCountryResponse({this.responseCode, this.msg, this.data});

  GetCountryResponse.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <CountryData>[];
      json['data'].forEach((v) {
        data!.add(new CountryData.fromJson(v));
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

class CountryData {
  String? id;
  String? name;
  String? countryCode;
  String? currency;
  String? symbol;
  String? nicename;
  String? updatedAt;

  CountryData(
      {this.id,
      this.name,
      this.countryCode,
      this.currency,
      this.symbol,
      this.nicename,
      this.updatedAt});

  CountryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    countryCode = json['country_code'];
    currency = json['currency'];
    symbol = json['symbol'];
    nicename = json['nicename'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['country_code'] = this.countryCode;
    data['currency'] = this.currency;
    data['symbol'] = this.symbol;
    data['nicename'] = this.nicename;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
