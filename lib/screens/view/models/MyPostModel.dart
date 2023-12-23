/// response_code : "1"
/// msg : "My Posts"
/// data : [{"id":"37","user_id":"31","cat_id":"44","sub_cat_id":"82","note":"haircut","location":"Vijay Nagar, Indore, Madhya Pradesh 452010, India, 45","date":"2023-06-07","budget":"500.00","status":"0","created_at":"2023-06-06 08:06:46","updated_at":"2023-06-06 08:14:04","rejected_by":null,"accepted_by":"34,87","currency_code":"3","country":"3","state":"115","city":"108"}]

class MyPostModel {
  MyPostModel({
    String? responseCode,
    String? msg,
    List<Data>? data,
  }) {
    _responseCode = responseCode;
    _msg = msg;
    _data = data;
  }

  MyPostModel.fromJson(dynamic json) {
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

  MyPostModel copyWith({
    String? responseCode,
    String? msg,
    List<Data>? data,
  }) =>
      MyPostModel(
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

/// id : "37"
/// user_id : "31"
/// cat_id : "44"
/// sub_cat_id : "82"
/// note : "haircut"
/// location : "Vijay Nagar, Indore, Madhya Pradesh 452010, India, 45"
/// date : "2023-06-07"
/// budget : "500.00"
/// status : "0"
/// created_at : "2023-06-06 08:06:46"
/// updated_at : "2023-06-06 08:14:04"
/// rejected_by : null
/// accepted_by : "34,87"
/// currency_code : "3"
/// country : "3"
/// state : "115"
/// city : "108"

class Data {
  Data({
    String? id,
    String? userId,
    String? catId,
    String? subCatId,
    String? note,
    String? location,
    String? date,
    String? budget,
    String? status,
    String? createdAt,
    String? updatedAt,
    dynamic rejectedBy,
    String? acceptedBy,
    String? currencyCode,
    String? country,
    String? state,
    String? city,
  }) {
    _id = id;
    _userId = userId;
    _catId = catId;
    _subCatId = subCatId;
    _note = note;
    _location = location;
    _date = date;
    _budget = budget;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _rejectedBy = rejectedBy;
    _acceptedBy = acceptedBy;
    _currencyCode = currencyCode;
    _country = country;
    _state = state;
    _city = city;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _catId = json['cat_id'];
    _subCatId = json['sub_cat_id'];
    _note = json['note'];
    _location = json['location'];
    _date = json['date'];
    _budget = json['budget'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _rejectedBy = json['rejected_by'];
    _acceptedBy = json['accepted_by'];
    _currencyCode = json['currency_code'];
    _country = json['country'];
    _state = json['state'];
    _city = json['city'];
  }

  String? _id;
  String? _userId;
  String? _catId;
  String? _subCatId;
  String? _note;
  String? _location;
  String? _date;
  String? _budget;
  String? _status;
  String? _createdAt;
  String? _updatedAt;
  dynamic _rejectedBy;
  String? _acceptedBy;
  String? _currencyCode;
  String? _country;
  String? _state;
  String? _city;

  Data copyWith({
    String? id,
    String? userId,
    String? catId,
    String? subCatId,
    String? note,
    String? location,
    String? date,
    String? budget,
    String? status,
    String? createdAt,
    String? updatedAt,
    dynamic rejectedBy,
    String? acceptedBy,
    String? currencyCode,
    String? country,
    String? state,
    String? city,
  }) =>
      Data(
        id: id ?? _id,
        userId: userId ?? _userId,
        catId: catId ?? _catId,
        subCatId: subCatId ?? _subCatId,
        note: note ?? _note,
        location: location ?? _location,
        date: date ?? _date,
        budget: budget ?? _budget,
        status: status ?? _status,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        rejectedBy: rejectedBy ?? _rejectedBy,
        acceptedBy: acceptedBy ?? _acceptedBy,
        currencyCode: currencyCode ?? _currencyCode,
        country: country ?? _country,
        state: state ?? _state,
        city: city ?? _city,
      );

  String? get id => _id;

  String? get userId => _userId;

  String? get catId => _catId;

  String? get subCatId => _subCatId;

  String? get note => _note;

  String? get location => _location;

  String? get date => _date;

  String? get budget => _budget;

  String? get status => _status;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  dynamic get rejectedBy => _rejectedBy;

  String? get acceptedBy => _acceptedBy;

  String? get currencyCode => _currencyCode;

  String? get country => _country;

  String? get state => _state;

  String? get city => _city;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['cat_id'] = _catId;
    map['sub_cat_id'] = _subCatId;
    map['note'] = _note;
    map['location'] = _location;
    map['date'] = _date;
    map['budget'] = _budget;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['rejected_by'] = _rejectedBy;
    map['accepted_by'] = _acceptedBy;
    map['currency_code'] = _currencyCode;
    map['country'] = _country;
    map['state'] = _state;
    map['city'] = _city;
    return map;
  }
}
