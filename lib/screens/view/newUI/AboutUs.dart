import 'dart:convert';

import 'package:ez/models/Aboutusmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import '../../../constant/global.dart';
import '../../../constant/sizeconfig.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  String? description;
  String? title;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAboutUs();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: appColorWhite,
      appBar: AppBar(
        backgroundColor: backgroundblack,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)
            )
        ),
        elevation: 2,
        title: Text(
          "About Us",
          style: TextStyle(
            fontSize: 20,
            color: appColorWhite,
          ),
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
      body: SingleChildScrollView(
        child: title != null
            ? Column(
          children: [
            Image.asset("assets/images/aboutus.png"),
            Container(
                margin: EdgeInsets.all(5.0),
                child: Html(data: title,
                  defaultTextStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14
                  ),
                )
            ),
            Container(
                margin: EdgeInsets.all(5.0),
                child: Html(data: description)
            )
          ],
        ): Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 2,
            child: Center(child: Image.asset("assets/images/loader1.gif"),)),
      ),
    );
  }

  Future<Aboutusmodel?> getAboutUs() async {
    var request = http.Request('GET', Uri.parse('https://developmentalphawizz.com/antsnest/api/about_us'));

    http.StreamedResponse response = await request.send();
    print(request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      final jsonResponse = Aboutusmodel.fromJson(json.decode(str));
      print(jsonResponse);
      if(jsonResponse.responseCode == "1"){
        setState(() {
          title = jsonResponse.data?.title;
          description = jsonResponse.data?.html;
        });
      }
      return Aboutusmodel.fromJson(json.decode(str));
    }
    else {
      return null;
    }
  }

}
