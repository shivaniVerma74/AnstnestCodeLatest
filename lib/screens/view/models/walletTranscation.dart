/// response_code : "1"
/// msg : "User transaction"
/// data : [{"id":"51","user_id":"29","message":"Payment for booking ID #234","amount":"990","transaction_id":"","created_at":"2023-06-12 06:18:04","updated_at":"0000-00-00 00:00:00"},{"id":"54","user_id":"29","message":"Payment for booking ID #241","amount":"990","transaction_id":"","created_at":"2023-06-12 09:55:49","updated_at":"0000-00-00 00:00:00"}]

class WalletTranscation {
  WalletTranscation({
    String? responseCode,
    String? msg,
    List<Data>? data,
  }) {
    _responseCode = responseCode;
    _msg = msg;
    _data = data;
  }

  WalletTranscation.fromJson(dynamic json) {
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

  WalletTranscation copyWith({
    String? responseCode,
    String? msg,
    List<Data>? data,
  }) =>
      WalletTranscation(
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

/// id : "51"
/// user_id : "29"
/// message : "Payment for booking ID #234"
/// amount : "990"
/// transaction_id : ""
/// created_at : "2023-06-12 06:18:04"
/// updated_at : "0000-00-00 00:00:00"

class Data {
  Data({
    String? id,
    String? userId,
    String? message,
    String? amount,
    String? transactionId,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _userId = userId;
    _message = message;
    _amount = amount;
    _transactionId = transactionId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _message = json['message'];
    _amount = json['amount'];
    _transactionId = json['transaction_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  String? _id;
  String? _userId;
  String? _message;
  String? _amount;
  String? _transactionId;
  String? _createdAt;
  String? _updatedAt;

  Data copyWith({
    String? id,
    String? userId,
    String? message,
    String? amount,
    String? transactionId,
    String? createdAt,
    String? updatedAt,
  }) =>
      Data(
        id: id ?? _id,
        userId: userId ?? _userId,
        message: message ?? _message,
        amount: amount ?? _amount,
        transactionId: transactionId ?? _transactionId,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get id => _id;

  String? get userId => _userId;

  String? get message => _message;

  String? get amount => _amount;

  String? get transactionId => _transactionId;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['message'] = _message;
    map['amount'] = _amount;
    map['transaction_id'] = _transactionId;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
