import 'dart:convert';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:ez/screens/view/models/add_address_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:http/http.dart' as http;
import '../../../constant/global.dart';
import '../../../models/City_model.dart';
import '../../../models/country_model.dart';
import '../../../models/state_model.dart';

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  TextEditingController addressC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  TextEditingController mobileC = TextEditingController();
  TextEditingController pincodeC = TextEditingController();
  TextEditingController cityC = TextEditingController();
  TextEditingController stateC = TextEditingController();
  TextEditingController buildingC = TextEditingController();
  TextEditingController countryC = TextEditingController();
  double lat = 0.0;
  double long = 0.0;

  // String radioButtonItem = 'ONE';
  int id = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 300), () {
      return getCountries();
    });
    if (userName != '' || userMobile != '') {
      nameC.text = userName;
      mobileC.text = userMobile;
    }
  }

  List<CountryData> countryList = [];
  List<StateData> stateList = [];
  List<CityData> cityList = [];

  String? selectedCountry;
  String? selectedState;
  String? selectedCity;

  Future getCountries() async {
    var request = http.Request('GET', Uri.parse('${baseUrl()}/get_countries'));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      final jsonResponse = CountryModel.fromJson(json.decode(str));

      if (jsonResponse.responseCode == "1") {
        setState(() {
          countryList = jsonResponse.data!;
          countryList.sort((a, b) {
            return a.name
                .toString()
                .toLowerCase()
                .compareTo(b.name.toString().toLowerCase());
          });
        });
      }
      return CountryModel.fromJson(json.decode(str));
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getState() async {
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/get_states'));
    request.fields.addAll({'country_id': '$selectedCountry'});
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      final jsonResponse = StateModel.fromJson(json.decode(str));
      if (jsonResponse.responseCode == "1") {
        setState(() {
          stateList = jsonResponse.data ?? [];
        });
      } else {
        setState(() {
          stateList = [];
        });
      }
      return StateModel.fromJson(json.decode(str));
    } else {
      return null;
    }
  }

  Future getCities() async {
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/get_cities'));
    request.fields.addAll({'state_id': '$selectedState'});
    print(request);
    print(request.fields);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      /*var fullResponse = json.decode(str);
      serviceList = fullResponse["data"];
      print(serviceList.length);
      setState(() {});
      boolList = serviceList.map((element) {
        return false;
      }).toList();
      serviceList.forEach((element) {
        boolServiceMapList[element["id"]] = false;
      });
      print(boolServiceMapList.length);
      print(boolList.length);*/
      final jsonResponse = CityModel.fromJson(json.decode(str));
      if (jsonResponse.responseCode == "1") {
        setState(() {
          cityList = jsonResponse.data ?? [];
        });
      } else {
        setState(() {
          cityList = [];
        });
      }
      return CityModel.fromJson(json.decode(str));
    } else {
      print(response.reasonPhrase);
    }
  }

  String phoneCode = '91';
  String countryName = 'IN';

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
        title: Text(
          'Add Address',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(height: 30.0),
            _userName(context),
            Container(height: 10.0),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      // optional. Shows phone code before the country name.
                      onSelect: (Country country) {
                        print(
                            'Select country: ${country.countryCode} and ${country.countryCode}');
                        setState(() {
                          phoneCode = country.phoneCode.toString();
                          countryName = country.countryCode.toString();
                        });
                      },
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.only(left: 30),
                    alignment: Alignment.center,
                    height: 66,
                    width: 70,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.black45)),
                    child: Text("${countryName} +${phoneCode}"),
                  ),
                ),
                Expanded(child: _mobile(context)),
              ],
            ),
            // _mobile(context),
            Container(height: 10.0),
            _addressField(context),
            Container(height: 10.0),
            _building(context),
            Container(height: 10.0),
            countrySelect(context),
            Container(height: 10.0),
            stateSelect(context),
            Container(height: 10.0),
            citySelect(context),
            // Container(height: 10.0),
            // _city(context),
            // Container(height: 10.0),
            // _state(context),
            // Container(height: 10.0),
            // _country(context),
            Container(height: 10.0),
            _pincode(context),
            Container(height: 10.0),
            _addressType(context),
            Container(height: 20.0),
            InkWell(
              onTap: () async {
                AddAddressModel? model = await addAddress();
                if (buildingC.text == "" ||
                    selectedCity == null ||
                    selectedState == null ||
                    selectedCountry == null ||
                    pincodeC.text == "") {
                  // if (model!.responseCode == "1") {
                  //   Navigator.pop(context);
                  //   Fluttertoast.showToast(
                  //       msg: "Address Added Successfully!",
                  //       toastLength: Toast.LENGTH_LONG,
                  //       gravity: ToastGravity.BOTTOM,
                  //       timeInSecForIosWeb: 1,
                  //       backgroundColor: backgroundblack,
                  //       textColor: appColorWhite,
                  //       fontSize: 13.0);
                  // }
                  const snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('All fields are required'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (mobileC.text.isEmpty || mobileC.text.length < 10) {
                  const snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text('Please enter a valid mobile'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  if (model!.responseCode == "1") {
                    Navigator.pop(context, true);
                    Fluttertoast.showToast(
                        msg: "Address Added Successfully!",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: primary,
                        textColor: appColorWhite,
                        fontSize: 13.0);
                  }
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                          color: primary,
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
                                "ADD ADDRESS",
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
          ],
        ),
      ),
    );
  }

  Widget countrySelect(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.topLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black45)),
      child: DropdownButton(
        // Initial Value
        underline: Container(),
        isExpanded: true,
        value: selectedCountry,
        hint: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Select Country",
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.left,
          ),
        ),
        // Down Arrow Icon
        icon: Icon(Icons.keyboard_arrow_down),
        // Array list of items
        items: countryList.map((items) {
          return DropdownMenuItem(
            value: items.id,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(items.name.toString()),
            ),
          );
        }).toList(),
        // After selecting the desired option,it will
        // change button value to selected value
        onChanged: (String? newValue) {
          setState(() {
            selectedCountry = newValue!;
            selectedState = null;
            selectedCity = null;
            print('___________${selectedCountry}__________');
            getState();
          });
        },
      ),
    );
  }

  Widget stateSelect(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.topLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black45)),
      child: DropdownButton(
        // Initial Value
        underline: Container(),
        isExpanded: true,
        value: selectedState,
        hint: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Select State",
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.left,
          ),
        ),
        // Down Arrow Icon
        icon: Icon(Icons.keyboard_arrow_down),
        // Array list of items
        items: stateList.map((items) {
          return DropdownMenuItem(
            value: items.id,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(items.name.toString()),
            ),
          );
        }).toList(),
        // After selecting the desired option,it will
        // change button value to selected value
        onChanged: (String? newValue) {
          setState(() {
            selectedState = newValue!;
            selectedCity = null;
            getCities();
          });
        },
      ),
    );
  }

  Widget citySelect(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.topLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.black45)),
      child: DropdownButton(
        // Initial Value
        underline: Container(),
        isExpanded: true,
        value: selectedCity,
        hint: Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Select City",
            style: TextStyle(fontSize: 14),
            textAlign: TextAlign.left,
          ),
        ),
        // Down Arrow Icon
        icon: Icon(Icons.keyboard_arrow_down),
        // Array list of items
        items: cityList.map((items) {
          return DropdownMenuItem(
            value: items.id,
            child: Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(items.name.toString()),
            ),
          );
        }).toList(),
        // After selecting the desired option,it will
        // change button value to selected value
        onChanged: (String? newValue) {
          setState(() {
            selectedCity = newValue!;
          });
        },
      ),
    );
  }

  Widget _addressField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        readOnly: true,
        controller: addressC,
        maxLines: 1,
        labelText: "Address",
        hintText: "Enter Address",
        textInputAction: TextInputAction.next,
        suffixIcon: Icon(Icons.location_searching),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlacePicker(
                apiKey: Platform.isAndroid
                    ? "AIzaSyB0uPBgryG9RisP8_0v50Meds1ZePMwsoY"
                    : "AIzaSyB0uPBgryG9RisP8_0v50Meds1ZePMwsoY",
                onPlacePicked: (result) {
                  print(result.formattedAddress);
                  //  restaurantList.clear();
                  setState(() {
                    addressC.text = result.formattedAddress.toString();
                    lat = result.geometry!.location.lat;
                    long = result.geometry!.location.lng;
                    // cityC.text = result.city
                    // stateC.text = result.administrativeAreaLevel1!.name.toString();
                    // countryC.text = result.country!.name.toString();
                    // pincodeC.text = result.postalCode.toString();
                  });
                  //  getRestaurants();
                  Navigator.of(context).pop();
                },
                initialPosition: LatLng(22.719568, 75.857727),
                useCurrentLocation: true,
              ),
            ),
          );
          // _getLocation();
        },
      ),
    );
  }

  Widget _userName(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: nameC,
        maxLines: 1,
        labelText: "User Name",
        hintText: "Enter User Name",
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _mobile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: mobileC,
        maxLines: 1,
        maxLength: 10,
        labelText: "User Mobile",
        hintText: "Enter Mobile Number",
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _pincode(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: pincodeC,
        maxLines: 1,
        // maxLength: 10,
        keyboardType: TextInputType.number,
        labelText: "Pincode",
        hintText: "Enter Pincode",
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _city(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: cityC,
        maxLines: 1,
        labelText: "City",
        hintText: "Enter City",
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _state(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: stateC,
        maxLines: 1,
        labelText: "State",
        hintText: "Enter State",
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _building(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: buildingC,
        maxLines: 1,
        labelText: "Building, Floor",
        hintText: "Enter Building, Floor, Flat no.",
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _country(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: countryC,
        maxLines: 1,
        labelText: "Country",
        hintText: "Enter Country",
        textInputAction: TextInputAction.next,
      ),
    );
  }

  Widget _addressType(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Radio(
            value: 0,
            groupValue: id,
            activeColor: primary,
            onChanged: (val) {
              setState(() {
                id = 0;
              });
            },
          ),
          Text(
            'HOME',
            style: new TextStyle(fontSize: 12.0),
          ),
          Radio(
            value: 1,
            groupValue: id,
            activeColor: primary,
            onChanged: (val) {
              setState(() {
                id = 1;
              });
            },
          ),
          Text(
            'WORK',
            style: new TextStyle(
              fontSize: 12.0,
            ),
          ),
          Radio(
            value: 2,
            groupValue: id,
            activeColor: primary,
            onChanged: (val) {
              setState(() {
                id = 2;
              });
            },
          ),
          Text(
            'OTHER',
            style: new TextStyle(fontSize: 12.0),
          ),
        ],
      ),
    );
  }

  // _getLocation() async {
  //   LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
  //       builder: (context) => PlacePicker(
  //         "AIzaSyCqQW9tN814NYD_MdsLIb35HRY65hHomco",
  //       )));
  //    print("checking adderss detail ${result.country!.name.toString()} and ${result.locality.toString()} and ${result.country!.shortName.toString()} ");
  //   setState(() {
  //     addressC.text = result.formattedAddress.toString();
  //     cityC.text = result.locality.toString();
  //     stateC.text = result.administrativeAreaLevel1!.name.toString();
  //     countryC.text = result.country!.name.toString();
  //     lat = result.latLng!.latitude;
  //     long = result.latLng!.longitude;
  //     pincodeC.text = result.postalCode.toString();
  //   });
  // }

  Future<AddAddressModel?> addAddress() async {
    var request =
        http.MultipartRequest('POST', Uri.parse('${baseUrl()}/add_address'));
    request.fields.addAll({
      'user_id': '$userID',
      'address': '${addressC.text.toString()}',
      'building': '${buildingC.text.toString()}',
      'city': '${selectedCity.toString()}',
      'state': '${selectedState.toString()}',
      'country': '${selectedCountry.toString()}',
      'country_code': '+${phoneCode.toString()}',
      'is_default': '1',
      'type': '$id',
      'lat': '$lat',
      'lng': '$long',
      'name': '${nameC.text.toString()}',
      'pincode': '${pincodeC.text.toString()}',
      'alt_mobile': '${mobileC.text.toString()}',
    });
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final str = await response.stream.bytesToString();
      return AddAddressModel.fromJson(json.decode(str));
    } else {
      return null;
    }
  }
}
