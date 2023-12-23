import 'dart:convert';
import 'package:another_flushbar/flushbar.dart';
import 'package:ez/screens/view/models/catModel.dart';
import 'package:ez/screens/view/newUI/filterPage.dart';
import 'package:ez/screens/view/newUI/wishList.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:ez/constant/global.dart';
import 'package:ez/screens/view/newUI/detail.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../constant/sizeconfig.dart';
import '../models/categories_model.dart';
import '../models/likeService_modal.dart';
import '../models/unLikeService_modal.dart';

// ignore: must_be_immutable
class ViewCategory extends StatefulWidget {
  String? id;
  String? vid;
  String? name;
  String? catId;
  String? cid;
  bool fromSeller;

  ViewCategory(
      {this.id,
      this.cid,
      this.name,
      this.catId,
      required this.fromSeller,
      this.vid});

  @override
  _ServiceTabState createState() => _ServiceTabState();
}

class _ServiceTabState extends State<ViewCategory> {
  bool isLoading = false;
  CatModal catModal = CatModal();
  String? selectedValue;
  String? selectedRating;

  List itemsList = [
    {"id": "1", "name": "Price low to high"},
    {"id": "2", "name": "Price high to low"},
    {"id": "3", "name": "Newest"}
  ];

  List ratingList = [
    {"id": "1", "name": "1"},
    {"id": "2", "name": "2"},
    {"id": "3", "name": "3"},
    {"id": "3", "name": "4"},
    {"id": "3", "name": "5"}
  ];

  @override
  void initState() {
    super.initState();
    getResidential();
    _getCollection();
  }

  Future<Null> refreshFunction() async {
    await getResidential();
  }

  RangeValues _currentRangeValues = const RangeValues(40, 80);

