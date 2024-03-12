import 'dart:convert';
import 'dart:developer';

import 'package:another_flushbar/flushbar.dart';
import 'package:ez/models/City_model.dart';
import 'package:ez/models/GetLocationCityModel.dart';
import 'package:ez/models/state_model.dart';
import 'package:ez/screens/view/models/NewCountryModel.dart';
import 'package:ez/screens/view/newUI/detail.dart';
import 'package:ez/screens/view/newUI/wishList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import '../../../constant/global.dart';
import '../../../constant/sizeconfig.dart';
import '../models/catModel.dart';
import '../models/categories_model.dart';
import '../models/get_city_response.dart';
import '../models/get_country_response.dart';
import '../models/likeService_modal.dart';
import '../models/unLikeService_modal.dart';

class AllProviderService extends StatefulWidget {
  final String? catid;

  AllProviderService({this.catid});

  @override
  State<AllProviderService> createState() => _AllProviderServiceState();
}

class _AllProviderServiceState extends State<AllProviderService> {
  CatModal catModal = CatModal();

  getResidential() async {
    log(selectedCountry.toString());

    try {
      Map<String, String> headers = {
        'content-type': 'application/x-www-form-urlencoded',
      };
      var map = new Map<String, dynamic>();
      // map['vid'] = widget.vid;
      map['cat_id'] = selectedCategory ?? widget.catid ?? "0";
      map['sort_by'] = selectedValue ?? "";
      map['min_price'] = _startValue.toString() ?? "0";
      map['max_price'] = _endValue.toString() ?? "0";
      map['max_price'] = _endValue.toString() ?? "0";
      map['search'] = lookingCtr.text.toString();
      map['star_rating'] = selectedRating ?? '';
      map['s_cat_id'] = selectedSubcategory ?? "";

      map['country'] = selectedCountry ?? '';
      map['state'] = selectedState ?? '';
      map['city'] = selectedCity ?? "";
      // map['cat_id'] = _endValue.toString() ?? "0";
      // map['cid'] = _endValue.toString() ?? "0";
      log(map.toString() + "PARAMS");
      final response = await client.post(Uri.parse("${baseUrl()}/get_cat_res"),
          headers: headers, body: map);
      var dic = json.decode(response.body);

      log("${baseUrl()}/get_cat_res");
      Map<String, dynamic> userMap = jsonDecode(response.body);
      print(response.body.toString() + "ok now res");
      setState(() {
        catModal = CatModal.fromJson(userMap);
      });
      print("ok now ${catModal.msg} and ${catModal.status}");
      log(userMap.toString());
    } catch (stacktrace, err) {
      log(stacktrace.toString() + "RESPONSE ERROR");
      log(err.toString() + "RESPONSE ERRORs");
    }
  }

  String? selectedValue;

  Future<Null> refreshFunction() async {
    await getResidential();
  }

  List itemsList = [
    {"id": "1", "name": "Price low to high"},
    {"id": "2", "name": "Price high to low"},
    {"id": "3", "name": "Newest"},
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getResidential();
    _getCollection();
    //getLocationCity() ;
    getCountries();
  }

  TextEditingController lookingCtr = TextEditingController();
  double _startValue = 100.0;
  double _endValue = 10000.0;
  String? selectedRating;

