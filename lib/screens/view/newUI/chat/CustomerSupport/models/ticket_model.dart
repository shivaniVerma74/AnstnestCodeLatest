/// status : "0"
/// message : "Ticket types fetched successfully"
/// data : [{"ticket_type":"Reporting a late service delivery","u_name":"admin","id":"95","ticket_type_id":"20","user_id":"1","booking_id":"444","subject":"late service delivery ","email":null,"description":"Reporting a late service delivery","status":"PENDING","last_updated":"2023-08-18 17:29:17","date_created":"2023-08-18 17:29:17","type":"1","tickets_id":"95","tickets_status":"PENDING"},{"ticket_type":"Want to evaluate the service you received","u_name":"admin","id":"93","ticket_type_id":"23","user_id":"1","booking_id":"444","subject":"dev issue","email":null,"description":" Didn't Receive Was I Ordered","status":"PENDING","last_updated":"2023-08-18 17:27:29","date_created":"2023-08-18 17:27:29","type":"1","tickets_id":"93","tickets_status":"PENDING"},{"ticket_type":"Want to evaluate the service you received","u_name":"admin","id":"78","ticket_type_id":"23","user_id":"1","booking_id":"444","subject":"payment issu","email":null,"description":"I am not satisfied with the stock image selection","status":"PENDING","last_updated":"2023-08-18 14:08:56","date_created":"2023-08-18 14:08:56","type":"1","tickets_id":"78","tickets_status":"PENDING"},{"ticket_type":"Want to evaluate the service you received","u_name":"admin","id":"77","ticket_type_id":"23","user_id":"1","booking_id":"444","subject":"Payment issue","email":null,"description":"The Seller Can't deliever product","status":"PENDING","last_updated":"2023-08-18 14:08:55","date_created":"2023-08-18 14:08:55","type":"1","tickets_id":"77","tickets_status":"PENDING"},{"ticket_type":"Want to evaluate the service you received","u_name":"admin","id":"76","ticket_type_id":"23","user_id":"1","booking_id":"444","subject":"demo","email":null,"description":"The Seller Can't deliever product","status":"PENDING","last_updated":"2023-08-18 13:30:26","date_created":"2023-08-18 13:30:26","type":"1","tickets_id":"76","tickets_status":"PENDING"}]

class TicketModel {
  TicketModel({
    String? status,
    String? message,
    List<Tickets>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  TicketModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Tickets.fromJson(v));
      });
    }
  }

  String? _status;
  String? _message;
  List<Tickets>? _data;

  TicketModel copyWith({
    String? status,
    String? message,
    List<Tickets>? data,
  }) =>
      TicketModel(
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );

  String? get status => _status;

  String? get message => _message;

  List<Tickets>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// ticket_type : "Reporting a late service delivery"
/// u_name : "admin"
/// id : "95"
/// ticket_type_id : "20"
/// user_id : "1"
/// booking_id : "444"
/// subject : "late service delivery "
/// email : null
/// description : "Reporting a late service delivery"
/// status : "PENDING"
/// last_updated : "2023-08-18 17:29:17"
/// date_created : "2023-08-18 17:29:17"
/// type : "1"
/// tickets_id : "95"
/// tickets_status : "PENDING"

class Tickets {
  Tickets({
    String? ticketType,
    String? uName,
    String? id,
    String? ticketTypeId,
    String? userId,
    String? bookingId,
    String? subject,
    dynamic email,
    String? description,
    String? status,
    String? lastUpdated,
    String? dateCreated,
    String? type,
    String? ticketsId,
    String? ticketsStatus,
  }) {
    _ticketType = ticketType;
    _uName = uName;
    _id = id;
    _ticketTypeId = ticketTypeId;
    _userId = userId;
    _bookingId = bookingId;
    _subject = subject;
    _email = email;
    _description = description;
    _status = status;
    _lastUpdated = lastUpdated;
    _dateCreated = dateCreated;
    _type = type;
    _ticketsId = ticketsId;
    _ticketsStatus = ticketsStatus;
  }

  Tickets.fromJson(dynamic json) {
    _ticketType = json['ticket_type'];
    _uName = json['u_name'];
    _id = json['id'];
    _ticketTypeId = json['ticket_type_id'];
    _userId = json['user_id'];
    _bookingId = json['booking_id'];
    _subject = json['subject'];
    _email = json['email'];
    _description = json['description'];
    _status = json['status'];
    _lastUpdated = json['last_updated'];
    _dateCreated = json['date_created'];
    _type = json['type'];
    _ticketsId = json['tickets_id'];
    _ticketsStatus = json['tickets_status'];
  }

  String? _ticketType;
  String? _uName;
  String? _id;
  String? _ticketTypeId;
  String? _userId;
  String? _bookingId;
  String? _subject;
  dynamic _email;
  String? _description;
  String? _status;
  String? _lastUpdated;
  String? _dateCreated;
  String? _type;
  String? _ticketsId;
  String? _ticketsStatus;

  Tickets copyWith({
    String? ticketType,
    String? uName,
    String? id,
    String? ticketTypeId,
    String? userId,
    String? bookingId,
    String? subject,
    dynamic email,
    String? description,
    String? status,
    String? lastUpdated,
    String? dateCreated,
    String? type,
    String? ticketsId,
    String? ticketsStatus,
  }) =>
      Tickets(
        ticketType: ticketType ?? _ticketType,
        uName: uName ?? _uName,
        id: id ?? _id,
        ticketTypeId: ticketTypeId ?? _ticketTypeId,
        userId: userId ?? _userId,
        bookingId: bookingId ?? _bookingId,
        subject: subject ?? _subject,
        email: email ?? _email,
        description: description ?? _description,
        status: status ?? _status,
        lastUpdated: lastUpdated ?? _lastUpdated,
        dateCreated: dateCreated ?? _dateCreated,
        type: type ?? _type,
        ticketsId: ticketsId ?? _ticketsId,
        ticketsStatus: ticketsStatus ?? _ticketsStatus,
      );

  String? get ticketType => _ticketType;

  String? get uName => _uName;

  String? get id => _id;

  String? get ticketTypeId => _ticketTypeId;

  String? get userId => _userId;

  String? get bookingId => _bookingId;

  String? get subject => _subject;

  dynamic get email => _email;

  String? get description => _description;

  String? get status => _status;

  String? get lastUpdated => _lastUpdated;

  String? get dateCreated => _dateCreated;

  String? get type => _type;

  String? get ticketsId => _ticketsId;

  String? get ticketsStatus => _ticketsStatus;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ticket_type'] = _ticketType;
    map['u_name'] = _uName;
    map['id'] = _id;
    map['ticket_type_id'] = _ticketTypeId;
    map['user_id'] = _userId;
    map['booking_id'] = _bookingId;
    map['subject'] = _subject;
    map['email'] = _email;
    map['description'] = _description;
    map['status'] = _status;
    map['last_updated'] = _lastUpdated;
    map['date_created'] = _dateCreated;
    map['type'] = _type;
    map['tickets_id'] = _ticketsId;
    map['tickets_status'] = _ticketsStatus;
    return map;
  }
}
