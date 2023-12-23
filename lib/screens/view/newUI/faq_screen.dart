import 'dart:convert';
import 'package:ez/constant/global.dart';
import 'package:ez/screens/view/models/faq_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../constant/sizeconfig.dart';

class FaqScreen extends StatefulWidget {
  const FaqScreen({Key? key}) : super(key: key);

  @override
  State<FaqScreen> createState() => _FaqScreenState();
}

class _FaqScreenState extends State<FaqScreen> {
  ScrollController controller = new ScrollController();
  bool flag = true;
  bool expand = true;
  int selectedIndex = -1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(_scrollListener);
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (this.mounted) {
        if (mounted)
          setState(() {
            // isLoadingmore = true;
            getFaq();
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: appColorWhite,
      appBar: AppBar(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        elevation: 2,
        title: Text(
          "FAQ",
          style: TextStyle(
            fontSize: 20,
            color: appColorWhite,
          ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Text(
              "Frequently Asked Questions",
              style: TextStyle(
                  fontSize: 15,
                  color: appColorBlack,
                  fontWeight: FontWeight.bold),
            ),
          ),
          FutureBuilder(
              future: getFaq(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                FaqModel faqsList = snapshot.data;
                if (snapshot.hasData) {
                  return Expanded(
                    child: ListView.builder(
                      controller: controller,
                      itemCount: faqsList.setting?.length,
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Card(
                                elevation: 1,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(4),
                                  onTap: () {
                                    if (mounted)
                                      setState(() {
                                        selectedIndex = index;
                                        flag = !flag;
                                      });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        selectedIndex != index || flag
                                            ? Icon(
                                                Icons.add,
                                                color: primary,
                                              )
                                            : Icon(
                                                Icons.close,
                                                color: primary,
                                              ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${index + 1}." ?? "",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Expanded(
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 8.0),
                                                    child: Text(
                                                      faqsList.setting![index]
                                                              .title ??
                                                          "",
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )),
                                              ]),
                                        ),
                                      ],
                                    ),
                                  ),
                                )),
                            selectedIndex != index || flag
                                ? SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Card(
                                        elevation: 1,
                                        color: Colors.grey[100],
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          onTap: () {
                                            if (mounted)
                                              setState(() {
                                                selectedIndex = index;
                                                flag = !flag;
                                              });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child:
                                                selectedIndex != index || flag
                                                    ? SizedBox.shrink()
                                                    : Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                            Expanded(
                                                                child: Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            8.0),
                                                                    child: Text(
                                                                      faqsList.setting![index]
                                                                              .description ??
                                                                          "",
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black45),
                                                                    ))),
                                                            //Icon(Icons.keyboard_arrow_up)
                                                          ]),
                                          ),
                                        )),
                                  ),
                          ],
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Icon(Icons.error_outline);
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }

  Future getFaq() async {
    var request = http.Request('GET', Uri.parse('${baseUrl()}/faq'));

    http.StreamedResponse response = await request.send();
    print(request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      print(str);
      return FaqModel.fromJson(json.decode(str));
    } else {
      return null;
    }
  }
}
