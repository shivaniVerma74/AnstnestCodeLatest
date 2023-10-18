import 'dart:convert';
import 'package:ez/screens/view/models/newVendorModel.dart';
import 'package:ez/screens/view/newUI/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:ez/constant/global.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../chat_page.dart';
import '../models/MessageModel.dart';
import '../models/getBookingModel.dart';
import 'Chat_Detail.dart';

class ChatScreen extends StatefulWidget {
  String? id, postid;
  bool fromPost;
  ChatScreen({this.id,this.postid,this.fromPost= false});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  NewVendorModel? newVendorModel;

  getVendor()async{
    var headers = {
      'Cookie': 'ci_session=04eca0e1e2a787a9ed34f528cb675bbb49c3ea10'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl()}/get_vendors'));
    request.fields.addAll({
      'ids': '${widget.id}'
    });
    print("herre idss ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = NewVendorModel.fromJson(json.decode(finalResult));
      setState(() {
        newVendorModel = jsonResponse;
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }


  GetBookingModel? model;
  getBookingAPICall() async {
    try {
      Map<String, String> headers = {
        'content-type': 'application/x-www-form-urlencoded',
      };
      var map = new Map<String, dynamic>();
      map['user_id'] = userID;

      final response = await client.post(Uri.parse("${baseUrl()}/get_booking_by_user"),
          headers: headers, body: map);

      var dic = json.decode(response.body);
      print("booking data" + map.toString());
      print("sds ${baseUrl()}/get_booking_by_user");
      Map<String, dynamic> userMap = jsonDecode(response.body);
      setState(() {
        model = GetBookingModel.fromJson(userMap);
      });
      return GetBookingModel.fromJson(userMap);
      print("GetBooking>>>>>>");
      print(dic);
    } on Exception {
      Fluttertoast.showToast(msg: "No Internet connection");
      throw Exception('No Internet connection');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 200),(){
      return getVendor();
    });

    // getBookingAPICall();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)
            )
        ),
        backgroundColor: backgroundblack,
        elevation: 0,
        title: Text(
          'Providers',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
        )
      ),
      body: Container(
        child: newVendorModel == null ? SizedBox() : newVendorModel!.data == null ? Center(child: Text("No data to show"),) : ListView.builder(
          itemCount: newVendorModel!.data!.length,
          itemBuilder: (BuildContext context, int index) {
            // final Message chat = chats[index];
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    print("checking chat data here now now ${widget.postid} and ${ newVendorModel!.data![index].uname} andc ${ newVendorModel!.data![index].id} and ${ newVendorModel!.data![index].profileImage}");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatPage(
                          fromPost: widget.fromPost,
                          bookingId: '${widget.postid}',
                          providerName: newVendorModel!.data![index].uname,
                          providerId: newVendorModel!.data![index].id,
                          providerImage: newVendorModel!.data![index].profileImage,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(2),
                          decoration
                              : BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0.1,
                                blurRadius: 0.1,
                              ),
                            ],
                          ),
                          child: newVendorModel!.data![index].profileImage == null ? CircleAvatar(
                              radius: 25,
                              backgroundColor: backgroundgrey,
                              backgroundImage: AssetImage("")
                          ) : CircleAvatar(
                            radius: 25,
                            backgroundColor: backgroundgrey,
                            backgroundImage: NetworkImage("${imageUrl}${newVendorModel!.data![index].profileImage}"),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          padding: EdgeInsets.only(
                            left: 20,
                          ),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Text( "${newVendorModel!.data![index].uname}",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // chat. == true
                                      //     ? Container(
                                      //   margin: const EdgeInsets.only(left: 5),
                                      //   width: 7,
                                      //   height: 7,
                                      //   decoration: BoxDecoration(
                                      //     shape: BoxShape.circle,
                                      //     color: backgroundgrey,
                                      //   ),
                                      // )
                                      //     : Container(
                                      //   child: null,
                                      // ),
                                    ],
                                  ),
                                  // Text(
                                  //   chat.time.toString(),
                                  //   style: TextStyle(
                                  //     fontSize: 11,
                                  //     fontWeight: FontWeight.w300,
                                  //     color: Colors.black54,
                                  //   ),
                                  // ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              // Container(
                              //   alignment: Alignment.topLeft,
                              //   child: Text(
                              //     chat.text.toString(),
                              //     style: TextStyle(
                              //       fontSize: 13,
                              //       color: Colors.black54,
                              //     ),
                              //     overflow: TextOverflow.ellipsis,
                              //     maxLines: 2,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Divider(),
              ],
            );
          },
        )

        // FutureBuilder(
        //     future:getBookingAPICall(),
        //     builder: (BuildContext context, AsyncSnapshot snapshot) {
        //       if (snapshot.hasData) {
        //         GetBookingModel model = snapshot.data;
        //         return model.booking!.isEmpty ?  Center(child: Text("Chats to show",style: TextStyle(color: Colors.black,fontSize: 15),),) : ListView.builder(
        //           itemCount: model.booking!.length,
        //           itemBuilder: (BuildContext context, int index) {
        //             // final Message chat = chats[index];
        //             return Column(
        //               children: [
        //                 GestureDetector(
        //                   onTap: () => Navigator.push(
        //                     context,
        //                     MaterialPageRoute(
        //                       builder: (_) => ChatPage(
        //                         bookingId: model.booking![index].id,
        //                         providerName: model.booking![index].service!.vendorName,
        //                         providerId: model.booking![index].service!.vendorId,
        //                         providerImage: model.booking![index].service!.vendorImage,
        //                       ),
        //                     ),
        //                   ),
        //                   child: Container(
        //                     padding: EdgeInsets.symmetric(
        //                       horizontal: 20,
        //                       vertical: 15,
        //                     ),
        //                     child: Row(
        //                       children: <Widget>[
        //                         Container(
        //                           padding: EdgeInsets.all(2),
        //                           decoration
        //                               : BoxDecoration(
        //                             shape: BoxShape.circle,
        //                             boxShadow: [
        //                               BoxShadow(
        //                                 color: Colors.grey.withOpacity(0.5),
        //                                 spreadRadius: 0.1,
        //                                 blurRadius: 0.1,
        //                               ),
        //                             ],
        //                           ),
        //                           child: model.booking![index].service!.vendorImage == null ? CircleAvatar(
        //                             radius: 25,
        //                             backgroundColor: backgroundgrey,
        //                             backgroundImage: AssetImage("")
        //                           ) : CircleAvatar(
        //                             radius: 25,
        //                             backgroundColor: backgroundgrey,
        //                             backgroundImage: NetworkImage("${model.booking![index].service!.vendorImage}"),
        //                           ),
        //                         ),
        //                         Container(
        //                           width: MediaQuery.of(context).size.width * 0.65,
        //                           padding: EdgeInsets.only(
        //                             left: 20,
        //                           ),
        //                           child: Column(
        //                             children: <Widget>[
        //                               Row(
        //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //                                 children: <Widget>[
        //                                   Row(
        //                                     children: <Widget>[
        //                                       Text( "${model.booking![index].service!.vendorName}",
        //                                         style: TextStyle(
        //                                           fontSize: 16,
        //                                           fontWeight: FontWeight.bold,
        //                                         ),
        //                                       ),
        //                                       // chat. == true
        //                                       //     ? Container(
        //                                       //   margin: const EdgeInsets.only(left: 5),
        //                                       //   width: 7,
        //                                       //   height: 7,
        //                                       //   decoration: BoxDecoration(
        //                                       //     shape: BoxShape.circle,
        //                                       //     color: backgroundgrey,
        //                                       //   ),
        //                                       // )
        //                                       //     : Container(
        //                                       //   child: null,
        //                                       // ),
        //                                     ],
        //                                   ),
        //                                   // Text(
        //                                   //   chat.time.toString(),
        //                                   //   style: TextStyle(
        //                                   //     fontSize: 11,
        //                                   //     fontWeight: FontWeight.w300,
        //                                   //     color: Colors.black54,
        //                                   //   ),
        //                                   // ),
        //                                 ],
        //                               ),
        //                               SizedBox(
        //                                 height: 10,
        //                               ),
        //                               // Container(
        //                               //   alignment: Alignment.topLeft,
        //                               //   child: Text(
        //                               //     chat.text.toString(),
        //                               //     style: TextStyle(
        //                               //       fontSize: 13,
        //                               //       color: Colors.black54,
        //                               //     ),
        //                               //     overflow: TextOverflow.ellipsis,
        //                               //     maxLines: 2,
        //                               //   ),
        //                               // ),
        //                             ],
        //                           ),
        //                         ),
        //                       ],
        //                     ),
        //                   ),
        //                 ),
        //                 Divider(),
        //               ],
        //             );
        //           },
        //         );
        //       } else if (snapshot.hasError) {
        //         return Icon(Icons.error_outline);
        //       } else {
        //         return CircularProgressIndicator();
        //       }
        //     }),
      ),
    );
  }
}
