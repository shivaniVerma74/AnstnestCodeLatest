import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:ez/screens/view/models/GetChatModel.dart';

import 'package:ez/screens/view/models/User_Model.dart';
import 'package:ez/screens/view/newUI/allServices.dart';
import 'package:ez/screens/view/newUI/chat/CustomerSupport/constants.dart';
import 'package:ez/screens/view/newUI/detail.dart';
import 'package:ez/screens/view/newUI/openImage.dart';
import 'package:ez/screens/view/newUI/ticketpage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

// import 'package:flutter_chat_app/pages/gallary_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../constant/global.dart';

class ChatPage extends StatefulWidget {
  // final SharedPreferences prefs;
  String? bookingId;
  bool fromPost;

  // final String? title;
  final User? user;
  String? lastSeen;
  final providerName, providerId, providerImage;

  ChatPage({
    this.user,
    this.providerId,
    this.lastSeen,
    this.providerImage,
    this.providerName,
    this.bookingId,
    this.fromPost = false,
  });

  @override
  ChatPageState createState() {
    return new ChatPageState();
  }
}

class ChatPageState extends State<ChatPage> {
  StreamController<GetChatModel>? _postsController;

  final db = FirebaseFirestore.instance;
  CollectionReference? chatReference;
  TextEditingController _textController = new TextEditingController();
  bool _isWritting = false;
  bool isFirstTym = true;

  TextEditingController ticketController = TextEditingController();
  Timer? timer;

  @override
  void initState() {
    convertDateTimeDispla();
    _postsController = new StreamController();
    // loadMessage();
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => loadMessage());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  File? imageFiles;

