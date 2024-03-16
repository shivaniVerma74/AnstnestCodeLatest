import 'package:ez/constant/global.dart';
import 'package:ez/constant/sizeconfig.dart';
import 'package:flutter/material.dart';

class BlogsScreen extends StatelessWidget {
  final String name;
  final String description;
  final String image;

  const BlogsScreen(
      {super.key,
      required this.name,
      required this.description,
      required this.image});

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
          "Blog Details",
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image.network(
              image,
              height: 250,
              fit: BoxFit.contain,
            ),
            SizedBox(
              height: 5,
            ),
            Align(
                alignment: Alignment.center,
                child: Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                )),
            SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                description,
                style: TextStyle(fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
