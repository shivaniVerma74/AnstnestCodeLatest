/// status : 1
/// msg : "Restaurnats Found"
/// booking : [{"id":"651","date":"2023-10-14","slot":"3:15 PM","user_id":"252","res_id":"130","size":"gugugu","status":"Confirmed","a_status":"2","reason":null,"is_paid":"0","otp":"","amount":"INR 900","txn_id":"","p_date":null,"address":"vijay nagar, 777","address_id":"193","payment_type":"","subtotal":"900.00","tax_amt":"162.00","tax":"0.00","discount":"0.00","addons":"0.00","addon_service":"","total":"1062.00","currency":"INR","created_at":"2023-10-14 16:53:34","updated_at":"2023-10-14 11:23:34","currency_symbol":"₹","service":{"res_id":"130","cat_id":"42","scat_id":"58","res_name":"WEDDING","res_name_u":"","res_desc":"Create timeless memories without the hassle. We’ll capture the moments you never want.","res_desc_u":"","res_website":"","res_image":{"res_imag0":"https://developmentalphawizz.com/antsnest/uploads/6329b66b2b02e.jpg"},"logo":"https://developmentalphawizz.com/antsnest/uploads/6329b66b2ba6b.jpg","res_phone":"","res_address":"vijay Nagar Square","res_isOpen":"","res_status":"active","res_create_date":"1692626263","res_ratings":"3","status":"1","res_video":"","res_url":"","mfo":"","lat":"","lon":"","vid":"34","country_id":"3","state_id":"6","city_id":"9","structure":"a:3:{i:0;a:4:{s:7:\"service\";s:5:\"Basic\";s:7:\"price_a\";s:3:\"500\";s:4:\"hrly\";s:4:\"Hour\";s:8:\"days_hrs\";s:1:\"2\";}i:1;a:4:{s:7:\"service\";s:8:\"Standard\";s:7:\"price_a\";s:3:\"100\";s:4:\"hrly\";s:4:\"Hour\";s:8:\"days_hrs\";s:1:\"3\";}i:2;a:4:{s:7:\"service\";s:7:\"Premium\";s:7:\"price_a\";s:4:\"1000\";s:4:\"hrly\";s:4:\"Hour\";s:8:\"days_hrs\";s:1:\"5\";}}","hours":"4","hour_type":"Days","experts":"2","service_offered":"Wedding, Photography,","price":"900","base_currency":"INR","type":"0","provider_id":"34","provider_name":"Sawan Shakya","last_login":"14 Oct, 2023 04:58 PM","provider_image":"https://developmentalphawizz.com/antsnest/uploads/profile_pics/64ba6c6e4ca48.png","c_name":"PHOTOGRAPHERS","review_count":15,"view_count":0,"all_image":["https://developmentalphawizz.com/antsnest/uploads/6329b66b2b02e.jpg"]}}]

class GetBookingModel {
  GetBookingModel({
    num? status,
    String? msg,
    List<Booking>? booking,
  }) {
    _status = status;
    _msg = msg;
    _booking = booking;
  }

  GetBookingModel.fromJson(dynamic json) {
    _status = json['status'];
    _msg = json['msg'];
    if (json['booking'] != null) {
      _booking = [];
      json['booking'].forEach((v) {
        _booking?.add(Booking.fromJson(v));
      });
    }
  }

  num? _status;
  String? _msg;
  List<Booking>? _booking;

  GetBookingModel copyWith({
    num? status,
    String? msg,
    List<Booking>? booking,
  }) =>
      GetBookingModel(
        status: status ?? _status,
        msg: msg ?? _msg,
        booking: booking ?? _booking,
      );

  num? get status => _status;

  String? get msg => _msg;

