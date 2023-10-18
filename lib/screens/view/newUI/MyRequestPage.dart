import 'dart:convert';

import 'package:ez/screens/chat_page.dart';
import 'package:ez/screens/view/models/MyPostModel.dart';
import 'package:ez/screens/view/newUI/Chat_Screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../constant/global.dart';

class MyRequestPage extends StatefulWidget {
  const MyRequestPage({Key? key}) : super(key: key);

  @override
  State<MyRequestPage> createState() => _MyRequestPageState();
}

class _MyRequestPageState extends State<MyRequestPage> {

  MyPostModel? postModel;
  getMyPostRequest()async{
    var headers = {
      'Cookie': 'ci_session=5b1m9j8ulbplkuoiu2i8gf4u9smuh16u'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl()}/my_post'));
    request.fields.addAll({
      'user_id': '$userID'
    });

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var finalRsponse = await response.stream.bytesToString();
      final jsonResponse = MyPostModel.fromJson(json.decode(finalRsponse));
        setState(() {
          postModel = MyPostModel.fromJson(json.decode(finalRsponse));
        });
    }
    else {
      print(response.reasonPhrase);
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMyPostRequest();
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
        elevation: 2,
        title: Text(
          'My Post List',
          style: TextStyle(color: appColorWhite, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading:  Padding(
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
      body: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
        child: postModel == null || postModel!.data!.isEmpty ? Container(child: Center(child: Text("No data to show"),),) : ListView.builder(
            itemCount: postModel!.data!.length,
            itemBuilder: (c,i){
          return Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Id",style: TextStyle(color: appColorBlack,fontSize: 15,fontWeight: FontWeight.w500),),
                    Text("#${postModel!.data![i].id}",style: TextStyle(color: appColorBlack,fontSize: 15,fontWeight: FontWeight.w500),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date",style: TextStyle(color: appColorBlack,fontSize: 15,fontWeight: FontWeight.w500),),
                    Text("${postModel!.data![i].createdAt}",style: TextStyle(color: appColorBlack,fontSize: 15,fontWeight: FontWeight.w500),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Service Date",style: TextStyle(color: appColorBlack,fontSize: 15,fontWeight: FontWeight.w500),),
                    Text("${postModel!.data![i].date}",style: TextStyle(color: appColorBlack,fontSize: 15,fontWeight: FontWeight.w500),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Service",style: TextStyle(color: appColorBlack,fontSize: 15,fontWeight: FontWeight.w500),),
                    Text("${postModel!.data![i].note![0].toUpperCase() + postModel!.data![i].note!.substring(1)}",style: TextStyle(color: appColorBlack,fontSize: 15,fontWeight: FontWeight.w500),)
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Price",style: TextStyle(color: appColorBlack,fontSize: 15,fontWeight: FontWeight.w500),),
                    Text(" \u{20B9} ${postModel!.data![i].budget}",style: TextStyle(color: appColorBlack,fontSize: 15,fontWeight: FontWeight.w500),)
                  ],
                ),
                SizedBox(height: 10,),
                Text("${postModel!.data![i].location}",style: TextStyle(color: appColorBlack,fontSize: 15,fontWeight: FontWeight.w500),),
                SizedBox(height: 15,),
                postModel!.data![i].acceptedBy != null ?  MaterialButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(fromPost: true,id: postModel!.data![i].acceptedBy.toString(),postid: postModel!.data![i].id.toString(),)));
              },child: Text("Chat with Provider",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w600),),color: backgroundblack,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),) : SizedBox()
              ],
              ),
            ),);
        }),
      ),
    );
  }
}
