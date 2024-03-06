import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ez/constant/global.dart';
import 'package:ez/screens/view/newUI/chat/CustomerSupport/constants.dart';
import 'package:ez/screens/view/newUI/chat/CustomerSupport/models/Model.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/ticket_model.dart';

class Chat extends StatefulWidget {
  final Tickets? model;
  final String? id, status;

  const Chat({Key? key, this.id, this.status, this.model}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

StreamController<String>? chatstreamdata;

class _ChatState extends State<Chat> {
  TextEditingController msgController = new TextEditingController();
  File? files;

  List<Model> chatList = [];
  late Map<String?, String> downloadlist;
  String _filePath = "";

  ScrollController _scrollController = new ScrollController();

  String? roles;
  String? uid;
  String? type;
  String? userName;
  String? userPic;
  String? wallet;

  getSharedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // uid = prefs.getString(TokenString.userid);
    // type = prefs.getString(TokenString.type);
    // roles = prefs.getString(TokenString.roles);
    // userName = prefs.getString(TokenString.userName);
    // userPic = prefs.getString(TokenString.userPic);
    // wallet = prefs.getString(TokenString.walletBalance);
    // currentAddress =prefs.getString(TokenString.deviceToken);
    // print("roles here ${roles.toString()} aaand ${type.toString()} &&& ${uid.toString()}");
  }

  @override
  void initState() {
    super.initState();
    convertDateTimeDispla();
    downloadlist = new Map<String?, String>();
    CUR_TICK_ID = widget.id;
    // FlutterDownloader.registerCallback(downloadCallback);
    // setupChannel();
    getSharedData();
    getMsg();
  }

  @override
  void dispose() {
    CUR_TICK_ID = '';
    if (chatstreamdata != null) chatstreamdata!.sink.close();

    super.dispose();
  }

  // static void downloadCallback(
  //     String id, DownloadTaskStatus status, int progress) {
  //   final SendPort send =
  //       IsolateNameServer.lookupPortByName('downloader_send_port')!;
  //   send.send([id, status, progress]);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          backgroundColor: primary,
          elevation: 0,
          // centerTitle: true,
          title: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 250,
                    child: Text(
                      "${widget.model?.subject}:${widget.model?.dateCreated}",
                      style: TextStyle(fontSize: 17),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 50),
                child: Container(
                    width: 230,
                    child: Text(
                      "${widget.model?.description}",
                      style: TextStyle(fontSize: 17),
                      overflow: TextOverflow.ellipsis,
                    )),
              )
            ],
          )
          // actions: [
          //   InkWell(
          //     onTap: () {
          //       Navigator.push(
          //           context, MaterialPageRoute(builder: (context) => Wallet()));
          //     },
          //     child: Padding(
          //       padding: const EdgeInsets.only(right: 10.0),
          //       child: Row(
          //         children: [
          //           Icon(
          //             Icons.account_balance_wallet_outlined,
          //             color: Colors.white,
          //             size: 24,
          //           ),
          //           const SizedBox(
          //             width: 5,
          //           ),
          //           Text(
          //             wallet == null || wallet == ""
          //                 ? " ₹ 0"
          //                 : "₹ ${wallet.toString()}",
          //
          //             /*textScaleFactor: 1.3,*/
          //             style: TextStyle(
          //                 fontWeight: FontWeight.w500, color: Colors.white),
          //           ),
          //         ],
          //       ),
          //     ),
          //   )
          // ],
          ),
      // getAppBar(getTranslated(context, 'CHAT')!, context),
      body: Container(
        padding: EdgeInsets.only(top: 5),
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45),
              topRight: Radius.circular(45),
            )),
        child: Container(
          // height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45),
                topRight: Radius.circular(45),
              )),
          child: Column(
            children: <Widget>[buildListMessage(), msgRow()],
          ),
        ),
      ),
    );
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

  void setupChannel() {
    chatstreamdata = StreamController<String>(); //.broadcast();
    chatstreamdata!.stream.listen((response) {
      setState(() {
        final res = json.decode(response);
        Model message;
        String mid;
        message = Model.fromChat(res["data"]);
        chatList.insert(0, message);
        //files.clear();
      });
    });
  }

  void insertItem(String response) {
    if (chatstreamdata != null) chatstreamdata!.sink.add(response);
    _scrollController.animateTo(0.0,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  Widget buildListMessage() {
    return Flexible(
      child: ListView.builder(
        padding: EdgeInsets.all(10.0),
        itemBuilder: (context, index) => msgItem(index, chatList[index]),
        itemCount: chatList.length,
        reverse: true,
        controller: _scrollController,
      ),
    );
  }

  Widget msgItem(int index, Model message) {
    // if (message.uid == context.read<SettingProvider>().userId) {
    //Own message
    return Row(
      mainAxisAlignment:
          // message.uid == uid ?
          MainAxisAlignment.center,
      // : MainAxisAlignment.start,
      children: <Widget>[
        // Flexible(
        //   flex: 1,
        //   child: Container(),
        // ),
        Flexible(
          flex: 2,
          child: MsgContent(index, message),
        ),
      ],
    );
    // } else {
    //   //Other's message
    //   return Row(
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: <Widget>[
    //       Flexible(
    //         flex: 2,
    //         child: MsgContent(index, message),
    //       ),
    //       Flexible(
    //         flex: 1,
    //         child: Container(),
    //       ),
    //     ],
    //   );
    // }
  }

  Widget MsgContent(int index, Model message) {
    //String filetype = message.attachment_mime_type.trim();
    // SettingProvider settingsProvider =
    //     Provider.of<SettingProvider>(this.context, listen: false);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: message.uid == uid
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: <Widget>[
        // message.uid == userId
        //     ? Container()
        //     :
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // ClipOval(child:
              // message.profile == null || message.profile.isEmpty? Image.asset("assets/images/placeholder.png",width: 25, height: 25,)
              //     :FadeInImage.assetNetwork(
              //   image: message.profile,
              //   placeholder: "assets/images/placeholder.png",
              //   width: 25,
              //   height: 25,
              //   fit: BoxFit.cover,
              // )),
              // Padding(
              //   padding: EdgeInsets.only(left: 5.0),
              //   child: Text(message.name!,
              //       style:
              //           TextStyle(color: backgroundblack, fontSize: 12)),
              // )
            ],
          ),
        ),
        ListView.builder(
            itemBuilder: (context, index) {
              return attachItem(message.attach!, index, message);
            },
            itemCount: message.attach!.length,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true),
        message.msg != null && message.msg!.isNotEmpty
            ? Card(
                elevation: 0.0,
                color: message.uid == uid
                    // settingsProvider.userId
                    ? Colors.black54.withOpacity(0.1)
                    : primary,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                  child: Column(
                    crossAxisAlignment: message.uid == uid
                        // settingsProvider.userId
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "$formattedDate",
                        style: TextStyle(fontSize: 9, color: Colors.white),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Text("${message.msg}",
                          style: TextStyle(
                              color: message.uid == uid
                                  ? Colors.black
                                  : Colors.white)),
                      Padding(
                          padding: const EdgeInsetsDirectional.only(top: 5),
                          child: Text(
                            "$timeData",
                            style: TextStyle(fontSize: 9, color: Colors.white),
                          )
                          // Text(message.date!,
                          //     style: TextStyle(
                          //         color: message.uid == uid
                          //             ? Colors.black54
                          //             : Colors.white,
                          //         fontSize: 9)),
                          ),
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }

  void _requestDownload(String? url, String? mid) async {
    bool checkpermission = await Checkpermission();
    if (checkpermission) {
      if (Platform.isIOS) {
        Directory target = await getApplicationDocumentsDirectory();
        _filePath = target.path.toString();
      } else {
        Directory target = await getApplicationDocumentsDirectory();
        _filePath = target.path.toString();
      }

      String fileName = url!.substring(url.lastIndexOf("/") + 1);
      File file = new File(_filePath + "/" + fileName);
      bool hasExisted = await file.exists();

      if (downloadlist.containsKey(mid)) {
        // final tasks = await FlutterDownloader.loadTasksWithRawQuery(
        //     query:
        //         "SELECT status FROM task WHERE task_id=${downloadlist[mid]}");

        // if (tasks == 4 || tasks == 5) downloadlist.remove(mid);
      }

      if (hasExisted) {
        // final _openFile = await OpenFile.open(_filePath + "/" + fileName);
      } else if (downloadlist.containsKey(mid)) {
        setSnackbar("Downloading"
            // getTranslated(context, 'Downloading')!
            );
      } else {
        setSnackbar("Downloading"
            // getTranslated(context, 'Downloading')!
            );
        // final taskid = await FlutterDownloader.enqueue(
        //     url: url,
        //     savedDir: _filePath,
        //     headers: {"auth": "test_for_sql_encoding"},
        //     showNotification: true,
        //     openFileFromNotification: true);

        setState(() {
          // downloadlist[mid] = taskid.toString();
        });
      }
    }
  }

  Future<bool> Checkpermission() async {
    var status = await Permission.storage.status;

    if (status != PermissionStatus.granted) {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();

      if (statuses[Permission.storage] == PermissionStatus.granted) {
        FileDirectoryPrepare();
        return true;
      }
    } else {
      FileDirectoryPrepare();
      return true;
    }
    return false;
  }

  Future<Null> FileDirectoryPrepare() async {
    // _filePath = (await _findLocalPath()) +
    //     Platform.pathSeparator +
    //     'Download'; //"${StringsRes.mainappname}";

    if (Platform.isIOS) {
      Directory target = await getApplicationDocumentsDirectory();
      _filePath = target.path.toString();
    } else {
      Directory target = await getApplicationDocumentsDirectory();
      _filePath = target.path.toString();
    }
  }

  _imgFromGallery() async {
    /*FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result != null) {
      files = result.paths.map((path) => File(path!)).toList();
      if (mounted) setState(() {});
    } else {
      // User canceled the picker
    }*/
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        files = File(pickedFile.path);
        setState(() {});
        // imagePath = File(pickedFile.path) ;
        // filePath = imagePath!.path.toString();
      });
    }
  }

  Future<void> sendMessage(String message) async {
    // SettingProvider settingsProvider =
    //     Provider.of<SettingProvider>(this.context, listen: false);

    setState(() {
      msgController.text = "";
    });
    var request = http.MultipartRequest("POST", Uri.parse(Apipath.sendMsgApi));
    // request.headers.addAll(headers);
    request.fields[USER_ID] = userID.toString();
    request.fields[TICKET_ID] = widget.id!;
    request.fields[USER_TYPE] = "user";
    request.fields[MESSAGE] = message;

    print(
        "this is request ========>>>${Apipath.sendMsgApi}  ${request.fields.toString()}");

    if (files != null) {
      /*for (int i = 0; i < files.length; i++) {*/
      var pic = await http.MultipartFile.fromPath(ATTACH, files!.path);
      request.files.add(pic);
      //}
    }
    print('___________${request.files}__________');
    var response = await request.send();
    var responseData = await response.stream.bytesToString();
    final jsonResponse = json.decode(responseData);
    // var responseString = String.fromCharCodes(responseData);
    // var getdata = json.decode(responseString);
    bool error = jsonResponse["error"];
    String? msg = jsonResponse['message'];
    var data = jsonResponse["data"];
    if (!error) {
      getMsg();
      insertItem(data.toString());
    }
  }

  Future<void> getMsg() async {
    try {
      var data = {
        TICKET_ID: widget.id,
      };

      Response response = await post(Uri.parse(Apipath.getMsgApi), body: data)
          .timeout(Duration(seconds: 50));
      print('ticket id is ${data}');
      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);

        bool error = getdata["error"];
        String? msg = getdata["message"];

        if (!error) {
          var data = getdata["data"];
          chatList =
              (data as List).map((data) => new Model.fromChat(data)).toList();
        } else {
          if (msg != "Ticket Message(s) does not exist") setSnackbar(msg!);
        }
        if (mounted) setState(() {});
      }
    } on TimeoutException catch (_) {
      setSnackbar("Something went wrong!");
    }
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      elevation: 1.0,
    ));
  }

  msgRow() {
    return widget.status != "4"
        ? Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: Platform.isAndroid
                  ? EdgeInsets.symmetric(horizontal: 10)
                  : EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Row(
                children: <Widget>[
                  /*GestureDetector(
                    onTap: () {
                      _imgFromGallery();
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: backgroundblack,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),*/
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: msgController,
                      maxLines: null,
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    mini: true,
                    onPressed: () {
                      if (msgController.text.trim().length >
                              0 /*||
                          files.length > 0*/
                          ) {
                        sendMessage(msgController.text.trim());
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                    backgroundColor: primary,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          )
        : Container();
  }

  Widget attachItem(List<attachment> attach, int index, Model message) {
    String? file = attach[index].media;
    String? type = attach[index].type;
    String icon;
    if (type == "video")
      icon = "assets/images/video.png";
    else if (type == "document")
      icon = "assets/images/doc.png";
    else if (type == "spreadsheet")
      icon = "assets/images/sheet.png";
    else
      icon = "assets/images/zip.png";
    // SettingProvider settingsProvider =
    //     Provider.of<SettingProvider>(this.context, listen: false);

    return file == null
        ? Container()
        : Stack(
            alignment: Alignment.bottomRight,
            children: <Widget>[
              Card(
                //margin: EdgeInsets.only(right: message.sender_id == myid ? 10 : 50, left: message.sender_id == myid ? 50 : 10, bottom: 10),
                elevation: 0.0,
                color: message.uid == uid
                    ? Colors.black54.withOpacity(0.1)
                    : Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: message.uid == uid
                        ? CrossAxisAlignment.end
                        : CrossAxisAlignment.start,
                    children: <Widget>[
                      //_messages[index].issend ? Container() : Center(child: SizedBox(height:20,width: 20,child: new CircularProgressIndicator(backgroundColor: ColorsRes.secondgradientcolor,))),

                      GestureDetector(
                        onTap: () {
                          _requestDownload(attach[index].media, message.id);
                        },
                        child: type == "image"
                            ? Image.network(file,
                                width: 250,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      width: 150,
                                      height: 150,
                                      child: Icon(
                                        Icons.image,
                                        size: 50,
                                        color: primary,
                                      ),
                                    ))
                            : Image.asset(
                                icon,
                                width: 100,
                                height: 100,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(message.date!,
                      style: TextStyle(color: Colors.black54, fontSize: 9)),
                ),
              ),
            ],
          );
  }
}
