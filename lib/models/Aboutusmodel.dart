/// response_code : "1"
/// msg : "About Us"
/// data : {"id":"2","title":"About Us","slug":"about-us","html":"<p>Our Story</p>\r\n\r\n<p>AntsNest started in 2021 when its co-founders Aatiya and Niraj were traveling to Prague for a work event. They encountered a problem when the photographer backed out at the last moment, and it took them a village to find a reliable local photographer hours before the event with the language barrier being one of the many challenges. It struck them how overseas travellers like themselves would be facing challenges to find trustworthy and pocket-friendly professional services.</p>\r\n\r\n<p>Colleagues turned Entrepreneurs, Aatiya and Niraj started AntsNest as a platform, or a &lsquo;Nest&rsquo;, of handpicked practitioners, or &lsquo;Ants&rsquo;, across geographies. The platform caters to the needs of travelers who wish to source reliable and vetted professionals. Unlike other expert listing websites, AntsNest handpicks and verifies an Ant before listing them for its consumers so that another person like the founders themselves never has to go through the pain of finding a reliable professional when in a foreign land!</p>\r\n","created_at":"2022-11-08 10:21:09","updated_at":"2023-07-24 13:08:12"}

class Aboutusmodel {
  Aboutusmodel({
    String? responseCode,
    String? msg,
    Data? data,
  }) {
    _responseCode = responseCode;
    _msg = msg;
    _data = data;
  }

  Aboutusmodel.fromJson(dynamic json) {
    _responseCode = json['response_code'];
    _msg = json['msg'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  String? _responseCode;
  String? _msg;
  Data? _data;

  Aboutusmodel copyWith({
    String? responseCode,
    String? msg,
    Data? data,
  }) =>
      Aboutusmodel(
        responseCode: responseCode ?? _responseCode,
        msg: msg ?? _msg,
        data: data ?? _data,
      );

  String? get responseCode => _responseCode;

  String? get msg => _msg;

  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['response_code'] = _responseCode;
    map['msg'] = _msg;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }
}

/// id : "2"
/// title : "About Us"
/// slug : "about-us"
/// html : "<p>Our Story</p>\r\n\r\n<p>AntsNest started in 2021 when its co-founders Aatiya and Niraj were traveling to Prague for a work event. They encountered a problem when the photographer backed out at the last moment, and it took them a village to find a reliable local photographer hours before the event with the language barrier being one of the many challenges. It struck them how overseas travellers like themselves would be facing challenges to find trustworthy and pocket-friendly professional services.</p>\r\n\r\n<p>Colleagues turned Entrepreneurs, Aatiya and Niraj started AntsNest as a platform, or a &lsquo;Nest&rsquo;, of handpicked practitioners, or &lsquo;Ants&rsquo;, across geographies. The platform caters to the needs of travelers who wish to source reliable and vetted professionals. Unlike other expert listing websites, AntsNest handpicks and verifies an Ant before listing them for its consumers so that another person like the founders themselves never has to go through the pain of finding a reliable professional when in a foreign land!</p>\r\n"
/// created_at : "2022-11-08 10:21:09"
/// updated_at : "2023-07-24 13:08:12"

class Data {
  Data({
    String? id,
    String? title,
    String? slug,
    String? html,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _title = title;
    _slug = slug;
    _html = html;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _slug = json['slug'];
    _html = json['html'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  String? _id;
  String? _title;
  String? _slug;
  String? _html;
  String? _createdAt;
  String? _updatedAt;

  Data copyWith({
    String? id,
    String? title,
    String? slug,
    String? html,
    String? createdAt,
    String? updatedAt,
  }) =>
      Data(
        id: id ?? _id,
        title: title ?? _title,
        slug: slug ?? _slug,
        html: html ?? _html,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
      );

  String? get id => _id;

  String? get title => _title;

  String? get slug => _slug;

  String? get html => _html;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['slug'] = _slug;
    map['html'] = _html;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
