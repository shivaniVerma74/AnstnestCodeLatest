import 'dart:convert';
import 'dart:io';
import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:ez/screens/view/models/DestinationModel.dart';
import 'package:ez/screens/view/models/allKey_modal.dart';
import 'package:ez/screens/view/models/allProduct_modal.dart';
import 'package:ez/screens/view/models/bannerModal.dart';
import 'package:ez/screens/view/models/categories_model.dart';
import 'package:ez/screens/view/models/getCart_modal.dart';
import 'package:ez/screens/view/models/getServiceWishList_modal.dart';
import 'package:ez/screens/view/models/getWishList_modal.dart';
import 'package:ez/screens/view/models/likeService_modal.dart';
import 'package:ez/screens/view/models/unLikeService_modal.dart';
import 'package:ez/screens/view/newUI/DestinationDetails.dart';
import 'package:ez/screens/view/newUI/MyRequestPage.dart';
import 'package:ez/screens/view/newUI/MyWallet.dart';
import 'package:ez/screens/view/newUI/RequestService.dart';
import 'package:ez/screens/view/newUI/Testing.dart';
import 'package:ez/screens/view/newUI/allServices.dart';
import 'package:ez/screens/view/newUI/cart.dart';
import 'package:ez/screens/view/newUI/chat/CustomerSupport/customer_support_faq.dart';
import 'package:ez/screens/view/newUI/contactPage.dart';
import 'package:ez/screens/view/newUI/fb_sign_in.dart';
import 'package:ez/screens/view/newUI/google_sign_in.dart';
import 'package:ez/screens/view/newUI/notificationScreen.dart';
import 'package:ez/screens/view/newUI/privacy_policy.dart';
import 'package:ez/screens/view/newUI/productDetails.dart';
import 'package:ez/screens/view/newUI/searchProduct.dart';
import 'package:ez/screens/view/newUI/serviceScreenNew.dart';
import 'package:ez/screens/view/newUI/sub_category.dart';
import 'package:ez/screens/view/newUI/terms_condition.dart';
import 'package:ez/screens/view/newUI/welcome2.dart';
import 'package:ez/screens/view/newUI/wishList.dart';
import 'package:fancy_drawer/fancy_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ez/constant/global.dart';
import 'package:ez/constant/sizeconfig.dart';
import 'package:ez/screens/view/newUI/detail.dart';
import 'package:ez/screens/view/models/catModel.dart';
import 'package:ez/screens/view/newUI/viewCategory.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:permission_handler/permission_handler.dart';

// import 'package:geolocator/geolocator.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:ez/screens/view/newUI/newTabbar.dart';
import 'package:ez/screens/view/newUI/profile.dart';
import 'package:ez/share_preference/preferencesKey.dart';

import '../../chat_page.dart';
import '../models/getUserModel.dart';
import 'AboutUs.dart';
import 'AllDestinationService.dart';
import 'Chat_Screen.dart';
import 'booking.dart';
import 'chat/CustomerSupport/chat_page.dart';
import 'faq_screen.dart';
import 'login.dart';

class HomeScreen extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

var homelat;
var homeLong;

