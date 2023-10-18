import 'dart:convert';
import 'package:dotted_line/dotted_line.dart';
import 'package:ez/screens/view/models/getOrder_modal.dart';
import 'package:ez/screens/view/newUI/booking_details.dart';
import 'package:ez/screens/view/newUI/viewBookingNotification.dart';
import 'package:ez/screens/view/newUI/viewOrders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ez/constant/global.dart';
import 'package:ez/constant/sizeconfig.dart';
import 'package:ez/screens/view/models/getBookingModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../NewChatPage.dart';
import '../../chat_page.dart';
import '../models/getUserModel.dart';
// import 'package:toast/toast.dart';

// ignore: must_be_immutable
class BookingScreen extends StatefulWidget {
  bool? back;
  BookingScreen({this.back});
  @override
  _BookingState createState() => _BookingState();
}

class _BookingState extends State<BookingScreen> {
  bool explorScreen = false;
  bool mapScreen = true;
  GetBookingModel? model;
  GetOrdersModal? getOrdersModal;

  @override
  void initState() {
    // getOrderApi();
    super.initState();
    Future.delayed(Duration(milliseconds: 200),(){
      return getUserDataApicalls();
    });
    Future.delayed(Duration(milliseconds: 400),(){
      return getBookingAPICall();
    });
  }

  getOrderApi() async {
    try {
      Map<String, String> headers = {
        'content-type': 'application/x-www-form-urlencoded',
      };
      var map = new Map<String, dynamic>();
      map['user_id'] = userID;

      final response = await client.post(Uri.parse("${baseUrl()}/get_user_orders"),
          headers: headers, body: map);

      Map<String, dynamic> userMap = jsonDecode(response.body);
      setState(() {
        getOrdersModal = GetOrdersModal.fromJson(userMap);
      });
    } on Exception {
      Fluttertoast.showToast(msg: "No Internet connection");
      throw Exception('No Internet connection');
    }
  }


  GeeUserModel? models;
  String selectedCurrency = '';

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

