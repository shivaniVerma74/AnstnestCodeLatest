import 'dart:convert';
import 'package:ez/constant/global.dart';
import 'package:ez/constant/sizeconfig.dart';
import 'package:ez/screens/view/models/bookingNotification_modal.dart';
import 'package:ez/screens/view/models/getBookingModel.dart';
import 'package:ez/screens/view/models/getUserModel.dart';
import 'package:ez/screens/view/models/notification_modal.dart';
import 'package:ez/screens/view/newUI/viewBookingNotification.dart';
import 'package:ez/screens/view/newUI/viewNotification.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'booking_details.dart';

// ignore: must_be_immutable
class NotificationList extends StatefulWidget {
  @override
  _NotificationListState createState() => new _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  NotificationModal? modal;
  BookingNotificationModal? bookingNotificationModal;

  @override
  void initState() {
    _getData();
    _getData2();
    super.initState();

    Future.delayed(Duration(milliseconds: 200), () {
      return getUserDataApicalls();
    });
    Future.delayed(Duration(milliseconds: 400), () {
      return getBookingAPICall();
    });
  }

  _getData() async {
    var uri = Uri.parse('${baseUrl()}/order_notification_listing');
    var request = new http.MultipartRequest("Post", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({'user_id': userID});
    request.fields['user_id'] = userID;
    var response = await request.send();
    print(" response data here ${response.statusCode}");
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    if (mounted) {
      setState(() {
        modal = NotificationModal.fromJson(userData);
      });
    }
  }

  _getData2() async {
    var uri = Uri.parse('${baseUrl()}/booking_notification_listing');

    var request = new http.MultipartRequest("Post", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({'user_id': userID});
    request.fields['user_id'] = userID;
    print("checking rrequest here ${uri} and ${request.fields}");
    var response = await request.send();
    print("booking listing here ${response.statusCode}");
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    if (mounted) {
      setState(() {
        bookingNotificationModal = BookingNotificationModal.fromJson(userData);
        // print("notification list is here ${bookingNotificationModal!.notifications!.length}");
      });
    }
  }

  _readNotification() async {
    var uri = Uri.parse('${baseUrl()}/read_notification_message_user');

    var request = new http.MultipartRequest("Post", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({'user_id': userID});
    request.fields['user_id'] = userID;
    print("checking rrequest here ${uri} and ${request.fields}");
    var response = await request.send();
    print("booking listing here ${response.statusCode}");
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    if (mounted) {
      setState(() {
        // print("notification list is here ${bookingNotificationModal!.notifications!.length}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: new BoxDecoration(),
      child: Scaffold(
        backgroundColor: appColorWhite,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          backgroundColor: primary,
          elevation: 2,
          title: Text(
            'Notification',
            style: TextStyle(color: appColorWhite, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: Padding(
            padding: const EdgeInsets.all(12),
            child: RawMaterialButton(
              shape: CircleBorder(),
              padding: const EdgeInsets.all(0),
              fillColor: Colors.white,
              splashColor: Colors.grey[400],
              child: Icon(
                Icons.arrow_back,
                size: 20,
                color: appColorBlack,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: Column(
          children: [
            Container(height: 15),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 0),
                child: DefaultTabController(
                  length: 1,
                  initialIndex: 0,
                  child: Column(
                    children: <Widget>[
                      /*Container(
                        width: 250,
                        height: 40,
                        decoration: new BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[300]),
                        child: Center(
                          child: TabBar(
                            labelColor: appColorWhite,
                            unselectedLabelColor: appColorBlack,
                            labelStyle: TextStyle(
                                fontSize: 13.0,
                                color: appColorWhite,
                                fontWeight: FontWeight.bold),
                            unselectedLabelStyle: TextStyle(
                                fontSize: 13.0,
                                color: appColorBlack,
                                fontWeight: FontWeight.bold),
                            indicator: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Color(0xFF619aa5)),
                            tabs: <Widget>[
                              Tab(
                                text: 'Orders',
                              ),
                              Tab(
                                text: 'Booking',
                              ),
                            ],
                          ),
                        ),
                      ),*/
                      Expanded(
                        child: TabBarView(
                          children: <Widget>[
                            // orderWidget(),
                            bookingWidget()
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget orderWidget() {
    return modal == null
        ? Align(
            alignment: Alignment.center,
            child: Container(
              height: 20,
              width: 20,
              child: Image.asset("assets/images/loader1.gif"),
              // child: Center(
              //     child: CircularProgressIndicator(
              //   strokeWidth: 3,
              //   valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
              // ),
            ),
          )
        : modal!.responseCode == '1'
            ? Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: ListView.builder(
                    shrinkWrap: true,
                    //physics: NeverScrollableScrollPhysics(),
                    itemCount: modal!.notifications!.length,
                    itemBuilder: (context, index) => dataWidget(index)),
              )
            : Container(
                height: SizeConfig.screenHeight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Image.asset(
                          "assets/images/emptyNotification.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        'Notification list is empty',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                ),
              );
  }

  Widget dataWidget(int index) {
    return Column(
      children: [
        Container(
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(5.0),
            child: InkWell(
              splashColor: Colors.grey[200],
              focusColor: Colors.grey[200],
              highlightColor: Colors.grey[200],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ViewNotification(
                          products: modal!.notifications![index].products!)),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: index % 3 == 0
                              ? Color(0xFFE9E4B2)
                              : index % 3 == 1
                                  ? Color(0xFFEBBFA1)
                                  : Color(0xFFC6D3EF),
                          shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: modal!.notifications![index].title ==
                                "Order Placed"
                            ? Image.asset(
                                "assets/images/orderPlaced.png",
                              )
                            : modal!.notifications![index].title ==
                                    "Order Dispatch"
                                ? Image.asset(
                                    "assets/images/order Dispatch.png",
                                    height: 20)
                                : modal!.notifications![index].title ==
                                        "Order Deliver"
                                    ? Image.asset(
                                        "assets/images/orderDeliver.png",
                                        height: 20)
                                    : modal!.notifications![index].title ==
                                            "Order Cancel"
                                        ? Image.asset(
                                            "assets/images/orderCancel.png",
                                            height: 20)
                                        : Icon(
                                            FontAwesomeIcons.truckMonster,
                                            size: 20,
                                            color:
                                                Colors.black.withOpacity(0.2),
                                          ),
                      ),
                    ),
                    SizedBox(width: 15),
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(modal!.notifications![index].message!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: appColorGreen,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'OderId: ${modal!.notifications![index].dataId}',
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  format(
                                    DateTime.parse(
                                        modal!.notifications![index].date!),
                                  ),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Divider(color: Colors.black45, thickness: 0.3)
      ],
    );
  }

  Widget bookingWidget() {
    return bookingNotificationModal == null
        ? Align(
            alignment: Alignment.center,
            child: Container(
                height: 20,
                width: 20,
                child: Center(
                    child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                ))),
          )
        : bookingNotificationModal!.responseCode == '1'
            ? Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: ListView.builder(
                    shrinkWrap: true,
                    //physics: NeverScrollableScrollPhysics(),
                    itemCount: bookingNotificationModal!.notifications!.length,
                    itemBuilder: (context, index) => bookingItemWidget(index)),
              )
            : Container(
                height: SizeConfig.screenHeight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        child: Image.asset(
                          "assets/images/emptyNotification.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        'Notification list is empty',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
                ),
              );
  }

  getUserDataApicalls() async {
    try {
      Map<String, String> headers = {
        'content-type': 'application/x-www-form-urlencoded',
      };
      var map = new Map<String, dynamic>();
      map['user_id'] = userID;

      final response = await client.post(Uri.parse("${baseUrl()}/user_data"),
          headers: headers, body: map);
      print(map.toString());
      print("user data here now ${baseUrl()}/user_data   and ${map}");
      var dic = json.decode(response.body);
      Map<String, dynamic> userMap = jsonDecode(response.body);
      models = GeeUserModel.fromJson(userMap);

      userEmail = models!.user!.email!;
      userMobile = models!.user!.mobile!;
      setState(() {
        selectedCurrency = models!.user!.currency.toString();
      });

      print("checking selected currency ${selectedCurrency}");
      // _username.text = model!.user!.username!;
      // _mobile.text = model!.user!.mobile!;
      // _address.text = model!.user!.address ?? "";
      // phoneCode = model!.user!.c
      print("GetUserData>>>>>>");
      print(dic);
    } on Exception {
      Fluttertoast.showToast(msg: "No Internet connection");
      throw Exception('No Internet connection');
    }
  }

  GeeUserModel? models;

  GetBookingModel? model;
  String selectedCurrency = '';
  getBookingAPICall() async {
    Map<String, String> headers = {
      'content-type': 'application/x-www-form-urlencoded',
    };
    var map = new Map<String, dynamic>();
    map['user_id'] = userID;
    map['currency'] = selectedCurrency.toString();
    final response = await client.post(
        Uri.parse("${baseUrl()}/get_booking_by_user"),
        headers: headers,
        body: map);
    print(
        "ok now here ${selectedCurrency} and ${baseUrl()}/get_booking_by_user");
    print('___________${map}__________');
    var dic = json.decode(response.body);
    Map<String, dynamic> userMap = jsonDecode(response.body);
    setState(() {
      model = GetBookingModel.fromJson(userMap);
    });
    debugPrint(response.body);
    // } on Exception {
    //   Fluttertoast.showToast(msg: "No Internet connection");
    //   throw Exception('No Internet connection');
    // }
  }

  Widget bookingItemWidget(int index) {
    var dateFormate = DateFormat("dd/MM/yyyy").format(DateTime.parse(
        bookingNotificationModal!.notifications![index].date! ?? ""));
    return Column(
      children: [
        Container(
          child: Material(
            elevation: 0,
            borderRadius: BorderRadius.circular(5.0),
            child: InkWell(
              splashColor: Colors.grey[200],
              focusColor: Colors.grey[200],
              highlightColor: Colors.grey[200],
              onTap: () async {
                for (int i = 0; i < model!.booking!.length; i++) {
                  if (model!.booking![i].id.toString() ==
                      bookingNotificationModal!.notifications![index].dataId
                          .toString()) {
                              //this
                    bool result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingDetailScreen(
                                model!.booking![index],
                              ),
                            ));
                        if (result == true) {
                          setState(() {
                            getBookingAPICall();
                          });
                        }

                          }
                }
              
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) => ViewBookingNotification(
                //           booking: bookingNotificationModal!
                //               .notifications![index].booking!)),
                // );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: index % 3 == 0
                              ? Color(0xFFE9E4B2)
                              : index % 3 == 1
                                  ? Color(0xFFEBBFA1)
                                  : Color(0xFFC6D3EF),
                          shape: BoxShape.circle),
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: bookingNotificationModal!.notifications![index].title ==
                                  "Booking accepted"
                              ? Image.asset(
                                  "assets/images/booking confirmed.png",
                                )
                              : bookingNotificationModal!.notifications![index].title ==
                                      "Payment Success"
                                  ? Icon(Icons.check)
                                  : bookingNotificationModal!.notifications![index].title ==
                                          "Booking Request"
                                      ? Image.asset(
                                          "assets/images/booking request.png",
                                        )
                                      : bookingNotificationModal!
                                                  .notifications![index]
                                                  .title ==
                                              "Booking On Way"
                                          ? Image.asset("assets/images/order Dispatch.png",
                                              height: 20)
                                          : bookingNotificationModal!
                                                      .notifications![index]
                                                      .title ==
                                                  "Booking Completed"
                                              ? Image.asset(
                                                  "assets/images/orderDeliver.png",
                                                  height: 20)
                                              : bookingNotificationModal!
                                                          .notifications![index]
                                                          .title ==
                                                      "Booking Cancel"
                                                  ? Image.asset(
                                                      "assets/images/booking cancel.png",
                                                      height: 20)
                                                  : bookingNotificationModal!
                                                              .notifications![index]
                                                              .title ==
                                                          "Booking Confirm"
                                                      ? Image.asset("assets/images/booking confirmed.png", height: 20)
                                                      : Image.asset("assets/images/booking cancel.png", height: 20)),
                    ),
                    SizedBox(width: 15),
                    Flexible(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                    bookingNotificationModal!
                                        .notifications![index].message!,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: appColorGreen,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Booking Id: ${bookingNotificationModal!.notifications![index].dataId}',
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: Theme.of(context).textTheme.caption,
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "${dateFormate}",
                                  // format(
                                  //   DateTime.parse(bookingNotificationModal!
                                  //       .notifications![index].date!),
                                  // ),
                                  overflow: TextOverflow.fade,
                                  softWrap: false,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Divider(color: Colors.black45, thickness: 0.3)
      ],
    );
  }
}
