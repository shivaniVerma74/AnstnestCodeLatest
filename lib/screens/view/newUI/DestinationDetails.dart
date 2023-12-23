import 'dart:convert';

import 'package:ez/screens/view/newUI/viewCategory.dart';
import 'package:flutter/material.dart';

import '../../../constant/global.dart';
import '../models/DestinationModel.dart';
import 'package:http/http.dart' as http;

class DestinationDetails extends StatefulWidget {
  Data Details;

  DestinationDetails({Key? key, required this.Details}) : super(key: key);

  @override
  State<DestinationDetails> createState() => _DestinationDetailsState();
}

class _DestinationDetailsState extends State<DestinationDetails> {
  DestinationModel? destinationModel;

  @override
  void initState() {
    print("Detailssssss ${widget.Details}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        backgroundColor: primary,
        elevation: 2,
        title: Text(
          'Details',
          style: TextStyle(color: appColorWhite, fontWeight: FontWeight.bold),
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
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              height: MediaQuery.of(context).size.height / 1.8,
              width: MediaQuery.of(context).size.width / 1.1,
              margin: EdgeInsets.only(right: 10),
              child: Card(
                color: appColorWhite,
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                borderOnForeground: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // height: 100,
                      // width: 150,
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                        child: Image.network(
                          "${widget.Details.image}",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 19,
                        ),
                        Text(
                          "${widget.Details.name}",
                          style: TextStyle(
                              color: appColorBlack,
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 5),
                      child: Text(
                        "${widget.Details.description}",
                        style: TextStyle(
                            height: 1, color: appColorBlack, fontSize: 13),
                        // maxLines: 2,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewCategory(
                                  fromSeller: false,
                                  cid: widget.Details.id,
                                )));
                  },
                  child: Container(
                    height: 45,
                    width: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: primary,
                          width: 1,
                        ),
                        color: primary,
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      "View Provider",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
