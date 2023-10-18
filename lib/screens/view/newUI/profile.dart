import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:country_picker/country_picker.dart';
import 'package:ez/models/uProfileModal.dart';
import 'package:ez/screens/view/models/NewCurrencyModel.dart';
import 'package:ez/screens/view/newUI/booking.dart';
import 'package:ez/screens/view/newUI/changePassword.dart';
import 'package:ez/screens/view/newUI/newTabbar.dart';
import 'package:ez/screens/view/newUI/notificationScreen.dart';
import 'package:ez/screens/view/newUI/welcome2.dart';
import 'package:ez/utils/extention.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:ez/constant/global.dart';
import 'package:ez/constant/sizeconfig.dart';
import 'package:ez/screens/view/newUI/login.dart';
import 'package:ez/screens/view/models/getUserModel.dart';
import 'package:ez/share_preference/preferencesKey.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:toast/toast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// ignore: must_be_immutable
class Profile extends StatefulWidget {
  bool? back;
  Profile({this.back});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  TextEditingController _username = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _lastName = TextEditingController();

  // File? selectedImage;
  // String? imageUrl;

   File? imagePath;
  // String? filePath;
  // File? selectedImage;
  String? filePath;
  GeeUserModel? model;
  bool? isLoading = false;
  bool? isLoad = false;
  //final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Position? currentLocation;
  String? _currentAddress;

 // XFile? image = await picker.pickImage(source: ImageSource.gallery);
  @override
  void initState() {
    _getAddressFromLatLng();
    super.initState();
   Future.delayed(Duration.zero,(){
     return  getUserDataApicall();
   });

   Future.delayed(Duration(milliseconds: 300),(){
     return getCurrency();
   });
  }

  String phoneCode = '91';
  String countryName = '';

  String? selectedCurrency;

  getUserDataApicall() async {
    setState(() {
      isLoading = true;
    });

    //try {
      Map<String, String> headers = {
        'content-type': 'application/x-www-form-urlencoded',
      };
      var map = new Map<String, dynamic>();
      map['user_id'] = userID;

      final response = await client.post(Uri.parse("${baseUrl()}/user_data"),
          headers: headers, body: map);
      print(map.toString());
      print("user data here now ${baseUrl()}/user_data   and ${map}");
      var dic = json.decode(response.body);
      Map<String, dynamic> userMap = jsonDecode(response.body);
      model = GeeUserModel.fromJson(userMap);
      userEmail = model!.user!.email!;
      userMobile = model!.user!.mobile!;
      selectedCurrency = model!.user!.currency;
      _username.text = model!.user!.username!.split(' ')[0].toString().capitalizeByWord();
      if(model!.user!.username!.contains(' ')) _lastName.text = model!.user!.username!.split(' ')[1];
      _mobile.text = model!.user!.mobile!;
      _address.text = model!.user!.address ?? "";
     // phoneCode = model!.user!.c
      print("GetUserData>>>>>>");
      print("checking address here ${_address.text} and ${_mobile.text}");
      print(dic);
      setState(() {
        isLoading = false;
      });
  //   } on Exception {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     Fluttertoast.showToast(msg: "No Internet connection");
  //     throw Exception('No Internet connection');
  //   }
    }

  Future getUserCurrentLocation() async {
    await Geolocator.getCurrentPosition().then((position) {
      if (mounted)
        setState(() {
          currentLocation = position;
        });
    });
  }


  NewCurrencyModel? currencyModel;

  getCurrency()async{
    var headers = {
      'Cookie': 'ci_session=bba38841200d796c5a2c59f6faf3664a74756f90'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${baseUrl()}/get_currency'));
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      print('${finalResult}____________');
      final jsonResponse = NewCurrencyModel.fromJson(json.decode(finalResult));
      setState(() {
        currencyModel = jsonResponse;
      });
    }
    else {
      print(response.reasonPhrase);
    }
  }


