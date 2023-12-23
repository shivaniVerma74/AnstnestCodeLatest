/// response_code : "1"
/// msg : "City List"
/// data : [{"id":"108","name":" Indore","image":"","description":"Madhya Pradesh","country_id":"3","state_id":"115","created_at":"2022-12-19 12:02:26","updated_at":"2022-12-19 12:02:26"},{"id":"110","name":"Bhopal","image":"","description":"madhya pradhesh","country_id":"3","state_id":"115","created_at":"2022-12-19 12:03:45","updated_at":"2022-12-19 12:04:48"}]

class CityModel {
  CityModel({
    String? responseCode,
    String? msg,
    List<Data>? data,
  }) {
    _responseCode = responseCode;
    _msg = msg;
    _data = data;
  }

  CityModel.fromJson(dynamic json) {
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

  CityModel copyWith({
    String? responseCode,
    String? msg,
    List<Data>? data,
  }) =>
      CityModel(
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

/// id : "108"
/// name : " Indore"
/// image : ""
/// description : "Madhya Pradesh"
/// country_id : "3"
/// state_id : "115"
/// created_at : "2022-12-19 12:02:26"
/// updated_at : "2022-12-19 12:02:26"

class Data {
  Data({
    String? id,
    String? name,
    String? image,
    String? description,
    String? countryId,
    String? stateId,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _name = name;
    _image = image;
    _description = description;
    _countryId = countryId;
    _stateId = stateId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
    _description = json['description'];
    _countryId = json['country_id'];
    _stateId = json['state_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  String? _id;
  String? _name;
  String? _image;
  String? _description;
  String? _countryId;
  String? _stateId;
  String? _createdAt;
  String? _updatedAt;

  Data copyWith({
    String? id,
    String? name,
    String? image,
    String? description,
    String? countryId,
    String? stateId,
    String? createdAt,
    String? updatedAt,
  }) =>
      Data(
        id: id ?? _id,
        name: name ?? _name,
        image: image ?? _image,
        description: description ?? _description,
        countryId: countryId ?? _countryId,
        stateId: stateId ?? _stateId,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get id => _id;

  String? get name => _name;

  String? get image => _image;

  String? get description => _description;

  String? get countryId => _countryId;

  String? get stateId => _stateId;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['image'] = _image;
    map['description'] = _description;
    map['country_id'] = _countryId;
    map['state_id'] = _stateId;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
