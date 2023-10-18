import 'dart:convert';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:ez/screens/view/models/LoginWithOtpModel.dart';
import 'package:ez/screens/view/newUI/google_sign_in.dart';
import 'package:ez/screens/view/newUI/signup.dart';
import 'package:ez/screens/view/newUI/verify_otp.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ez/block/login_bloc.dart';
import 'package:ez/constant/global.dart';
import 'package:ez/screens/view/newUI/forgetpass.dart';
import 'package:ez/screens/view/newUI/newTabbar.dart';
import 'package:ez/share_preference/preferencesKey.dart';
import 'package:ez/strings/strings.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  ProgressDialog? pr;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = false;

  LocationData? locationData;
  String _token = '';
  dynamic loginType = 1;

  @override
  void initState() {
    // getToken();
    super.initState();
    getToken();
    // getCurrentLocation().then((_) async {
    //   setState(() {});
    // });
  }

  Future<LocationData?> getCurrentLocation() async {
    print("getCurrentLocation");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('currentLat') && prefs.containsKey('currentLon')) {
      locationData = LocationData.fromMap({
        "latitude": prefs.getDouble('currentLat'),
        "longitude": prefs.getDouble('currentLon')
      });
    } else {
      setCurrentLocation().then((value) {
        if (prefs.containsKey('currentLat') &&
            prefs.containsKey('currentLon')) {
          locationData = LocationData.fromMap({
            "latitude": prefs.getDouble('currentLat'),
            "longitude": prefs.getDouble('currentLon')
          });
        }
      });
    }
    return locationData;
  }

  getToken() {
    FirebaseMessaging.instance.getToken().then((token) async {
      _token = token!;
      print(" checking token here ${_token}");
    });
  }

  Future<LocationData?> setCurrentLocation() async {
    var location = new Location();
    location.requestService().then((value) async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        locationData = await location.getLocation();
        await prefs.setDouble('currentLat', locationData!.latitude!);
        await prefs.setDouble('currentLon', locationData!.longitude!);
      } on PlatformException catch (e) {
        if (e.code == 'PERMISSION_DENIED') {
          print('Permission denied');
        }
      }
    });
    return locationData;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: appColorWhite),
      child: Scaffold(
        backgroundColor: appColorWhite,
        appBar: AppBar(
            backgroundColor: appColorWhite,
            elevation: 0,
            title: Text(
              "",
              style: TextStyle(
                  fontSize: 20,
                  color: appColorBlack,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            // leading: InkWell(
            //   onTap: () {
            //     Navigator.of(context).pop();
            //   },
            //   child: Container(
            //     child: Icon(
            //       Icons.arrow_back_ios,
            //       color: backgroundblack,
            //     ),
            //   ),
            // )
         ),
        body: _loginForm(context),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // applogo(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "Welcome\nBack",
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'OpenSansBold',
                      fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Hey! Good See You Again",  style: TextStyle(
                    fontSize: 17,
                    // fontFamily: 'OpenSansBold',
                ),
                ),
              ],
            ),
          ),
          Container(height: 30.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Login",
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'OpenSansBold',
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 35),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Radio(
          //           value: 1,
          //           activeColor: backgroundblack,
          //           groupValue: loginType,
          //           onChanged: (value) {
          //             setState(() {
          //               loginType = value;
          //             });
          //           }),
          //       Text("Mobile"),
          //       Radio(
          //           value: 2,
          //           activeColor: backgroundblack,
          //           groupValue: loginType,
          //           onChanged: (value) {
          //             setState(() {
          //               loginType = value;
          //             });
          //           }),
          //       Text("Email"),
          //     ],
          //   ),
          // ),
          Container(height: 30.0),
          // loginType == 1 ?
          mobileLogin()
          // emailType(),
          // Container(height: 15.0),
        ],
      ),
    );
  }

  Widget mobileType() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          _mobileTextfield(context),
          Container(height: 30.0),
          _loginButton(context),
          Container(height: 30.0),
          _dontHaveAnAccount(context),
          Container(height: 30.0),
          googleButton(),
          Container(height: 30.0),
          facebookButton()
          //_createAccountButton(context)
        ],
      ),
    );
  }

  Widget mobileLogin() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 22),
          child: TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              hintText: "Enter email",
              label: Text(
                "Email",
                style: TextStyle(color: Colors.black54),
              ),
              prefixIcon: Icon(
                Icons.email_outlined,
                color: Colors.grey,
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.black12),
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.black54)),
            ),
          ),
        ),
        Container(height: 30.0),
        _loginButton(context),
        Container(height: 30.0),
        _dontHaveAnAccount(context),
        Container(height: 30.0),
        googleButton(),
        Container(height: 30.0),
        facebookButton(),
        //_createAccountButton(context)
      ],
    );
  }

  Widget emailType() {
    return Column(
      children: [
        _emailTextfield(context),
        // Container(height: 15.0),
        // _passwordTextfield(context),
        // Container(height: 20.0),
        // _forgotPassword(),
        Container(height: 30.0),
        _loginButton(context),
        Container(height: 30.0),
        _dontHaveAnAccount(context),
        Container(height: 30.0),
        _createAccountButton(context)
      ],
    );
  }

  Widget _mobileTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: _mobileController,
        maxLength: 10,
        labelText: "Mobile",
        hintText: "Enter Mobile No",
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
        prefixIcon: Icon(
          Icons.call,
          color: backgroundblack,
        ),
      ),
    );
  }

  Widget _emailTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        maxLines: 1,
        labelText: "Email",
        hintText: "Enter Email",
        textInputAction: TextInputAction.next,
        prefixIcon: Icon(Icons.email),
      ),
    );
  }

  Widget _passwordTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: _passwordController,
        maxLines: 1,
        labelText: "Password",
        hintText: "Enter Password",
        obscureText: !_obscureText,
        textInputAction: TextInputAction.next,
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ),
      ),
    );
  }

  Widget _forgotPassword() {
    return Padding(
      padding: const EdgeInsets.only(right: 40),
      child: Align(
        alignment: Alignment.topLeft,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ForgetPass()),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: InkWell(
        onTap: () async {
          // if(loginType != 1){
          //   _apiCall(context);
          // } else {
          if (_emailController.text.isNotEmpty) {
            LoginWithOtpModel? model = await loginWithOtp();
            if (model!.responseCode == "1") {
              // Fluttertoast.showToast(msg: model.message!);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VerifyOtp(
                            otp: model.otp.toString(),
                            email: _emailController.text.toString(),
                          )));
              // }
            }
          } else {
            Fluttertoast.showToast(msg: "Enter valid email");
          }
        },
        // },
        child: SizedBox(
            height: 60,
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                  color: backgroundblack,
                  // gradient: new LinearGradient(
                  //     colors: [
                  //         backgroundblack,
                  //         appColorGreen,
                  //     ],
                  //     begin: const FractionalOffset(0.0, 0.0),
                  //     end: const FractionalOffset(1.0, 0.0),
                  //     stops: [0.0, 1.0],
                  //     tileMode: TileMode.clamp),
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              height: 50.0,
              // ignore: deprecated_member_use
              child:
                  // child: loginType != 1 ? Center(
                  //   child: Stack(
                  //     children: [
                  //       Align(
                  //         alignment: Alignment.center,
                  //         child: Text(
                  //           "SIGN IN",
                  //           textAlign: TextAlign.center,
                  //           style: TextStyle(
                  //               color: appColorWhite,
                  //               fontWeight: FontWeight.bold,
                  //               fontSize: 15),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // )
                  // :
                  Center(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "SIGN IN",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: appColorWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget _createAccountButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => SignUp(),
            ),
          );
        },
        child: SizedBox(
            height: 60,
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                  color: appColorWhite,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              height: 50.0,
              // ignore: deprecated_member_use
              child: Center(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Create an Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: appColorBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget applogo() {
    return Column(
      children: [
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'assets/images/auth1.png',
            fit: BoxFit.fill,
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  Widget _dontHaveAnAccount(BuildContext context) {
    return Text.rich(
      TextSpan(
          // text: "Don\'t have an account?",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          children: [
            TextSpan(text: "Don\'t have an account?"),
            TextSpan(
                text: " Signup",
                style: TextStyle(color: backgroundblack),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => SignUp(),
                    ),
                  )),
          ]),
    );
  }

  void _apiCall(BuildContext context) {
    closeKeyboard();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr!.style(message: 'Showing some progress...');
    pr!.style(
      message: 'Please wait...',
      borderRadius: 10.0,
      backgroundColor: Colors.white,
      progressWidget: Container(
        height: 10,
        width: 10,
        margin: EdgeInsets.all(5),
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation(Colors.blue),
        ),
      ),
      elevation: 10.0,
      insetAnimCurve: Curves.easeInOut,
      progressTextStyle: TextStyle(
          color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
      messageTextStyle: TextStyle(
          color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    );

    if (_emailController.text.isNotEmpty) {
      pr!.show();

      loginBloc
          .loginSink(_emailController.text, _passwordController.text, _token)
          .then(
        (userResponse) async {
          print(
              "checking response here ${userResponse.message} and ${userResponse.status}");
          if (userResponse.responseCode == Strings.responseSuccess) {
            String userResponseStr = json.encode(userResponse);
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setString(
                SharedPreferencesKey.LOGGED_IN_USERRDATA, userResponseStr);
            // Loader().hideIndicator(context);
            loginBloc.dispose();
            pr!.hide();
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => TabbarScreen(),
              ),
              (Route<dynamic> route) => false,
            );
          } else {
            pr!.hide();
            loginerrorDialog(
                context, "Make sure you have entered right credential");
          }
        },
      );
    } else {
      loginerrorDialog(context, "Please enter your credential to login");
    }
  }

  Future<LoginWithOtpModel?> loginWithOtp() async {
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/send_otp'));
    request.fields.addAll(
        {'mobile': '${_emailController.text}', 'device_token': '$_token'});

    http.StreamedResponse response = await request.send();

    print(request);
    print(request.fields);
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      var results = LoginWithOtpModel.fromJson(json.decode(str));
      print("checking result here ${results.message}");
      String? msg;
      msg = results.message;
      Fluttertoast.showToast(msg: "${results.message}");
      return LoginWithOtpModel.fromJson(json.decode(str));
    } else {
      return null;
    }
  }


  bool isLoading = false;

  Widget googleButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: InkWell(
        onTap: () {
          setState(() {
            isLoading = true;
          });
          signInWithGoogle(context).whenComplete(() {
            setState(() {
              isLoading = false;
            });
          }
          );
        },
        child: SizedBox(
            height: 60,
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                  color: appColorWhite,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              height: 50.0,
              // ignore: deprecated_member_use
              child: Center(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          "assets/images/google.png",
                          height: 25,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Login With Google",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: appColorBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  Widget facebookButton() {
    return Padding(
      padding: const EdgeInsets.only(left: 40, right: 40),
      child: InkWell(
        onTap: () {
          setState(() {
            isLoading = true;
          });
          signInWithGoogle(context).whenComplete(() {
            setState(() {
              isLoading = false;
            });
          }
          );
        },
        child: SizedBox(
            height: 60,
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                  color: appColorWhite,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              height: 50.0,
              // ignore: deprecated_member_use
              child: Center(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Image.asset(
                          "assets/images/facebook.png",
                          height: 25,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Login With Facebook",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: appColorBlack,
                            fontWeight: FontWeight.bold,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
