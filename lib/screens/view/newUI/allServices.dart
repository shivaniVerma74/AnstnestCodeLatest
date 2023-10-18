import 'dart:convert';

import 'package:ez/constant/global.dart';
import 'package:ez/screens/view/models/Search_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../models/catModel.dart';
import 'detail.dart';

class AllServices extends StatefulWidget {
  @override
  State<AllServices> createState() => _AllServicesState();
}

class _AllServicesState extends State<AllServices> {
  bool isLoading = false;

  CatModal? sortingModel;

  @override
  void initState() {
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
      final response = await client.post(
        Uri.parse("${baseUrl()}/get_all_cat_nvip_sorting"),
        headers: headers,
      );
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
        backgroundColor: backgroundblack,
        elevation: 0,
        title: Text("All Services", style: TextStyle(fontSize: 18, color: Colors.white),),
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
      if (userDetail.resName != null) if (userDetail.resName!.toLowerCase().contains(text.toLowerCase())) _searchResult.add(userDetail);
    });
    setState(() {});
  }

  Widget search(){
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
                hintStyle:
                new TextStyle(color: Colors.grey[600], fontSize: 14),
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

  Widget bestSellerItems(BuildContext context) {
    return sortingModel!.restaurants!.length != 0
        ? GridView.builder(
            shrinkWrap: true,
            //physics: NeverScrollableScrollPhysics(),
            primary: false,
            padding: EdgeInsets.all(10),
            itemCount: _searchResult.isEmpty ? sortingModel!.restaurants!.length : _searchResult.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 105 / 170,
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
            ),
            itemBuilder: (BuildContext context, int index) {
              var item ;
              if(_searchResult.isEmpty){
                item = sortingModel!.restaurants![index];
              }else {
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
                            height: 100,
                            alignment: Alignment.topCenter,
                            decoration: BoxDecoration(
                              color: Colors.black45,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10)),
                              image: DecorationImage(
                                image: NetworkImage(item.logo![0]
                                    .toString()),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 115,
                                      child: Text(
                                        item.resName![0]
                                                .toUpperCase() +
                                            item.resName!
                                                .substring(1),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            height: 1.2,
                                            color: appColorBlack,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(height: 5),
                               Row(
                                 children: [
                                   Icon(Icons.location_on, size: 14),
                                   Text("${item.cityName}", style: TextStyle(fontSize: 14),),
                                 ],
                               ),
                                Container(height: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Container(
                                    //   width: 110,
                                    //   child: Text(
                                    //     catModal!
                                    //         .restaurants![index].resDesc!,
                                    //     maxLines: 1,
                                    //     overflow: TextOverflow.ellipsis,
                                    //     style: TextStyle(
                                    //         color: appColorBlack,
                                    //         fontSize: 12,
                                    //         fontWeight: FontWeight.normal),
                                    //   ),
                                    // ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "${item.base_currency} " + item.price!,
                                          style: TextStyle(
                                              color: appColorBlack,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6,),
                                    Row(
                                      children: [
                                        Text("Rating:", style: TextStyle(fontSize: 12),),
                                        RatingBar.builder(
                                          initialRating: item.resRating == ""
                                              ? 0.0
                                              : double.parse(item.resRating.toString()),
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
                                        Text("${double.parse(sortingModel?.restaurants?[index].resRating ?? '0.0').toStringAsFixed(1)}", style: TextStyle(fontSize: 12), overflow: TextOverflow.ellipsis,)
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Center(
                                      child: Container(
                                        height: 30,
                                        width: 100,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: backgroundblack,
                                              width: 1,
                                            ),
                                            color: backgroundblack.withOpacity(0.3),
                                            borderRadius: BorderRadius.circular(5)
                                        ),
                                        child: Text("Book Service",style: TextStyle(color: backgroundblack, fontWeight: FontWeight.w600)),
                                      ),
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
