/// status : true
/// message : "Vendors lists"
/// data : [{"id":"34","fname":"Sawan","lname":"Shakya","email":"sawan1232@mailinator.com","country_code":"+91","mobile":"7897899877","address":"Manali, Himachal Pradesh, India 46666","country_id":"3","state_id":"6","city_id":"9","dob":"2014-02-01","category_id":"43","subcategory_id":"87","postal_code":"46666","payment_details":"{\"account_holder_name\":\"Rohit Jhariya\",\"acc_no\":\"1000000420\",\"bank_name\":\"PNB \",\"bank_addr\":\"Mulund \",\"ifsc_code\":\"PNB0000988\",\"pancard_no\":\"AHQPT4583Q\",\"sort_code\":\"1111\",\"routing_number\":\"1111\",\"paypal_email_id\":\"pt.quanticteq@gmail.com\",\"contact_number\":\"9867990355\",\"mode\":\"NEFT\",\"purpose\":\"Payout\",\"razorpay_id\":\"12345687897654231\"}","lat":"0","lang":"0","uname":"Sawan Shakya","password":"","profile_image":"633a97a1251e9.png","device_token":"djSRB_aXS4qA-KXa1wRJcn:APA91bGnTOYVhH0e12IDcMPhlJib-yNRmUNQ_q0OSdZapw50B4J0CkpjZQd8ucWCDd4TCG8N7CWJ1-iMl2Y0hQAnjZrLKJwRfCgKJuSnO9kfN6IfJP9xuhLsESFG0dw0C4KsjEP-tvZb","otp":"7544","status":"1","wallet":"16308.50","balance":"2700.00","json_data":"{\"can_travel\":\"Nationwide\",\"service_cities\":\"[]\",\"website\":\"sbsbbzb\",\"t_link\":\"sbshsjdjfjfllloo\",\"i_link\":\"lllkllllll\",\"l_link\":\"iiioooouuy\",\"equipments\":\"qqaasswwww\",\"birthday\":\"21\\/10\\/2022\",\"provide_services\":\"eueieiwkwk\",\"join_antsnest\":\"ssbbsnsnsn\",\"cat\":\"42\",\"sub_cat\":\"58\",\"amount\":\"9497\",\"hrs_day\":\"Hour\",\"language\":\"Italian\"}","last_login":null,"created_at":"2022-10-10 13:30:35","updated_at":"2023-06-06 07:06:24"},{"id":"35","fname":"Sawan","lname":"Shakya","email":"sawan122@mailinator.com","country_code":"91","mobile":"7897899871","address":"","country_id":"5","state_id":"7","city_id":"2,5","dob":"0000-00-00","category_id":null,"subcategory_id":null,"postal_code":"","payment_details":null,"lat":"0","lang":"0","uname":"Sawan Shakya","password":"","profile_image":"","device_token":"fekld8wUStKbQAQCTNdIDG:APA91bHW4Lkmh5SGGspHxXkIhVnw6UA5Jz_q-xchiTMWLMDqh7E0rfW60pGe_6NpVwdek_kfRVID1oQPUzOuTX1wDJTsVWdFrqY83I-3YCMQbXvGS1jGT4UonCkbfIzXtT89JB_pKcm4","otp":"5616","status":"1","wallet":"8500.00","balance":"43899.00","json_data":null,"last_login":null,"created_at":"2022-10-10 13:30:35","updated_at":"2023-04-13 03:37:40"}]

class NewVendorModel {
  NewVendorModel({
    bool? status,
    String? message,
    List<Data>? data,
  }) {
    _status = status;
    _message = message;
    _data = data;
  }

