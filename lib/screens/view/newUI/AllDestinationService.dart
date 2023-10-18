import 'dart:convert';

import 'package:ez/screens/view/newUI/detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import '../../../constant/global.dart';
import '../models/DestinationModel.dart';
import '../models/catModel.dart';
import 'DestinationDetails.dart';

class AllDestination extends StatefulWidget {
  final String? catid;
  AllDestination({this.catid});
  @override
  State<AllDestination> createState() => _AllDestinationState();
}

class _AllDestinationState extends State<AllDestination> {


  String? selectedValue;
  Future<Null> refreshFunction()async{
    await getDestination();
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDestination();
  }

  DestinationModel? destinationModel;

  getDestination() async {
    var uri = Uri.parse('${baseUrl()}/destinations');
    var request = new http.MultipartRequest("Post", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({'user_id': userID});

    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    if (mounted) {
      setState(() {
        destinationList.clear();
        destinationModel = DestinationModel.fromJson(userData);
      });
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20)
            )
        ),
        // bottom:
        title: Text(
          "All services",
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
      body: RefreshIndicator(
          onRefresh: refreshFunction,
          child:  destinationModel == null || destinationModel!.data!.isEmpty
              ? Container(
            child: Center(
              child: Text("No destination to show"),
            ),
          ) : Padding(
            padding: EdgeInsets.only(top: 20),
            child: ListView(
              children: [
                bestSellerItems(context),
              ],
            ),
          )),
    );
  }


  Widget bestSellerItems(BuildContext context) {
    return  destinationModel!.data!.length != 0
        ? GridView.builder(
      shrinkWrap: true,
      //physics: NeverScrollableScrollPhysics(),
      primary: false,
      padding: EdgeInsets.all(8),
      itemCount: destinationModel!.data!.length ?? 0,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 95/160,
        crossAxisSpacing: 0.0,
        mainAxisSpacing: 5.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: InkWell(
            onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => DestinationDetails(Details: destinationModel!.data![index])));
            },
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
              child: Container(
                width: 210,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 140,
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(0),
                            topLeft: Radius.circular(0)),
                        image: DecorationImage(
                          image: NetworkImage(
                              "${destinationModel!.data![index].image}"),
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                // color: Colors.red,
                                alignment:Alignment.topLeft,
                                width: MediaQuery.of(context).size.width/4.5,
                                child: Text(
                                  "${destinationModel!.data![index].name}",
                                  style: TextStyle(
                                      color: appColorBlack,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3),
                            child: Text(
                              "${destinationModel!.data![index].description}",
                              style: TextStyle(
                                  height: 1,
                                  color: appColorBlack
                                      .withOpacity(0.5),
                                  fontSize: 13),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Divider(
                            height: 1,
                          ),
                          SizedBox(
                            height: 7,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3),
                            child: Row(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "View More",
                                  style: TextStyle(
                                      color: backgroundblack,
                                      fontWeight:
                                      FontWeight.w600,
                                      fontSize: 13),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  color: backgroundblack,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                          // Container(height: 5),
                          // Text("Can Travel: NationWide",style: TextStyle(
                          //     color: Colors.black,
                          //     fontSize: 10, fontWeight: FontWeight.w600
                          // ),
                          // ),
                          // Container(height: 5),
                          // Column(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     // Container(
                          //     //   width: 110,
                          //     //   child: Text(
                          //     //     catModal!
                          //     //         .restaurants![index].resDesc!,
                          //     //     maxLines: 1,
                          //     //     overflow: TextOverflow.ellipsis,
                          //     //     style: TextStyle(
                          //     //         color: appColorBlack,
                          //     //         fontSize: 12,
                          //     //         fontWeight: FontWeight.normal),
                          //     //   ),
                          //     // ),
                          //     SizedBox(height: 3),
                          //     Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //       children: [
                          //         // Text(
                          //         //   "₹" + catModal.restaurants![index].price!,
                          //         //       style: TextStyle(
                          //         //       color: appColorBlack,
                          //         //       fontSize: 16,
                          //         //       fontWeight: FontWeight.bold),
                          //         // ),
                          //         Text("₹${catModal.restaurants![index].price}-${catModal.restaurants![index].hours!}hrs", style: TextStyle(
                          //             color: appColorBlack,
                          //             fontSize: 14,
                          //             fontWeight: FontWeight.bold),
                          //         ),
                          //       ],
                          //     ),
                          //     SizedBox(height: 5,),
                          //     Row(
                          //       children: [
                          //         Text("Rating:", style: TextStyle(),),
                          //         SizedBox(width: 2),
                          //         RatingBar.builder(
                          //           initialRating: catModal.restaurants![index].resRating == "" ? 0.0 : double.parse(catModal.restaurants![index].resRating.toString()),
                          //           minRating: 0,
                          //           direction: Axis.horizontal,
                          //           allowHalfRating: true,
                          //           itemCount: 5,
                          //           itemSize: 15,
                          //           ignoreGestures: true,
                          //           unratedColor: Colors.grey,
                          //           itemBuilder: (context, _) => Icon(Icons.star, color: appColorOrange),
                          //           onRatingUpdate: (rating) {
                          //             print(rating);
                          //           },
                          //         ),
                          //         // SizedBox(width: 2,),
                          //         // catModal.restaurants?[index].reviews?.first.revStars.toString() == null ||  catModal.restaurants![index].reviews?.first.revStars.toString()== "" ? Text("0.0"):
                          //         // Text("${catModal.restaurants?[index].reviews?.first.revStars.toString()}"),
                          //       ],
                          //     ),
                          //     SizedBox(height: 10),
                          //     Center(
                          //       child: Container(
                          //         height: 30,
                          //         width: 100,
                          //         alignment: Alignment.center,
                          //         decoration: BoxDecoration(
                          //             border: Border.all(
                          //               color: backgroundblack,
                          //               width: 1,
                          //             ),
                          //             color: backgroundblack.withOpacity(0.3),
                          //             borderRadius: BorderRadius.circular(5)
                          //         ),
                          //         child: Text("Book Service",style: TextStyle(color: backgroundblack, fontWeight: FontWeight.w600)),
                          //       ),
                          //     ),
                          //     // Container(
                          //     //   child: Padding(
                          //     //       padding: EdgeInsets.all(0),
                          //     //       child: Text(
                          //     //         "BOOK NOW",
                          //     //         style: TextStyle(
                          //     //             color: Colors.blue,
                          //     //             fontSize: 12),
                          //     //       )),
                          //     // ),
                          //   ],
                          // ),
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
