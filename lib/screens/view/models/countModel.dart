// To parse this JSON data, do
//
//     final countModel = countModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CountModel countModelFromJson(String str) =>
    CountModel.fromJson(json.decode(str));

String countModelToJson(CountModel data) => json.encode(data.toJson());

class CountModel {
  String responseCode;
  String status;
  DataCount data;

  CountModel({
    required this.responseCode,
    required this.status,
    required this.data,
  });

  factory CountModel.fromJson(Map<String, dynamic> json) => CountModel(
        responseCode: json["response_code"],
        status: json["status"],
        data: DataCount.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "response_code": responseCode,
        "status": status,
        "data": data.toJson(),
      };
}

class DataCount {
  Bookings bookings;
  Notifications notifications;

  DataCount({
    required this.bookings,
    required this.notifications,
  });

  factory DataCount.fromJson(Map<String, dynamic> json) => DataCount(
        bookings: Bookings.fromJson(json["bookings"]),
        notifications: Notifications.fromJson(json["notifications"]),
      );

  Map<String, dynamic> toJson() => {
        "bookings": bookings.toJson(),
        "notifications": notifications.toJson(),
      };
}

class Bookings {
  String totalBooking;

  Bookings({
    required this.totalBooking,
  });

  factory Bookings.fromJson(Map<String, dynamic> json) => Bookings(
        totalBooking: json["total_booking"],
      );

  Map<String, dynamic> toJson() => {
        "total_booking": totalBooking,
      };
}

class Notifications {
  String totalNotification;

  Notifications({
    required this.totalNotification,
  });

  factory Notifications.fromJson(Map<String, dynamic> json) => Notifications(
        totalNotification: json["total_notification"],
      );

  Map<String, dynamic> toJson() => {
        "total_notification": totalNotification,
      };
}