  NewVendorModel.fromJson(dynamic json) {
    _status = json['status'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
  }

  bool? _status;
  String? _message;
  List<Data>? _data;

  NewVendorModel copyWith({
    bool? status,
    String? message,
    List<Data>? data,
  }) =>
      NewVendorModel(
        status: status ?? _status,
        message: message ?? _message,
        data: data ?? _data,
      );

  bool? get status => _status;

  String? get message => _message;

  List<Data>? get data => _data;

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

/// id : "34"
/// fname : "Sawan"
/// lname : "Shakya"
/// email : "sawan1232@mailinator.com"
/// country_code : "+91"
/// mobile : "7897899877"
/// address : "Manali, Himachal Pradesh, India 46666"
/// country_id : "3"
/// state_id : "6"
/// city_id : "9"
/// dob : "2014-02-01"
/// category_id : "43"
/// subcategory_id : "87"
/// postal_code : "46666"
/// payment_details : "{\"account_holder_name\":\"Rohit Jhariya\",\"acc_no\":\"1000000420\",\"bank_name\":\"PNB \",\"bank_addr\":\"Mulund \",\"ifsc_code\":\"PNB0000988\",\"pancard_no\":\"AHQPT4583Q\",\"sort_code\":\"1111\",\"routing_number\":\"1111\",\"paypal_email_id\":\"pt.quanticteq@gmail.com\",\"contact_number\":\"9867990355\",\"mode\":\"NEFT\",\"purpose\":\"Payout\",\"razorpay_id\":\"12345687897654231\"}"
/// lat : "0"
/// lang : "0"
/// uname : "Sawan Shakya"
/// password : ""
/// profile_image : "633a97a1251e9.png"
/// device_token : "djSRB_aXS4qA-KXa1wRJcn:APA91bGnTOYVhH0e12IDcMPhlJib-yNRmUNQ_q0OSdZapw50B4J0CkpjZQd8ucWCDd4TCG8N7CWJ1-iMl2Y0hQAnjZrLKJwRfCgKJuSnO9kfN6IfJP9xuhLsESFG0dw0C4KsjEP-tvZb"
/// otp : "7544"
/// status : "1"
/// wallet : "16308.50"
/// balance : "2700.00"
/// json_data : "{\"can_travel\":\"Nationwide\",\"service_cities\":\"[]\",\"website\":\"sbsbbzb\",\"t_link\":\"sbshsjdjfjfllloo\",\"i_link\":\"lllkllllll\",\"l_link\":\"iiioooouuy\",\"equipments\":\"qqaasswwww\",\"birthday\":\"21\\/10\\/2022\",\"provide_services\":\"eueieiwkwk\",\"join_antsnest\":\"ssbbsnsnsn\",\"cat\":\"42\",\"sub_cat\":\"58\",\"amount\":\"9497\",\"hrs_day\":\"Hour\",\"language\":\"Italian\"}"
/// last_login : null
/// created_at : "2022-10-10 13:30:35"
/// updated_at : "2023-06-06 07:06:24"

class Data {
  Data({
    String? id,
    String? fname,
    String? lname,
    String? email,
    String? countryCode,
    String? mobile,
    String? address,
    String? countryId,
    String? stateId,
    String? cityId,
    String? dob,
    String? categoryId,
    String? subcategoryId,
    String? postalCode,
    String? paymentDetails,
    String? lat,
    String? lang,
    String? uname,
    String? password,
    String? profileImage,
    String? deviceToken,
    String? otp,
    String? status,
    String? wallet,
    String? balance,
    String? jsonData,
    dynamic lastLogin,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _fname = fname;
    _lname = lname;
    _email = email;
    _countryCode = countryCode;
    _mobile = mobile;
    _address = address;
    _countryId = countryId;
    _stateId = stateId;
    _cityId = cityId;
    _dob = dob;
    _categoryId = categoryId;
    _subcategoryId = subcategoryId;
    _postalCode = postalCode;
    _paymentDetails = paymentDetails;
    _lat = lat;
    _lang = lang;
    _uname = uname;
    _password = password;
    _profileImage = profileImage;
    _deviceToken = deviceToken;
    _otp = otp;
    _status = status;
    _wallet = wallet;
    _balance = balance;
    _jsonData = jsonData;
    _lastLogin = lastLogin;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _fname = json['fname'];
    _lname = json['lname'];
    _email = json['email'];
    _countryCode = json['country_code'];
    _mobile = json['mobile'];
    _address = json['address'];
    _countryId = json['country_id'];
    _stateId = json['state_id'];
    _cityId = json['city_id'];
    _dob = json['dob'];
    _categoryId = json['category_id'];
    _subcategoryId = json['subcategory_id'];
    _postalCode = json['postal_code'];
    _paymentDetails = json['payment_details'];
    _lat = json['lat'];
    _lang = json['lang'];
    _uname = json['uname'];
    _password = json['password'];
    _profileImage = json['profile_image'];
    _deviceToken = json['device_token'];
    _otp = json['otp'];
    _status = json['status'];
    _wallet = json['wallet'];
    _balance = json['balance'];
    _jsonData = json['json_data'];
    _lastLogin = json['last_login'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  String? _id;
  String? _fname;
  String? _lname;
  String? _email;
  String? _countryCode;
  String? _mobile;
  String? _address;
  String? _countryId;
  String? _stateId;
  String? _cityId;
  String? _dob;
  String? _categoryId;
  String? _subcategoryId;
  String? _postalCode;
  String? _paymentDetails;
  String? _lat;
  String? _lang;
  String? _uname;
  String? _password;
  String? _profileImage;
  String? _deviceToken;
  String? _otp;
  String? _status;
  String? _wallet;
  String? _balance;
  String? _jsonData;
  dynamic _lastLogin;
  String? _createdAt;
  String? _updatedAt;

  Data copyWith({
    String? id,
    String? fname,
    String? lname,
    String? email,
    String? countryCode,
    String? mobile,
    String? address,
    String? countryId,
    String? stateId,
    String? cityId,
    String? dob,
    String? categoryId,
    String? subcategoryId,
    String? postalCode,
    String? paymentDetails,
    String? lat,
    String? lang,
    String? uname,
    String? password,
    String? profileImage,
    String? deviceToken,
    String? otp,
    String? status,
    String? wallet,
    String? balance,
    String? jsonData,
    dynamic lastLogin,
    String? createdAt,
    String? updatedAt,
  }) =>
      Data(
        id: id ?? _id,
        fname: fname ?? _fname,
        lname: lname ?? _lname,
        email: email ?? _email,
        countryCode: countryCode ?? _countryCode,
        mobile: mobile ?? _mobile,
        address: address ?? _address,
        countryId: countryId ?? _countryId,
        stateId: stateId ?? _stateId,
        cityId: cityId ?? _cityId,
        dob: dob ?? _dob,
        categoryId: categoryId ?? _categoryId,
        subcategoryId: subcategoryId ?? _subcategoryId,
        postalCode: postalCode ?? _postalCode,
        paymentDetails: paymentDetails ?? _paymentDetails,
        lat: lat ?? _lat,
        lang: lang ?? _lang,
        uname: uname ?? _uname,
        password: password ?? _password,
        profileImage: profileImage ?? _profileImage,
        deviceToken: deviceToken ?? _deviceToken,
        otp: otp ?? _otp,
        status: status ?? _status,
        wallet: wallet ?? _wallet,
        balance: balance ?? _balance,
        jsonData: jsonData ?? _jsonData,
        lastLogin: lastLogin ?? _lastLogin,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get id => _id;

  String? get fname => _fname;

  String? get lname => _lname;

  String? get email => _email;

  String? get countryCode => _countryCode;

  String? get mobile => _mobile;

  String? get address => _address;

  String? get countryId => _countryId;

  String? get stateId => _stateId;

  String? get cityId => _cityId;

  String? get dob => _dob;

  String? get categoryId => _categoryId;

  String? get subcategoryId => _subcategoryId;

  String? get postalCode => _postalCode;

  String? get paymentDetails => _paymentDetails;

  String? get lat => _lat;

  String? get lang => _lang;

  String? get uname => _uname;

  String? get password => _password;

  String? get profileImage => _profileImage;

  String? get deviceToken => _deviceToken;

  String? get otp => _otp;

  String? get status => _status;

  String? get wallet => _wallet;

  String? get balance => _balance;

  String? get jsonData => _jsonData;

  dynamic get lastLogin => _lastLogin;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['fname'] = _fname;
    map['lname'] = _lname;
    map['email'] = _email;
    map['country_code'] = _countryCode;
    map['mobile'] = _mobile;
    map['address'] = _address;
    map['country_id'] = _countryId;
    map['state_id'] = _stateId;
    map['city_id'] = _cityId;
    map['dob'] = _dob;
    map['category_id'] = _categoryId;
    map['subcategory_id'] = _subcategoryId;
    map['postal_code'] = _postalCode;
    map['payment_details'] = _paymentDetails;
    map['lat'] = _lat;
    map['lang'] = _lang;
    map['uname'] = _uname;
    map['password'] = _password;
    map['profile_image'] = _profileImage;
    map['device_token'] = _deviceToken;
    map['otp'] = _otp;
    map['status'] = _status;
    map['wallet'] = _wallet;
    map['balance'] = _balance;
    map['json_data'] = _jsonData;
    map['last_login'] = _lastLogin;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
