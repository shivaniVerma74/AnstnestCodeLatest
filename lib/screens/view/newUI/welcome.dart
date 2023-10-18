import 'package:ez/screens/view/newUI/login.dart';
import 'package:ez/screens/view/newUI/welcome2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ez/constant/global.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: splashColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                    ),
                    // Image.asset(
                    //   'assets/images/logo.png',
                    //   height: 70,
                    // ),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    Text(appName,
                        style: TextStyle(
                            color: appColorWhite,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'OpenSans',
                            fontStyle: FontStyle.italic)),
                    SizedBox(
                      height: 5,
                    ),
                    Text('Find Your Professional Ants',
                        style: TextStyle(
                          color: appColorWhite,
                          fontSize: 14,
                        )),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      child: Image.asset(
                        'assets/images/getstarted.png',
                        width: 300,
                        // fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:13, right:13),
                      child: Text(
                          'Welcome to AntsNest! We connect you with the finest professionals in town. Our curated network includes experts like photographers, fashion stylists, makeup artists, tour guides, translators, videographers, hair stylists, and more. Enjoy reliable and top-quality services at your fingertips, anytime, anywhere! ',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: appColorWhite,
                            fontSize: 15,
                          ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // Container(
                    //   height: 4,
                    //   width: 50,
                    //   decoration: BoxDecoration(
                    //       color: appColorWhite,
                    //       borderRadius: BorderRadius.all(Radius.circular(30))),
                    // ),
                  ],
                ),
              ),
            ),
            // SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: Container(
                    height: 50.0,
                    // ignore: deprecated_member_use
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Login()
                          ),
                        );
                      },
                      elevation: 10,
                      color: appColorWhite,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.all(0.0),
                      child: Text(
                        "GET STARTED",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: appColorBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Container(
            //   height: 4,
            //   width: 150,
            //   decoration: BoxDecoration(
            //       color: appColorWhite,
            //       borderRadius: BorderRadius.all(Radius.circular(30))),
            // ),
            SizedBox(
              height: 30,
            ),
          ],
        ));
  }
}
