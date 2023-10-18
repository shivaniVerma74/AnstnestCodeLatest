import 'package:country_picker/country_picker.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:date_picker_timeline/extra/color.dart';
import 'package:ez/screens/view/newUI/login.dart';
import 'package:ez/screens/view/newUI/privacy_policy.dart';
import 'package:ez/screens/view/newUI/terms_condition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ez/block/signup_bloc.dart';
import 'package:ez/constant/global.dart';
import 'package:ez/constant/sizeconfig.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:ez/strings/strings.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  ProgressDialog? pr;

  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _countryCodePicker = TextEditingController();
  final TextEditingController _currencyPicker = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  bool _obscureText = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
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
            //   onTap: (){
            //     Navigator.of(context).pop();
            //   },
            //   child: Container(
            //     child: Icon(Icons.arrow_back_ios,color: backgroundblack,),
            //   ),
            // )
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _signupForm(context),
          ],
        ),
      ),
    );
  }
  final _formKey = GlobalKey<FormState>();

  Widget _signupForm(BuildContext context) {
    return Center(
      child: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // applogo(),
                // Container(height: 30.0),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                            fontSize: 30,
                            fontFamily: 'OpenSansBold',
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "Hello! let's join with us as a user",
                        style: TextStyle(
                            fontSize: 17,
                           ),
                      ),
                    ),
                  ],
                ),
                Container(height: 30.0),
                _userTextfield(context),
                Container(height: 10.0),
                _emailTextfield(context),
                Container(height: 10.0),
                _mobileTextfield(context),
                 Container(height: 10.0),
                _countryCodeTextField(context),
                Container(height: 10.0),
                _currencyField(context),
                // _passwordTextfield(context),
                Container(height: 20.0),
                termsAndCondition(),
                Container(height: 20.0),
                _loginButton(context),
                Container(height: 20.0),
                _dontHaveAnAccount(context),
                Container(height: 50.0),
              ],
            ),
          ),
        ),
      ),
    );
  }


  bool _isChecked = false;

  Widget termsAndCondition () {
    return Padding(
      padding: const EdgeInsets.only(left: 50),
      child: Align(
        alignment: Alignment.topLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: SizedBox(
                height: 50,
                child: Checkbox(
                  value: _isChecked,
                  onChanged: (newValue) {
                    setState(() {
                      _isChecked = newValue!;
                    });
                  },
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('I agree to AntsNest' ,style: TextStyle( fontSize: 12)),
                RichText(
                  softWrap: false,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyScreen(),));
                            // Handle the Privacy Policy click action here.
                          },
                      ),
                      TextSpan(
                        text: ' & ',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      ),
                      TextSpan(
                        text: 'Terms and Conditions',
                        style: TextStyle(color: Colors.red, fontSize: 12),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            // Handle the Terms and Conditions click action here.
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TermsConditionScreen(),));
                          },
                      ),
                      TextSpan(
                        text: '.',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ignore: unused_element

  Widget applogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          child: Image.asset(
            'assets/images/auth2.png',
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }

  Widget _userTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: _unameController,
        maxLines: 1,
        labelText: "Name",
        hintText: "Enter Name",
        textInputAction: TextInputAction.next,
        prefixIcon: Icon(Icons.person),
      ),
    );
  }

  Widget _mobileTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        controller: _mobileController,
        maxLength: 10,
        labelText: "Mobile",
        hintText: "Enter User Mobile No",
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.number,
        prefixIcon: Icon(Icons.call),
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

  Widget _emailTextfield(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child:  TextFormField(
        validator: (value){
          if (value!.isEmpty) {
            return 'Email is required';
          }
          if(!value.contains(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')){
            return 'Invalid Email';
          }
          return null;
        },
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
              borderSide: BorderSide(color: Colors.black12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.black54)),
        ),
      ),
      // TextFormField(
      //   controller: _emailController,
      //   validator: (v) {
      //     if (!v!.contains('@')) {
      //       return "Enter valid email";
      //     }
      //     // return false;
      //   },
      //   style: TextStyle(color: Colors.black),
      //   cursorColor: Colors.black,
      //   decoration: InputDecoration(
      //     filled: true,
      //       labelText: "Email",
      //       hintText: "Enter Email",
      //       prefixIcon: Icon(Icons.email),
      //     contentPadding:
      //     const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20),
      //     errorStyle: TextStyle(color: Colors.black),
      //     // errorText: widget.errorText,
      //     focusedErrorBorder: OutlineInputBorder(
      //       borderSide: BorderSide(color: Colors.black),
      //       borderRadius: BorderRadius.circular(20),
      //     ),
      //     focusColor: Colors.white,
      //     labelStyle: TextStyle(color: Colors.black, fontSize: 14),
      //     hintStyle: TextStyle(color: Colors.black, fontSize: 14),
      //     focusedBorder: OutlineInputBorder(
      //       borderSide: BorderSide(color: Colors.grey, width: 1),
      //       borderRadius: BorderRadius.circular(20),
      //     ),
      //     enabledBorder: OutlineInputBorder(
      //       borderSide: BorderSide(color: Colors.grey, width: 1),
      //       borderRadius: BorderRadius.circular(20),
      //     ),
      //   ),
      // ),
      // CustomtextField(
      //   controller: _emailController,
      //   maxLines: 1,
      //   labelText: "Email",
      //   hintText: "Enter Email",
      //   textInputAction: TextInputAction.next,
      //   prefixIcon: Icon(Icons.email),
      // ),
    );
  }

  Widget _countryCodeTextField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        readOnly: true,
        controller: _countryCodePicker,
        maxLines: 1,
        labelText: "Country Code",
        hintText: "Enter Country Code",
        textInputAction: TextInputAction.next,
        prefixIcon: Image.asset('assets/images/code.png', color: Colors.black, height: 10, width: 10,),
        onTap: () {
          showCountryPicker(
            context: context,
            showPhoneCode: true,
            // optional. Shows phone code before the country name.
            onSelect: ( Country country) {
              print('Select country: ${country.countryCode}');
              setState(() {
                _countryCodePicker.text = '+${country.phoneCode.toString()}';
              });
            },
          );
        },
      ),
    );
  }

  Widget _currencyField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: CustomtextField(
        readOnly: true,
        controller: _currencyPicker,
        maxLines: 1,
        labelText: "Choose Currency",
        hintText: "Enter Currency",
        textInputAction: TextInputAction.next,
        prefixIcon: Image.asset('assets/images/currency.png', color: Colors.black, height: 10, width: 10,),
        onTap: () {
          showCurrencyPicker(
            context: context,
            showFlag: true,
            showCurrencyName: true,
            showCurrencyCode: true,
            onSelect: (Currency currency) {
              print('Select currency: ${currency.name}');
              _currencyPicker.text =   currency.code;
            },
          );
        },
      ),
    );
  }


  Widget _loginButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: InkWell(
        onTap: () {
           if(_unameController.text.isEmpty) {
            Fluttertoast.showToast(msg: "Please Enter Name");
          }
          else if(_formKey.currentState!.validate()) {
            // Fluttertoast.showToast(msg: "Please Enter Email");
          }
          else if(_mobileController.text.isEmpty) {
            Fluttertoast.showToast(msg: "Please Enter Mobile");
          } else if(_countryCodePicker.text.isEmpty) {
            Fluttertoast.showToast(msg: "Please select country code");
          }else if(_currencyPicker.text.isEmpty) {
            Fluttertoast.showToast(msg: "Please select currency");
          }
          else if(!_isChecked) {
            Fluttertoast.showToast(msg: "please check terms & condition");
          }
          else {
            _signup(context);
          }
          // _signup(context);
        },
        child: SizedBox(
            height: 60,
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                  color: backgroundblack,
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.all(Radius.circular(15),
                  ),
              ),
              height: 50.0,
              // ignore: deprecated_member_use
              child: Center(
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Register",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: appColorWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ),
      ),
    );
  }



  // Widget _loginButton(BuildContext context) {
  //   return SizedBox(
  //     height: 55,
  //     width: MediaQuery.of(context).size.width - 105,
  //     child: CustomButtom(
  //       title: 'SIGNUP',
  //       color: Colors.white,
  //       onPressed: () {
  //         // Navigator.push(
  //         //   context,
  //         //   MaterialPageRoute(builder: (context) => SignUp()),
  //         // );
  //         _signup(context);
  //         print('Button is pressed');
  //       },
  //     ),
  //   );
  // }

  Widget _dontHaveAnAccount(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: "Already have an account? ",
        style: TextStyle(
          fontSize: 15,
          color: appColorBlack,
          fontWeight: FontWeight.w700,
        ),
        children: <TextSpan>[
          TextSpan(
            recognizer: new TapGestureRecognizer()
              ..onTap = () => Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => Login(),
                    ),
                  ),
            text: 'Login',
            style: TextStyle(
              color: Color(0xffEB6C67),
            ),
          ),
        ],
      ),
    );
  }

  void _signup(BuildContext context) {
    closeKeyboard();
    pr = new ProgressDialog(context, type: ProgressDialogType.Normal);
    pr?.style(message: 'Loading please wait...');
    // pr?.style(
    //   message: 'Please wait...',
    //   borderRadius: 10.0,
    //   backgroundColor: Colors.white,
    //   progressWidget: Container(
    //     height: 10,
    //     width: 10,
    //     margin: EdgeInsets.all(5),
    //     child: CircularProgressIndicator(
    //       strokeWidth: 2.0,
    //       valueColor: AlwaysStoppedAnimation(Colors.blue),
    //     ),
    //   ),
    //   elevation: 10.0,
    //   insetAnimCurve: Curves.easeInOut,
    //   progressTextStyle: TextStyle(
    //       color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
    //   messageTextStyle: TextStyle(
    //       color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600),
    // );
    print("checking input ${_unameController.text} and ${_passwordController.text} and ${_emailController.text} and ${_mobileController.text}");
    if (_unameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern.toString());
      if (regex.hasMatch(_emailController.text)) {
        pr?.show();
        // Loader().showIndicator(context);
        signupBloc.signupSink(
          _emailController.text,
          _passwordController.text,
          _unameController.text,
          _mobileController.text,
          _countryCodePicker.text,
          _currencyPicker.text
        ).then(
          (userResponse) {
            print("checking data here ${userResponse.responseCode} ");
            if (userResponse.responseCode == Strings.responseSuccess) {
              // String userResponseStr = json.encode(userResponse);
              // preferences.setString(
              //     SharedPreferencesKey.LOGGED_IN_USERRDATA,
              //     userResponseStr);
              pr?.hide();
              Fluttertoast.showToast(msg: "USER REGISTER SUCCESSFULLY");
              signupBloc.dispose();
              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()),
              );
            }
            else if (userResponse.responseCode == '0') {
              pr?.hide();
              loginerrorDialog(context, "Email id already registered");
            }
            // else {
            //   pr?.hide();
            //   loginerrorDialog(context, "Make sure you have entered right credentials");
            // }
          },
        );
      }
      // else {
      //   loginerrorDialog(
      //       context, "Make sure you have entered right credential");
      // }
    }
  }
}
