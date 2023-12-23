import 'dart:convert';

import 'package:ez/constant/global.dart';
import 'package:ez/screens/view/newUI/chat/CustomerSupport/constants.dart';
import 'package:ez/screens/view/newUI/chat/CustomerSupport/customer_support_faq.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'models/ticket_type_model.dart';

class TicketPage extends StatefulWidget {
  String? bookingId;

  TicketPage({this.bookingId});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {
  TextEditingController ticketController = TextEditingController();

  int currentIndex = -1;
  String selectedTicketId = '';
  String selectedType = '';
  List<TicketType> typeList = [];

  Future getType() async {
    var request =
        http.MultipartRequest('GET', Uri.parse('${Apipath.getTicketsTypeApi}'));

    print("this is request !!${Apipath.getTicketsTypeApi}");

    http.StreamedResponse response = await request.send();
    print("this is request !! 11111${response}");
    if (response.statusCode == 200) {
      print("this response @@ ${response.statusCode}");
      final str = await response.stream.bytesToString();
      var datas = TicketTypeModel.fromJson(json.decode(str));
      setState(() {
        typeList = datas.data!;
      });

      print('this is types ${typeList.length}');

      //     .map((data) => TicketModel.fromJson(json.decode(str))
      //     .toList();
      // tempList = datas.data;
      return TicketTypeModel.fromJson(json.decode(str));
    } else {
      return null;
    }
  }

  submitTicket() async {
    var headers = {
      'Cookie': 'ci_session=9ec6a655b0715f9e32df3d727d7ced4d696b01eb'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse('${Apipath.addTicketApi}'));
    request.fields.addAll({
      'booking_id': widget.bookingId.toString(),
      'title': ticketController.text,
      'support_ticket_type': selectedTicketId.toString(),
      'description': selectedType.toString()
    });
    print("request fields here now ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResult);
      if (jsonResponse['status'] == "0") {
        var snackBar = SnackBar(
          content: Text(jsonResponse['message'].toString()),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          ticketController.clear();
          currentIndex = -1;
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => CustomerSupport()));
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getType();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Generate Support Ticket",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        backgroundColor: primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Subject",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: ticketController,
                  decoration: InputDecoration(
                      hintText: "Subject",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: Colors.grey))),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "What issue are you having with this order?",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
                SizedBox(
                  height: 10,
                ),

                ListView.builder(
                    shrinkWrap: true,
                    itemCount: typeList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            currentIndex = index;
                            selectedTicketId = typeList[index].id.toString();
                            selectedType = typeList[index].title.toString();
                          });
                        },
                        child: Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              currentIndex == index
                                  ? Icon(Icons.check_circle_outlined)
                                  : Icon(
                                      Icons.circle_outlined,
                                      size: 20,
                                    ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(typeList[index].title.toString())
                            ],
                          ),
                        ),
                      );
                    }),
                // InkWell(
                //   onTap: (){
                //     setState(() {
                //       currentIndex = "The seller can't deliver on time";
                //     });
                //   },
                //   child: Container(
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         currentIndex == "The seller can't deliver on time" ? Icon(Icons.check_circle_outlined)  :   Icon(Icons.circle_outlined,size: 20,),
                //         SizedBox(width: 10,),
                //         Text("The seller can't deliver on time")
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(height: 10,),
                // InkWell(
                //   onTap: (){
                //     setState(() {
                //       currentIndex = "I am not satisfied with the stock image selection";
                //     });
                //   },
                //   child: Container(
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         currentIndex == "I am not satisfied with the stock image selection" ? Icon(Icons.check_circle_outlined)  :  Icon(Icons.circle_outlined,size: 20,),
                //         SizedBox(width: 10,),
                //         Container(
                //             width: MediaQuery.of(context).size.width/1.2,
                //             child: Text("I am not satisfied with the stock image selection",maxLines: 2,))
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(height: 10,),
                // InkWell(
                //   onTap: (){
                //     setState(() {
                //       currentIndex = "The quality of the work i recived was poor";
                //     });
                //   },
                //   child: Container(
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         currentIndex == "The quality of the work i recived was poor" ? Icon(Icons.check_circle_outlined)  :    Icon(Icons.circle_outlined,size: 20,),
                //         SizedBox(width: 10,),
                //         Container(
                //             width: MediaQuery.of(context).size.width/1.2,
                //             child: Text("The quality of the work i recived was poor"))
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(height: 10,),
                // InkWell(
                //   onTap: (){
                //     setState(() {
                //       currentIndex = "The seller is not responding";
                //     });
                //   },
                //   child: Container(
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         currentIndex == "The seller is not responding" ? Icon(Icons.check_circle_outlined)  :  Icon(Icons.circle_outlined,size: 20,),
                //         SizedBox(width: 10,),
                //         Text("The seller is not responding")
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(height: 10,),
                // InkWell(
                //   onTap: (){
                //     setState(() {
                //       currentIndex = "I didn't receive was i ordered";
                //     });
                //   },
                //   child: Container(
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         currentIndex == "I didn't receive was i ordered" ? Icon(Icons.check_circle_outlined)  : Icon(Icons.circle_outlined,size: 20,),
                //         SizedBox(width: 10,),
                //         Text("I didn't receive was i ordered")
                //       ],
                //     ),
                //   ),
                // ),
                // SizedBox(height: 10,),
                // InkWell(
                //   onTap: (){
                //     setState(() {
                //       currentIndex = "Other";
                //     });
                //   },
                //   child: Container(
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.center,
                //       children: [
                //         currentIndex == "Other" ? Icon(Icons.check_circle_outlined) :  Icon(Icons.circle_outlined,size: 20,),
                //         SizedBox(width: 10,),
                //         Text("Other")
                //       ],
                //     ),
                //   ),
                // ),

                SizedBox(
                  height: 20,
                ),
                Center(
                  child: MaterialButton(
                    onPressed: () {
                      submitTicket();
                    },
                    child: Text(
                      "Submit",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w500),
                    ),
                    color: primary,
                  ),
                )
              ],
            )),
      ),
    );
  }
}
