import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez/screens/view/models/User_Model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_chat_app/pages/gallary_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/global.dart';

class ChatPageNew extends StatefulWidget {
  // final SharedPreferences prefs;

  // final String? title;
  final User? user;
  final providerName, providerId, providerImage;

  ChatPageNew(
      {this.user, this.providerId, this.providerImage, this.providerName});

  @override
  ChatPageNewState createState() {
    return new ChatPageNewState();
  }
}

class ChatPageNewState extends State<ChatPageNew> {
  final db = FirebaseFirestore.instance;
  CollectionReference? chatReference;
  TextEditingController _textController = new TextEditingController();
  bool _isWritting = false;

  @override
  void initState() {
    super.initState();
    print("user id ${userID}");
    chatReference = db.collection("chats").doc(userID).collection('messages');
  }

  List<Widget> generateSenderLayout(DocumentSnapshot documentSnapshot) {
    return <Widget>[
      new Expanded(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            new Text("Karan",
                // documentSnapshot.data['sender_name'],
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
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
            new Text("Karan",
                //documentSnapshot.data['sender_name'],
                style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                    fontWeight: FontWeight.bold)),
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

  generateMessages(AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data!.docs.map<Widget>((doc) {
      print("sender id here ${doc['sender_id']}");
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(children: [
          Expanded(
            child: new Column(
              crossAxisAlignment: doc['received'] == true
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: <Widget>[
                // doc['sender_id'] != "1"?
                // generateReceiverLayout(doc)
                // Text("receiver end ")
                //     :
                widget.providerId == doc['id']
                    ? Text(doc['text'].toString(),
                        // widget.user!.name.toString(),
                        //documentSnapshot.data['sender_name'],
                        style: new TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold))
                    : SizedBox(
                        height: 0,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
          backgroundColor: primary,
          elevation: 0,
          title: Text(
            '${widget.providerName}',
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
          )),
      body: Container(
        padding: EdgeInsets.all(5),
        child: new Column(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream:
                  chatReference!.orderBy('time', descending: true).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return new Text("No Chat");
                return Expanded(
                  child: new ListView(
                    reverse: true,
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

  IconButton getDefaultSendButton() {
    return new IconButton(
      icon: new Icon(
        Icons.send,
        color: primary,
      ),
      onPressed: _isWritting ? () => _sendMsg(_textController.text) : null,
    );
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
                      // _sendImage(messageText: null, imageUrl: fileUrl);
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
                  onSubmitted: _sendMsg,
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

  _sendMsg(String text) async {
    _textController.clear();
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