  Future getMessage() async {
    var headers = {
      'Cookie': 'ci_session=132b223a903b145b8f1056a17a0c9ef325151d5f'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/get_chat'));
    request.fields.addAll({
      'user_id': "$userID",
      'booking_id': '${widget.bookingId}',
      'vendor_id:': "${widget.providerId}",
    });

    if (widget.fromPost) {
      request.fields.addAll({"type": "2"});
    }

    print("vvvvvvvvvvvv ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = GetChatModel.fromJson(json.decode(finalResult));
      print("yes it is working here $jsonResponse");
      // setState(() {
      //   getChatModel = jsonResponse;
      // });
      //return json.decode(finalResult);
      return GetChatModel.fromJson(json.decode(finalResult));
    } else {
      print(response.reasonPhrase);
    }
  }

  loadMessage() async {
    getMessage().then((res) async {
      _postsController!.add(res);
      return res;
    });
    if (isFirstTym) {
      _scrollDown();
      isFirstTym = false;
    }
  }

  sendChatMessage(String type) async {
    var headers = {
      'Cookie': 'ci_session=cb5fe5415a2e7a3e28f499c842c30404bfbc8a99'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/send_message'));
    request.fields.addAll({
      'sender_id': '$userID',
      'sender_type': 'user',
      'message': '${_textController.text}',
      'message_type': '$type',
      'booking_id': '${widget.bookingId}',
      "vendor_id": "${widget.providerId}",
      "user_id": "$userID"
    });
    if (widget.fromPost) {
      request.fields.addAll({
        "type": "2",
        "vendor_id": "${widget.providerId}",
        "user_id": "$userID"
      });
    }
    imageFiles == null
        ? null
        : request.files.add(await http.MultipartFile.fromPath(
            'chat', '${imageFiles!.path.toString()}'));
    print(
        "ok checking hererrrrrrrr ${baseUrl()}/send_message  --  ${request.fields} ");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResult);
      _textController.clear();
      imageFiles = null;
      print("final json here $jsonResponse");
      loadMessage();
      getMessage().then((res) async {
        _postsController!.add(res);
        return res;
      });
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
  }

  List<Widget> generateSenderLayout(DocumentSnapshot documentSnapshot) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text(
              "Karan",
              // documentSnapshot.data['sender_name'],
              style: new TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            // new Container(
            //   margin: const EdgeInsets.only(top: 5.0),
            //   child: documentSnapshot.data['image_url'] != ''
            //       ? InkWell(
            //     child: new Container(
            //       child: Image.network(
            //         documentSnapshot.data['image_url'],
            //         fit: BoxFit.fitWidth,
            //       ),
            //       height: 150,
            //       width: 150.0,
            //       color: Color.fromRGBO(0, 0, 0, 0.2),
            //       padding: EdgeInsets.all(5),
            //     ),
            //     onTap: () {
            //       // Navigator.of(context).push(
            //       //   MaterialPageRoute(
            //       //     builder: (context) => GalleryPage(
            //       //       imagePath: documentSnapshot.data['image_url'],
            //       //     ),
            //       //   ),
            //       // );
            //     },
            //   )
            //       : new Text(documentSnapshot.data['text']),
            // ),
          ],
        ),
      ),
      new Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          // new Container(
          //     margin: const EdgeInsets.only(left: 8.0),
          //     child: new CircleAvatar(
          //       backgroundImage:
          //       new NetworkImage(documentSnapshot.data['profile_photo']),
          //     )),
        ],
      ),
    ];
  }

  List<Widget> generateReceiverLayout(DocumentSnapshot documentSnapshot) {
    return <Widget>[
      new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // new Container(
          //     margin: const EdgeInsets.only(right: 8.0),
          //     child: new CircleAvatar(
          //       backgroundImage:
          //       new NetworkImage(documentSnapshot.data['profile_photo']),
          //     )),
        ],
      ),
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              "Karan",
              //documentSnapshot.data['sender_name'],
              style: new TextStyle(
                  fontSize: 14.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            // new Container(
            //   margin: const EdgeInsets.only(top: 5.0),
            //   child: documentSnapshot.data['image_url'] != ''
            //       ? InkWell(
            //     child: new Container(
            //       child: Image.network(
            //         documentSnapshot.data['image_url'],
            //         fit: BoxFit.fitWidth,
            //       ),
            //       height: 150,
            //       width: 150.0,
            //       color: Color.fromRGBO(0, 0, 0, 0.2),
            //       padding: EdgeInsets.all(5),
            //     ),
            //     onTap: () {
            //       // Navigator.of(context).push(
            //       //   MaterialPageRoute(
            //       //     builder: (context) => GalleryPage(
            //       //       imagePath: documentSnapshot.data['image_url'],
            //       //     ),
            //       //   ),
            //       // );
            //     },
            //   )
            //       : new Text(documentSnapshot.data['text']),
            // ),
          ],
        ),
      ),
    ];
  }

  String _dateValue = '';
  var dateFormate;
  String? formattedDate;
  String? timeData;

  convertDateTimeDispla() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    formattedDate = formatter.format(now);
    print("datedetet$formattedDate"); // 2016-01-25
    timeData = DateFormat("hh:mm:ss a").format(DateTime.now());
    print("timeeeeeeeeee$timeData");
  }

  // generateMessages(AsyncSnapshot<GetChatModel> snapshot){
  //   return snapshot.data!.data!
  //       .map<Widget>((doc){
  //         print("check docs here ${doc}");
  //         return Container(
  //           margin: const EdgeInsets.symmetric(vertical: 10.0),
  //           child: new Row(
  //               children:[
  //                 Expanded(
  //                   child: new Column(
  //                     crossAxisAlignment: doc.senderType == "user" ? CrossAxisAlignment.end : CrossAxisAlignment.start,
  //                     children: <Widget>[
  //                       // doc['sender_id'] != "1"?
  //                       // generateReceiverLayout(doc)
  //                       // Text("receiver end ")
  //                       //     :
  //                       // widget.providerId == doc['id']
  //                       //     ?
  //                     doc.message == "" || doc.message == null ? SizedBox.shrink() : doc.messageType == "image" ?
  //                     InkWell(
  //                     onTap: () {
  //                       Navigator.push(context, MaterialPageRoute(builder: (context) => OpenImagePage(image: "${doc.message}",)));
  //                     },
  //                     child: Container(
  //                       height: 200,
  //                       width: 200,
  //                       child: Column(children: [
  //                         Text(doc.user ?? '', style: TextStyle(color: Colors.black54),),
  //                         ClipRRect(
  //                             borderRadius: BorderRadius.circular(6),
  //                             child: Image.network("${doc.message}",fit: BoxFit.fill,))
  //                       ],),
  //                     ),
  //                   ):
  //                     doc.messageType == "file"
  //                         ?
  //                     InkWell(
  //                       onTap: (){
  //                         // Navigator.push(context,MaterialPageRoute(builder: (context)=>
  //                         //
  //                         //     PdfViewScreen(linkofpdf: "${doc.message}",)
  //                         // ));
  //                       },
  //                       child: Container(
  //                         width: 150,
  //                         height: 60,
  //                         decoration: BoxDecoration(
  //                           color: Colors.grey[300],
  //                           borderRadius: BorderRadius.circular(5),
  //                         ),
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.center,
  //                           children: [
  //                             Text("Open with pdf"),
  //                             SizedBox(
  //                               height: 10,
  //                             ),
  //                             Icon(Icons.picture_as_pdf)
  //                           ],
  //                         ),
  //                       ),
  //                     ):
  //
  //
  //                     Column(
  //                     children: [
  //                       Text(doc.user ?? '', style: TextStyle(color: Colors.black),),
  //                       Text("$formattedDate", style: TextStyle(fontSize: 10, color: Colors.black),),
  //                        Card(
  //                             // width: MediaQuery,
  //                         color:doc.senderType == "user" ? backgroundblack : Colors.grey.withOpacity(0.8) ,
  //                             shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(9)
  //                             ),
  //
  //                             child: Padding(
  //                               padding: const EdgeInsets.all(6.0),
  //                               child: Column(
  //                                 children: [
  //                                   Container(
  //                                    // width: MediaQuery.of(context).size.width/1.5,
  //                                     constraints:BoxConstraints(
  //                                     maxWidth:  MediaQuery.of(context).size.width/1.5,
  //                                     ),
  //                                     child: Text("${doc.message}",
  //                                         // widget.user!.name.toString(),
  //                                          //documentSnapshot.data['sender_name'],
  //                                         style: new TextStyle(
  //                                             fontSize: 14.0,
  //                                             color: Colors.white,
  //                                             fontWeight: FontWeight.bold),
  //                                     ),
  //                                   ),
  //                                   Text("$timeData", style: TextStyle(fontSize: 10, color: Colors.white))
  //                                 ],
  //                               ),
  //                             ),
  //                           ),
  //                     ],
  //                     ),
  //                     ],
  //                   ),
  //                 ),
  //               ]
  //             //doc.data['sender_id']
  //             //     "1" != "1"
  //             // ? generateReceiverLayout(doc)
  //             // : generateSenderLayout(doc),
  //           ),
  //         );
  //   } ).toList();
  // }

  generateMessages(AsyncSnapshot<GetChatModel> snapshot) {
    return snapshot.data!.data!.map<Widget>((doc) {
      print("check docs here ${doc}");

      print("message" + doc.message.toString());
      print("message" + doc.messageType.toString());
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(children: [
          Expanded(
            child: new Column(
              crossAxisAlignment: doc.senderType == "user"
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                // doc['sender_id'] != "1"?
                // generateReceiverLayout(doc)
                // Text("receiver end ")
                //     :
                // widget.providerId == doc['id']
                //     ?
                //doc.senderType == "user" ?
                doc.message == "" || doc.message == null
                    ? SizedBox.shrink()
                    : doc.messageType == "image"
                        ? InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => OpenImagePage(
                                            image: '${doc.message}',
                                          )));
                              setState(() {});
                              Container(
                                height: 200,
                                width: 200,
                                child: PhotoView(
                                  imageProvider: NetworkImage("${doc.message}"),
                                ),
                              );
                            },
                            child: Container(
                              height: 90,
                              width: 100,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: Image.network(
                                    "${doc.message}",
                                    fit: BoxFit.fill,
                                  )),
                            ))
                        : doc.messageType == "file"
                            ? InkWell(
                                onTap: () {
                                  // Navigator.push(context,MaterialPageRoute(builder: (context)=>
                                  //
                                  //     PdfViewScreen(linkofpdf: "${doc.message}",)
                                  // ));
                                  _launchUrl(
                                      'https://developmentalphawizz.com/antsnest/uploads/chats/${doc.message}');
                                  // print('https://developmentalphawizz.com/antsnest/uploads/chats/${doc.message}___________jjjjj');
                                },
                                child: Container(
                                  width: 150,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Open with pdf"),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Icon(Icons.picture_as_pdf)
                                    ],
                                  ),
                                ),
                              )
                            : isLink("${doc.message}")
                                ? InkWell(
                                    onTap: () {
                                      print("Hello");
                                      print(doc.message);

                                      _launchUrl(
                                        "https://${doc.message}",
                                      );
                                    },
                                    child: Container(
                                      // constraints:BoxConstraints(
                                      //   maxWidth:  MediaQuery.of(context).size.width/1.5,
                                      // ),
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: doc.senderType == "user"
                                              ? primary
                                              : Colors.grey.withOpacity(0.8),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Column(
                                        children: [
                                          Text("$formattedDate",
                                              style: new TextStyle(
                                                  fontSize: 10.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                          SizedBox(height: 5),
                                          Text(
                                            "${doc.message}",
                                            // widget.user!.name.toString(),
                                            //documentSnapshot.data['sender_name'],
                                            style: new TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "$timeData",
                                            // widget.user!.name.toString(),
                                            //documentSnapshot.data['sender_name'],
                                            style: new TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    // constraints:BoxConstraints(
                                    //   maxWidth:  MediaQuery.of(context).size.width/1.5,
                                    // ),
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        color: doc.senderType == "user"
                                            ? primary
                                            : Colors.grey.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Column(
                                      children: [
                                        Text("$formattedDate",
                                            style: new TextStyle(
                                                fontSize: 10.0,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)),
                                        SizedBox(height: 5),
                                        Text(
                                          "${doc.message}",
                                          // widget.user!.name.toString(),
                                          //documentSnapshot.data['sender_name'],
                                          style: new TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          "$timeData",
                                          // widget.user!.name.toString(),
                                          //documentSnapshot.data['sender_name'],
                                          style: new TextStyle(
                                              fontSize: 10,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
              ],
            ),
          ),
        ]
            //doc.data['sender_id']
            //     "1" != "1"
            // ? generateReceiverLayout(doc)
            // : generateSenderLayout(doc),
            ),
      );
    }).toList();
  }

  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';

  //RegExp regExp = RegExp(pattern);
  showTicketDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Report"),
                  Divider(),
                  Text("Subject"),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: ticketController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                      hintText: "Subject",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "What issue are you having with this order?",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.5,
                    child: Row(
                      children: [
                        Icon(Icons.circle_outlined),
                        SizedBox(width: 10),
                        Text("The seller can't deliver on time", maxLines: 2),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                ],
              ),
            );
          });
        });
  }

  Future<void> _launchUrl(String uri) async {
    if (!await launch(uri)) {
      throw Exception('Could not launch $uri');
    }
  }

  final ScrollController _controller = ScrollController();