  _getAddressFromLatLng() async {
    getUserCurrentLocation().then((_) async {
      try {
        List<Placemark> p = await placemarkFromCoordinates(
            currentLocation!.latitude, currentLocation!.longitude);

        Placemark place = p[0];

        setState(() {
          _currentAddress = "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
          print(_currentAddress);
        });
      } catch (e) {
        print(e);
      }
    });
  }


  Future<Null> onRefresh()async{
    await getUserDataApicall();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: appColorWhite,
        appBar: AppBar(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)
              )
          ),
          backgroundColor: backgroundblack,
          elevation: 0,
          title: Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: widget.back == true
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    if (widget.back == true) {
                      Navigator.pop(context);
                    }
                  },
                )
              : Container(),
          actions: [
            // IconButton(
            //     onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => NotificationList()),
            //       );
            //     },
            //     icon: Icon(
            //       Icons.notifications_outlined,
            //       color: appColorWhite,
            //     )),
            Container(width: 10),
          ],
        ),
        body: isLoading == true
            ? Center(
                child: Image.asset("assets/images/loader1.gif"),
              )
            : Stack(
                children: [
                model == null ? Container(child: Center(child: CircularProgressIndicator(color: backgroundblack,))) :  _userInfo(),
                  isLoad == true ? Center(child: load()) : Container()
                ],
              )
    );
  }

  Widget   _userInfo() {
    return model!.user != null
        ? Stack(
            children: <Widget>[
              RefreshIndicator(
                onRefresh: onRefresh,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        height: 15,
                      ),
                      profilePic(model!.user!),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 2,
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        controller: _username,
                        maxLines: 1,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                        decoration: InputDecoration.collapsed(
                          hintText: "Enter Name",
                          hintStyle: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(height: 10),
                      Row(
                        children: [
                          // Container(
                          //   child: Card(
                          //     elevation: 5,
                          //     shape: CircleBorder(),
                          //     child: Padding(
                          //       padding:
                          //       const EdgeInsets.all(10),
                          //       child: Icon(
                          //         Icons.email_outlined,
                          //         size: 25,
                          //         color: Colors.cyan,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // Container(
                          //   width: 30,
                          // ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [

                                Text(
                                  model!.user!.email!.length > 0
                                      ? model!.user!.email!
                                      : "Logged in with social account",
                                  maxLines: 1,
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight:
                                      FontWeight.bold,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(height: 10),
                      Text(
                        _currentAddress != null
                            ? _currentAddress!
                            : "please wait..",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 14),
                      ),

                      Container(height: 20),

                      Padding(
                        padding: EdgeInsets.only(left: 12,right: 12),
                        child: Row(
                          children: [
                            Expanded(
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Card(
                                      elevation: 3,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Container(
                                        height: 320,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    //elevation: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0,right: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(height: 10),

                                          Row(
                                            children: [
                                              Container(
                                                child: Card(
                                                  elevation: 5,
                                                  shape: CircleBorder(),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(10),
                                                    child: Icon(
                                                      Icons.local_phone_outlined,
                                                      size: 25,
                                                      color: Colors.cyan,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 30,
                                              ),
                                              InkWell(
                                                onTap: (){
                                                  showCountryPicker(
                                                    context: context,
                                                    showPhoneCode: true,
                                                    // optional. Shows phone code before the country name.
                                                    onSelect: ( Country country) {
                                                      print('Select country: ${country.countryCode}');
                                                      setState(() {
                                                        phoneCode = country.phoneCode.toString();
                                                        countryName = country.countryCode.toString();
                                                      });
                                                    },
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(bottom: 13),
                                                  margin: EdgeInsets.only(right: 10),
                                                  height: 70,
                                                  alignment: Alignment.bottomCenter,
                                                  decoration: BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(color: Colors.black45)
                                                  )
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                    children: [
                                                      Text("${countryName} +${phoneCode}",style:TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),

                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Mobile Number",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey[600],
                                                          fontSize: 12),
                                                    ),
                                                    Container(height: 3),
                                                    TextFormField(
                                                      controller: _mobile,
                                                      maxLines: 1,
                                                      maxLength: 10,
                                                        validator: (value){
                                                        if(value!.length != 10){
                                                          return "Enter valid number";
                                                        }
                                                        return null;
                                                        },
                                                      keyboardType: TextInputType.phone,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14),
                                                      decoration: InputDecoration(

                                                      counterText: "",
                                                        hintText: "Enter Mobile",
                                                        hintStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(height: 10),

                                          Row(
                                            children: [
                                              Container(
                                                child: Card(
                                                  elevation: 5,
                                                  shape: CircleBorder(),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(8),
                                                    child: Icon(
                                                      Icons.person,
                                                      size: 27,
                                                      color: Colors.cyan,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 30,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Last Name",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.grey[600],
                                                          fontSize: 12),
                                                    ),
                                                    Container(height: 1),
                                                    TextFormField(
                                                      controller: _lastName,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          fontSize: 14),
                                                      decoration:
                                                      InputDecoration
                                                        (
                                                        hintText: "Enter Last Name",
                                                        hintStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                            FontWeight.bold,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Container(height: 10),
                                          // Row(
                                          //   children: [
                                          //     Container(
                                          //       child: Card(
                                          //         elevation: 5,
                                          //         shape: CircleBorder(),
                                          //         child: Padding(
                                          //           padding:
                                          //               const EdgeInsets.all(10),
                                          //           child: Icon(
                                          //             Icons.email_outlined,
                                          //             size: 25,
                                          //             color: Colors.cyan,
                                          //           ),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     Container(
                                          //       width: 30,
                                          //     ),
                                          //     Expanded(
                                          //       child: Column(
                                          //         crossAxisAlignment:
                                          //             CrossAxisAlignment.start,
                                          //         mainAxisAlignment:
                                          //             MainAxisAlignment.center,
                                          //         children: [
                                          //           Text(
                                          //             "Email",
                                          //             style: TextStyle(
                                          //                 fontWeight:
                                          //                     FontWeight.bold,
                                          //                 color: Colors.grey[600],
                                          //                 fontSize: 12),
                                          //           ),
                                          //           Container(height: 3),
                                          //           Text(
                                          //             model!.user!.email!.length > 0
                                          //                 ? model!.user!.email!
                                          //                 : "Logged in with social account",
                                          //             maxLines: 1,
                                          //             style: TextStyle(
                                          //                 color: Colors.black,
                                          //                 fontWeight:
                                          //                     FontWeight.bold,
                                          //                 fontSize: 14),
                                          //           ),
                                          //         ],
                                          //       ),
                                          //     ),
                                          //   ],
                                          // ),
                                          Container(height: 10),
                                          Row(
                                            children: [
                                              Container(
                                                child: Card(
                                                  elevation: 5,
                                                  shape: CircleBorder(),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Icon(
                                                      Icons.location_on_outlined,
                                                      size: 27,
                                                      color: Colors.cyan,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 30,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Address",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.grey[600],
                                                          fontSize: 12),
                                                    ),
                                                    Container(height: 1),
                                                    TextFormField(
                                                      controller: _address,
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14),
                                                      decoration:
                                                           InputDecoration
                                                              (
                                                        hintText: "Enter Address",
                                                        hintStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(height: 10),
                                          Row(
                                            children: [
                                              Container(
                                                child: Card(
                                                  elevation: 5,
                                                  shape: CircleBorder(),
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(8),
                                                    child: Icon(
                                                      Icons.currency_exchange_outlined,
                                                      size: 27,
                                                      color: Colors.cyan,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                width: 30,
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Select Currency",
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: Colors.grey[600],
                                                          fontSize: 12),
                                                    ),
                                                    Container(height: 1),
                                                    currencyModel == null ? SizedBox.shrink() : DropdownButton(
                                                isExpanded: true,

                                                      // Initial Value
                                                      value: selectedCurrency  == null || selectedCurrency == "" ? 'INR' : selectedCurrency,

                                                      // Down Arrow Icon
                                                      icon: const Icon(Icons.keyboard_arrow_down),

                                                      // Array list of items
                                                      items: currencyModel!.data!.map((items) {
                                                        return DropdownMenuItem(
                                                          value: items.name,
                                                          child: Text("${items.name   }"),
                                                        );
                                                      }).toList(),
                                                      // After selecting the desired option,it will
                                                      // change button value to selected value
                                                      onChanged: (String? newValue) {
                                                        setState(() {
                                                          selectedCurrency = newValue!;

                                                          currency = selectedCurrency! ;
                                                          print("selected currency here ${selectedCurrency}");
                                                        });
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(height: 20)
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 10, right: 15),
                            //   child: Column(
                            //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       InkWell(
                            //         onTap: () {
                            //           Navigator.push(
                            //             context,
                            //             MaterialPageRoute(
                            //                 builder: (context) =>
                            //                     BookingScreen(back: true)),
                            //           );
                            //         },
                            //         child: Container(
                            //           decoration: BoxDecoration(
                            //               shape: BoxShape.circle,
                            //               color: Colors.black45),
                            //           child: Padding(
                            //             padding: const EdgeInsets.all(8.0),
                            //             child: Icon(
                            //               Icons.format_list_bulleted_rounded,
                            //               color: appColorWhite,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       Text(
                            //         "Bookings",
                            //         style: TextStyle(
                            //             color: Colors.black45,
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 12),
                            //       ),
                            //       //Container(height: 10),
                            //       // InkWell(
                            //       //   onTap: () {
                            //       //     Navigator.push(
                            //       //       context,
                            //       //       MaterialPageRoute(
                            //       //           builder: (context) => ChangePass()),
                            //       //     );
                            //       //   },
                            //       //   child: Container(
                            //       //     decoration: BoxDecoration(
                            //       //         shape: BoxShape.circle,
                            //       //         color: Colors.black45),
                            //       //     child: Padding(
                            //       //       padding: const EdgeInsets.all(8.0),
                            //       //       child: Icon(
                            //       //         Icons.lock_open_rounded,
                            //       //         color: appColorWhite,
                            //       //       ),
                            //       //     ),
                            //       //   ),
                            //       // ),
                            //       // Text(
                            //       //   "Password",
                            //       //   style: TextStyle(
                            //       //       color: Colors.black45,
                            //       //       fontWeight: FontWeight.bold,
                            //       //       fontSize: 12),
                            //       // ),
                            //       Container(height: 10),
                            //       InkWell(
                            //         onTap: () {
                            //           Alert(
                            //             context: context,
                            //             title: "Log out",
                            //             desc: "Are you sure you want to log out?",
                            //             style: AlertStyle(
                            //                 isCloseButton: false,
                            //                 descStyle: TextStyle(
                            //                     fontFamily: "MuliRegular",
                            //                     fontSize: 15),
                            //                 titleStyle: TextStyle(
                            //                     fontFamily: "MuliRegular")),
                            //             buttons: [
                            //               DialogButton(
                            //                 child: Text(
                            //                   "OK",
                            //                   style: TextStyle(
                            //                       color: Colors.white,
                            //                       fontSize: 16,
                            //                       fontFamily: "MuliRegular"),
                            //                 ),
                            //                 onPressed: () async {
                            //                   setState(() {
                            //                     userID = '';
                            //
                            //                     userEmail = '';
                            //                     userMobile = '';
                            //                     likedProduct = [];
                            //                     likedService = [];
                            //                   });
                            //                   // signOutGoogle();
                            //                  // signOutFacebook();
                            //                   preferences!
                            //                       .remove(SharedPreferencesKey
                            //                           .LOGGED_IN_USERRDATA)
                            //                       .then((_) {
                            //                     Navigator.of(context)
                            //                         .pushAndRemoveUntil(
                            //                       MaterialPageRoute(
                            //                         builder: (context) =>
                            //                             Welcome2(),
                            //                       ),
                            //                       (Route<dynamic> route) => false,
                            //                     );
                            //                   });
                            //
                            //                   Navigator.of(context,
                            //                           rootNavigator: true)
                            //                       .pop();
                            //                 },
                            //                 color:backgroundblack,
                            //                     // Color.fromRGBO(0, 179, 134, 1.0),
                            //               ),
                            //               DialogButton(
                            //                 child: Text(
                            //                   "Cancel",
                            //                   style: TextStyle(
                            //                       color: Colors.white,
                            //                       fontSize: 16,
                            //                       fontFamily: "MuliRegular"),
                            //                 ),
                            //                 onPressed: () {
                            //                   Navigator.of(context,
                            //                           rootNavigator: true)
                            //                       .pop();
                            //                 },
                            //              color: backgroundblack,
                            //               ),
                            //             ],
                            //           ).show();
                            //         },
                            //         child: Container(
                            //           decoration: BoxDecoration(
                            //               shape: BoxShape.circle,
                            //               color: Colors.black45),
                            //           child: Padding(
                            //             padding: const EdgeInsets.all(8.0),
                            //             child: Icon(
                            //               Icons.logout,
                            //               color: appColorWhite,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //       Text(
                            //         "Logout",
                            //         style: TextStyle(
                            //             color: Colors.black45,
                            //             fontWeight: FontWeight.bold,
                            //             fontSize: 12),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),




                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 55, right: 55),
                        child: InkWell(
                          onTap: () {
                            updateAPICall();
                          },
                          child: SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: Container(
                                decoration: BoxDecoration(
                                color: backgroundblack,
                                    border: Border.all(color: Colors.grey),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                height: 50.0,
                                // ignore: deprecated_member_use
                                child: Center(
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "UPDATE",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: appColorWhite,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.blockSizeVertical! * 5,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        : Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No data found",
                style:
                    TextStyle(fontSize: SizeConfig.blockSizeHorizontal! * 6.5),
              ),
              SizedBox(
                height: SizeConfig.blockSizeVertical! * 3,
              ),
              Container(
                width: SizeConfig.blockSizeHorizontal! * 60,
                height: SizeConfig.blockSizeVertical! * 7,
                child: CupertinoButton(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => Login(),
                      ),
                    )
                  },
                  color: Color(0xFF1E3C72),
                  borderRadius: new BorderRadius.circular(30.0),
                  child: new Text(
                    "Login Now",
                    textAlign: TextAlign.center,
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: SizeConfig.blockSizeHorizontal! * 3.5),
                  ),
                ),
              ),
            ],
          ));
  }

  Widget profilePic(User user) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: <Widget>[
        userImg(user),
        InkWell(
          onTap: (){
            openImageFromCamOrGallary(context);
          },
          child: Container(
              decoration: BoxDecoration(
                color: backgroundblack,
                borderRadius: BorderRadius.circular(100)
              ),
              child: Padding(
                padding:  EdgeInsets.all(5.0),
                child: Icon(Icons.edit,color: appColorWhite,),
              )),
        )
        // editIconForPhoto(),
      ],
    );
  }

  Widget userImg(User user) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: () {
          // openImageFromCamOrGallary(context);
        },
        child: Container(
          height: 150,
          width: 150,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: imagePath == null
                ? user.profilePic != null
                    ? Image.network(
                        user.profilePic!,
                        fit: BoxFit.cover,
                        errorBuilder: (BuildContext context, Object? exception,
                            StackTrace? stackTrace) {
                          return Icon(Icons.person, size: 100);
                        },
                      )
                    : Icon(Icons.person, size: 100)
                : Image.file(imagePath!, fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget editIconForPhoto() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      padding: EdgeInsets.all(5),
      child: Container(
          child: InkWell(
        onTap: () {
          openImageFromCamOrGallary(context);
        },
        child: Image.asset('assets/images/logo.png', height: 25),
      )),
    );
  }

  void containerForSheet<T>({BuildContext? context, Widget? child}) {
    showCupertinoModalPopup<T>(
      context: context!,
      builder: (BuildContext context) => child!,
    ).then<void>((T? value) {});
  }

  openImageFromCamOrGallary(BuildContext context) {
    containerForSheet<String>(
      context: context,
      child: CupertinoActionSheet(
        actions: <Widget>[
          CupertinoActionSheetAction(
            child: Text(
              "Camera",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            onPressed: () {
              getImageFromCamera();
              Navigator.of(context, rootNavigator: true).pop("Discard");
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              "Photo & Video Library",
              style: TextStyle(color: Colors.black, fontSize: 15),
            ),
            onPressed: () {
              getImageFromGallery();
              Navigator.of(context, rootNavigator: true).pop("Discard");
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          isDefaultAction: true,
          onPressed: () {
            // Navigator.pop(context, 'Cancel');
            Navigator.of(context, rootNavigator: true).pop("Discard");
          },
        ),
      ),
    );
  }

  // Future getImageFromCamera() async {
  //   // ignore: deprecated_member_use
  //   final ImagePicker _picker = ImagePicker();
  //   XFile? image = await _picker.pickImage(
  //       source: ImageSource.camera, imageQuality: 30);
  //        setState(() {
  //          imagePath = image as File;
  //   });
  // }

  Future<void> getImageFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,maxHeight: 400,maxWidth: 400
    );
    if (pickedFile != null) {
      setState(() {
        imagePath =  File(pickedFile.path);
        // imagePath = File(pickedFile.path) ;
        // filePath = imagePath!.path.toString();
      });
    }
  }

  // Future getImageFromGallery() async {
  //   // ignore: deprecated_member_use
  //   final ImagePicker _picker = ImagePicker();
  //   File image = (await _picker.pickImage(
  //       source: ImageSource.gallery, imageQuality: 30)) as File;
  //   setState(() {
  //     selectedImage = image;
  //   });
  // }
  Future<void> getImageFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        imagePath =  File(pickedFile.path);
        // imagePath = File(pickedFile.path) ;
        // filePath = imagePath!.path.toString();
      });
    }
  }


     updateAPICall() async {
    closeKeyboard();
    UpdatePro editProfileModal;

    setState(() {
      isLoad = true;
    });

    var uri = Uri.parse('${baseUrl()}/user_edit');
    var request = new http.MultipartRequest("POST", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    print(uri.toString());

    request.headers.addAll(headers);
    request.fields['email'] = model!.user!.email.toString();
    request.fields['username'] = _username.text + ' '+ _lastName.text;
    request.fields['mobile'] = _mobile.text;
    request.fields['address'] = _address.text;
    request.fields['city'] = model!.user!.city.toString();
    request.fields['country'] = model!.user!.country.toString();
    request.fields['id'] = userID;
    request.fields['country_code'] = "+${phoneCode}";
    request.fields['currency'] = "${selectedCurrency}";
    print(request.fields.toString());

    if (imagePath != null) {
      request.files.add(
          await http.MultipartFile.fromPath('profile_pic', imagePath!.path));
    }
    var response = await request.send();

    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);
    editProfileModal = UpdatePro.fromJson(userData);

    if (editProfileModal.responseCode == "1") {
      setState(() {
        isLoad = false;
      });

      Flushbar(
        title: "Success",
        message: editProfileModal.message,
        duration: Duration(seconds: 3),
        icon: Icon(
          Icons.done,
          color: appColorOrange,
          size: 35,
        ),
      )..show(context);
      Navigator.push(context, MaterialPageRoute(builder: (context) => TabbarScreen()));
    } else {
      setState(() {
        isLoad = false;
      });
      Flushbar(
        title: "Error",
        message: editProfileModal.message,
        duration: Duration(seconds: 3),
        icon: Icon(
          Icons.error,
          color: Colors.red,
        ),
      )..show(context);
    }
  }
}
