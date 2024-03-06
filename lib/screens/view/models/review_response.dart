class ReviewResponse {
  String? status;
  String? message;
  List<ReviewData>? review;

  ReviewResponse({this.status, this.message, this.review});

  ReviewResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['Review'] != null) {
      review = <ReviewData>[];
      json['Review'].forEach((v) {
        review!.add(new ReviewData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.review != null) {
      data['Review'] = this.review!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReviewData {
  String? username;
  String? revId;
  String? revUser;
  String? revRes;
  String? revStars;
  String? revText;
  String? revDate;
  String? createdAt;
  String? profilePic;

  List<ReplyData>? replyData;

  ReviewData(
      {this.username,
        this.revId,
        this.revUser,
        this.revRes,
        this.revStars,
        this.revText,
        this.revDate,
        this.createdAt,
        this.replyData,this.profilePic});

  ReviewData.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    profilePic = json['profile_pic'];
    revId = json['rev_id'];
    revUser = json['rev_user'];
    revRes = json['rev_res'];
    revStars = json['rev_stars'];
    revText = json['rev_text'];
    revDate = json['rev_date'];
    createdAt = json['created_at'];
    if (json['reply_data'] != null) {
      replyData = <ReplyData>[];
      json['reply_data'].forEach((v) {
        replyData!.add(new ReplyData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['profile_pic'] = this.profilePic;

    data['rev_id'] = this.revId;
    data['rev_user'] = this.revUser;
    data['rev_res'] = this.revRes;
    data['rev_stars'] = this.revStars;
    data['rev_text'] = this.revText;
    data['rev_date'] = this.revDate;
    data['created_at'] = this.createdAt;
    if (this.replyData != null) {
      data['reply_data'] = this.replyData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ReplyData {
  String? username;
  String? userId;
  String? reviewId;
  String? replyText;
  String? createdAt;
  String? id;
  String? replyId;
  List<ReplyData>? replyData;

  ReplyData(
      {this.username,
        this.userId,
        this.reviewId,
        this.replyText,
        this.createdAt,
        this.id,
        this.replyId,
        this.replyData});

  ReplyData.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    userId = json['user_id'];
    reviewId = json['review_id'];
    replyText = json['reply_text'];
    createdAt = json['created_at'];
    id = json['id'];
    replyId = json['reply_id'];
    if (json['reply_data'] != null) {
      replyData = <ReplyData>[];
      json['reply_data'].forEach((v) {
        replyData!.add(new ReplyData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['user_id'] = this.userId;
    data['review_id'] = this.reviewId;
    data['reply_text'] = this.replyText;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    data['reply_id'] = this.replyId;
    if (this.replyData != null) {
      data['reply_data'] = this.replyData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

