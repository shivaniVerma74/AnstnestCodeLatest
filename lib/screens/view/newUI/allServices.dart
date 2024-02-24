import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:ez/constant/global.dart';
import 'package:ez/screens/view/models/Search_model.dart';
import 'package:ez/screens/view/newUI/wishList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../../../constant/sizeconfig.dart';
import '../models/catModel.dart';
import '../models/likeService_modal.dart';
import '../models/unLikeService_modal.dart';
import 'detail.dart';

class AllServices extends StatefulWidget {
  String? v_id;

  AllServices({this.v_id});

  @override
  State<AllServices> createState() => _AllServicesState();
}

class _AllServicesState extends State<AllServices> {
  bool isLoading = false;

  CatModal? sortingModel;

  @override
  void initState() {
    print("id id id id id ${widget.v_id}");
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      return sortingApiCall();
    });
  }

  Future<Null> refreshFunction() async {
    await sortingApiCall();
  }

  TextEditingController controller = TextEditingController();
  SearchModel? allProduct;

  getAllProduct() async {
    var uri = Uri.parse('${baseUrl()}/search');
    var request = new http.MultipartRequest("POST", uri);
    request.fields.addAll({
      'text': controller.text,
    });

    var response = await request.send();
    print(request);
    print("ololo ${baseUrl()}/search and ${request.fields}");
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    if (mounted) {
      setState(() {
        allProduct = SearchModel.fromJson(userData);
      });
    }
    print(responseData);
  }

  sortingApiCall() async {
    try {
      Map<String, String> headers = {
        'content-type': 'application/x-www-form-urlencoded',
      };
      var map = new Map<String, dynamic>();
      widget.v_id != null || widget.v_id != ""
          ? map['vid'] = widget.v_id ?? ""
          : print("");
      final response = await client.post(
          Uri.parse("${baseUrl()}/get_all_cat_nvip_sorting"),
          headers: headers,
          body: map);
      print("v id isisisis ${map}");
      var dic = json.decode(response.body);
      Map<String, dynamic> userMap = jsonDecode(response.body);
      sortingModel = CatModal.fromJson(userMap);
      print("Sorting>>>>>>");
      print(dic);
      if (mounted)
        setState(() {
          isLoading = false;
        });
    } on Exception {
      if (mounted)
        setState(() {
          isLoading = false;
        });
      Fluttertoast.showToast(msg: "No Internet connection");
      // Toast.show("No Internet connection", context,
      //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      throw Exception('No Internet connection');
    }
  }

  double _startValue = 100.0;
  double _endValue = 10000.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        title: Text(
          "All Services",
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        // bottom:
        // title: widget.name == null ? SizedBox.shrink()  : Text(
        //  "${ widget.name!.toUpperCase()}",
        //   style: TextStyle(color: appColorWhite),
        // ),
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
      body: RefreshIndicator(
        onRefresh: refreshFunction,
        child: sortingModel == null
            ? Center(
                child: Image.asset("assets/images/loader1.gif"),
              )
            : sortingModel!.restaurants!.length == 0
                ? Center(
                    child: Text("No data to show"),
                  )
                : ListView(
                    children: [
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Container(
                      //       margin: EdgeInsets.only(left: 12, top: 10),
                      //       width: MediaQuery.of(context).size.width / 2.5,
                      //       child: MaterialButton(
                      //         minWidth:
                      //             MediaQuery.of(context).size.width / 2.5,
                      //         onPressed: () {
                      //           showModalBottomSheet(
                      //               context: context,
                      //               builder: (context) {
                      //                 return StatefulBuilder(builder:
                      //                     (BuildContext context,
                      //                         StateSetter setState) {
                      //                   return Container(
                      //                     decoration: BoxDecoration(
                      //                       borderRadius: BorderRadius.only(
                      //                           topLeft: Radius.circular(10),
                      //                           topRight:
                      //                               Radius.circular(10)),
                      //                     ),
                      //                     padding: EdgeInsets.symmetric(
                      //                         horizontal: 12, vertical: 15),
                      //                     child: Column(
                      //                       mainAxisSize: MainAxisSize.min,
                      //                       children: [
                      //                         Text(
                      //                           "Filter by price",
                      //                           style: TextStyle(
                      //                               color: appColorBlack,
                      //                               fontSize: 16,
                      //                               fontWeight:
                      //                                   FontWeight.w500),
                      //                         ),
                      //                         SizedBox(
                      //                           height: 10,
                      //                         ),
                      //                         RangeSlider(
                      //                           divisions: 20,
                      //                           activeColor: backgroundblack,
                      //                           labels: RangeLabels(
                      //                             _startValue
                      //                                 .round()
                      //                                 .toString(),
                      //                             _endValue
                      //                                 .round()
                      //                                 .toString(),
                      //                           ),
                      //                           min: 100,
                      //                           max: 10000,
                      //                           values: RangeValues(
                      //                               _startValue, _endValue),
                      //                           onChanged: (values) {
                      //                             setState(() {
                      //                               _startValue =
                      //                                   values.start;
                      //                               _endValue = values.end;
                      //                             });
                      //                           },
                      //                         ),
                      //                         // Container(
                      //                         //   decoration: BoxDecoration(
                      //                         //       borderRadius:
                      //                         //       BorderRadius.circular(10),
                      //                         //       border: Border.all(
                      //                         //           color: appColorBlack
                      //                         //               .withOpacity(0.5))),
                      //                         //   child: DropdownButton(
                      //                         //     value: selectedValue,
                      //                         //     underline: Container(),
                      //                         //     icon: Container(
                      //                         //         alignment: Alignment.centerRight,
                      //                         //         width: MediaQuery.of(context)
                      //                         //             .size
                      //                         //             .width /
                      //                         //             1.8,
                      //                         //         child: Padding(
                      //                         //           padding:
                      //                         //           EdgeInsets.only(right: 10),
                      //                         //           child: Icon(
                      //                         //               Icons.keyboard_arrow_down),
                      //                         //         )),
                      //                         //     hint: Padding(
                      //                         //       padding: EdgeInsets.only(left: 5),
                      //                         //       child: Text("Sort by"),
                      //                         //     ),
                      //                         //     items: itemsList.map((items) {
                      //                         //       return DropdownMenuItem(
                      //                         //         value: items['id'],
                      //                         //         child: Padding(
                      //                         //           padding:
                      //                         //           EdgeInsets.only(left: 5),
                      //                         //           child: Text(
                      //                         //               items['name'].toString()),
                      //                         //         ),
                      //                         //       );
                      //                         //     }).toList(),
                      //                         //     onChanged: ( newValue) {
                      //                         //       setState(() {
                      //                         //         selectedValue = newValue.toString();
                      //                         //         print(
                      //                         //             "selected value is ${selectedValue}");
                      //                         //       });
                      //                         //     },
                      //                         //   ),
                      //                         // ),
                      //                         //   SizedBox(height: 20,),
                      //                         // Text("Price Range",style: TextStyle(color: appColorBlack,fontSize: 15,fontWeight: FontWeight.w500),),
                      //                         // Slider(
                      //                         //   label: "price",
                      //                         //   min: 00.0,
                      //                         //   max: 100.0,
                      //                         //   value: _value.toDouble(),
                      //                         //   onChanged: (value) {
                      //                         //     setState(() {
                      //                         //       _value = value.toInt();
                      //                         //     });
                      //                         //   },
                      //                         // ),
                      //                         SizedBox(
                      //                           height: 50,
                      //                         ),
                      //                         Row(
                      //                           mainAxisAlignment:
                      //                               MainAxisAlignment.center,
                      //                           children: [
                      //                             InkWell(
                      //                               onTap: () {
                      //                                 setState(() {
                      //                                   sortingApiCall();
                      //                                 });
                      //                                 Navigator.of(context)
                      //                                     .pop();
                      //                               },
                      //                               child: Container(
                      //                                 width: 100,
                      //                                 height: 40,
                      //                                 alignment:
                      //                                     Alignment.center,
                      //                                 decoration:
                      //                                     BoxDecoration(
                      //                                   color:
                      //                                       backgroundblack,
                      //                                   borderRadius:
                      //                                       BorderRadius
                      //                                           .circular(10),
                      //                                 ),
                      //                                 child: Text(
                      //                                   "Apply",
                      //                                   style: TextStyle(
                      //                                       color:
                      //                                           appColorWhite,
                      //                                       fontSize: 16,
                      //                                       fontWeight:
                      //                                           FontWeight
                      //                                               .w600),
                      //                                 ),
                      //                               ),
                      //                             ),
                      //                           ],
                      //                         ),
                      //                         // Expanded(child: Slider(value: _value.toDouble(),onChanged: (double newValue){
                      //                         //   setState(() {
                      //                         //     _value = newValue.toInt();
                      //                         //   });
                      //                         // }))
                      //                       ],
                      //                     ),
                      //                   );
                      //                 });
                      //               });
                      //         },
                      //         child: Text(
                      //           "Filter",
                      //           style: TextStyle(
                      //               color: Colors.white,
                      //               fontWeight: FontWeight.w500),
                      //         ),
                      //         color: backgroundblack,
                      //       ),
                      //     ),
                      //     Container(),
                      //   ],
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: search(),
                      ),
                      bestSellerItems(context),
                    ],
                  ),
      ),
    );
  }

  List _searchResult = [];

  onSearchTextChanged(String text) async {
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    sortingModel!.restaurants!.forEach((userDetail) {
      if (userDetail.resName != null) if (userDetail.resName!
          .toLowerCase()
          .contains(text.toLowerCase())) _searchResult.add(userDetail);
    });
    setState(() {});
  }

  Widget search() {
    return Padding(
        padding: const EdgeInsets.only(top: 10, right: 0, left: 0),
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.green,
            borderRadius: new BorderRadius.all(
              Radius.circular(15.0),
            ),
          ),
          height: 40,
          child: Center(
            child: TextField(
              controller: controller,
              onChanged: onSearchTextChanged,
              autofocus: true,
              style: TextStyle(color: Colors.grey),
              decoration: new InputDecoration(
                border: new OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.grey),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(15.0),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.grey),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(15.0),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: new BorderSide(color: Colors.grey),
                  borderRadius: const BorderRadius.all(
                    const Radius.circular(15.0),
                  ),
                ),
                filled: true,
                hintStyle: new TextStyle(color: Colors.grey[600], fontSize: 14),
                hintText: "Search",
                contentPadding: EdgeInsets.only(top: 10.0),
                fillColor: Colors.grey[200],
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey[600],
                  size: 25.0,
                ),
              ),
            ),
          ),
        ));
  }

  unLikeServiceFunction(String resId, String userID) async {
    UnlikeServiceModal unlikeServiceModal;

    var uri = Uri.parse('${baseUrl()}/unlike');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({
      'res_id': resId,
      'user_id': userID,
    });

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    unlikeServiceModal = UnlikeServiceModal.fromJson(userData);

    if (unlikeServiceModal.status == '1') {
      setState(() {
        likedService.remove(resId);
      });
      Flushbar(
        backgroundColor: appColorWhite,
        messageText: Text(
          unlikeServiceModal.msg!,
          style: TextStyle(
            fontSize: SizeConfig.blockSizeHorizontal! * 4,
            color: appColorBlack,
          ),
        ),

        duration: Duration(seconds: 3),
        // ignore: deprecated_member_use
        mainButton: Container(),
        icon: Icon(
          Icons.favorite_border,
          color: appColorBlack,
          size: 25,
        ),
      )..show(context);
    } else {
      Flushbar(
        title: "Fail",
        message: unlikeServiceModal.msg,
        duration: Duration(seconds: 3),
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
      )..show(context);
    }
  }

  likeServiceFunction(String resId, String userID) async {
    LikeServiceModal likeServiceModal;

    var uri = Uri.parse('${baseUrl()}/likeRes');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({
      'res_id': resId,
      'user_id': userID,
    });

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    likeServiceModal = LikeServiceModal.fromJson(userData);

    if (likeServiceModal.responseCode == "1") {
      setState(() {
        likedService.add(resId);
      });
      Flushbar(
        backgroundColor: appColorWhite,
        messageText: Text(
          likeServiceModal.message!,
          style: TextStyle(
            fontSize: SizeConfig.blockSizeHorizontal! * 4,
            color: appColorBlack,
          ),
        ),

        duration: Duration(seconds: 3),
        // ignore: deprecated_member_use
        mainButton: MaterialButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WishListScreen(
                  back: true,
                ),
              ),
            );
          },
          child: Text(
            "Go to wish list",
            style: TextStyle(color: appColorBlack),
          ),
        ),
        icon: Icon(
          Icons.favorite,
          color: appColorBlack,
          size: 25,
        ),
      )..show(context);
    } else {
      Flushbar(
        title: "Fail",
        message: likeServiceModal.message,
        duration: Duration(seconds: 3),
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
      )..show(context);
    }
  }

  Widget bestSellerItems(BuildContext context) {
    return sortingModel!.restaurants!.length != 0
        ? GridView.builder(
            shrinkWrap: true,
            //physics: NeverScrollableScrollPhysics(),
            primary: false,
            padding: EdgeInsets.all(10),
            itemCount: _searchResult.isEmpty
                ? sortingModel!.restaurants!.length
                : _searchResult.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 93 / 170,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              var item;
              if (_searchResult.isEmpty) {
                item = sortingModel!.restaurants![index];
              } else {
                item = _searchResult[index];
              }
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                          resId: item.resId,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Container(
                      width: 210,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 110,
                            width: 200,
                            child: Stack(
                              children: [
                                Container(
                                  height: 100,
                                  alignment: Alignment.topCenter,
                                  decoration: BoxDecoration(
                                    color: Colors.black45,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        topLeft: Radius.circular(10)),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                          item.logo![0].toString()),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                // Carousel(
                                //   images: sortingModel!.restaurants![index].logo!
                                //       .map((it) {
                                //     return
                                //
                                //   }).toList(),
                                //   showIndicator: true,
                                //   dotBgColor: Colors.transparent,
                                //   borderRadius: false,
                                //   autoplay: false,
                                //   dotSize: 4.0,
                                //   dotSpacing: 15.0,
                                // ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    width: 40,
                                    child: likedService.contains(sortingModel!
                                            .restaurants![index].resId)
                                        ? Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: RawMaterialButton(
                                              shape: CircleBorder(),
                                              padding: const EdgeInsets.all(0),
                                              fillColor: Colors.white54,
                                              splashColor: Colors.grey[400],
                                              child: Icon(
                                                Icons.favorite,
                                                color: Colors.red,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                unLikeServiceFunction(
                                                    sortingModel!
                                                        .restaurants![index]
                                                        .resId
                                                        .toString(),
                                                    userID);
                                              },
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.all(4),
                                            child: RawMaterialButton(
                                              shape: CircleBorder(),
                                              padding: const EdgeInsets.all(0),
                                              fillColor: Colors.white54,
                                              splashColor: Colors.grey[400],
                                              child: Icon(
                                                Icons.favorite_border,
                                                size: 20,
                                              ),
                                              onPressed: () {
                                                likeServiceFunction(
                                                    sortingModel!
                                                        .restaurants![index]
                                                        .resId
                                                        .toString(),
                                                    userID);
                                              },
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   height: 100,
                          //   alignment: Alignment.topCenter,
                          //   decoration: BoxDecoration(
                          //     color: Colors.black45,
                          //     borderRadius: BorderRadius.only(
                          //         topRight: Radius.circular(10),
                          //         topLeft: Radius.circular(10)),
                          //     image: DecorationImage(
                          //       image: NetworkImage(item.logo![0]
                          //           .toString()),
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),
                          // Align(
                          //   alignment: Alignment.bottomLeft,
                          //   child: Container(
                          //     width: 40,
                          //     child: likedService.contains(sortingModel!.restaurants![index].resId)
                          //         ? Padding(
                          //       padding:
                          //       const EdgeInsets.all(4),
                          //       child: RawMaterialButton(
                          //         shape: CircleBorder(),
                          //         padding:
                          //         const EdgeInsets.all(
                          //             0),
                          //         fillColor: Colors.white54,
                          //         splashColor:
                          //         Colors.grey[400],
                          //         child: Icon(
                          //           Icons.favorite,
                          //           color: Colors.red,
                          //           size: 20,
                          //         ),
                          //         onPressed: () {
                          //           unLikeServiceFunction(
                          //               sortingModel!
                          //                   .restaurants![
                          //               index]
                          //                   .resId
                          //                   .toString(),
                          //               userID);
                          //         },
                          //       ),
                          //     )
                          //         : Padding(
                          //       padding:
                          //       const EdgeInsets.all(4),
                          //       child: RawMaterialButton(
                          //         shape: CircleBorder(),
                          //         padding:
                          //         const EdgeInsets.all(
                          //             0),
                          //         fillColor: Colors.white54,
                          //         splashColor:
                          //         Colors.grey[400],
                          //         child: Icon(
                          //           Icons.favorite_border,
                          //           size: 20,
                          //         ),
                          //         onPressed: () {
                          //           likeServiceFunction(
                          //               sortingModel!
                          //                   .restaurants![
                          //               index]
                          //                   .resId
                          //                   .toString(),
                          //               userID);
                          //         },
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // Padding(
                          //   padding: EdgeInsets.all(8.0),
                          //   child: Column(
                          //     crossAxisAlignment: CrossAxisAlignment.start,
                          //     children: [
                          //       Row(
                          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //         children: [
                          //           Container(
                          //             width: 115,
                          //             child: Text(
                          //               item.resName![0]
                          //                       .toUpperCase() +
                          //                   item.resName!
                          //                       .substring(1),
                          //               maxLines: 1,
                          //               overflow: TextOverflow.ellipsis,
                          //               style: TextStyle(
                          //                   height: 1.2,
                          //                   color: appColorBlack,
                          //                   fontSize: 12,
                          //                   fontWeight: FontWeight.bold),
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //       Container(height: 5),
                          //      Row(
                          //        children: [
                          //          Icon(Icons.location_on, size: 14),
                          //          Text("${item.cityName}", style: TextStyle(fontSize: 14),),
                          //        ],
                          //      ),
                          //       Container(height: 5),
                          //       Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           // Container(
                          //           //   width: 110,
                          //           //   child: Text(
                          //           //     catModal!
                          //           //         .restaurants![index].resDesc!,
                          //           //     maxLines: 1,
                          //           //     overflow: TextOverflow.ellipsis,
                          //           //     style: TextStyle(
                          //           //         color: appColorBlack,
                          //           //         fontSize: 12,
                          //           //         fontWeight: FontWeight.normal),
                          //           //   ),
                          //           // ),
                          //           SizedBox(
                          //             height: 3,
                          //           ),
                          //           Row(
                          //             mainAxisAlignment:
                          //                 MainAxisAlignment.spaceBetween,
                          //             children: [
                          //               Text(
                          //                 "${item.base_currency} " + item.price!,
                          //                 style: TextStyle(
                          //                     color: appColorBlack,
                          //                     fontSize: 14,
                          //                     fontWeight: FontWeight.bold),
                          //               ),
                          //             ],
                          //           ),
                          //           SizedBox(height: 6,),
                          //           Row(
                          //             children: [
                          //               Text("Rating:", style: TextStyle(fontSize: 12),),
                          //               RatingBar.builder(
                          //                 initialRating: item.resRating == ""
                          //                     ? 0.0
                          //                     : double.parse(item.resRating.toString()),
                          //                 minRating: 0,
                          //                 direction: Axis.horizontal,
                          //                 allowHalfRating: true,
                          //                 itemCount: 5,
                          //                 itemSize: 15,
                          //                 ignoreGestures: true,
                          //                 unratedColor: Colors.grey,
                          //                 itemBuilder: (context, _) => Icon(
                          //                     Icons.star,
                          //                     color: appColorOrange),
                          //                 onRatingUpdate: (rating) {
                          //                   print(rating);
                          //                 },
                          //               ),
                          //               SizedBox(width: 3),
                          //               Text("${double.parse(sortingModel?.restaurants?[index].resRating ?? '0.0').toStringAsFixed(1)}", style: TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis,)
                          //             ],
                          //           ),
                          //           SizedBox(height: 10),
                          //           Center(
                          //             child: Container(
                          //               height: 30,
                          //               width: 100,
                          //               alignment: Alignment.center,
                          //               decoration: BoxDecoration(
                          //                   border: Border.all(
                          //                     color: backgroundblack,
                          //                     width: 1,
                          //                   ),
                          //                   color: backgroundblack.withOpacity(0.3),
                          //                   borderRadius: BorderRadius.circular(5)
                          //               ),
                          //               child: Text("Book Service",style: TextStyle(color: backgroundblack, fontWeight: FontWeight.w600)),
                          //             ),
                          //           ),
                          //           // Container(
                          //           //   child: Padding(
                          //           //       padding: EdgeInsets.all(0),
                          //           //       child: Text(
                          //           //         "BOOK NOW",
                          //           //         style: TextStyle(
                          //           //             color: Colors.blue,
                          //           //             fontSize: 12),
                          //           //       )),
                          //           // ),
                          //         ],
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0, top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Stack(children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: primary,
                                        child: Padding(
                                          padding: EdgeInsets.all(2),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(sortingModel!
                                                      .restaurants![index]
                                                      .vendorImage ??
                                                  '')),
                                        ),
                                      ),
                                      sortingModel!.restaurants![index]
                                                  .is_verified ??
                                              false
                                          ? Positioned(
                                              right: 0,
                                              bottom: 0,
                                              child: Container(
                                                  height: 15,
                                                  width: 15,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors
                                                          .grey.shade300
                                                          .withOpacity(0.9)),
                                                  child: Icon(
                                                    Icons.check,
                                                    color: Colors.blue,
                                                    size: 12,
                                                  )))
                                          : SizedBox()
                                    ]),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        sortingModel!.restaurants![index]
                                                .vendorName ??
                                            'Sawan Sakhya',
                                        style: TextStyle(
                                          color: appColorBlack,
                                          fontSize: 12,
                                        ))
                                  ],
                                ),
                                Text(
                                  'Can travel: ${sortingModel!.restaurants![index].canTravel}',
                                  style: TextStyle(
                                    color: appColorBlack,
                                    fontSize: 10,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 10, top: 5, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  // width:
                                  //     MediaQuery.of(context).size.width /
                                  //         2.7,
                                  child: Text(
                                    sortingModel!
                                            .restaurants![index].resName![0]
                                            .toUpperCase() +
                                        sortingModel!
                                            .restaurants![index].resName!
                                            .substring(1),
                                    maxLines: 2,
                                    style: TextStyle(
                                        color: appColorBlack,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // Container(
                                //   height: 25,
                                //   width: 25,
                                //   child: Image.asset("assets/images/recommanded.png",fit: BoxFit.fill,),
                                // ),
                                // Text(
                                //   "${sortingModel!.restaurants![index].cityName}",
                                //   maxLines: 1,
                                //   style: TextStyle(
                                //       color: appColorBlack,
                                //       fontSize: 14,
                                //       fontWeight: FontWeight.w400),
                                // ),
                              ],
                            ),
                          ),
                          Container(height: 5),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 10, right: 5, bottom: 5),
                            child: Text(
                              "${sortingModel!.restaurants![index].resDesc}",
                              style: TextStyle(
                                  height: 1.3,
                                  fontSize: 12,
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 1,
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 5, right: 5, bottom: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Container(
                                //   width: 130,
                                //   child: Text(
                                //     sortingModel!.restaurants![index].resDesc!,
                                //     maxLines: 1,
                                //     style: TextStyle(
                                //         color: appColorBlack,
                                //         fontSize: 12,
                                //         height: 1.2,
                                //         fontWeight: FontWeight.normal),
                                //   ),
                                // ),
                                // SizedBox(height: 3,),
                                Row(
                                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "₹" +
                                    //           sortingModel!
                                    //               .restaurants![index].price!,
                                    //       style: TextStyle(
                                    //           color: appColorBlack,
                                    //           fontSize: 14,
                                    //           fontWeight: FontWeight.bold),
                                    //     ),
                                    //     Text(" - ${sortingModel!.restaurants![index].hours} ${sortingModel!.restaurants![index].hour_type}",style: TextStyle(
                                    //         color: appColorBlack,
                                    //         fontSize: 14,
                                    //         fontWeight: FontWeight.bold),)
                                    //   ],
                                    // ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.grey,
                                          size: 13,
                                        ),
                                        SizedBox(
                                          width: 1,
                                        ),
                                        Text(
                                          "${sortingModel!.restaurants![index].cityName}",
                                          style: TextStyle(
                                              color: appColorBlack,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 15),
                                    RatingBar.builder(
                                      initialRating: sortingModel!
                                                  .restaurants![index]
                                                  .resRating ==
                                              ""
                                          ? 0.0
                                          : double.parse(sortingModel!
                                              .restaurants![index].resRating
                                              .toString()),
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 13,
                                      ignoreGestures: true,
                                      unratedColor: Colors.grey,
                                      itemBuilder: (context, _) => Icon(
                                          Icons.star,
                                          color: appColorOrange),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                    SizedBox(width: 3),
                                    Text(
                                      "${double.parse(sortingModel?.restaurants?[index].resRating ?? '0.0').toStringAsFixed(1)}",
                                      style: TextStyle(fontSize: 12),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        "${sortingModel!.restaurants![index].base_currency} " +
                                            sortingModel!
                                                .restaurants![index].price!,
                                        style: TextStyle(
                                            color: appColorBlack,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      sortingModel!.restaurants![index].hours ==
                                                  null ||
                                              sortingModel!.restaurants![index]
                                                      .hours ==
                                                  ""
                                          ? Text(
                                              "- 2 ${sortingModel!.restaurants![index].hour_type}",
                                              style: TextStyle(
                                                  color: appColorBlack,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold))
                                          : Text(
                                              " - ${sortingModel!.restaurants![index].hours} ${sortingModel!.restaurants![index].hour_type}",
                                              style: TextStyle(
                                                  color: appColorBlack,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailScreen(
                                                    resId: sortingModel!
                                                        .restaurants![index]
                                                        .resId,
                                                  )),
                                        );
                                      },
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          padding: EdgeInsets.all(3),
                                          decoration: BoxDecoration(
                                              color: primary
                                                  .withOpacity(0.2),
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: primary)),
                                          child: Text(
                                            "Book Service",
                                            style: TextStyle(
                                                color: primary,
                                                fontSize: 11,
                                                fontWeight: FontWeight.w600),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DetailScreen(
                                              resId: sortingModel!
                                                  .restaurants![index].resId,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.person_add,
                                            color: primary,
                                            size: 18,
                                          ),
                                          Text(
                                            "View Profile",
                                            style: TextStyle(
                                                color: primary,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        : Container(
            height: 100,
            child: Center(
              child: Text(
                "No Services Available",
                style: TextStyle(
                  color: appColorBlack,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          );
  }
}