  List<Booking>? get booking => _booking;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    map['msg'] = _msg;
    if (_booking != null) {
      map['booking'] = _booking?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : "651"
/// date : "2023-10-14"
/// slot : "3:15 PM"
/// user_id : "252"
/// res_id : "130"
/// size : "gugugu"
/// status : "Confirmed"
/// a_status : "2"
/// reason : null
/// is_paid : "0"
/// otp : ""
/// amount : "INR 900"
/// txn_id : ""
/// p_date : null
/// address : "vijay nagar, 777"
/// address_id : "193"
/// payment_type : ""
/// subtotal : "900.00"
/// tax_amt : "162.00"
/// tax : "0.00"
/// discount : "0.00"
/// addons : "0.00"
/// addon_service : ""
/// total : "1062.00"
/// currency : "INR"
/// created_at : "2023-10-14 16:53:34"
/// updated_at : "2023-10-14 11:23:34"
/// currency_symbol : "₹"
/// service : {"res_id":"130","cat_id":"42","scat_id":"58","res_name":"WEDDING","res_name_u":"","res_desc":"Create timeless memories without the hassle. We’ll capture the moments you never want.","res_desc_u":"","res_website":"","res_image":{"res_imag0":"https://developmentalphawizz.com/antsnest/uploads/6329b66b2b02e.jpg"},"logo":"https://developmentalphawizz.com/antsnest/uploads/6329b66b2ba6b.jpg","res_phone":"","res_address":"vijay Nagar Square","res_isOpen":"","res_status":"active","res_create_date":"1692626263","res_ratings":"3","status":"1","res_video":"","res_url":"","mfo":"","lat":"","lon":"","vid":"34","country_id":"3","state_id":"6","city_id":"9","structure":"a:3:{i:0;a:4:{s:7:\"service\";s:5:\"Basic\";s:7:\"price_a\";s:3:\"500\";s:4:\"hrly\";s:4:\"Hour\";s:8:\"days_hrs\";s:1:\"2\";}i:1;a:4:{s:7:\"service\";s:8:\"Standard\";s:7:\"price_a\";s:3:\"100\";s:4:\"hrly\";s:4:\"Hour\";s:8:\"days_hrs\";s:1:\"3\";}i:2;a:4:{s:7:\"service\";s:7:\"Premium\";s:7:\"price_a\";s:4:\"1000\";s:4:\"hrly\";s:4:\"Hour\";s:8:\"days_hrs\";s:1:\"5\";}}","hours":"4","hour_type":"Days","experts":"2","service_offered":"Wedding, Photography,","price":"900","base_currency":"INR","type":"0","provider_id":"34","provider_name":"Sawan Shakya","last_login":"14 Oct, 2023 04:58 PM","provider_image":"https://developmentalphawizz.com/antsnest/uploads/profile_pics/64ba6c6e4ca48.png","c_name":"PHOTOGRAPHERS","review_count":15,"view_count":0,"all_image":["https://developmentalphawizz.com/antsnest/uploads/6329b66b2b02e.jpg"]}

class Booking {
  Booking({
    String? id,
    String? date,
    String? slot,
    String? userId,
    String? resId,
    String? size,
    String? status,
    String? aStatus,
    dynamic reason,
    String? isPaid,
    String? otp,
    String? amount,
    String? txnId,
    dynamic pDate,
    String? address,
    String? addressId,
    String? paymentType,
    String? subtotal,
    String? taxAmt,
    String? tax,
    String? discount,
    String? addons,
    String? addonService,
    String? total,
    String? currency,
    String? createdAt,
    String? updatedAt,
    String? currencySymbol,
    Service? service,
  }) {
    _id = id;
    _date = date;
    _slot = slot;
    _userId = userId;
    _resId = resId;
    _size = size;
    _status = status;
    _aStatus = aStatus;
    _reason = reason;
    _isPaid = isPaid;
    _otp = otp;
    _amount = amount;
    _txnId = txnId;
    _pDate = pDate;
    _address = address;
    _addressId = addressId;
    _paymentType = paymentType;
    _subtotal = subtotal;
    _taxAmt = taxAmt;
    _tax = tax;
    _discount = discount;
    _addons = addons;
    _addonService = addonService;
    _total = total;
    _currency = currency;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _currencySymbol = currencySymbol;
    _service = service;
  }

  Booking.fromJson(dynamic json) {
    _id = json['id'];
    _date = json['date'];
    _slot = json['slot'];
    _userId = json['user_id'];
    _resId = json['res_id'];
    _size = json['size'];
    _status = json['status'];
    _aStatus = json['a_status'];
    _reason = json['reason'];
    _isPaid = json['is_paid'];
    _otp = json['otp'];
    _amount = json['amount'];
    _txnId = json['txn_id'];
    _pDate = json['p_date'];
    _address = json['address'];
    _addressId = json['address_id'];
    _paymentType = json['payment_type'];
    _subtotal = json['subtotal'];
    _taxAmt = json['tax_amt'];
    _tax = json['tax'];
    _discount = json['discount'];
    _addons = json['addons'];
    _addonService = json['addon_service'];
    _total = json['total'];
    _currency = json['currency'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _currencySymbol = json['currency_symbol'];
    _service =
        json['service'] != null ? Service.fromJson(json['service']) : null;
  }

  String? _id;
  String? _date;
  String? _slot;
  String? _userId;
  String? _resId;
  String? _size;
  String? _status;
  String? _aStatus;
  dynamic _reason;
  String? _isPaid;
  String? _otp;
  String? _amount;
  String? _txnId;
  dynamic _pDate;
  String? _address;
  String? _addressId;
  String? _paymentType;
  String? _subtotal;
  String? _taxAmt;
  String? _tax;
  String? _discount;
  String? _addons;
  String? _addonService;
  String? _total;
  String? _currency;
  String? _createdAt;
  String? _updatedAt;
  String? _currencySymbol;
  Service? _service;

  Booking copyWith({
    String? id,
    String? date,
    String? slot,
    String? userId,
    String? resId,
    String? size,
    String? status,
    String? aStatus,
    dynamic reason,
    String? isPaid,
    String? otp,
    String? amount,
    String? txnId,
    dynamic pDate,
    String? address,
    String? addressId,
    String? paymentType,
    String? subtotal,
    String? taxAmt,
    String? tax,
    String? discount,
    String? addons,
    String? addonService,
    String? total,
    String? currency,
    String? createdAt,
    String? updatedAt,
    String? currencySymbol,
    Service? service,
  }) =>
      Booking(
        id: id ?? _id,
        date: date ?? _date,
        slot: slot ?? _slot,
        userId: userId ?? _userId,
        resId: resId ?? _resId,
        size: size ?? _size,
        status: status ?? _status,
        aStatus: aStatus ?? _aStatus,
        reason: reason ?? _reason,
        isPaid: isPaid ?? _isPaid,
        otp: otp ?? _otp,
        amount: amount ?? _amount,
        txnId: txnId ?? _txnId,
        pDate: pDate ?? _pDate,
        address: address ?? _address,
        addressId: addressId ?? _addressId,
        paymentType: paymentType ?? _paymentType,
        subtotal: subtotal ?? _subtotal,
        taxAmt: taxAmt ?? _taxAmt,
        tax: tax ?? _tax,
        discount: discount ?? _discount,
        addons: addons ?? _addons,
        addonService: addonService ?? _addonService,
        total: total ?? _total,
        currency: currency ?? _currency,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        currencySymbol: currencySymbol ?? _currencySymbol,
        service: service ?? _service,
      );

  String? get id => _id;

  String? get date => _date;

  String? get slot => _slot;

  String? get userId => _userId;

  String? get resId => _resId;

  String? get size => _size;

  String? get status => _status;

  String? get aStatus => _aStatus;

  dynamic get reason => _reason;

  String? get isPaid => _isPaid;

  String? get otp => _otp;

  String? get amount => _amount;

  String? get txnId => _txnId;

  dynamic get pDate => _pDate;

  String? get address => _address;

  String? get addressId => _addressId;

  String? get paymentType => _paymentType;

  String? get subtotal => _subtotal;

  String? get taxAmt => _taxAmt;

  String? get tax => _tax;

  String? get discount => _discount;

  String? get addons => _addons;

  String? get addonService => _addonService;

  String? get total => _total;

  String? get currency => _currency;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get currencySymbol => _currencySymbol;

  Service? get service => _service;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['date'] = _date;
    map['slot'] = _slot;
    map['user_id'] = _userId;
    map['res_id'] = _resId;
    map['size'] = _size;
    map['status'] = _status;
    map['a_status'] = _aStatus;
    map['reason'] = _reason;
    map['is_paid'] = _isPaid;
    map['otp'] = _otp;
    map['amount'] = _amount;
    map['txn_id'] = _txnId;
    map['p_date'] = _pDate;
    map['address'] = _address;
    map['address_id'] = _addressId;
    map['payment_type'] = _paymentType;
    map['subtotal'] = _subtotal;
    map['tax_amt'] = _taxAmt;
    map['tax'] = _tax;
    map['discount'] = _discount;
    map['addons'] = _addons;
    map['addon_service'] = _addonService;
    map['total'] = _total;
    map['currency'] = _currency;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['currency_symbol'] = _currencySymbol;
    if (_service != null) {
      map['service'] = _service?.toJson();
    }
    return map;
  }
}

/// res_id : "130"
/// cat_id : "42"
/// scat_id : "58"
/// res_name : "WEDDING"
/// res_name_u : ""
/// res_desc : "Create timeless memories without the hassle. We’ll capture the moments you never want."
/// res_desc_u : ""
/// res_website : ""
/// res_image : {"res_imag0":"https://developmentalphawizz.com/antsnest/uploads/6329b66b2b02e.jpg"}
/// logo : "https://developmentalphawizz.com/antsnest/uploads/6329b66b2ba6b.jpg"
/// res_phone : ""
/// res_address : "vijay Nagar Square"
/// res_isOpen : ""
/// res_status : "active"
/// res_create_date : "1692626263"
/// res_ratings : "3"
/// status : "1"
/// res_video : ""
/// res_url : ""
/// mfo : ""
/// lat : ""
/// lon : ""
/// vid : "34"
/// country_id : "3"
/// state_id : "6"
/// city_id : "9"
/// structure : "a:3:{i:0;a:4:{s:7:\"service\";s:5:\"Basic\";s:7:\"price_a\";s:3:\"500\";s:4:\"hrly\";s:4:\"Hour\";s:8:\"days_hrs\";s:1:\"2\";}i:1;a:4:{s:7:\"service\";s:8:\"Standard\";s:7:\"price_a\";s:3:\"100\";s:4:\"hrly\";s:4:\"Hour\";s:8:\"days_hrs\";s:1:\"3\";}i:2;a:4:{s:7:\"service\";s:7:\"Premium\";s:7:\"price_a\";s:4:\"1000\";s:4:\"hrly\";s:4:\"Hour\";s:8:\"days_hrs\";s:1:\"5\";}}"
/// hours : "4"
/// hour_type : "Days"
/// experts : "2"
/// service_offered : "Wedding, Photography,"
/// price : "900"
/// base_currency : "INR"
/// type : "0"
/// provider_id : "34"
/// provider_name : "Sawan Shakya"
/// last_login : "14 Oct, 2023 04:58 PM"
/// provider_image : "https://developmentalphawizz.com/antsnest/uploads/profile_pics/64ba6c6e4ca48.png"
/// c_name : "PHOTOGRAPHERS"
/// review_count : 15
/// view_count : 0
/// all_image : ["https://developmentalphawizz.com/antsnest/uploads/6329b66b2b02e.jpg"]

class Service {
  Service({
    String? resId,
    String? catId,
    String? scatId,
    String? resName,
    String? resNameU,
    String? resDesc,
    String? resDescU,
    String? resWebsite,
    ResImage? resImage,
    String? logo,
    String? resPhone,
    String? resAddress,
    String? resIsOpen,
    String? resStatus,
    String? resCreateDate,
    String? resRatings,
    String? status,
    String? resVideo,
    String? resUrl,
    String? mfo,
    String? lat,
    String? lon,
    String? vid,
    String? countryId,
    String? stateId,
    String? cityId,
    String? structure,
    String? hours,
    String? hourType,
    String? experts,
    String? serviceOffered,
    String? price,
    String? baseCurrency,
    String? type,
    String? providerId,
    String? providerName,
    String? lastLogin,
    String? providerImage,
    String? cName,
    num? reviewCount,
    num? viewCount,
    List<String>? allImage,
  }) {
    _resId = resId;
    _catId = catId;
    _scatId = scatId;
    _resName = resName;
    _resNameU = resNameU;
    _resDesc = resDesc;
    _resDescU = resDescU;
    _resWebsite = resWebsite;
    _resImage = resImage;
    _logo = logo;
    _resPhone = resPhone;
    _resAddress = resAddress;
    _resIsOpen = resIsOpen;
    _resStatus = resStatus;
    _resCreateDate = resCreateDate;
    _resRatings = resRatings;
    _status = status;
    _resVideo = resVideo;
    _resUrl = resUrl;
    _mfo = mfo;
    _lat = lat;
    _lon = lon;
    _vid = vid;
    _countryId = countryId;
    _stateId = stateId;
    _cityId = cityId;
    _structure = structure;
    _hours = hours;
    _hourType = hourType;
    _experts = experts;
    _serviceOffered = serviceOffered;
    _price = price;
    _baseCurrency = baseCurrency;
    _type = type;
    _providerId = providerId;
    _providerName = providerName;
    _lastLogin = lastLogin;
    _providerImage = providerImage;
    _cName = cName;
    _reviewCount = reviewCount;
    _viewCount = viewCount;
    _allImage = allImage;
  }

  Service.fromJson(dynamic json) {
    _resId = json['res_id'];
    _catId = json['cat_id'];
    _scatId = json['scat_id'];
    _resName = json['res_name'];
    _resNameU = json['res_name_u'];
    _resDesc = json['res_desc'];
    _resDescU = json['res_desc_u'];
    _resWebsite = json['res_website'];
    _resImage =
        json['res_image'] != null ? ResImage.fromJson(json['res_image']) : null;
    _logo = json['logo'];
    _resPhone = json['res_phone'];
    _resAddress = json['res_address'];
    _resIsOpen = json['res_isOpen'];
    _resStatus = json['res_status'];
    _resCreateDate = json['res_create_date'];
    _resRatings = json['res_ratings'];
    _status = json['status'];
    _resVideo = json['res_video'];
    _resUrl = json['res_url'];
    _mfo = json['mfo'];
    _lat = json['lat'];
    _lon = json['lon'];
    _vid = json['vid'];
    _countryId = json['country_id'];
    _stateId = json['state_id'];
    _cityId = json['city_id'];
    _structure = json['structure'];
    _hours = json['hours'];
    _hourType = json['hour_type'];
    _experts = json['experts'];
    _serviceOffered = json['service_offered'];
    _price = json['price'];
    _baseCurrency = json['base_currency'];
    _type = json['type'];
    _providerId = json['provider_id'];
    _providerName = json['provider_name'];
    _lastLogin = json['last_login'];
    _providerImage = json['provider_image'];
    _cName = json['c_name'];
    _reviewCount = json['review_count'];
    _viewCount = json['view_count'];
    _allImage =
        json['all_image'] != null ? json['all_image'].cast<String>() : [];
  }

  String? _resId;
  String? _catId;
  String? _scatId;
  String? _resName;
  String? _resNameU;
  String? _resDesc;
  String? _resDescU;
  String? _resWebsite;
  ResImage? _resImage;
  String? _logo;
  String? _resPhone;
  String? _resAddress;
  String? _resIsOpen;
  String? _resStatus;
  String? _resCreateDate;
  String? _resRatings;
  String? _status;
  String? _resVideo;
  String? _resUrl;
  String? _mfo;
  String? _lat;
  String? _lon;
  String? _vid;
  String? _countryId;
  String? _stateId;
  String? _cityId;
  String? _structure;
  String? _hours;
  String? _hourType;
  String? _experts;
  String? _serviceOffered;
  String? _price;
  String? _baseCurrency;
  String? _type;
  String? _providerId;
  String? _providerName;
  String? _lastLogin;
  String? _providerImage;
  String? _cName;
  num? _reviewCount;
  num? _viewCount;
  List<String>? _allImage;

  Service copyWith({
    String? resId,
    String? catId,
    String? scatId,
    String? resName,
    String? resNameU,
    String? resDesc,
    String? resDescU,
    String? resWebsite,
    ResImage? resImage,
    String? logo,
    String? resPhone,
    String? resAddress,
    String? resIsOpen,
    String? resStatus,
    String? resCreateDate,
    String? resRatings,
    String? status,
    String? resVideo,
    String? resUrl,
    String? mfo,
    String? lat,
    String? lon,
    String? vid,
    String? countryId,
    String? stateId,
    String? cityId,
    String? structure,
    String? hours,
    String? hourType,
    String? experts,
    String? serviceOffered,
    String? price,
    String? baseCurrency,
    String? type,
    String? providerId,
    String? providerName,
    String? lastLogin,
    String? providerImage,
    String? cName,
    num? reviewCount,
    num? viewCount,
    List<String>? allImage,
  }) =>
      Service(
        resId: resId ?? _resId,
        catId: catId ?? _catId,
        scatId: scatId ?? _scatId,
        resName: resName ?? _resName,
        resNameU: resNameU ?? _resNameU,
        resDesc: resDesc ?? _resDesc,
        resDescU: resDescU ?? _resDescU,
        resWebsite: resWebsite ?? _resWebsite,
        resImage: resImage ?? _resImage,
        logo: logo ?? _logo,
        resPhone: resPhone ?? _resPhone,
        resAddress: resAddress ?? _resAddress,
        resIsOpen: resIsOpen ?? _resIsOpen,
        resStatus: resStatus ?? _resStatus,
        resCreateDate: resCreateDate ?? _resCreateDate,
        resRatings: resRatings ?? _resRatings,
        status: status ?? _status,
        resVideo: resVideo ?? _resVideo,
        resUrl: resUrl ?? _resUrl,
        mfo: mfo ?? _mfo,
        lat: lat ?? _lat,
        lon: lon ?? _lon,
        vid: vid ?? _vid,
        countryId: countryId ?? _countryId,
        stateId: stateId ?? _stateId,
        cityId: cityId ?? _cityId,
        structure: structure ?? _structure,
        hours: hours ?? _hours,
        hourType: hourType ?? _hourType,
        experts: experts ?? _experts,
        serviceOffered: serviceOffered ?? _serviceOffered,
        price: price ?? _price,
        baseCurrency: baseCurrency ?? _baseCurrency,
        type: type ?? _type,
        providerId: providerId ?? _providerId,
        providerName: providerName ?? _providerName,
        lastLogin: lastLogin ?? _lastLogin,
        providerImage: providerImage ?? _providerImage,
        cName: cName ?? _cName,
        reviewCount: reviewCount ?? _reviewCount,
        viewCount: viewCount ?? _viewCount,
        allImage: allImage ?? _allImage,
      );

  String? get resId => _resId;

  String? get catId => _catId;

  String? get scatId => _scatId;

  String? get resName => _resName;

  String? get resNameU => _resNameU;

  String? get resDesc => _resDesc;

  String? get resDescU => _resDescU;

  String? get resWebsite => _resWebsite;

  ResImage? get resImage => _resImage;

  String? get logo => _logo;

  String? get resPhone => _resPhone;

  String? get resAddress => _resAddress;

  String? get resIsOpen => _resIsOpen;

  String? get resStatus => _resStatus;

  String? get resCreateDate => _resCreateDate;

  String? get resRatings => _resRatings;

  String? get status => _status;

  String? get resVideo => _resVideo;

  String? get resUrl => _resUrl;

  String? get mfo => _mfo;

  String? get lat => _lat;

  String? get lon => _lon;

  String? get vid => _vid;

  String? get countryId => _countryId;

  String? get stateId => _stateId;

  String? get cityId => _cityId;

  String? get structure => _structure;

  String? get hours => _hours;

  String? get hourType => _hourType;

  String? get experts => _experts;

  String? get serviceOffered => _serviceOffered;

  String? get price => _price;

  String? get baseCurrency => _baseCurrency;

  String? get type => _type;

  String? get providerId => _providerId;

  String? get providerName => _providerName;

  String? get lastLogin => _lastLogin;

  String? get providerImage => _providerImage;

  String? get cName => _cName;

  num? get reviewCount => _reviewCount;

  num? get viewCount => _viewCount;

  List<String>? get allImage => _allImage;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['res_id'] = _resId;
    map['cat_id'] = _catId;
    map['scat_id'] = _scatId;
    map['res_name'] = _resName;
    map['res_name_u'] = _resNameU;
    map['res_desc'] = _resDesc;
    map['res_desc_u'] = _resDescU;
    map['res_website'] = _resWebsite;
    if (_resImage != null) {
      map['res_image'] = _resImage?.toJson();
    }
    map['logo'] = _logo;
    map['res_phone'] = _resPhone;
    map['res_address'] = _resAddress;
    map['res_isOpen'] = _resIsOpen;
    map['res_status'] = _resStatus;
    map['res_create_date'] = _resCreateDate;
    map['res_ratings'] = _resRatings;
    map['status'] = _status;
    map['res_video'] = _resVideo;
    map['res_url'] = _resUrl;
    map['mfo'] = _mfo;
    map['lat'] = _lat;
    map['lon'] = _lon;
    map['vid'] = _vid;
    map['country_id'] = _countryId;
    map['state_id'] = _stateId;
    map['city_id'] = _cityId;
    map['structure'] = _structure;
    map['hours'] = _hours;
    map['hour_type'] = _hourType;
    map['experts'] = _experts;
    map['service_offered'] = _serviceOffered;
    map['price'] = _price;
    map['base_currency'] = _baseCurrency;
    map['type'] = _type;
    map['provider_id'] = _providerId;
    map['provider_name'] = _providerName;
    map['last_login'] = _lastLogin;
    map['provider_image'] = _providerImage;
    map['c_name'] = _cName;
    map['review_count'] = _reviewCount;
    map['view_count'] = _viewCount;
    map['all_image'] = _allImage;
    return map;
  }
}

/// res_imag0 : "https://developmentalphawizz.com/antsnest/uploads/6329b66b2b02e.jpg"

class ResImage {
  ResImage({
    String? resImag0,
  }) {
    _resImag0 = resImag0;
  }

  ResImage.fromJson(dynamic json) {
    _resImag0 = json['res_imag0'];
  }

  String? _resImag0;

  ResImage copyWith({
    String? resImag0,
  }) =>
      ResImage(
        resImag0: resImag0 ?? _resImag0,
      );

  String? get resImag0 => _resImag0;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['res_imag0'] = _resImag0;
    return map;
  }
}
