import 'dart:convert';

import 'package:ez/models/Aboutusmodel.dart';
import 'package:ez/models/blogsModel.dart';
import 'package:ez/screens/view/newUI/blogDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
    getMyBlogs();
  }

  Future getMyBlogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var request = http.MultipartRequest('POST',
        Uri.parse('https://developmentalphawizz.com/antsnest/api/my_blog'));
    // request.fields.addAll({'vendor_id': '256'});
    print(request);
    print(request.fields);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      print(str.toString());
      return BlogsModel.fromJson(json.decode(str));
    } else {
      return null;
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
          "About Us",
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
      body: SingleChildScrollView(
        child: title != null
            ? Column(children: [
                Image.asset("assets/images/aboutus.png"),
                Container(
                    margin: EdgeInsets.all(5.0),
                    child: Html(
                      data: title,

                      /*style:Map<String, Style> => {TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14
                    ),}*/
                    )),
                Container(
                    margin: EdgeInsets.all(5.0),
                    child: Html(data: description)),
                Text(
                  "Blogs",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                FutureBuilder(
                    future: getMyBlogs(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        BlogsModel his = snapshot.data;
                        return his.responseCode == "1"
                            ? GridView.builder(
                                shrinkWrap: true,
                                //physics: NeverScrollableScrollPhysics(),
                                primary: false,
                                padding: EdgeInsets.all(8),
                                itemCount: his.data.length ?? 0,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 110 / 110,
                                  crossAxisSpacing: 0.0,
                                  mainAxisSpacing: 5.0,
                                ),
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Card(
                                      elevation: 4,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Column(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          BlogsScreen(
                                                            name: his
                                                                .data[index]
                                                                .title,
                                                            description: his
                                                                .data[index]
                                                                .description,
                                                            image: his
                                                                .data[index]
                                                                .image,
                                                          )));
                                            },
                                            child: Container(
                                              height: 100,
                                              width: 150,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    topRight:
                                                        Radius.circular(8)),
                                                child: Image.network(
                                                  "${his.data[index].image}",
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            his.data[index].title,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            : Center(
                                child: Text("No Blogs"),
                              );
                      } else if (snapshot.hasError) {
                        return Icon(Icons.error_outline);
                      } else {
                        return Center(
                            child: Image.asset("images/icons/loader.gif"));
                      }
                    })
              ])
            : Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 2,
                child: Center(
                  child: Image.asset("assets/images/loader1.gif"),
                )),
      ),
    );
  }

  Future<Aboutusmodel?> getAboutUs() async {
    var request = http.Request('GET',
        Uri.parse('https://developmentalphawizz.com/antsnest/api/about_us'));

    http.StreamedResponse response = await request.send();
    print(request);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      final jsonResponse = Aboutusmodel.fromJson(json.decode(str));
      print(jsonResponse);
      if (jsonResponse.responseCode == "1") {
        setState(() {
          title = jsonResponse.data?.title;
          description = jsonResponse.data?.html;
        });
      }
      return Aboutusmodel.fromJson(json.decode(str));
    } else {
      return null;
    }
  }
}