class _DiscoverState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  var orientation;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  CatModal? sortingModel;
  BannerModal? bannerModal;
  AllCateModel? collectionModal;
  FancyDrawerController? _controller;
  AllProductModal? allProduct;
  GetCartModal? getCartModal;
  GetWishListModal? getWishListModal;
  Position? currentLocation;
  GeeUserModel? model;
  final Geolocator geolocator = Geolocator();
  String? _currentAddress;

  @override
  void initState() {
    //getUserCurrentLocation();
    refreshFunction();
    // _getAddressFromLatLng();
    getDestination();
    Future.delayed(Duration(milliseconds: 200), () {
      return getUserDataApicalls();
    });
    Future.delayed(Duration(milliseconds: 350), () {
      return getUserDataFromPrefs();
    });
    _controller = FancyDrawerController(
        vsync: this, duration: Duration(milliseconds: 250))
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  Future getUserCurrentLocation() async {
    //LocationPermission permission;
    // permission = await Geolocator.requestPermission();
    //var paermissionIs = await Geolocator.checkPermission();
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
    print(statuses[Permission.location]);
    if (PermissionStatus.denied ==
        statuses[Permission
            .location]) /*if(paermissionIs == LocationPermission.denied)*/ {
    } else if (PermissionStatus.permanentlyDenied ==
        statuses[Permission.location]) {
      openAppSettings();
    } else {
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((position) {
        setState(() {
          currentLocation = position;
          homelat = currentLocation!.latitude;
          homeLong = currentLocation!.longitude;
        });
      });
    }

    //_getAddressFromLatLng();
  }

  _getAddressFromLatLng() async {
    getUserCurrentLocation().then((_) async {
      try {
        List<Placemark> p = await placemarkFromCoordinates(
            currentLocation!.latitude, currentLocation!.longitude);

        Placemark place = p[0];

        setState(() {
          _currentAddress =
              "${place.street}, ${place.subLocality}, ${place.locality}, ${place.country}";
          //"${place.name}, ${place.locality},${place.administrativeArea},${place.country}";
          print(_currentAddress);
        });
      } catch (e) {
        print(e);
      }
    });
  }

  getUserDataFromPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userDataStr =
        preferences.getString(SharedPreferencesKey.LOGGED_IN_USERRDATA);
    Map<String, dynamic> userData = json.decode(userDataStr!);
    print(userData);
    setState(() {
      userID = userData['user_id'];
    });
    _getAllKey();
    _getBanners();
    _getCollection();
    sortingApiCall();

    Future.delayed(Duration(seconds: 5), () {
      _getAllProduct();
    });

    _getCart();
    _getWishList();
    getUserDataApicall();
    _getServiceWishList();
  }

  _getAllKey() async {
    AllKeyModal allKeyModal;
    var uri = Uri.parse('${baseUrl()}/general_setting');
    var request = new http.MultipartRequest("GET", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    // request.fields['vendor_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    if (mounted) {
      setState(() {
        allKeyModal = AllKeyModal.fromJson(userData);
        if (allKeyModal != null) {
          stripSecret = allKeyModal.setting!.sSecretKey!;
          stripPublic = allKeyModal.setting!.sPublicKey!;
          rozSecret = allKeyModal.setting!.rSecretKey!;
          rozPublic = allKeyModal.setting!.rPublicKey!;
        }
      });
    }

    print(responseData);
  }

  sortingApiCall() async {
    // if (mounted)
    //   setState(() {
    //     isLoading = true;
    //   });

    //  try {
    Map<String, String> headers = {
      'content-type': 'application/x-www-form-urlencoded',
    };

    final response = await client.post(
      Uri.parse(
        "${baseUrl()}/get_all_cat_nvip_sorting",
      ),
      body: {
        "currency": selectedCurrency.toString(),
      },
      headers: headers,
    );
    print("body now here $selectedCurrency");
    print(
        'checking new ai data here now ${baseUrl()}/get_all_cat_nvip_sorting');
    var dic = json.decode(response.body);
    Map<String, dynamic> userMap = jsonDecode(response.body);
    sortingModel = CatModal.fromJson(userMap);
    print(dic);
    if (mounted)
      setState(() {
        isLoading = false;
      });
    // } on Exception {
    //   if (mounted)
    //     setState(() {
    //       isLoading = false;
    //     });
    //   Fluttertoast.showToast(msg: "No Internet connection");
    //   // Toast.show("No Internet connection", context,
    //   //     duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    //
    //   throw Exception('No Internet connection');
    // }
  }

  _getBanners() async {
    var uri = Uri.parse('${baseUrl()}/get_all_banners');
    var request = new http.MultipartRequest("GET", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    // request.fields['vendor_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    if (mounted) {
      setState(() {
        bannerModal = BannerModal.fromJson(userData);
      });
    }

    print(responseData);
  }

  _getCollection() async {
    var uri = Uri.parse('${baseUrl()}/get_all_cat');
    var request = new http.MultipartRequest("GET", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    print("checking paramter with api ${baseUrl()}/get_all_cat");

    request.headers.addAll(headers);
    // request.fields['vendor_id'] = userID;
    var response = await request.send();
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    if (mounted) {
      setState(() {
        collectionModal = AllCateModel.fromJson(userData);
      });
    }
    print(responseData);
  }

  _getAllProduct() async {
    var uri = Uri.parse('${baseUrl()}/service_providers');
    var request = new http.MultipartRequest("POST", uri);
    request.fields.addAll({
      'lat': '${currentLocation!.latitude}',
      'long': '${currentLocation!.longitude}'
    });

    var response = await request.send();
    print(request);
    print(request.fields);
    print(response.statusCode);
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    if (mounted) {
      setState(() {
        allProduct = AllProductModal.fromJson(userData);
      });
    }

    print(responseData);
  }

  String selectedCurrency = '';

  getUserDataApicalls() async {
    setState(() {
      isLoading = true;
    });

    try {
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
      setState(() {
        selectedCurrency = model!.user!.currency.toString();
      });
      print("checking selected currency ${selectedCurrency}");
      currency = selectedCurrency;
      sortingApiCall();
      // _username.text = model!.user!.username!;
      // _mobile.text = model!.user!.mobile!;
      // _address.text = model!.user!.address ?? "";
      // phoneCode = model!.user!.c
      print("GetUserData>>>>>>");
      print(dic);
      setState(() {
        isLoading = false;
      });
    } on Exception {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "No Internet connection");
      throw Exception('No Internet connection');
    }
  }

  _getCart() async {
    setState(() {
      isLoading = true;
    });

    var uri = Uri.parse('${baseUrl()}/get_cart_items');
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
        getCartModal = GetCartModal.fromJson(userData);
        isLoading = false;
      });
    }
  }

  _getWishList() async {
    var uri = Uri.parse('${baseUrl()}/wishlist');
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
        likedProduct.clear();
        getWishListModal = GetWishListModal.fromJson(userData);
        for (var i = 0; i < getWishListModal!.wishlist!.length; i++) {
          likedProduct.add(getWishListModal!.wishlist![i].proId.toString());
        }
      });
    }
  }

  _getServiceWishList() async {
    GetServiceWishListModal getServiceWishListModal;
    var uri = Uri.parse('${baseUrl()}/service_wishlist');
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
        likedService.clear();
        getServiceWishListModal = GetServiceWishListModal.fromJson(userData);
        for (var i = 0; i < getServiceWishListModal.wishlist!.length; i++) {
          likedService
              .add(getServiceWishListModal.wishlist![i].resId.toString());
        }
      });
    }
  }

  getUserDataApicall() async {
    setState(() {
      isLoading = true;
    });

    try {
      Map<String, String> headers = {
        'content-type': 'application/x-www-form-urlencoded',
      };
      var map = new Map<String, dynamic>();
      map['user_id'] = userID;

      final response = await client.post(Uri.parse("${baseUrl()}/user_data"),
          headers: headers, body: map);
      print("sddddddd ${map} sdsd ${baseUrl()}/user_data");
      var dic = json.decode(response.body);
      Map<String, dynamic> userMap = jsonDecode(response.body);
      model = GeeUserModel.fromJson(userMap);

      userEmail = model!.user!.email!;
      userMobile = model!.user!.mobile!;
      userName = model!.user!.username!;
      userPic = model!.user!.profilePic!;
      // _username.text = model!.user!.username!;
      // _mobile.text = model!.user!.mobile!;
      // _address.text = model!.user!.address!;
      print("GetUserData>>>>>>");
      print(dic);

      setState(() {
        isLoading = false;
      });
    } on Exception {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "No Internet connection");
      throw Exception('No Internet connection');
    }
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

  Future<Null> refreshFunction() async {
    await _getAddressFromLatLng();
    await getUserCurrentLocation();
    await getUserDataFromPrefs();
    await getDestination();
    await getUserDataApicalls();
    _getData2();
    _getChatCount();
  }

  // getCurrentLocationCard(){
  //   return InkWell(
  //       onTap: (){
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //             builder: (context) => PlacePicker(
  //               apiKey: Platform.isAndroid
  //                   ? "AIzaSyDPsdTq-a4AHYHSNvQsdAlZgWvRu11T9pM"
  //                   : "AIzaSyDPsdTq-a4AHYHSNvQsdAlZgWvRu11T9pM",
  //               onPlacePicked: (result) {
  //                 print(result.formattedAddress);
  //                 setState(() {
  //                   _currentAddress = result.formattedAddress.toString();
  //                   homelat = result.geometry!.location.lat;
  //                   homeLong = result.geometry!.location.lng;
  //                 });
  //                 Navigator.of(context).pop();
  //                 // distnce();
  //               },
  //               initialPosition: LatLng(currentLocation!.latitude, currentLocation!.longitude),
  //               // useCurrentLocation: true,
  //             ),
  //           ),
  //         );
  //         //showPlacePicker();
  //       },
  //       child: Row(
  //         children: [
  //           Icon(Icons.location_on_outlined,color: colors.primary,),
  //           Container(
  //             width: 150,
  //             child: Text(
  //               _currentAddress != null
  //                   ? _currentAddress!
  //                   : "please wait..",overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,maxLines: 1,
  //               style: const TextStyle(
  //                   fontWeight: FontWeight.w500,
  //                   color: colors.blackTemp,
  //                   fontSize: 15, overflow: TextOverflow.ellipsis
  //               ),
  //             ),
  //           ),
  //         ],
  //       )
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    /*return FancyDrawerWrapper(
      backgroundColor: Colors.white,
      controller: _controller,
      drawerItems: <Widget>[
        applogo(),
        Container(height: 30),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TabbarScreen()),
            );
          },
          child: Row(
            children: [
              Icon(
                Icons.home,
                color: Colors.black45,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Home",
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal! * 5,
                      fontFamily: 'OpenSans',
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StoreScreenNew(back: true)),
            );
          },
          child: Row(
            children: [
              Icon(
                Icons.shopping_bag,
                color: Colors.black45,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Services",
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal! * 5,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WishListScreen(back: true)),
            );
          },
          child: Row(
            children: [
              Icon(
                Icons.favorite,
                color: Colors.black45,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Wish List",
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal! * 5,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Profile(back: true)),
            );
          },
          child: Row(
            children: [
              Icon(
                Icons.person,
                color: Colors.black45,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Profile",
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal! * 5,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NotificationList()),
            );
          },
          child: Row(
            children: [
              Icon(
                Icons.notifications,
                color: Colors.black45,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Notification",
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal! * 5,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        InkWell(
          onTap: () {
            Alert(
              context: context,
              title: "Log out",
              desc: "Are you sure you want to log out?",
              style: AlertStyle(
                  isCloseButton: false,
                  descStyle: TextStyle(fontFamily: "MuliRegular", fontSize: 15),
                  titleStyle: TextStyle(fontFamily: "MuliRegular")),
              buttons: [
                DialogButton(
                  child: Text(
                    "OK",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "MuliRegular"),
                  ),
                  onPressed: () async {
                    setState(() {
                      userID = '';

                      userEmail = '';
                      userMobile = '';
                      likedProduct = [];
                      likedService = [];
                    });
                   // signOutGoogle();
                    //signOutFacebook();
                    preferences!
                        .remove(SharedPreferencesKey.LOGGED_IN_USERRDATA)
                        .then((_) {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => Welcome2(),
                        ),
                        (Route<dynamic> route) => false,
                      );
                    });

                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  color: Color.fromRGBO(0, 179, 134, 1.0),
                ),
                DialogButton(
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "MuliRegular"),
                  ),
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  gradient: LinearGradient(colors: [
                    Color.fromRGBO(116, 116, 191, 1.0),
                    Color.fromRGBO(52, 138, 199, 1.0)
                  ]),
                ),
              ],
            ).show();
          },
          child: Row(
            children: [
              Icon(
                Icons.settings_power,
                color: Colors.red,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Logout",
                  style: TextStyle(
                      fontSize: SizeConfig.blockSizeHorizontal! * 5,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontStyle: FontStyle.italic)),
            ],
          ),
        ),
        Container(height: 100),
      ],
      child: */
    print("notification ${notificationCount}");
    print("notification ${notificationCount.runtimeType}");
    return Scaffold(
      backgroundColor: appColorWhite,
      appBar: AppBar(
        backgroundColor: primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20)),
        ),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Image.asset('assets/images/home_one.png', height: 90),
        )
        /*Text(appName,
            style: TextStyle(
                color: backgroundgrey,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                fontStyle: FontStyle.italic))*/
        ,
        centerTitle: false,
        actions: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.grey[100],
            child: IconButton(
              icon: Icon(
                Icons.search,
                color: appColorBlack,
                size: 20,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchProduct()),
                );
              },
            ),
          ),
          Container(width: 10),
          // Stack(
          //   alignment: AlignmentDirectional.centerEnd,
          //   fit: StackFit.loose,
          //   children: [
          //     CircleAvatar(
          //       radius: 22,
          //       backgroundColor: Colors.grey[100],
          //       child: Padding(
          //         padding: const EdgeInsets.all(8.0),
          //         child: InkWell(
          //           onTap: () {
          //             Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                 builder: (context) => GetCartScreeen(),
          //               ),
          //             );
          //           },
          //           child: Stack(
          //             alignment: AlignmentDirectional.centerEnd,
          //             fit: StackFit.loose,
          //             children: <Widget>[
          //               Icon(
          //                 Icons.shopping_cart_outlined,
          //                 color: appColorBlack,
          //                 size: 25,
          //               ),
          //             ],
          //           ),
          //         ),
          //       ),
          //     ),
          //     isLoading
          //         ? Container(
          //             height: 10,
          //             width: 10,
          //             child: Center(
          //                 child: CircularProgressIndicator(
          //               strokeWidth: 3,
          //               valueColor:
          //                   new AlwaysStoppedAnimation<Color>(Colors.black),
          //             )))
          //         : getCartModal != null
          //             ? Padding(
          //                 padding: EdgeInsets.only(top: 18, left: 20),
          //                 child: Container(
          //                   decoration: BoxDecoration(
          //                     color: Colors.black,
          //                     shape: BoxShape.circle,
          //                   ),
          //                   child: Center(
          //                     child: Padding(
          //                       padding: const EdgeInsets.all(3),
          //                       child: Text(
          //                         getCartModal!.totalItems == null
          //                             ? '0'
          //                             : getCartModal!.totalItems.toString(),
          //                         textAlign: TextAlign.center,
          //                         style: Theme.of(context)
          //                             .textTheme
          //                             .caption!
          //                             .merge(
          //                               TextStyle(
          //                                 color: Colors.white,
          //                                 fontSize: 10,
          //                               ),
          //                             ),
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               )
          //             : Container()
          //   ],
          // ),
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey[100],
                child: IconButton(
                  icon: Icon(
                    Icons.chat_outlined,
                    color: appColorBlack,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookingScreen(),
                      ),
                    );
                  },
                ),
              ),
              chatCount=='0' || chatCount==null || chatCount == "null" ? SizedBox() :  Positioned(
                  top: 5,
                  right: 0,
                  child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(shape: BoxShape.circle, color: primary),
                      child: Text('${chatCount}', style: TextStyle(color: Colors.white, fontSize: 14),)))
            ],
          ),
          Container(width: 10),
          Stack(
            alignment: Alignment.center,
            children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[100],
              child: IconButton(
                icon: Icon(
                  Icons.notifications,
                  color: appColorBlack,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationList()),
                  );
                },
              ),
            ),
              notificationCount== '0' || notificationCount ==null || notificationCount =="null" ? SizedBox() : Positioned(
                top: 7,
                right: 0,
                child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(shape: BoxShape.circle, color: primary),
                    child: Text('$notificationCount', style: TextStyle(color: Colors.white, fontSize: 14),))),
             ],
          ),
          Container(width: 10),
        ],
      ),
      drawer: getDrawer(),
      body: RefreshIndicator(
        onRefresh: refreshFunction,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: <Widget>[
              Container(
                height: 9,
              ),
              servicesWidget(),
              Container(height: 10),
              collectionWidget(),
              Container(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Destination",
                          style: TextStyle(
                              color: appColorBlack,
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 7),
                          child: MaterialButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AllDestination(),
                                ),
                              );
                            },
                            child: Text(
                              "View All",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                            color: primary,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    destinationModel == null || destinationModel!.data!.isEmpty
                        ? Container(
                            child: Center(
                              child: Text("No destination to show"),
                            ),
                          )
                        : Container(
                            height: 210,
                            padding: EdgeInsets.symmetric(vertical: 8),
                            color: backgroundgrey,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                itemCount: destinationModel!.data!.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (c, i) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DestinationDetails(
                                                      Details: destinationModel!
                                                          .data![i])));
                                    },
                                    child: Container(
                                      width: 150,
                                      margin: EdgeInsets.only(right: 10),
                                      child: Card(
                                        color: appColorWhite,
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        borderOnForeground: false,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 100,
                                              width: 150,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(8),
                                                    topRight:
                                                        Radius.circular(8)),
                                                child: Image.network(
                                                  "${destinationModel!.data![i].image}",
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: Text(
                                                "${destinationModel!.data![i].name}",
                                                style: TextStyle(
                                                    color: appColorBlack,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                                maxLines: 1,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 5),
                                              child: Text(
                                                "${destinationModel!.data![i].description}",
                                                style: TextStyle(
                                                  height: 1,
                                                  color: appColorBlack
                                                      .withOpacity(0.5),
                                                  fontSize: 13,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Divider(
                                              height: 1,
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(left: 5),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "View More",
                                                    style: TextStyle(
                                                        color: primary,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 13),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_rounded,
                                                    color: primary,
                                                    size: 20,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                  ],
                ),
              ),
              Container(height: 20),
              //bestSellerWidget(),
              Container(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// new test function
String? notificationCount ;
String? chatCount ;
  getcheckStoreData() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("User Name"),
              Text("Rahul"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Address"), Text('Vijay nagar indore')],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Email"), Text("shivam@gmail.com")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Mobile Number"),
              Text("9926633442"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Profile Url"),
              Text("https://shivamkanathe.myprofile.com"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text("Status"), Text("Active")],
          ),
          Row(
            children: [
              Text("Aadhar Number"),
              Text("51256425635115"),
            ],
          ),
          Row(
            children: [
              Text("Pan Number"),
              Text("52ddw5253d2"),
            ],
          ),
          ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              reverse: true,
              scrollDirection: Axis.vertical,
              clipBehavior: Clip.hardEdge,
              itemBuilder: (c, i) {
                return Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 55,
                      width: 66,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            "https://naturepicture/worker-hard/beautify.com",
                            fit: BoxFit.cover,
                          )),
                    ),
                    Expanded(child: Text("Photographers"))
                  ],
                ));
              }),
          Text("Top Categories"),
          ListView.builder(
              itemCount: 10,
              scrollDirection: Axis.horizontal,
              physics: AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (c, i) {
                return Container(
                  child: Row(
                    children: [
                      Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100)),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.network(
                              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQe7K80SuPp6E0dfR6MJtPUdDax6B5afgiRqA&usqp=CAU",
                              fit: BoxFit.cover,
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width / 1.5,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white),
                        child: Center(
                          child: Text(
                            "Wedding",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),
          Text("Sub Categories"),
          ListView.builder(
              itemCount: 6,
              shrinkWrap: true,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (c, i) {
                return Container(
                  child: Text("Wedding"),
                );
              })
        ],
      ),
    );
  }

  _getData2() async {
    var uri = Uri.parse('${baseUrl()}/booking_notification_listing');

    var request = new http.MultipartRequest("Post", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);
    request.fields.addAll({'user_id': userID});
    request.fields['user_id'] = userID;
    print("checking rrequest here ${uri} and ${request.fields}");
    var response = await request.send();
    print("booking listing here ${response.statusCode}");
    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    notificationCount = userData['total'].toString();

    if (mounted) {
      setState(() {
       // bookingNotificationModal = BookingNotificationModal.fromJson(userData);
        // print("notification list is here ${bookingNotificationModal!.notifications!.length}");
      });
    }
  }

  _getChatCount() async {

    var uri = Uri.parse('${baseUrl()}/get_chatlists');

    var request = new http.MultipartRequest("Post", uri);
    Map<String, String> headers = {
      "Accept": "application/json",
    };
    request.headers.addAll(headers);

    //request.fields['user_id'] = userID;
    //request.fields['type'] = 'user';
    request.fields.addAll({'user_id': userID, 'type': 'user'});

    print(request);
    print(uri);

    var response = await request.send();

    String responseData = await response.stream.transform(utf8.decoder).join();
    var userData = json.decode(responseData);

    chatCount = userData['count'].toString();

    if (mounted) {
      setState(() {
        // bookingNotificationModal = BookingNotificationModal.fromJson(userData);
        // print("notification list is here ${bookingNotificationModal!.notifications!.length}");
      });
    }
  }


  getDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.all(0),
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: primary,
            ), //BoxDecoration
            child: Row(
              children: [
                SizedBox(
                  height: 20,
                ),
                userPic == null || userPic == ""
                    ? CircleAvatar(
                        backgroundColor: appColorWhite,
                        radius: 40,
                        child: Image.asset("assets/images/standinggirl.jpg"))
                    : CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(userPic),
                      ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "$userName",
                        style: TextStyle(fontSize: 18, color: appColorWhite),
                      ),
                      Text(
                        "$userEmail",
                        style: TextStyle(color: appColorWhite),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //DrawerHeader
          ListTile(
            leading: const Icon(
              Icons.home,
              color: primary,
            ),
            title: const Text(' Home '),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TabbarScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.chat,
              color: primary,
            ),
            title: const Text('Chats'),
            onTap: () {
              Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => ChatPage( chatId: "1", title: "Karan")),
                MaterialPageRoute(builder: (context) => BookingScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.support_agent,
              color: primary,
            ),
            title: const Text('Support Chat'),
            onTap: () {
              Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => ChatPage( chatId: "1", title: "Karan")),
                MaterialPageRoute(builder: (context) => CustomerSupport()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: primary,
            ),
            title: const Text('Post Your Requirement'),
            onTap: () {
              Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => ChatPage( chatId: "1", title: "Karan")),
                MaterialPageRoute(builder: (context) => RequestService()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.wallet,
              color: primary,
            ),
            title: const Text('Wallet'),
            onTap: () {
              Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => ChatPage( chatId: "1", title: "Karan")),
                MaterialPageRoute(builder: (context) => MyWallet()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.request_page,
              color: primary,
            ),
            title: const Text('My Post Requirement'),
            onTap: () {
              Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => ChatPage( chatId: "1", title: "Karan")),
                MaterialPageRoute(builder: (context) => MyRequestPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.favorite,
              color: primary,
            ),
            title: const Text('Wishlist'),
            onTap: () {
              Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => ChatPage( chatId: "1", title: "Karan")),
                MaterialPageRoute(
                    builder: (context) => WishListScreen(back: true)),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.privacy_tip_rounded,
              color: primary,
            ),
            title: const Text(' Privacy Policy '),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PrivacyPolicyScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.call,
              color: primary,
            ),
            title: const Text('Contact Us'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactUsPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.list_alt,
              color: primary,
            ),
            title: const Text('Terms & Condition'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TermsConditionScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.list_alt,
              color: primary,
            ),
            title: const Text('About Us'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutUs()),
              );
            },
          ),

          /// Only for Testing
          // ListTile(
          //   leading: const Icon(Icons.list_alt, color: backgroundblack,),
          //   title: const Text(' Testing '),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => HomePage()),
          //     );
          //   },
          // ),
          ListTile(
            leading: const Icon(
              Icons.question_answer,
              color: primary,
            ),
            title: const Text(' FAQ '),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FaqScreen()),
              );
            },
          ),

          ListTile(
            leading: const Icon(
              Icons.logout,
              color: primary,
            ),
            title: const Text('LogOut'),
            onTap: () {
              Alert(
                context: context,
                title: "Log out",
                desc: "Are you sure you want to log out?",
                style: AlertStyle(
                  isCloseButton: false,
                  descStyle: TextStyle(fontFamily: "MuliRegular", fontSize: 15),
                  titleStyle: TextStyle(fontFamily: "MuliRegular"),
                ),
                buttons: [
                  DialogButton(
                    child: Text(
                      "OK",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "MuliRegular"),
                    ),
                    onPressed: () async {
                      setState(() {
                        userID = '';
                        userEmail = '';
                        userMobile = '';
                        likedProduct = [];
                        likedService = [];
                      });
                      // signOutGoogle();
                      //signOutFacebook();
                      preferences!
                          .remove(SharedPreferencesKey.LOGGED_IN_USERRDATA)
                          .then((_) {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => Login(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      });
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    color: primary,
                    // color: Color.fromRGBO(0, 179, 134, 1.0),
                  ),
                  DialogButton(
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: "MuliRegular"),
                    ),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                    color: primary,
                    // gradient: LinearGradient(colors: [
                    //   Color.fromRGBO(116, 116, 191, 1.0),
                    //   Color.fromRGBO(52, 138, 199, 1.0)
                    // ]),
                  ),
                ],
              ).show();
            },
          ),
        ],
      ),
    );
  }

  Widget applogo() {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 50,
        ),
        SizedBox(
          height: 10,
        ),
        Text(appName,
            style: TextStyle(
                color: appColorBlack,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'OpenSans',
                fontStyle: FontStyle.italic)),
        SizedBox(
          height: 5,
        ),
        Text('Your Hygiene App',
            style: TextStyle(
              color: appColorBlack,
              fontSize: 12,
            )),
      ],
    );
  }

  Widget servicesWidget() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
            color: appColorWhite,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 1,
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PlacePicker(
                    apiKey: Platform.isAndroid
                        ? "AIzaSyB_R73InTM8ee1c57EiJhpkYRqoq3nF_Gc"
                        : "AIzaSyB_R73InTM8ee1c57EiJhpkYRqoq3nF_Gc",
                    onPlacePicked: (result) {
                      print(result.formattedAddress);
                      setState(() {
                        _currentAddress = result.formattedAddress.toString();
                        homelat = result.geometry!.location.lat;
                        homeLong = result.geometry!.location.lng;
                      });
                      Navigator.of(context).pop();
                      // distnce();
                    },
                    initialPosition: LatLng(
                        currentLocation!.latitude, currentLocation!.longitude),
                    // useCurrentLocation: true,
                  ),
                ),
              );
            },
            child: Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: appColorOrange,
                  size: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 1.65,
                    child: Text(
                      _currentAddress != null
                          ? _currentAddress!
                          : "please wait..",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                          fontSize: 12),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      // MaterialPageRoute(builder: (context) => ChatPage( chatId: "1", title: "Karan")),
                      MaterialPageRoute(builder: (context) => MyWallet()),
                    );
                  },
                  child: Icon(
                    Icons.wallet,
                    color: primary,
                    size: 20,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      // MaterialPageRoute(builder: (context) => ChatPage( chatId: "1", title: "Karan")),
                      MaterialPageRoute(builder: (context) => RequestService()),
                    );
                  },
                  child: Icon(
                    Icons.add,
                    color: primary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(height: 10),
        _banner(context),
        Container(height: 10),
        Container(
          color: backgroundgrey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Services",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AllServices()));
                        },
                        child: Text("View All Services",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                        color: primary,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Looking for a service? Find your Antsnest here:",
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                // Container(height: 10),
                Container(height: 330, child: serviceWidget()),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget serviceWidget() {
    return sortingModel == null
        ? Center(
            child: Image.asset("assets/images/loader1.gif"),
          )
        : sortingModel!.restaurants!.length > 0
            ? ListView.builder(
                padding: EdgeInsets.only(
                  bottom: 10,
                  //top: 10,
                ),
                itemCount: sortingModel!.restaurants!.length > 5
                    ? 5
                    : sortingModel!.restaurants!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (
                  context,
                  int index,
                ) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailScreen(
                                  resId:
                                      sortingModel!.restaurants![index].resId,
                                )),
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Container(
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 110,
                                  width: 200,
                                  child: Stack(
                                    children: [
                                      Carousel(
                                        images: sortingModel!
                                            .restaurants![index].logo!
                                            .map((it) {
                                          return Container(
                                            height: 110,
                                            width: 170,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(8),
                                                  topRight: Radius.circular(8)),
                                              child: CachedNetworkImage(
                                                imageUrl: it,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child: Container(
                                                      height: 110,
                                                      width: 100,
                                                      // margin: EdgeInsets.all(70.0),
                                                      child: Image.asset(
                                                        "assets/images/loader1.gif",
                                                        height: 30,
                                                        width: 30,
                                                      )
                                                      //     CircularProgressIndicator(
                                                      //   strokeWidth: 2.0,
                                                      //   valueColor:
                                                      //       new AlwaysStoppedAnimation<
                                                      //           Color>(appColorGreen),
                                                      // ),
                                                      ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        showIndicator: true,
                                        dotBgColor: Colors.transparent,
                                        borderRadius: false,
                                        autoplay: false,
                                        dotSize: 4.0,
                                        dotSpacing: 15.0,
                                      ),
                                      sortingModel!.restaurants![index]
                                                  .is_recommended ==
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
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Container(
                                          width: 40,
                                          child: likedService.contains(
                                                  sortingModel!
                                                      .restaurants![index]
                                                      .resId)
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
                                                          sortingModel!
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
                                                          sortingModel!
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
                                ),
                                // Container(
                                //   height: 100,
                                //    width: 170,
                                //   decoration: BoxDecoration(
                                //     color: Colors.black45,
                                //     borderRadius: BorderRadius.circular(10),
                                //   ),
                                //   child: ClipRRect(
                                //     borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                                //     child: Image.network("${sortingModel!
                                //         .restaurants![index].logo![0] }",fit: BoxFit.fill,),
                                //   )
                                // ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10.0, top: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                        BorderRadius.circular(
                                                            20),
                                                    child: Image.network(
                                                        sortingModel!
                                                                .restaurants![
                                                                    index]
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
                                                        decoration:
                                                            BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: Colors
                                                                    .grey
                                                                    .shade300
                                                                    .withOpacity(
                                                                        0.9)),
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
                                  padding: EdgeInsets.only(
                                      left: 10, top: 5, right: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        // width:
                                        //     MediaQuery.of(context).size.width /
                                        //         2.7,
                                        child: Text(
                                          sortingModel!.restaurants![index]
                                                  .resName![0]
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
                                  padding: EdgeInsets.only(
                                      left: 10, right: 5, bottom: 5),
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
                                  padding: EdgeInsets.only(
                                      left: 5, right: 5, bottom: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                size: 15,
                                              ),
                                              SizedBox(
                                                width: 1,
                                              ),
                                              Text(
                                                "${sortingModel!.restaurants![index].cityName}",
                                                style: TextStyle(
                                                    color: appColorBlack,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 30),
                                          RatingBar.builder(
                                            initialRating: sortingModel!.restaurants![index].resRating == "" ? 0.0
                                                : double.parse(sortingModel!.restaurants![index].resRating.toString()),
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
                                                      .restaurants![index]
                                                      .price!,
                                              style: TextStyle(
                                                  color: appColorBlack,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
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
                                                              .restaurants![
                                                                  index]
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
                                                          BorderRadius.circular(
                                                              5),
                                                      border: Border.all(
                                                          color:
                                                              primary)),
                                                  child: Text(
                                                    "Book Service",
                                                    style: TextStyle(
                                                        color: primary,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          DetailScreen(
                                                            resId: sortingModel!
                                                                .restaurants![
                                                                    index]
                                                                .resId,
                                                          )),
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
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ],
                                              ))
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
                      // Stack(
                      //    alignment: Alignment.topCenter,
                      //   children: [
                      //     Padding(
                      //       padding: const EdgeInsets.only(top: 30),
                      //       child: Card(
                      //         elevation: 5,
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(20),
                      //         ),
                      //         child: Container(
                      //           width: 170,
                      //           child: Padding(
                      //             padding:  EdgeInsets.only(
                      //                 bottom: 15, left: 15, right: 15),
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               mainAxisAlignment: MainAxisAlignment.end,
                      //               children: [
                      //                 Container(
                      //                   height: 100,
                      //                   width: 140,
                      //                   alignment: Alignment.topCenter,
                      //                   decoration: BoxDecoration(
                      //                     color: Colors.black45,
                      //                     borderRadius: BorderRadius.circular(10),
                      //                     image: DecorationImage(
                      //                       image: NetworkImage(sortingModel!
                      //                           .restaurants![index].allImage![0]),
                      //                       fit: BoxFit.cover,
                      //                     ),
                      //                   ),
                      //                 ),
                      //                 Text(
                      //                   sortingModel!.restaurants![index].resName!,
                      //                   maxLines: 1,
                      //                   style: TextStyle(
                      //                       color: appColorBlack,
                      //                       fontSize: 14,
                      //                       fontWeight: FontWeight.bold),
                      //                 ),
                      //                 Container(height: 8),
                      //                 Row(
                      //                   mainAxisAlignment:
                      //                       MainAxisAlignment.spaceBetween,
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.end,
                      //                   children: [
                      //                     Column(
                      //                       crossAxisAlignment:
                      //                           CrossAxisAlignment.start,
                      //                       children: [
                      //                         Container(
                      //                           width: 130,
                      //                           child: Text(
                      //                             sortingModel!.restaurants![index].resDesc!,
                      //                             maxLines: 2,
                      //                             style: TextStyle(
                      //                                 color: appColorBlack,
                      //                                 fontSize: 12,
                      //                                 height: 1.2,
                      //                                 fontWeight: FontWeight.normal),
                      //                           ),
                      //                         ),
                      //                         Text(
                      //                           "₹" +
                      //                               sortingModel!
                      //                                   .restaurants![index]
                      //                                   .price!,
                      //                           style: TextStyle(
                      //                               color: appColorBlack,
                      //                               fontSize: 16,
                      //                               fontWeight:
                      //                                   FontWeight.bold),
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //     ),
                      //     // Container(
                      //     //   height: 100,
                      //     //   width: 140,
                      //     //   alignment: Alignment.topCenter,
                      //     //   decoration: BoxDecoration(
                      //     //     color: Colors.black45,
                      //     //     borderRadius: BorderRadius.circular(10),
                      //     //     image: DecorationImage(
                      //     //       image: NetworkImage(sortingModel!
                      //     //           .restaurants![index].allImage![0]),
                      //     //       fit: BoxFit.cover,
                      //     //     ),
                      //     //   ),
                      //     // ),
                      //   ],
                      // ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  "Don't have any services",
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
  }

  Widget _banner(BuildContext context) {
    return bannerModal == null
        ? Center(
            child: Image.asset("assets/images/loader1.gif"),
          )
        : Stack(
            children: [
              ImageSlideshow(
                width: double.infinity,
                height: 240,
                initialPage: 0,
                indicatorColor: Colors.black,
                indicatorBackgroundColor: Colors.grey,
                children: bannerModal!.banners!.map(
                      (item) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl: item,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: Container(
                                margin: EdgeInsets.all(70.0),
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              height: 5,
                              width: 5,
                              child: Icon(
                                Icons.error,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onPageChanged: (value) {
                  print('Page changed: $value');
                },
              ),
              Positioned(
                top: MediaQuery.of(context).size.height/7,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Text("Find Your Professional Ants",
                        style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                    ),
                    Text("Anywhere, Everywhere",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          );
  }

  Widget collectionWidget() {
    return Column(
      children: [
        Container(
          color: backgroundgrey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 10),
                Text(
                  "Categories",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                // Text(
                //   "Hygiene & Safety Store",
                //   style: TextStyle(
                //       fontSize: 14,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.grey),
                // ),
                Container(height: 10),
                Container(
                    height: collectionModal == null ? 150 : 100,
                    child: collectionData()),
                Container(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget collectionData() {
    return collectionModal == null
        ? Center(
            child: Image.asset(
              "assets/images/loader1.gif",
              height: 150,
            ),
          )
        : collectionModal!.categories!.length > 0
            ? ListView.builder(
                padding: EdgeInsets.only(
                  bottom: 10,
                  top: 0,
                ),
                itemCount: collectionModal!.categories!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (
                  context,
                  int index,
                ) {
                  return sortingCard(
                      context, collectionModal!.categories![index]);
                },
              )
            : Center(
                child: Text(
                  "No data found",
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
  }

  Widget sortingCard(BuildContext context, Categories categories) {
    return Padding(
      padding: const EdgeInsets.only(right: 15),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubCategoryScreen(
                      id: categories.id!,
                      name: categories.cName!,
                      image: categories.img,
                      description: categories.description,
                    )
                // ViewCategory(id: categories.id!, name: categories.cName!)
                ),
          );
        },
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(width: 5),
              Container(
                width: 80,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.network(
                    categories.img!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categories.cName!,
                    style: TextStyle(
                        color: appColorBlack,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                  ),
                ],
              ),
              Container(width: 15)
            ],
          ),
        ),
      ),
    );
  }

  Widget bestSellerWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(height: 10),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "Best Service Provider",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "check out our best services",
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
        Container(height: 10),
        Container(
          //color: backgroundgrey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 10),
                /*Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchProduct(
                                      back: true,
                                    )),
                          );
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                              color: appColorBlack,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),*/
                Container(height: 200, child: bestSellerItems()),
                Container(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget bestSellerItems() {
    return allProduct == null
        ? Center(
            child: Image.asset("assets/images/loader1.gif"),
          )
        : allProduct!.setting!.length > 0
            ? ListView.builder(
                padding: EdgeInsets.only(bottom: 10),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: allProduct!.setting!.length,
                itemBuilder: (
                  context,
                  int index,
                ) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => ViewCategory(
                            vid: allProduct!.setting![index].id,
                            name: allProduct!.setting![index].uname,
                            fromSeller: true,
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Container(
                          width: 180,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 120,
                                      width: 140,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0)),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          allProduct!
                                              .setting![index].profileImage!,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(height: 5),
                                Text(
                                  "${allProduct!.setting![index].fname} ${allProduct!.setting![index].lname}",
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: appColorBlack,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                Container(height: 5),
                                /*Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "₹" +
                                              allProduct!.setting![index]
                                                  .productPrice!,
                                          style: TextStyle(
                                              color: appColorBlack,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: appColorOrange,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.shopping_bag_outlined,
                                          color: appColorWhite,
                                          size: 20,
                                        ),
                                      ),
                                    )
                                  ],
                                ),*/
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Center(
                child: Text(
                  "Don't have any near by service providers",
                  style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
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
}
