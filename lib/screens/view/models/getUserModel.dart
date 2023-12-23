import 'dart:convert';

class GeeUserModel {
  String? responseCode;
  String? message;
  User? user;
  String? status;

  GeeUserModel({this.responseCode, this.message, this.user, this.status});

  GeeUserModel.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class User {
  String? username;
  String? email;
  String? mobile;
  String? address;
  String? wallet;
  String? currency;
  String? city;
  String? country;
  String? isGold;
  String? profilePic;
  String? profileCreated;
  CurrencyData? currencySymbols;

  User(
      {this.username,
      this.email,
      this.mobile,
      this.address,
      this.city,
      this.wallet,
      this.country,
      this.currency,
      this.isGold,
      this.profilePic,
      this.profileCreated,
      this.currencySymbols});

  User.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    mobile = json['mobile'];
    currency = json['currency'];
    address = json['address'];
    city = json['city'];
    wallet = json['wallet'].toString();
    country = json['country'];
    isGold = json['isGold'];
    profilePic = json['profile_pic'];
    profileCreated = json['profile_created'].toString();
    currencySymbols = json['currency_symbols'] != null
        ? new CurrencyData.fromJson(json['currency_symbols'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['currency_symbols'] = this.currencySymbols;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['currency'] = this.currency;
    data['address'] = this.address;
    data['city'] = this.city;
    data['wallet'] = this.wallet;
    data['country'] = this.country;
    data['isGold'] = this.isGold;
    data['profile_pic'] = this.profilePic;
    data['profile_created'] = this.profileCreated;
    return data;
  }
}

class CurrencyData {
  String? name;
  String? symbol;
  String? code;

  CurrencyData({this.name, this.symbol, this.code});

  CurrencyData.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    symbol = json['symbol'];
    code = json['country_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    data['country_code'] = this.code;
    return data;
  }
}
