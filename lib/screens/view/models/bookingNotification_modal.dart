class BookingNotificationModal {
  String? responseCode;
  String? message;
  List<Notifications>? notifications;
  String? status;

  BookingNotificationModal(
      {this.responseCode, this.message, this.notifications, this.status});

  BookingNotificationModal.fromJson(Map<String, dynamic> json) {
    responseCode = json['response_code'];
    message = json['message'];
    if (json['notifications'] != null) {
      notifications = List<Notifications>.empty(growable: true);
      json['notifications'].forEach((v) {
        notifications!.add(new Notifications.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['response_code'] = this.responseCode;
    data['message'] = this.message;
    if (this.notifications != null) {
      data['notifications'] =
          this.notifications!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class Notifications {
  String? notId;
  String? userId;
  String? dataId;
  String? type;
  String? title;
  String? message;
  String? date;
  List<Booking>? booking;

  Notifications(
      {this.notId,
      this.userId,
      this.dataId,
      this.type,
      this.title,
      this.message,
      this.date,
      this.booking});

  Notifications.fromJson(Map<String, dynamic> json) {
    notId = json['not_id'];
    userId = json['user_id'];
    dataId = json['data_id'];
    type = json['type'];
    title = json['title'];
    message = json['message'];
    date = json['date'];
    if (json['booking'] != null) {
      booking = List<Booking>.empty(growable: true);
      json['booking'].forEach((v) {
        booking!.add(new Booking.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['not_id'] = this.notId;
    data['user_id'] = this.userId;
    data['data_id'] = this.dataId;
    data['type'] = this.type;
    data['title'] = this.title;
    data['message'] = this.message;
    data['date'] = this.date;
    if (this.booking != null) {
      data['booking'] = this.booking!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Booking {
  String? id;
  String? userId;
  String? resId;
  String? date;
  String? slot;
  String? size;
  String? amount;
  String? serviceName;
  String? serviceId;
  String? status;
  String? aStatus;
  dynamic? reason;
  String? isPaid;
  String? otp;
  String? txnId;
  dynamic? pDate;
  String? address;
  String? addressId;
  String? paymentType;
  String? taxAmt;
  String? tax;
  String? discount;
  String? addons;
  String? addonService;
  String? total;
  String? currency;
  String? createdAt;
  String? updatedAt;
  String? currencySymbol;
  String? service;
  String? resImage;

  Booking({this.id,
    this.userId,
    this.resId,
    this.date,
    this.slot,
    this.size,
    this.amount,
    this.serviceName,
    this.serviceId,
    this.status,
    this.aStatus,
    this.reason,
    this.isPaid,
    this.otp,
    this.txnId,
    this.pDate,
    this.address,
    this.addressId,
    this.paymentType,
    this.taxAmt,
    this.tax,
    this.discount,
    this.addons,
    this.addonService,
    this.total,
    this.currency,
    this.createdAt,
    this.updatedAt,
    this.currencySymbol,
    this.service,
    this.resImage});

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    resId = json['resId'];
    date = json['date'];
    slot = json['slot'];
    size = json['size'];
    amount = json['amount'];
    serviceName = json['service_name'];
    serviceId = json['service_id'];
    status = json['status'];
    aStatus = json['aStatus'];
    reason = json['reason'];
    isPaid = json['isPaid'];
    otp = json['otp'];
    txnId = json['txnId'];
    pDate = json['pDate'];
    address = json['address'];
    addressId = json['addressId'];
    paymentType = json['paymentType'];
    taxAmt = json['taxAmt'];
    tax = json['tax'];
    discount = json['discount'];
    addons = json['addons'];
    addonService = json['addonService'];
    total = json['total'];
    currency = json['currency'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    currencySymbol = json['currencySymbol'];
    service = json['service'];
    resImage = json['res_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    data['resId'] = this.resId;
    data['date'] = this.date;
    data['slot'] = this.slot;
    data['size'] = this.size;
    data['amount'] = this.amount;
    data['service_name'] = this.serviceName;
    data['service_id'] = this.serviceId;
    data['status'] = this.status;
    data['aStatus'] = this.aStatus;
    data['reason'] = this.reason;
    data['isPaid'] = this.isPaid;
    data['otp'] = this.otp;
    data['txnId'] = this.txnId;
    data['pDate'] = this.pDate;
    data['address'] = this.address;
    data['addressId'] = this.addressId;
    data['paymentType'] = this.paymentType;
    data['taxAmt'] = this.taxAmt;
    data['tax'] = this.tax;
    data['discount'] = this.discount;
    data['addons'] = this.addons;
    data['addonService'] = this.addonService;
    data['total'] = this.total;
    data['currency'] = this.currency;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['currencySymbol'] = this.currencySymbol;
    data['service'] = this.service;
    data['res_image'] = this.resImage;
    return data;
  }
}