// This is what you're looking for!
  void _scrollDown() {
    _controller.jumpTo(_controller.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        backgroundColor: primary,
        elevation: 0,
        title: Column(
          children: [
            Text(
              '${widget.providerName}',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Text(
              'Last Seen${widget.lastSeen}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 10),
            ),
          ],
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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AllServices(v_id: widget.providerId)));
              },
              child: Icon(Icons.person),
            ),
          ),
          widget.fromPost == true
              ? SizedBox()
              : Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                      onTap: () {
                        // showTicketDialog();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TicketPage(
                                      bookingId: widget.bookingId.toString(),
                                    )));
                      },
                      child: Icon(Icons.report_gmailerrorred,
                          color: Colors.white)),
                ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(5),
        child: new Column(
          children: <Widget>[
            StreamBuilder<GetChatModel>(
              stream: _postsController!.stream,
              builder:
                  (BuildContext context, AsyncSnapshot<GetChatModel> snapshot) {
                if (!snapshot.hasData) return new Text("No Chat");
                return Expanded(
                  child: ListView(
                    controller: _controller,
                    reverse: false,
                    children: generateMessages(snapshot),
                  ),
                );
              },
            ),
            new Divider(height: 1.0),
            new Container(
              decoration: new BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
            new Builder(builder: (BuildContext context) {
              return new Container(width: 0.0, height: 0.0);
            })
          ],
        ),
      ),
    );
  }

  void showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(color: primary, width: 5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.cancel_outlined,
                  size: 50,
                  color: primary,
                ),
                SizedBox(
                    height:
                        10), // Provides spacing between the icon and the text.
                Text(
                  "Warning",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                    height:
                        20), // Provides spacing between the warning text and the message.
                Text(
                  "We advise not sharing your contact number/email on AntsNest as it may violate our Terms of Service and lead to suspension of your account. To stay safe, always book services through AntsNest.",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 20),
                Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: primary)),
                        child: Text(
                          "OK",
                          style: TextStyle(
                              color: primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )),
                // ElevatedButton(
                //   onPressed: () => Navigator.of(context).pop(),
                //   child: Text('OK'),
                //   style: ElevatedButton.styleFrom(
                //     primary: Colors.red, // Button color
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconButton getDefaultSendButton() {
    return new IconButton(
        icon: new Icon(
          Icons.send,
          color: primary,
        ),
        onPressed: () {
          if (_textController.text.isEmpty) {
            print('Text is empty');
            Fluttertoast.showToast(msg: "Please enter text");
          } else if (!containsNoEmailOrPhoneNumber(_textController.text)) {
            showWarningDialog(context);
          } else {
            setState(() {
              sendChatMessage("text");
              getMessage().then((res) async {
                _postsController!.add(res);

                return res;
              });
              _textController.clear();
              _scrollDown();
            });
          }
        });
  }

  bool isLink(String input) {
    print("Hello");
    // Define a regular expression pattern for a simple URL
    RegExp urlPattern = RegExp(
        r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$");
    print("${urlPattern.hasMatch(input)}");
    // Check if the input string matches the URL pattern
    return urlPattern.hasMatch(input);
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(
          color: _isWritting
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor,
        ),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
            children: <Widget>[
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 4.0),
                child: new IconButton(
                    icon: new Icon(
                      Icons.photo_camera,
                      color: primary,
                    ),
                    onPressed: () async {
                      // var image = await ImagePicker.
                      // pickImage(
                      //     source: ImageSource.gallery);
                      // int timestamp = new DateTime.now().millisecondsSinceEpoch;
                      // StorageReference storageReference = FirebaseStorage
                      //     .instance
                      //     .ref()
                      //     .child('chats/img_' + timestamp.toString() + '.jpg');
                      // StorageUploadTask uploadTask =
                      // storageReference.putFile(image);
                      // await uploadTask.onComplete;
                      // String fileUrl = await storageReference.getDownloadURL();
                      PickedFile? image = await ImagePicker.platform
                          .pickImage(source: ImageSource.gallery);
                      imageFiles = File(image!.path);
                      print("image files here ${imageFiles!.path.toString()}");
                      if (imageFiles != null) {
                        setState(() {
                          sendChatMessage("image");
                          getMessage().then((res) async {
                            _postsController!.add(res);
                            return res;
                          });
                          _textController.clear();
                        });
                      }
                    }),
              ),
              new Container(
                margin: new EdgeInsets.symmetric(horizontal: 0.0),
                child: new IconButton(
                    icon: new Icon(
                      Icons.file_present_rounded,
                      color: primary,
                    ),
                    onPressed: () async {
                      // var image = await ImagePicker.
                      // pickImage(
                      //     source: ImageSource.gallery);
                      // int timestamp = new DateTime.now().millisecondsSinceEpoch;
                      // StorageReference storageReference = FirebaseStorage
                      //     .instance
                      //     .ref()
                      //     .child('chats/img_' + timestamp.toString() + '.jpg');
                      // StorageUploadTask uploadTask =
                      // storageReference.putFile(image);
                      // await uploadTask.onComplete;
                      // String fileUrl = await storageReference.getDownloadURL();
                      // PickedFile? image = await ImagePicker.platform
                      //     .pickImage(source: ImageSource.gallery);
                      // imageFiles = File(image!.path);
                      // print("image files here ${imageFiles!.path.toString()}");
                      // if (imageFiles != null) {
                      //   setState(() {
                      //     sendChatMessage("image");
                      //     getMessage().then((res) async {
                      //       _postsController!.add(res);
                      //       return res;
                      //     });
                      //     // textController.clear();
                      //   });
                      // }
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['pdf'],
                      );

                      if (result != null) {
                        File file = File(result.files.single.path!);
                        imageFiles = file;
                        sendChatMessage("file");
                        getMessage().then((res) async {
                          _postsController!.add(res);
                          return res;
                        });
                        print("${file.path}");
                      } else {
                        // User canceled the picker
                      }
                    }),
              ),
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  onChanged: (String messageText) {
                    setState(() {
                      _isWritting = messageText.length > 0;
                    });
                  },
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(RegExp(pattern))
                  // ],
                  onSubmitted: _sendMsg,
                  keyboardType: TextInputType.text,
                  decoration:
                      new InputDecoration.collapsed(hintText: "Send a message"),
                ),
              ),
              new Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: getDefaultSendButton(),
              ),
            ],
          ),
        ));
  }

  // Future<Null> _sendText(String text) async {
  //   _textController.clear();
  //   chatReference!.add({
  //     'text': text,
  //     'receiver_id': "1",
  //     "sender_id" : "1",
  //     //widget.prefs.getString('uid'),
  //     'receiver_name': "Karan",
  //     //widget.prefs.getString('name'),
  //     'profile_photo' : "",
  //   //widget.prefs.getString('profile_photo'),
  //     'image_url': '',
  //     'time': FieldValue.serverTimestamp(),
  //   }).then((documentReference) {
  //     setState(() {
  //       _isWritting = false;
  //     });
  //   }).catchError((e) {});
  // }

  bool containsNoEmailOrPhoneNumber(String text) {
    // Regex pattern for a simple email validation
    final emailRegex = RegExp(
      r'[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
    );

    // Regex pattern for a simple phone number validation
    // Adjust the regex according to the phone number formats you need to detect
    final phoneRegex = RegExp(
      r'\+?\d[\d -]{8,12}\d',
    );

    // Check if the text does not match either regex
    return !emailRegex.hasMatch(text) && !phoneRegex.hasMatch(text);
  }

  _sendMsg(String text) async {
    _textController.clear();
    if (!containsNoEmailOrPhoneNumber(text)) {
      showWarningDialog(context);
    } else {
      chatReference!.add({
        'text': text,
        'received': true,
        'id': "${widget.providerId}",
        "sender_id": "${userID}",
        //widget.prefs.getString('uid'),
        'name': "${widget.providerName}",
        //widget.prefs.getString('name'),
        'profile_photo': "${widget.providerImage}",
        //widget.prefs.getString('profile_photo'),
        'image_url': '',
        'time': FieldValue.serverTimestamp(),
      }).then((documentReference) {
        setState(() {
          _isWritting = false;
        });
      }).catchError((e) {});
    }
  }

  void _sendImage({String? messageText, String? imageUrl}) {
    chatReference!.add({
      'text': messageText,

      // 'sender_id': widget.prefs.getString('uid'),
      // 'sender_name': widget.prefs.getString('name'),
      // 'profile_photo': widget.prefs.getString('profile_photo'),
      'image_url': imageUrl,
      'time': FieldValue.serverTimestamp(),
    });
  }
}
