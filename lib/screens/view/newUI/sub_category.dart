import 'dart:convert';

import 'package:ez/screens/view/newUI/AllProviderService.dart';
import 'package:ez/screens/view/newUI/viewCategory.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../constant/global.dart';
import '../models/catModel.dart';
import '../models/categories_model.dart';

class SubCategoryScreen extends StatefulWidget {
  final name, id,image,description;
  const SubCategoryScreen({Key? key, this.name, this.id,this.description,this.image}) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  bool isLoading = false;
  AllCateModel? collectionModal;
  List catModel = [];
  List addonsList = [];


  @override
  void initState() {
    super.initState();
    getSubCategory();
  }

  getSubCategory() async {
    var uri = Uri.parse('${baseUrl()}/get_all_cat');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };

    print("checking id here ${widget.id} ");
    print("basese ulllllll${baseUrl.toString()}");
    request.headers.addAll(headers);
    request.fields['category_id'] = widget.id;
    print("get all catttt ${request.fields}");
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    if (mounted) {
      setState(() {
        collectionModal = AllCateModel.fromJson(userData);
        catModel = userData['categories'];
        addonsList.length = catModel.length;
        for(int i=0; i<catModel.length; i++)
          if(catModel[i]['addons'] != null)
            addonsList[i] = catModel[i]['addons'].split(",");
        print("catttt responseeee ${addonsList}");
      });
    }
    print(responseData);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundblack,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20)
          )
        ),
        // bottom:
        title: Text(
          widget.name!.toUpperCase(),
          style: TextStyle(color: appColorWhite),
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
        // leading: IconButton(
        //   icon: Icon(
        //     Icons.arrow_back,
        //     color: Colors.black,
        //   ),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
        body: collectionModal == null
            ? Center(
          child: Image.asset("assets/images/loader1.gif"),
        )
            : Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView(
            physics: ScrollPhysics(),
            children: [
            Container(
              child: Stack(
                children: [
                  Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network("${widget.image}",fit: BoxFit.fill,)),
                  Align(
                    alignment: Alignment.center,
                      // left: 1,
                      // right: 1,
                      // top: 1,
                      // bottom: 10,
                       child: Padding(
                         padding: EdgeInsets.only(top:70),
                         child: Text("${widget.name}",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600,fontSize: 16),textAlign: TextAlign.center,),
                       ),
                  ),
                ],
              ),
            ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("Say Cheese To Freeze!", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color:backgroundblack)),
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
                  child: Text("${widget.description}")),
              Padding(
                padding:  EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap:() {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AllProviderService(catid: widget.id,)));
                      },
                      child:
                      Container(
                        height: 45,
                        width: 150,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: backgroundblack,
                            width: 1,
                          ),
                          color: backgroundblack.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text("View Provider",style: TextStyle(color: backgroundblack, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
              bestSellerItems(context),
            ],
          ),
        )
    );
  }

  Widget bestSellerItems(BuildContext context) {
    return collectionModal!.categories!.length != 0
        ? GridView.builder(
      shrinkWrap: true,
      primary: false,
      padding: EdgeInsets.all(5),
      itemCount: collectionModal!.categories!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        // mainAxisSpacing: 1.0,
        crossAxisSpacing: 0.2,
        childAspectRatio: 190/294,
      ),
       itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ViewCategory(
                    id: collectionModal!.categories![index].id,
                    name: collectionModal!.categories![index].cName!,
                    catId: widget.id,
                    fromSeller: false,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5)
              ),
              child: Column(
                crossAxisAlignment:  CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 100,
                    // width: 140,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                      image: DecorationImage(
                        image: NetworkImage(collectionModal!.categories![index].img!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(4),
                    child: Row(
                      children: [
                        Container(
                          // width: 60,
                          child: Text(
                            collectionModal!.categories![index].cName![0].toUpperCase() + collectionModal!.categories![index].cName!.substring(1),
                            maxLines: 2,
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                                color: appColorBlack,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // SizedBox(width: 10),
                        // Icon(Icons.person, color: backgroundblack, size: 14,),
                        // InkWell(
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       CupertinoPageRoute(
                        //         builder: (context) => ViewCategory(
                        //           id: collectionModal!.categories![index].id,
                        //           name: collectionModal!.categories![index].cName!,
                        //           catId: widget.id,
                        //           fromSeller: false,
                        //         ),
                        //       ),
                        //     );
                        //   },
                        //     child:
                        //     // Padding(
                        //     //   padding: const EdgeInsets.only(bottom: 4),
                        //     //   child: Text("View Provider", style: TextStyle(fontSize: 11, color: backgroundblack)),
                        //     // )
                        // )
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Text(collectionModal!.categories![index].description!, overflow: TextOverflow.ellipsis, maxLines: 2, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),),
                    ),
                  ),
                  SizedBox(height: 4),
                  catModel[index]['addons']!= null ?
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // collectionModal!.categories![index].addons! == null || collectionModal!.categories![index].addons! == "" ? Text("--"):
                        Container(
                          width: 130,
                            child: Text("${addonsList[index][0]} ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis, maxLines: 1, )),
                        // Text("View Provider", style: TextStyle(fontSize: 11, overflow: TextOverflow.ellipsis, color: backgroundblack, fontWeight: FontWeight.w400)),
                      ],
                    ),
                  ): Text(""),
                  catModel[index]['addons']!= null?
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 70,
                          child: Text(addonsList.length> 1? "${addonsList[index][1]}" : "",
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
                              overflow: TextOverflow.ellipsis, maxLines: 1),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 3),
                          child: Icon(Icons.person, color: backgroundblack, size: 14,),
                        ),
                        InkWell(
                          onTap: () {
                         Navigator.push(context,
                        CupertinoPageRoute(
                        builder: (context) => ViewCategory(
                        id: collectionModal!.categories![index].id,
                        name: collectionModal!.categories![index].cName!,
                        catId: widget.id,
                       fromSeller: false,
                         ),
                        ),
                         );
                           },
                          child: Text("View Provider", style: TextStyle(fontSize: 11, color: backgroundblack,fontWeight: FontWeight.w400),
                          ),
                        ),
                      ],
                    ),
                  ): Text(""),
                ],
              ),
            ),
          ),
        );
      },
     ): Center(
      child: Text(
        "No Sub Category Available",
        style: TextStyle(
          color: appColorBlack,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}