  getResidential() async {
    print("from seller ${widget.fromSeller}");
    // try {
    Map<String, String> headers = {
      'content-type': 'application/x-www-form-urlencoded',
    };
    var map = new Map<String, dynamic>();
    if (widget.fromSeller) {
      map['vid'] = widget.vid;
      map['cat_id'] = widget.catId ?? "0";
      map['s_cat_id'] = widget.id ?? "0";
      map['sort_by'] = selectedValue.toString() ?? "0";
      map['min_price'] = _startValue.toString() ?? "0";
      map['max_price'] = _endValue.toString() ?? "0";
    } else {
      map['cid'] = widget.cid == null ? "" : widget.cid;
      map['cat_id'] = widget.catId ?? "";
      map['s_cat_id'] = widget.id ?? "";
      map['sort_by'] = selectedValue.toString() ?? "0";
      map['min_price'] = _startValue.toString() ?? "0";
      map['max_price'] = _endValue.toString() ?? "0";
      map['currency'] = currency;
    }
    final response = await client.post(Uri.parse("${baseUrl()}/get_cat_res"),
        headers: headers, body: map);
    print("checking result here ${baseUrl()}/get_cat_res and $map");
    // var dic = json.decode(response.body);
    // print("${baseUrl()}/get_cat_res");
    print('___________${response.body}__________');
    Map<String, dynamic> userMap = jsonDecode(response.body);
    setState(() {
      catModal = CatModal.fromJson(userMap);
    });
    print(">>>>>>");
    print(map);
    // } on Exception {
    //   Fluttertoast.showToast(msg: "No Internet connection");
    //   throw Exception('No Internet connection');
    // }
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

  String? selectedCategory;
  String? selectedSubcategory;
  AllCateModel? collectionModal;

  List<Categories> catlist = [];

  _getCollection() async {
    var uri = Uri.parse('${baseUrl()}/get_all_cat');
    var request = new http.MultipartRequest("GET", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    print(baseUrl.toString());

    request.headers.addAll(headers);
    // request.fields['vendor_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    if (mounted) {
      setState(() {
        collectionModal = AllCateModel.fromJson(userData);
        catlist = AllCateModel.fromJson(userData).categories!;
        print(
            "ooooo ${collectionModal!.status} and ${collectionModal!.categories!.length} and $userID");
      });
    }
    print(responseData);
  }

  List<Categories> subCatList = [];

  getSubCategory() async {
    var uri = Uri.parse('${baseUrl()}/get_all_cat');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    print("checking id here $selectedCategory");
    print(baseUrl.toString());
    request.headers.addAll(headers);
    request.fields['category_id'] = selectedCategory.toString();
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    if (mounted) {
      setState(() {
        subCatList = AllCateModel.fromJson(userData).categories!;
        collectionModal = AllCateModel.fromJson(userData);
      });
    }
    print(responseData);
  }

  double _startValue = 100.0;
  double _endValue = 10000.0;
  TextEditingController lookingCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        // bottom:
        title: widget.name == null
            ? SizedBox.shrink()
            : Text("${widget.name!.toUpperCase()}",
                style: TextStyle(color: appColorWhite)),
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
        child: catModal.restaurants == null
            ? Center(
                child: Text(
                  "No services to show",
                  style: TextStyle(
                      fontSize: 16,
                      color: appColorBlack,
                      fontWeight: FontWeight.w500),
                ),
              )
            : Padding(
                padding: EdgeInsets.only(top: 10),
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      child: Text("Keyword",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width / 1.2,
                        child: TextField(
                          controller: lookingCtr,
                          // onChanged: onSearchTextChanged,
                          autofocus: true,
                          style: TextStyle(color: Colors.white),
                          decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                              borderSide:
                                  new BorderSide(color: primary),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  new BorderSide(color: primary),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: new BorderSide(color: Colors.white),
                              borderRadius: const BorderRadius.all(
                                const Radius.circular(10.0),
                              ),
                            ),
                            filled: true,
                            hintStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800),
                            hintText: "What are you looking for?",
                            contentPadding: EdgeInsets.only(top: 10.0),
                            fillColor: primary,
                            prefixIcon: Icon(
                              Icons.tv_outlined,
                              color: Colors.white,
                              size: 25.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 15),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Filter by price",
                                                style: TextStyle(
                                                    color: appColorBlack,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              RangeSlider(
                                                divisions: 20,
                                                activeColor: primary,
                                                labels: RangeLabels(
                                                  _startValue
                                                      .round()
                                                      .toString(),
                                                  _endValue.round().toString(),
                                                ),
                                                min: 100,
                                                max: 10000,
                                                values: RangeValues(
                                                    _startValue, _endValue),
                                                onChanged: (values) {
                                                  setState(() {
                                                    _startValue = values.start;
                                                    _endValue = values.end;
                                                  });
                                                },
                                              ),
                                              // Container(
                                              //   decoration: BoxDecoration(
                                              //       borderRadius:
                                              //       BorderRadius.circular(10),
                                              //       border: Border.all(
                                              //           color: appColorBlack
                                              //               .withOpacity(0.5))),
                                              //   child: DropdownButton(
                                              //     value: selectedValue,
                                              //     underline: Container(),
                                              //     icon: Container(
                                              //         alignment: Alignment.centerRight,
                                              //         width: MediaQuery.of(context)
                                              //             .size
                                              //             .width /
                                              //             1.8,
                                              //         child: Padding(
                                              //           padding:
                                              //           EdgeInsets.only(right: 10),
                                              //           child: Icon(
                                              //               Icons.keyboard_arrow_down),
                                              //         )),
                                              //     hint: Padding(
                                              //       padding: EdgeInsets.only(left: 5),
                                              //       child: Text("Sort by"),
                                              //     ),
                                              //     items: itemsList.map((items) {
                                              //       return DropdownMenuItem(
                                              //         value: items['id'],
                                              //         child: Padding(
                                              //           padding:
                                              //           EdgeInsets.only(left: 5),
                                              //           child: Text(
                                              //               items['name'].toString()),
                                              //         ),
                                              //       );
                                              //     }).toList(),
                                              //     onChanged: ( newValue) {
                                              //       setState(() {
                                              //         selectedValue = newValue.toString();
                                              //         print(
                                              //             "selected value is ${selectedValue}");
                                              //       });
                                              //     },
                                              //   ),
                                              // ),
                                              //   SizedBox(height: 20,),
                                              // Text("Price Range",style: TextStyle(color: appColorBlack,fontSize: 15,fontWeight: FontWeight.w500),),
                                              // Slider(
                                              //   label: "price",
                                              //   min: 00.0,
                                              //   max: 100.0,
                                              //   value: _value.toDouble(),
                                              //   onChanged: (value) {
                                              //     setState(() {
                                              //       _value = value.toInt();
                                              //     });
                                              //   },
                                              // ),
                                              SizedBox(
                                                height: 50,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        getResidential();
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Container(
                                                      width: 100,
                                                      height: 40,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Text(
                                                        "Apply",
                                                        style: TextStyle(
                                                            color:
                                                                appColorWhite,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Expanded(child: Slider(value: _value.toDouble(),onChanged: (double newValue){
                                              //   setState(() {
                                              //     _value = newValue.toInt();
                                              //   });
                                              // }))
                                            ],
                                          ),
                                        );
                                      });
                                    });
                              },
                              child: Container(
                                width: 100,
                                padding: EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.filter_list,
                                      color: appColorWhite,
                                    ),
                                    Text(
                                      "Filter",
                                      style: TextStyle(color: appColorWhite),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 15),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Sort By",
                                                style: TextStyle(
                                                    color: appColorBlack,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: appColorBlack
                                                            .withOpacity(0.5))),
                                                child: DropdownButton(
                                                  value: selectedValue,
                                                  underline: Container(),
                                                  icon: Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.8,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10),
                                                        child: Icon(Icons
                                                            .keyboard_arrow_down),
                                                      )),
                                                  hint: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text("Sort by"),
                                                  ),
                                                  items: itemsList.map((items) {
                                                    return DropdownMenuItem(
                                                      value: items['id'],
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        child: Text(
                                                            items['name']
                                                                .toString()),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selectedValue =
                                                          newValue.toString();
                                                      print(
                                                          "selected value is ${selectedValue}");
                                                    });
                                                  },
                                                ),
                                              ),
                                              //   SizedBox(height: 20,),
                                              // Text("Price Range",style: TextStyle(color: appColorBlack,fontSize: 15,fontWeight: FontWeight.w500),),
                                              // Slider(
                                              //   label: "price",
                                              //   min: 00.0,
                                              //   max: 100.0,
                                              //   value: _value.toDouble(),
                                              //   onChanged: (value) {
                                              //     setState(() {
                                              //       _value = value.toInt();
                                              //     });
                                              //   },
                                              // ),
                                              SizedBox(
                                                height: 50,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        getResidential();
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Container(
                                                      width: 100,
                                                      height: 40,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Text(
                                                        "Apply",
                                                        style: TextStyle(
                                                            color:
                                                                appColorWhite,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // Expanded(child: Slider(value: _value.toDouble(),onChanged: (double newValue){
                                              //   setState(() {
                                              //     _value = newValue.toInt();
                                              //   });
                                              // }))
                                            ],
                                          ),
                                        );
                                      });
                                    });
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => FilterPage()));
                              },
                              child: Container(
                                width: 100,
                                padding: EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.sort,
                                      color: appColorWhite,
                                    ),
                                    Text(
                                      "Sort by",
                                      style: TextStyle(color: appColorWhite),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 15),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Rating",
                                                style: TextStyle(
                                                    color: appColorBlack,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: appColorBlack
                                                            .withOpacity(0.5))),
                                                child: DropdownButton(
                                                  value: selectedRating,
                                                  underline: Container(),
                                                  icon: Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.8,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: Icon(Icons
                                                          .keyboard_arrow_down),
                                                    ),
                                                  ),
                                                  hint: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text("Rating"),
                                                  ),
                                                  items:
                                                      ratingList.map((items) {
                                                    return DropdownMenuItem(
                                                      value: items['id'],
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        child: Text(
                                                            items['name']
                                                                .toString()),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selectedRating =
                                                          newValue.toString();
                                                      print(
                                                          "selected value is $selectedRating");
                                                    });
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 50,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        getResidential();
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Container(
                                                      width: 100,
                                                      height: 40,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Text(
                                                        "Apply",
                                                        style: TextStyle(
                                                            color:
                                                                appColorWhite,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                    });
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => FilterPage()));
                              },
                              child: Container(
                                width: 100,
                                padding: EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: appColorWhite,
                                    ),
                                    Text(
                                      "Rating",
                                      style: TextStyle(color: appColorWhite),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 15),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Categories",
                                                style: TextStyle(
                                                    color: appColorBlack,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: appColorBlack
                                                            .withOpacity(0.5))),
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  // Initial Value
                                                  value: selectedCategory,
                                                  underline: Container(),
                                                  // Down Arrow Icon
                                                  icon: Container(
                                                      // width: MediaQuery.of(context).size.width/1.5,
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Icon(Icons
                                                          .keyboard_arrow_down)),
                                                  hint: SizedBox(
                                                      width: 250,
                                                      child: Text(
                                                          "Select Category")),
                                                  // Array list of items
                                                  items: catlist.map((items) {
                                                    return DropdownMenuItem(
                                                      value: items.id,
                                                      child: Container(
                                                          child: Text(items
                                                              .cName
                                                              .toString())),
                                                    );
                                                  }).toList(),
                                                  // After selecting the desired option,it will
                                                  // change button value to selected value
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedCategory =
                                                          newValue!;
                                                      getSubCategory();
                                                      print(
                                                          "selected category ${selectedCategory}");
                                                    });
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 50,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        // getResidential();
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Container(
                                                      width: 100,
                                                      height: 40,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Text(
                                                        "Apply",
                                                        style: TextStyle(
                                                            color:
                                                                appColorWhite,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                    });
                              },
                              child: Container(
                                width: 100,
                                padding: EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.category,
                                      color: appColorWhite,
                                    ),
                                    Text("Categories",
                                        style: TextStyle(color: appColorWhite)),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 15),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "SubCategory",
                                                style: TextStyle(
                                                    color: appColorBlack,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: appColorBlack
                                                            .withOpacity(0.5))),
                                                child: DropdownButton(
                                                  isExpanded: true,
                                                  // Initial Value
                                                  value: selectedSubcategory,
                                                  underline: Container(),
                                                  // Down Arrow Icon
                                                  icon: Container(
                                                      // width: MediaQuery.of(context).size.width/1.5,
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: Icon(Icons
                                                          .keyboard_arrow_down)),
                                                  hint: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              1.25,
                                                      child:
                                                          Text("Subcategory")),
                                                  // Array list of items
                                                  items:
                                                      subCatList.map((items) {
                                                    return DropdownMenuItem(
                                                      value: items.id,
                                                      child: Container(
                                                          child: Text(items
                                                              .cName
                                                              .toString())),
                                                    );
                                                  }).toList(),
                                                  // After selecting the desired option,it will
                                                  // change button value to selected value
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedSubcategory =
                                                          newValue!;
                                                      print(
                                                          "selected sub category ${selectedSubcategory}");
                                                    });
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 50,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        getResidential();
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Container(
                                                      width: 100,
                                                      height: 40,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Text(
                                                        "Apply",
                                                        style: TextStyle(
                                                            color:
                                                                appColorWhite,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                    });
                              },
                              child: Container(
                                width: 100,
                                padding: EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "SubCategory",
                                      style: TextStyle(color: appColorWhite),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10)),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 15),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "Location",
                                                style: TextStyle(
                                                    color: appColorBlack,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    border: Border.all(
                                                        color: appColorBlack
                                                            .withOpacity(0.5))),
                                                child: DropdownButton(
                                                  value: selectedValue,
                                                  underline: Container(),
                                                  icon: Container(
                                                    alignment:
                                                        Alignment.centerRight,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.8,
                                                    child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: Icon(Icons
                                                          .keyboard_arrow_down),
                                                    ),
                                                  ),
                                                  hint: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5),
                                                    child: Text("Location"),
                                                  ),
                                                  items: itemsList.map((items) {
                                                    return DropdownMenuItem(
                                                      value: items['id'],
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        child: Text(
                                                            items['name']
                                                                .toString()),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      selectedValue =
                                                          newValue.toString();
                                                      print(
                                                          "selected value is $selectedValue");
                                                    });
                                                  },
                                                ),
                                              ),
                                              SizedBox(
                                                height: 50,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        getResidential();
                                                      });
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Container(
                                                      width: 100,
                                                      height: 40,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child: Text(
                                                        "Apply",
                                                        style: TextStyle(
                                                            color:
                                                                appColorWhite,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                    });
                                //Navigator.push(context, MaterialPageRoute(builder: (context) => FilterPage()));
                              },
                              child: Container(
                                width: 100,
                                padding: EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                    color: primary,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      color: appColorWhite,
                                    ),
                                    Text(
                                      "Location",
                                      style: TextStyle(color: appColorWhite),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    bestSellerItems(context),
                  ],
                ),
              ),
      ),
    );
  }

  Widget bestSellerItems(BuildContext context) {
    return catModal.restaurants!.length != 0
        ? GridView.builder(
            shrinkWrap: true,
            //physics: NeverScrollableScrollPhysics(),
            primary: false,
            padding: EdgeInsets.all(10),
            itemCount: catModal.restaurants!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 105 / 170,
              crossAxisSpacing: 0.0,
              mainAxisSpacing: 5.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(
                            resId: catModal!.restaurants![index].resId),
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
                          catModal.restaurants![index].logo!.isNotEmpty
                              ? Container(
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
                                            image: NetworkImage(catModal!
                                                .restaurants![index].logo![0]
                                                .toString()),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Container(
                                          width: 40,
                                          child: likedService.contains(catModal!
                                                  .restaurants![index].resId)
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: RawMaterialButton(
                                                    shape: CircleBorder(),
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    fillColor: Colors.white54,
                                                    splashColor:
                                                        Colors.grey[400],
                                                    child: Icon(
                                                      Icons.favorite,
                                                      color: Colors.red,
                                                      size: 20,
                                                    ),
                                                    onPressed: () {
                                                      unLikeServiceFunction(
                                                          catModal!
                                                              .restaurants![
                                                                  index]
                                                              .resId
                                                              .toString(),
                                                          userID);
                                                    },
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  child: RawMaterialButton(
                                                    shape: CircleBorder(),
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    fillColor: Colors.white54,
                                                    splashColor:
                                                        Colors.grey[400],
                                                    child: Icon(
                                                      Icons.favorite_border,
                                                      size: 20,
                                                    ),
                                                    onPressed: () {
                                                      likeServiceFunction(
                                                          catModal!
                                                              .restaurants![
                                                                  index]
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
                                )
                              // Container(
                              //   height: 100,
                              //   alignment: Alignment.topCenter,
                              //   decoration: BoxDecoration(
                              //     color: Colors.black45,
                              //     borderRadius: BorderRadius.only(
                              //         topRight: Radius.circular(10),
                              //         topLeft: Radius.circular(10)),
                              //     image: DecorationImage(
                              //       image: NetworkImage(catModal
                              //           .restaurants![index].logo![0]
                              //           .toString()),
                              //       fit: BoxFit.cover,
                              //     ),
                              //   ),
                              // )
                              : SizedBox(),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 100,
                                      child: Text(
                                        catModal.restaurants![index].resName![0]
                                                .toUpperCase() +
                                            catModal
                                                .restaurants![index].resName!
                                                .substring(1),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            height: 1.2,
                                            color: appColorBlack,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 3),
                                Row(
                                  children: [
                                    Text(
                                      catModal.restaurants![index]
                                              .currency_symbol! +
                                          double.parse(catModal
                                                      .restaurants![index]
                                                      .price ??
                                                  '0.0')
                                              .toStringAsFixed(2),
                                      style: TextStyle(
                                          color: appColorBlack,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(width: 5),
                                    Icon(Icons.location_on, size: 18),
                                    SizedBox(
                                        width: 57,
                                        child: Text(
                                            "${catModal.restaurants![index].cityName}")),
                                  ],
                                ),
                                Container(height: 2),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 120,
                                      child: Text(
                                        catModal!.restaurants![index].resDesc!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: appColorBlack,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Text(
                                    //       catModal.restaurants![index].currency_symbol! +
                                    //           double.parse(catModal.restaurants![index].price ?? '0.0').toStringAsFixed(2),
                                    //       style: TextStyle(
                                    //           color: appColorBlack,
                                    //           fontSize: 15,
                                    //           fontWeight: FontWeight.bold),
                                    //     ),
                                    //   ],
                                    // ),
                                    Text(
                                      "Can Travel: NationWide",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Container(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          "Rating:",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        RatingBar.builder(
                                          initialRating: catModal
                                                      .restaurants![index]
                                                      .resRating ==
                                                  ""
                                              ? 0.0
                                              : double.parse(catModal
                                                  .restaurants![index].resRating
                                                  .toString()),
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemSize: 15,
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
                                        catModal.restaurants![index]
                                                        .resRating ==
                                                    null ||
                                                catModal.restaurants![index]
                                                        .resRating ==
                                                    ""
                                            ? Text("0.0")
                                            : Text(
                                                "${double.parse(catModal.restaurants![index].resRating ?? '0.0').toStringAsFixed(1)}",
                                                style: TextStyle(fontSize: 12),
                                                overflow: TextOverflow.ellipsis,
                                              )
                                      ],
                                    ),
                                    SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            // Navigator.push(context, MaterialPageRoute(builder: (context) => DetailScreen(resId: sortingModel!.restaurants![index].resId,)),
                                            // );
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
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
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
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    // Container(
                                    //   child: Padding(
                                    //       padding: EdgeInsets.all(0),
                                    //       child: Text(
                                    //         "BOOK NOW",
                                    //         style: TextStyle(
                                    //             color: Colors.blue,
                                    //             fontSize: 12),
                                    //       )),
                                    // ),
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
