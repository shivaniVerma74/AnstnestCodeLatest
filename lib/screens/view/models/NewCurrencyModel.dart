/// response_code : "1"
/// msg : "Currency List"
/// data : [{"name":"INR","symbol":"₹","country_code":"+91","id":1},{"name":"USD","symbol":"$","country_code":"+1","id":2},{"name":"AED","symbol":"AED","country_code":"","id":3},{"name":"AUD","symbol":"AU$","country_code":"","id":4}]

class NewCurrencyModel {
  NewCurrencyModel({
    String? responseCode,
    String? msg,
    List<Data>? data,
  }) {
    _responseCode = responseCode;
    _msg = msg;
    _data = data;
  }

  NewCurrencyModel.fromJson(dynamic json) {
    _responseCode = json['response_code'];
    _msg = json['msg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }

  String? _responseCode;
  String? _msg;
  List<Data>? _data;

  NewCurrencyModel copyWith({
    String? responseCode,
    String? msg,
    List<Data>? data,
  }) =>
      NewCurrencyModel(
        responseCode: responseCode ?? _responseCode,
        msg: msg ?? _msg,
        data: data ?? _data,
      );

  String? get responseCode => _responseCode;

  String? get msg => _msg;

  List<Data>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response_code'] = _responseCode;
    map['msg'] = _msg;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// name : "INR"
/// symbol : "₹"
/// country_code : "+91"
/// id : 1

class Data {
  Data({
    String? name,
    String? symbol,
    String? countryCode,
    num? id,
  }) {
    _name = name;
    _symbol = symbol;
    _countryCode = countryCode;
    _id = id;
  }

  Data.fromJson(dynamic json) {
    _name = json['name'];
    _symbol = json['symbol'];
    _countryCode = json['country_code'];
    _id = json['id'];
  }

  String? _name;
  String? _symbol;
  String? _countryCode;
  num? _id;

  Data copyWith({
    String? name,
    String? symbol,
    String? countryCode,
    num? id,
  }) =>
      Data(
        name: name ?? _name,
        symbol: symbol ?? _symbol,
        countryCode: countryCode ?? _countryCode,
        id: id ?? _id,
      );

  String? get name => _name;

  String? get symbol => _symbol;

  String? get countryCode => _countryCode;

  num? get id => _id;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = _name;
    map['symbol'] = _symbol;
    map['country_code'] = _countryCode;
    map['id'] = _id;
    return map;
  }
}
