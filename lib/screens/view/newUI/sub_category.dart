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
    print(baseUrl.toString());
    request.headers.addAll(headers);
    request.fields['category_id'] = widget.id;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    if (mounted) {
      setState(() {
        collectionModal = AllCateModel.fromJson(userData);
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
                       )),
                ],
              ),
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
                      onTap:(){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AllProviderService(catid: widget.id,)));
                      },
                      child: Container(
                        height: 45,
                        width: 150,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: backgroundblack,
                            width: 1,
                          ),
                          color: backgroundblack.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(5)
                        ),
                        child: Text("View Provider",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),
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
      padding: EdgeInsets.all(10),
      itemCount: collectionModal!.categories!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 15.0,
        childAspectRatio: 250 / 290,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8)
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
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      image: DecorationImage(
                        image: NetworkImage(collectionModal!.categories![index].img!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      collectionModal!.categories![index].cName![0].toUpperCase() + collectionModal!.categories![index].cName!.substring(1),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: appColorBlack,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  // Card(
                  //   elevation: 5,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: Container(
                  //     width: 180,
                  //     child: Padding(
                  //       padding: const EdgeInsets.only(
                  //           bottom: 15, left: 15, right: 5),
                  //       child: Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         mainAxisAlignment: MainAxisAlignment.end,
                  //         children: [
                  //           Text(
                  //             collectionModal!.categories![index].cName!,
                  //             maxLines: 1,
                  //             style: TextStyle(
                  //                 color: appColorBlack,
                  //                 fontSize: 14,
                  //                 fontWeight: FontWeight.bold),
                  //           ),
                  //           Container(height: 10),
                  //           /*Row(
                  //             mainAxisAlignment:
                  //             MainAxisAlignment.spaceBetween,
                  //             crossAxisAlignment:
                  //             CrossAxisAlignment.end,
                  //             children: [
                  //               Column(
                  //                 crossAxisAlignment:
                  //                 CrossAxisAlignment.start,
                  //                 children: [
                  //                   Container(
                  //                     width: 110,
                  //                     child: Text(
                  //                       catModal!.restaurants![index].resDesc!,
                  //                       maxLines: 2,
                  //                       overflow: TextOverflow.ellipsis,
                  //                       style: TextStyle(
                  //                           color: appColorBlack,
                  //                           fontSize: 12,
                  //                           fontWeight: FontWeight.normal),
                  //                     ),
                  //                   ),
                  //                   Text(
                  //                     "₹" + catModal!.restaurants![index].price!,
                  //                     style: TextStyle(
                  //                         color: appColorBlack,
                  //                         fontSize: 16,
                  //                         fontWeight: FontWeight.bold),
                  //                   ),
                  //                   Container(
                  //                     child: Padding(
                  //                         padding: EdgeInsets.all(0),
                  //                         child: Text(
                  //                           "BOOK NOW",
                  //                           style: TextStyle(
                  //                               color: Colors.blue,
                  //                               fontSize: 12),
                  //                         )),
                  //                   ),
                  //                 ],
                  //               ),
                  //
                  //             ],
                  //           ),*/
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // Container(
                  //   height: 100,
                  //   width: 140,
                  //   alignment: Alignment.topCenter,
                  //   decoration: BoxDecoration(
                  //     color: Colors.black45,
                  //     borderRadius: BorderRadius.circular(10),
                  //     image: DecorationImage(
                  //       image: NetworkImage(collectionModal!.categories![index].img!),
                  //       fit: BoxFit.cover,
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    )
        : Center(
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
