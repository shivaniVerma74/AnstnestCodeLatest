// To parse this JSON data, do
//
//     final blogsModel = blogsModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

BlogsModel blogsModelFromJson(String str) =>
    BlogsModel.fromJson(json.decode(str));

String blogsModelToJson(BlogsModel data) => json.encode(data.toJson());

class BlogsModel {
  String responseCode;
  String status;
  List<DatumBlogs> data;

  BlogsModel({
    required this.responseCode,
    required this.status,
    required this.data,
  });

  factory BlogsModel.fromJson(Map<String, dynamic> json) => BlogsModel(
        responseCode: json["response_code"],
        status: json["status"],
        data: List<DatumBlogs>.from(
            json["data"].map((x) => DatumBlogs.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response_code": responseCode,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class DatumBlogs {
  String id;
  String vendorId;
  String title;
  String description;
  String image;
  String status;

  DatumBlogs({
    required this.id,
    required this.vendorId,
    required this.title,
    required this.description,
    required this.image,
    required this.status,
  });

  factory DatumBlogs.fromJson(Map<String, dynamic> json) => DatumBlogs(
        id: json["id"],
        vendorId: json["vendor_id"],
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        image: json["image"] ?? "",
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "vendor_id": vendorId,
        "title": title,
        "description": description,
        "image": image,
        "status": status,
      };
}
