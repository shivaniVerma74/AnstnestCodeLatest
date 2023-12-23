/// response_code : "1"
/// msg : "State List"
/// data : [{"id":"1","name":"Maharastra","country_id":"3","created_at":"2022-11-07 12:44:13","updated_at":"2022-12-09 12:47:43"},{"id":"3","name":"Uttarakhand","country_id":"3","created_at":"2022-11-07 12:45:06","updated_at":"2022-12-09 12:47:51"},{"id":"4","name":"Uttar Pradesh","country_id":"3","created_at":"2022-11-07 12:45:30","updated_at":"2022-12-09 12:47:51"},{"id":"5","name":"Punjab","country_id":"3","created_at":"2022-11-07 12:45:50","updated_at":"2022-12-09 12:47:51"},{"id":"6","name":"Himachal Pradesh","country_id":"3","created_at":"2022-11-07 12:46:38","updated_at":"2022-12-09 12:47:51"},{"id":"7","name":"Telangana","country_id":"3","created_at":"2022-11-07 12:47:34","updated_at":"2022-12-09 12:47:51"},{"id":"8","name":"Kerala","country_id":"3","created_at":"2022-11-07 12:48:07","updated_at":"2022-12-09 12:47:51"},{"id":"11","name":"Delhi","country_id":"3","created_at":"2022-11-07 12:49:58","updated_at":"2022-12-09 12:47:51"},{"id":"12","name":"Rajasthan","country_id":"3","created_at":"2022-11-07 12:50:21","updated_at":"2022-12-09 12:47:51"},{"id":"13","name":"Andhra Pradesh","country_id":"3","created_at":"2022-11-07 12:59:07","updated_at":"2022-12-09 12:47:51"},{"id":"103","name":"Arunachal Pradesh","country_id":"3","created_at":"2022-12-19 07:48:34","updated_at":"2022-12-19 07:48:34"},{"id":"104","name":"Assam","country_id":"3","created_at":"2022-12-19 07:48:51","updated_at":"2022-12-19 07:48:51"},{"id":"105","name":"Bihar","country_id":"3","created_at":"2022-12-19 07:49:09","updated_at":"2022-12-19 07:49:09"},{"id":"106","name":"Chhattisgarh","country_id":"3","created_at":"2022-12-19 07:49:27","updated_at":"2022-12-19 07:49:27"},{"id":"107","name":"Goa","country_id":"3","created_at":"2022-12-19 07:49:45","updated_at":"2022-12-19 07:49:45"},{"id":"108","name":"Gujarat","country_id":"3","created_at":"2022-12-19 07:50:00","updated_at":"2022-12-19 07:50:00"},{"id":"109","name":"Haryana","country_id":"3","created_at":"2022-12-19 07:50:26","updated_at":"2022-12-19 07:50:26"},{"id":"111","name":"Jammu and Kashmir","country_id":"3","created_at":"2022-12-19 07:51:03","updated_at":"2022-12-19 07:51:03"},{"id":"112","name":"Jharkhand","country_id":"3","created_at":"2022-12-19 07:51:21","updated_at":"2022-12-19 07:51:21"},{"id":"113","name":" Karnataka","country_id":"3","created_at":"2022-12-19 07:51:39","updated_at":"2022-12-19 07:51:39"},{"id":"115","name":"Madhya Pradesh","country_id":"3","created_at":"2022-12-19 07:52:33","updated_at":"2022-12-19 07:52:33"},{"id":"116","name":"Maharashtra","country_id":"3","created_at":"2022-12-19 07:52:47","updated_at":"2022-12-19 07:52:47"},{"id":"117","name":"Manipur","country_id":"3","created_at":"2022-12-19 07:53:04","updated_at":"2022-12-19 07:53:04"},{"id":"118","name":" Meghalaya","country_id":"3","created_at":"2022-12-19 07:53:19","updated_at":"2022-12-19 07:53:19"},{"id":"119","name":"Mizoram","country_id":"3","created_at":"2022-12-19 07:53:36","updated_at":"2022-12-19 07:53:36"},{"id":"120","name":"Nagaland","country_id":"3","created_at":"2022-12-19 07:53:53","updated_at":"2022-12-19 07:53:53"},{"id":"121","name":"Odisha","country_id":"3","created_at":"2022-12-19 07:54:08","updated_at":"2022-12-19 07:54:08"},{"id":"124","name":"Sikkim","country_id":"3","created_at":"2022-12-19 07:54:53","updated_at":"2022-12-19 07:54:53"},{"id":"125","name":"Tamil Nadu","country_id":"3","created_at":"2022-12-19 07:55:10","updated_at":"2022-12-19 07:55:10"},{"id":"127","name":"Tripura","country_id":"3","created_at":"2022-12-19 07:55:42","updated_at":"2022-12-19 07:55:42"},{"id":"130","name":"West Bengal","country_id":"3","created_at":"2022-12-19 07:56:29","updated_at":"2022-12-19 07:56:29"}]

class StateModel {
  StateModel({
    String? responseCode,
    String? msg,
    List<Data>? data,
  }) {
    _responseCode = responseCode;
    _msg = msg;
    _data = data;
  }

  StateModel.fromJson(dynamic json) {
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

  StateModel copyWith({
    String? responseCode,
    String? msg,
    List<Data>? data,
  }) =>
      StateModel(
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

/// id : "1"
/// name : "Maharastra"
/// country_id : "3"
/// created_at : "2022-11-07 12:44:13"
/// updated_at : "2022-12-09 12:47:43"

class Data {
  Data({
    String? id,
    String? name,
    String? countryId,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _name = name;
    _countryId = countryId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _countryId = json['country_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  String? _id;
  String? _name;
  String? _countryId;
  String? _createdAt;
  String? _updatedAt;

  Data copyWith({
    String? id,
    String? name,
    String? countryId,
    String? createdAt,
    String? updatedAt,
  }) =>
      Data(
        id: id ?? _id,
        name: name ?? _name,
        countryId: countryId ?? _countryId,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get id => _id;

  String? get name => _name;

  String? get countryId => _countryId;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['country_id'] = _countryId;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