  getBookingAPICall() async {
      Map<String, String> headers = {
        'content-type': 'application/x-www-form-urlencoded',
      };
      var map = new Map<String, dynamic>();
      map['user_id'] = userID;
      map['currency'] = selectedCurrency.toString();
      final response = await client.post(Uri.parse("${baseUrl()}/get_booking_by_user"),
          headers: headers, body: map);
      print("ok now here ${selectedCurrency} and ${baseUrl()}/get_booking_by_user");
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

  Future<Null> refreshFunction() async {
    print("checking refresh indicator here now");
    await getBookingAPICall();

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: Scaffold(
        backgroundColor: appColorWhite,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)
              ),
          ),
          backgroundColor: backgroundblack,
          elevation: 0,
          title: Text(
            'My Bookings',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: widget.back == true
              ?   Padding(
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
          )
              : Container(),
        ),
        body: RefreshIndicator(
          onRefresh: refreshFunction,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                bookingWidget()
                // Expanded(
                //   child: DefaultTabController(
                //     length: 1,
                //     initialIndex: 0,
                //     child: Column(
                //       children: <Widget>[
                //         /*Container(
                //           width: 250,
                //           height: 40,
                //           decoration: new BoxDecoration(
                //               borderRadius: BorderRadius.circular(8),
                //               color: Colors.grey[300]),
                //           child: Center(
                //             child: TabBar(
                //               labelColor: appColorWhite,
                //               unselectedLabelColor: appColorBlack,
                //               labelStyle: TextStyle(
                //                   fontSize: 13.0,
                //                   color: appColorWhite,
                //                   fontWeight: FontWeight.bold),
                //               unselectedLabelStyle: TextStyle(
                //                   fontSize: 13.0,
                //                   color: appColorBlack,
                //                   fontWeight: FontWeight.bold),
                //               indicator: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(8),
                //                   color: Color(0xFF619aa5)),
                //               tabs: <Widget>[
                //                 // Tab(
                //                 //   text: 'Orders',
                //                 // ),
                //                 Tab(
                //                   text: 'Booking',
                //                 ),
                //               ],
                //             ),
                //           ),
                //         ),*/
                //         Expanded(
                //           child: TabBarView(
                //             children: <Widget>[
                //               // orderWidget(),
                //               bookingWidget()
                //             ],
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // _refresh(){
  //   getBookingAPICall();
  // }

  Widget orderWidget() {
    return getOrdersModal == null
        ? Center(
            child: Image.asset("assets/images/loader1.gif"),
          )
        : getOrdersModal!.responseCode != "0"
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                //physics: const NeverScrollableScrollPhysics(),
                itemCount: getOrdersModal!.orders!.length,
                //scrollDirection: Axis.horizontal,
                itemBuilder: (
                  context,
                  int index,
                ) {
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewOrders(
                                  orders: getOrdersModal!.orders![index])),
                        );
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, right: 25, top: 20),
                              child: Container(
                                height: 100,
                                width: double.infinity,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateFormat('dd').format(
                                                  DateTime.parse(getOrdersModal!
                                                      .orders![index].date.toString())),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22),
                                            ),
                                            Text(
                                              DateFormat('MMM').format(
                                                  DateTime.parse(getOrdersModal!
                                                      .orders![index].date.toString())),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17),
                                            ),
                                          ],
                                        ),
                                        Container(width: 10),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 20,
                                              bottom: 20,
                                              left: 10,
                                              right: 10),
                                          child: DottedLine(
                                            direction: Axis.vertical,
                                            lineLength: double.infinity,
                                            lineThickness: 1.0,
                                            dashLength: 4.0,
                                            dashColor: Colors.grey[600],
                                            dashRadius: 0.0,
                                            dashGapLength: 4.0,
                                            dashGapColor: Colors.transparent,
                                            dashGapRadius: 0.0,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "OrderId: " +
                                                    getOrdersModal!
                                                        .orders![index].orderId.toString(),
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Container(height: 4),
                                              Text(
                                                "TxnId: " +
                                                    getOrdersModal!
                                                        .orders![index].txnId.toString(),
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ));
                },
              )
            : Center(
                child: Text(
                  "Don't have any Orders",
                  style: TextStyle(
                    color: appColorBlack,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
  }

  Widget bookingWidget() {
    return model == null
        ? Center(
            child: Image.asset("assets/images/loader1.gif"),
          )
        : model!.booking!.isNotEmpty
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                //physics: const NeverScrollableScrollPhysics(),
                itemCount: model!.booking!.length,
                //scrollDirection: Axis.horizontal,
                itemBuilder: (context, int index,) {
                  var dateFormate =  DateFormat("dd/MM/yyyy").format(DateTime.parse(model!.booking![index].date ?? ""));
                  return InkWell(
                      onTap: () async {
                        bool result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BookingDetailScreen(model!.booking![index], ),
                        ));
                        if(result == true){
                          setState(() {
                            getBookingAPICall();
                          });
                        }
                      },
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25, right: 25, top: 15),
                              child: Container(
                                height: 130,
                                width: double.infinity,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, right: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              DateFormat('dd').format(
                                                  DateTime.parse(model!
                                                      .booking![index].date.toString())),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 22),
                                            ),
                                            Text(
                                              DateFormat('MMM').format(
                                                  DateTime.parse(model!
                                                      .booking![index].date.toString())),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 17),
                                            ),
                                          ],
                                        ),
                                        Container(width: 10),
                                        Padding(
                                          padding: EdgeInsets.only(
                                              top: 20,
                                              bottom: 20,
                                              left: 10,
                                              right: 10),
                                          child: DottedLine(
                                            direction: Axis.vertical,
                                            lineLength: double.infinity,
                                            lineThickness: 1.0,
                                            dashLength: 4.0,
                                            dashColor: Colors.grey[600],
                                            dashRadius: 0.0,
                                            dashGapLength: 4.0,
                                            dashGapColor: Colors.transparent,
                                            dashGapRadius: 0.0,
                                          ),
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                               "Booking Id - ${ model!.booking![index].id.toString()}",
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.bold),
                                              ),
                                              Container(height: 2),
                                              Text(
                                                model!.booking![index].service!.resName.toString(),
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Container(height: 2),
                                              Text(
                                                "$dateFormate",
                                                // model!.booking![index].date!,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                              ),
                                              Container(height: 2),
                                              Text(
                                                model!.booking![index].slot!,
                                                maxLines: 1,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12),
                                              )
                                              // model!.booking![index].status == "Completed"
                                              //     ? Container(
                                              //  // width: 80,
                                              //   height: 30,
                                              //   alignment: Alignment.center,
                                              //   decoration: BoxDecoration(
                                              //     borderRadius: BorderRadius.circular(10.0),
                                              //     color: Colors.green
                                              //   ),
                                              //   child: Text(
                                              //     model!.booking![index].status!,
                                              //     maxLines: 1,
                                              //     textAlign: TextAlign.center,
                                              //     style: TextStyle(
                                              //         color: Colors.white,
                                              //         fontSize: 12),
                                              //   ),
                                              // )
                                              //     : model!.booking![index].status == "Cancelled by user" ? Container(
                                              //   //width: 80,
                                              //   height: 30,
                                              //   alignment: Alignment.center,
                                              //   decoration: BoxDecoration(
                                              //       borderRadius: BorderRadius.circular(10.0),
                                              //       color: Colors.red
                                              //   ),
                                              //   child: Text(
                                              //     model!.booking![index].status!,
                                              //     maxLines: 1,
                                              //     textAlign: TextAlign.center,
                                              //     style: TextStyle(
                                              //         color: Colors.white,
                                              //         fontSize: 12),
                                              //   ),
                                              // ) : model!.booking![index].status == "Cancelled by vendor" ?
                                              // Container(
                                              //   //width: 80,
                                              //   height: 30,
                                              //   alignment: Alignment.center,
                                              //   decoration: BoxDecoration(
                                              //       borderRadius: BorderRadius.circular(10.0),
                                              //       color: Colors.red
                                              //   ),
                                              //   child: Text(
                                              //     model!.booking![index].status!,
                                              //     maxLines: 1,
                                              //     textAlign: TextAlign.center,
                                              //     style: TextStyle(
                                              //         color: appColorWhite,
                                              //         fontSize: 12),
                                              //   ),
                                              // ) :
                                              // Container(
                                              // //  width: 80,
                                              //   height: 30,
                                              //   alignment: Alignment.center,
                                              //   decoration: BoxDecoration(
                                              //       borderRadius: BorderRadius.circular(10.0),
                                              //       color: backgroundblack
                                              //   ),
                                              //   child: Text(
                                              //     model!.booking![index].status!,
                                              //     maxLines: 1,
                                              //     textAlign: TextAlign.center,
                                              //     style: TextStyle(
                                              //         color: appColorWhite,
                                              //         fontSize: 12),
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(
                                              providerId: model?.booking?[index].service?.providerId,
                                              providerName: model?.booking?[index].service?.providerName,
                                              providerImage: model?.booking?[index].service?.providerImage,
                                              bookingId: model?.booking?[index].id,
                                              lastSeen: model?.booking?[index].service?.lastLogin
                                            ),
                                            ),
                                            );
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(100),
                                              color: backgroundblack,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Icon(Icons.chat,color: appColorWhite,),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ));
                },
              )
            : Center(
                child: Text(
                  "Don't have any Booking",
                  style: TextStyle(
                    color: appColorBlack,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
  }
}
