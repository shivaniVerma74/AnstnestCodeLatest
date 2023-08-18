import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../constant/global.dart';



class TicketPage extends StatefulWidget {
  String? bookingId;
  TicketPage({this.bookingId});

  @override
  State<TicketPage> createState() => _TicketPageState();
}

class _TicketPageState extends State<TicketPage> {

  TextEditingController ticketController = TextEditingController();

  String currentIndex =  '';

  submitTicket()async{
    var headers = {
      'Cookie': 'ci_session=9ec6a655b0715f9e32df3d727d7ced4d696b01eb'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl()}/send_report'));
    request.fields.addAll({
      'booking_id': widget.bookingId.toString(),
      'title': ticketController.text,
      'description': currentIndex.toString()
    });
    print("request fields here now ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResult);
      if(jsonResponse['response_code'] == "1"){
        var snackBar = SnackBar(
          content: Text('Submitted successfully'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          ticketController.clear();
          currentIndex = '';
        });
      }
    }
    else {
      print(response.reasonPhrase);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)
            )
        ),
        backgroundColor: backgroundblack,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12,vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Subject",style: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.w600),),
                SizedBox(height: 10,),
              TextFormField(
                controller: ticketController,
                decoration: InputDecoration(
                  hintText: "Subject",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey)
                  )
                ),
              ),
              SizedBox(height: 10,),
              Text("What issue are you having with this order?",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 15),),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  setState(() {
                    currentIndex = "The seller can't deliver on time";
                  });
                },
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      currentIndex == "The seller can't deliver on time" ? Icon(Icons.check_circle_outlined)  :   Icon(Icons.circle_outlined,size: 20,),
                      SizedBox(width: 10,),
                      Text("The seller can't deliver on time")
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  setState(() {
                    currentIndex = "I am not satisfied with the stock image selection";
                  });
                },
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      currentIndex == "I am not satisfied with the stock image selection" ? Icon(Icons.check_circle_outlined)  :  Icon(Icons.circle_outlined,size: 20,),
                      SizedBox(width: 10,),
                      Container(
                          width: MediaQuery.of(context).size.width/1.2,
                          child: Text("I am not satisfied with the stock image selection",maxLines: 2,))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  setState(() {
                    currentIndex = "The quality of the work i recived was poor";
                  });
                },
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      currentIndex == "The quality of the work i recived was poor" ? Icon(Icons.check_circle_outlined)  :    Icon(Icons.circle_outlined,size: 20,),
                      SizedBox(width: 10,),
                      Container(
                          width: MediaQuery.of(context).size.width/1.2,
                          child: Text("The quality of the work i recived was poor"))
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  setState(() {
                    currentIndex = "The seller is not responding";
                  });
                },
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      currentIndex == "The seller is not responding" ? Icon(Icons.check_circle_outlined)  :  Icon(Icons.circle_outlined,size: 20,),
                      SizedBox(width: 10,),
                      Text("The seller is not responding")
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  setState(() {
                    currentIndex = "I didn't receive was i ordered";
                  });
                },
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      currentIndex == "I didn't receive was i ordered" ? Icon(Icons.check_circle_outlined)  : Icon(Icons.circle_outlined,size: 20,),
                      SizedBox(width: 10,),
                      Text("I didn't receive was i ordered")
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  setState(() {
                    currentIndex = "Other";
                  });
                },
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      currentIndex == "Other" ? Icon(Icons.check_circle_outlined) :  Icon(Icons.circle_outlined,size: 20,),
                      SizedBox(width: 10,),
                      Text("Other")
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 20,),
              MaterialButton(onPressed: (){
                submitTicket();
              },child: Text("Submit",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),color: backgroundblack,)
            ],
          )
        ),
      ),
    );
  }
}