  List<String> ratingList = ['1', '2', '3', '4', '5'];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        // bottom:
        title: Text(
          "All services",
          style: TextStyle(color: appColorWhite),
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
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            child: TextField(
                              controller: lookingCtr,
                              // onChanged: onSearchTextChanged,
                              onChanged: (value) {
                                getResidential();
                              },
                              autofocus: true,
                              style: TextStyle(color: Colors.white),
                              decoration: new InputDecoration(
                                border: new OutlineInputBorder(
                                  borderSide: new BorderSide(color: primary),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: new BorderSide(color: primary),
                                  borderRadius: const BorderRadius.all(
                                    const Radius.circular(10.0),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      new BorderSide(color: Colors.white),
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
                        ],
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
                                                "Filter by prices",
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
                                                    print(
                                                        "start value $_startValue and $_endValue");
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
                                      size: 15,
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
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: Icon(Icons
                                                          .keyboard_arrow_down),
                                                    ),
                                                  ),
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
                                    Icon(
                                      Icons.sort,
                                      color: appColorWhite,
                                      size: 15,
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
                                                      value: items,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        child: Text(items),
                                                      ),
                                                    );
                                                  }).toList(),
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedRating = newValue;
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
                                    Icon(
                                      Icons.star,
                                      color: appColorWhite,
                                      size: 15,
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
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedCategory =
                                                          newValue!;
                                                      getResidential();
                                                      getSubCategory();
                                                      print(
                                                          "selected category $selectedCategory");
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
                                    Icon(
                                      Icons.category,
                                      color: appColorWhite,
                                      size: 15,
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
                                                  onChanged:
                                                      (String? newValue) {
                                                    setState(() {
                                                      selectedSubcategory =
                                                          newValue!;
                                                      print(
                                                          "selected sub category $selectedSubcategory");
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
                                                                  .circular(
                                                                      10)),
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
                                              StateSetter setModalState) {
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
                                              /*Container(
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
                                                            .keyboard_arrow_down)),
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
                                              ),*/
                                              SizedBox(
                                                height: 10,
                                              ),
                                              _countryModel == null
                                                  ? SizedBox()
                                                  : Container(
                                                      height: 60,
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7),
                                                          border: Border.all(
                                                              color: appColorBlack
                                                                  .withOpacity(
                                                                      0.3))),
                                                      child: DropdownButton(
                                                        // Initial Value
                                                        value: selectedCountry,
                                                        isExpanded: true,

                                                        underline: Container(),
                                                        // Down Arrow Icon
                                                        icon: Container(
                                                            alignment: Alignment
                                                                .centerRight,
                                                            child: Icon(Icons
                                                                .keyboard_arrow_down)),
                                                        hint: SizedBox(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                1.25,
                                                            child: Text(
                                                                "Select Country")),
                                                        // Array list of items
                                                        items: _countryModel!
                                                            .data!
                                                            .map((items) {
                                                          return DropdownMenuItem(
                                                            value: items.id,
                                                            child: Container(
                                                                child: Text(items
                                                                    .nicename
                                                                    .toString())),
                                                          );
                                                        }).toList(),
                                                        // After selecting the desired option,it will
                                                        // change button value to selected value
                                                        onChanged:
                                                            (String? newValue) {
                                                          setModalState(() {
                                                            selectedCountry =
                                                                newValue!;
                                                            getState(
                                                                selectedCountry
                                                                    .toString());
                                                          });
                                                          setModalState(() {});
                                                        },
                                                      ),
                                                    ),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment
                                              //           .spaceAround,
                                              //   // mainAxisSize: MainAxisSize.min,
                                              //   children: [
                                              //     Container(
                                              //       height: 45,
                                              //       width: 140,
                                              //       padding: EdgeInsets.only(
                                              //           left: 10),
                                              //       decoration: BoxDecoration(
                                              //         color: Colors.white,
                                              //         borderRadius:
                                              //             BorderRadius.circular(
                                              //                 10),
                                              //         border: Border.all(
                                              //           color: Colors.black,
                                              //         ),
                                              //       ),
                                              //       child:
                                              //           DropdownButtonHideUnderline(
                                              //         child: DropdownButton<
                                              //             CountryData>(
                                              //           hint: Text(
                                              //               'select Country'),
                                              //           value: selectedCountry,
                                              //           isExpanded: false,
                                              //           onChanged: (newValue) {
                                              //             setState(() {
                                              //               selectedCountry =
                                              //                   newValue!;
                                              //               selectedCity = null;
                                              //               _getCities(
                                              //                   selectedCountry
                                              //                           ?.id ??
                                              //                       '',
                                              //                   setState);
                                              //             });
                                              //           },
                                              //           items: countries.map(
                                              //               (CountryData
                                              //                   value) {
                                              //             return DropdownMenuItem<
                                              //                     CountryData>(
                                              //                 value: value,
                                              //                 child: SizedBox(
                                              //                   width: 100,
                                              //                   child: Text(
                                              //                     value.nicename ??
                                              //                         '',
                                              //                     overflow:
                                              //                         TextOverflow
                                              //                             .ellipsis,
                                              //                     textAlign:
                                              //                         TextAlign
                                              //                             .center,
                                              //                     style:
                                              //                         TextStyle(
                                              //                       fontWeight:
                                              //                           FontWeight
                                              //                               .normal,
                                              //                     ),
                                              //                   ),
                                              //                 ));
                                              //           }).toList(),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //     Container(
                                              //       height: 45,
                                              //       width: 140,
                                              //       padding: EdgeInsets.only(
                                              //           left: 10),
                                              //       decoration: BoxDecoration(
                                              //         color: Colors.white,
                                              //         borderRadius:
                                              //             BorderRadius.circular(
                                              //                 10),
                                              //         border: Border.all(
                                              //           color: Colors.black,
                                              //         ),
                                              //       ),
                                              //       child:
                                              //           DropdownButtonHideUnderline(
                                              //         child: DropdownButton<
                                              //             CityDataLsit>(
                                              //           isExpanded: false,
                                              //           hint:
                                              //               Text('Select City'),
                                              //           value: selectedCity,
                                              //           onChanged: (newValue) {
                                              //             setState(() {
                                              //               selectedCity =
                                              //                   newValue!;
                                              //             });
                                              //           },
                                              //           items: cities.map(
                                              //               (CityDataLsit
                                              //                   value) {
                                              //             return DropdownMenuItem<
                                              //                     CityDataLsit>(
                                              //                 value: value,
                                              //                 child: SizedBox(
                                              //                   width: 100,
                                              //                   child: Text(
                                              //                     value.name ??
                                              //                         '',
                                              //                     textAlign:
                                              //                         TextAlign
                                              //                             .center,
                                              //                     style:
                                              //                         TextStyle(
                                              //                       fontWeight:
                                              //                           FontWeight
                                              //                               .normal,
                                              //                     ),
                                              //                   ),
                                              //                 ));
                                              //           }).toList(),
                                              //         ),
                                              //       ),
                                              //     ),
                                              //   ],
                                              // ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              stateModel == null
                                                  ? SizedBox()
                                                  : Container(
                                                      height: 60,
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7),
                                                          border: Border.all(
                                                              color: appColorBlack
                                                                  .withOpacity(
                                                                      0.3))),
                                                      child: DropdownButton(
                                                        // Initial Value
                                                        isExpanded: true,
                                                        value: selectedState,
                                                        underline: Container(),
                                                        // Down Arrow Icon
                                                        icon: Icon(Icons
                                                            .keyboard_arrow_down),
                                                        hint: Text(
                                                            "Select State"),
                                                        // Array list of items
                                                        items: stateModel!.data!
                                                            .map((items) {
                                                          return DropdownMenuItem(
                                                            value: items.id,
                                                            child: Container(
                                                                child: Text(items
                                                                    .name
                                                                    .toString())),
                                                          );
                                                        }).toList(),
                                                        // After selecting the desired option,it will
                                                        // change button value to selected value
                                                        onChanged:
                                                            (String? newValue) {
                                                          setModalState(() {
                                                            selectedState =
                                                                newValue!;
                                                            selectedCity = null;
                                                            //getSubCategory();
                                                            getCities(
                                                                selectedState
                                                                    .toString());
                                                            setModalState(
                                                                () {});

                                                            print(
                                                                "selected category ${selectedCategory}");
                                                          });
                                                        },
                                                      ),
                                                    ),

                                              SizedBox(
                                                height: 10,
                                              ),

                                              cityModel == null
                                                  ? SizedBox()
                                                  : Container(
                                                      height: 60,
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(7),
                                                          border: Border.all(
                                                              color: appColorBlack
                                                                  .withOpacity(
                                                                      0.3))),
                                                      child: DropdownButton(
                                                        // Initial Value
                                                        value: selectedCity,
                                                        isExpanded: true,
                                                        underline: Container(),
                                                        // Down Arrow Icon
                                                        icon: Icon(Icons
                                                            .keyboard_arrow_down),
                                                        hint:
                                                            Text("Select City"),
                                                        // Array list of items
                                                        items: cityModel!.data!
                                                            .map((items) {
                                                          return DropdownMenuItem(
                                                            value: items.id,
                                                            child: Container(
                                                                child: Text(items
                                                                    .name
                                                                    .toString())),
                                                          );
                                                        }).toList(),
                                                        onChanged:
                                                            (String? newValue) {
                                                          setModalState(() {
                                                            selectedCity =
                                                                newValue!;
                                                            print(
                                                                "selected category $selectedCategory");
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
                                                      child: Text("Apply",
                                                          style: TextStyle(
                                                              color:
                                                                  appColorWhite,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
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
                                      Icons.location_on,
                                      color: appColorWhite,
                                      size: 15,
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

  List<CountryData> countries = [];
  List<CityDataLsit> cities = [];

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
    return catModal.restaurants!.length != 0
        ? GridView.builder(
            shrinkWrap: true,
            //physics: NeverScrollableScrollPhysics(),
            primary: false,
            padding: EdgeInsets.all(8),
            itemCount: catModal!.restaurants!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio:
                  MediaQuery.of(context).size.height / 100 * 0.065,
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
                          resId: catModal.restaurants![index].resId,
                          isComingForBooking: false,
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
                            // height: 300,
                            width: 200,
                            child: Stack(
                              children: [
                                catModal!.restaurants![index].logo?.isEmpty ??
                                        false
                                    ? SizedBox.shrink()
                                    : SizedBox(
                                        height: 100,
                                        // width: 10,
                                        child: GridTile(
                                          footer: SizedBox(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Text(
                                                catModal.restaurants![index]
                                                        .currency_symbol! +
                                                    catModal.restaurants![index]
                                                        .price! +
                                                    "-" +
                                                    (catModal
                                                                .restaurants![
                                                                    index]
                                                                .hours
                                                                .toString() ==
                                                            "null"
                                                        ? "1"
                                                        : catModal
                                                            .restaurants![index]
                                                            .hours
                                                            .toString()) +
                                                    (catModal
                                                                .restaurants![
                                                                    index]
                                                                .hour_type
                                                                .toString() ==
                                                            'Hours'
                                                        ? 'hrs'
                                                        : 'days'),
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          child: Container(
                                            height: 100,
                                            alignment: Alignment.topCenter,
                                            decoration: BoxDecoration(
                                              color: Colors.black45,
                                              borderRadius: BorderRadius.only(
                                                  topRight: Radius.circular(10),
                                                  topLeft: Radius.circular(10)),
                                              image: DecorationImage(
                                                image: NetworkImage(catModal!
                                                    .restaurants![index]
                                                    .logo![0]
                                                    .toString()),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                catModal!.restaurants![index].is_recommended ==
                                        true
                                    ? Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          height: 35,
                                          width: 35,
                                          child: Image.asset(
                                            "assets/images/recommanded.png",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      width: 40,
                                      child: likedService.contains(catModal!
                                              .restaurants![index].resId)
                                          ? Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: RawMaterialButton(
                                                shape: CircleBorder(),
                                                padding:
                                                    const EdgeInsets.all(0),
                                                fillColor: Colors.white54,
                                                splashColor: Colors.grey[400],
                                                child: Icon(
                                                  Icons.favorite,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  unLikeServiceFunction(
                                                      catModal!
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
                                                padding:
                                                    const EdgeInsets.all(0),
                                                fillColor: Colors.white54,
                                                splashColor: Colors.grey[400],
                                                child: Icon(
                                                  Icons.favorite_border,
                                                  size: 20,
                                                ),
                                                onPressed: () {
                                                  likeServiceFunction(
                                                      catModal!
                                                          .restaurants![index]
                                                          .resId
                                                          .toString(),
                                                      userID);
                                                },
                                              ),
                                            ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   height: 110,
                          //   alignment: Alignment.topCenter,
                          //   decoration: BoxDecoration(
                          //     color: Colors.black45,
                          //     borderRadius: BorderRadius.only(
                          //         topRight: Radius.circular(10),
                          //         topLeft: Radius.circular(10)),
                          //     image: DecorationImage(
                          //       image: NetworkImage(
                          //           catModal!.restaurants![index].logo![0].toString()),
                          //       fit: BoxFit.cover,
                          //     ),
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Row(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: primary,
                                      child: Padding(
                                        padding: EdgeInsets.all(2),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image.network(
                                              catModal.restaurants![index]
                                                      .vendorImage ??
                                                  '',
                                              fit: BoxFit.cover,
                                            )),
                                      ),
                                    ),
                                    catModal!.restaurants![index].is_verified ??
                                            false
                                        ? Positioned(
                                            right: 0,
                                            bottom: 0,
                                            child: Container(
                                                height: 15,
                                                width: 15,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.grey.shade300
                                                        .withOpacity(0.9)),
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors.blue,
                                                  size: 12,
                                                )))
                                        : SizedBox()
                                  ],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "${catModal.restaurants![index].vendorName}",
                                  maxLines: 1,
                                  style: TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      // color: Colors.red,
                                      width: 80,
                                      alignment: Alignment.topLeft,

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
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 5),
                                          child: Icon(
                                            Icons.location_on,
                                            size: 13,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 55,
                                          child: Text(
                                            "${catModal.restaurants![index].cityName}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(fontSize: 13),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(height: 5),
                                Text(
                                  "Can Travel: NationWide",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                                Container(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: 130,
                                      child: Text(
                                        catModal!.restaurants![index].resDesc!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: appColorBlack,
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Text(
                                        //   "₹" + catModal.restaurants![index].price!,
                                        //       style: TextStyle(
                                        //       color: appColorBlack,
                                        //       fontSize: 16,
                                        //       fontWeight: FontWeight.bold),
                                        // ),
                                        // catModal.restaurants![index].hours! == null || catModal.restaurants![index].hours! == "" ? Text("0.0"):
                                        // Text("₹${catModal.restaurants?[index].price}-${catModal.restaurants?[index].hours!}/${catModal.restaurants?[index].hour_type}", style: TextStyle(
                                        //     color: appColorBlack,
                                        //     fontSize: 14,
                                        //     fontWeight: FontWeight.bold),
                                        // ),
                                      ],
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      children: [
                                        Text(
                                          "Rating:",
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        SizedBox(width: 2),
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
                                    SizedBox(height: 25),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Container(
                                            height: 25,
                                            width: 60,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: primary,
                                                  width: 1,
                                                ),
                                                color: primary.withOpacity(0.3),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: Text("Book Service",
                                                style: TextStyle(
                                                    color: primary,
                                                    fontSize: 8,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.person,
                                                color: primary,
                                                size: 15,
                                              ),
                                              Text(
                                                "View Profile",
                                                style: TextStyle(
                                                    color: primary,
                                                    fontSize: 8,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ],
                                          ),
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

  String? selectedCountry, selectedState, selectedCity, selectedCountryCode;

  NewCountryModel? _countryModel;

  getCountries() async {
    var headers = {
      'Cookie': 'ci_session=9ea27dd74c60662925c9cd9abc1046f289e10c02'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/get_countries'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalresponse = await response.stream.bytesToString();
      final jsonResponse = NewCountryModel.fromJson(json.decode(finalresponse));
      setState(() {
        _countryModel = jsonResponse;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  StateModel? stateModel;

  getState(String id) async {
    var headers = {
      'Cookie': 'ci_session=9ea27dd74c60662925c9cd9abc1046f289e10c02'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/get_states'));
    request.fields.addAll({'country_id': '${id}'});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = StateModel.fromJson(json.decode(finalResponse));
      setState(() {
        stateModel = jsonResponse;
      });
      setState(() {});
    } else {
      print(response.reasonPhrase);
    }
  }

  CityModel? cityModel;

  getCities(String id) async {
    var headers = {
      'Cookie': 'ci_session=9ea27dd74c60662925c9cd9abc1046f289e10c02'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/get_cities'));
    request.fields.addAll({'state_id': '${id}'});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = CityModel.fromJson(json.decode(finalResult));
      setState(() {
        cityModel = jsonResponse;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  GetLocationCityModel? locationCityModel;

  getLocationCity() async {
    var uri = Uri.parse('${baseUrl()}/get_location');
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
    print("checking location data here $userData");
    if (mounted) {
      setState(() {
        locationCityModel = GetLocationCityModel.fromJson(userData);
      });
    }
    print(responseData);
  }

  var selectedCountryId;
  var selectedCityId;
}
