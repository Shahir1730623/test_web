import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneTextEditingController = TextEditingController();
  String? selectedCountry;
  var temp;
  String? countryCode;

  bool isValidPhoneNumber(String countryCode, String phoneNumber) {
    return (countryCode == '+88' && phoneNumber.length == 14) ||
        (countryCode == '+91' && phoneNumber.length == 13);
  }

  Future<ConfirmationResult?> sendOTP(String phoneNumber) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseAuthPlatform authPlatform = FirebaseAuthPlatform.instanceFor(app: Firebase.apps.first, pluginConstants: {},);
    //
    RecaptchaVerifier verifier = RecaptchaVerifier(
      container: 'recaptcha-container',
      size: RecaptchaVerifierSize.compact,
      theme: RecaptchaVerifierTheme.dark,
      auth: authPlatform,
      onSuccess: () => debugPrint('reCAPTCHA Completed!'),
      onError: (FirebaseAuthException error) => debugPrint(error.toString()),
      onExpired: () => debugPrint('reCAPTCHA Expired!'),
    );


    try {
      ConfirmationResult result = await auth.signInWithPhoneNumber(
          phoneNumber,
          verifier
      );

      debugPrint("OTP Sent to $phoneNumber");
      return result;
    }

    catch (e) {
      debugPrint("Error sending OTP: $e");
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30,horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              textMain("Ready to Connect?", 30),
              SizedBox(height: screenHeight * 0.01,),
              text("Sign in with your phone number to rejoin the adventure.\n\nIt's quick, secure, and keeps you seamlessly connected!" , 20),
              SizedBox(height: screenHeight * 0.02,),

              // Phone TextField
              Container(
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 2), // changes position of shadow
                      ),]
                ),
                child: Row(
                  children: [
                    PopupMenuButton<PhoneMenuItem>(
                      onSelected: (PhoneMenuItem item) {
                        countryCode = item.text;
                        phoneTextEditingController.text = item.text;
                        setState(() {});
                      },
                      icon: const Icon(Icons.keyboard_arrow_down_outlined),
                      iconSize: 30,
                      itemBuilder: (BuildContext context) {
                        return menuItems.map((PhoneMenuItem item) {
                          return PopupMenuItem<PhoneMenuItem>(
                            value: item,
                            child: Row(
                              children: <Widget>[
                                Image.asset(item.image,width: 20,),
                                const SizedBox(width: 8), // Add space between icon and text
                                Text(item.text),
                              ],
                            ),
                          );
                        }).toList();
                      },
                    ),
                    const Text('|',style: TextStyle(fontSize: 20),),
                    const SizedBox(width: 10,),
                    Expanded(
                      child: Align(child: TextFormField(
                        textAlignVertical: TextAlignVertical.center,
                        controller: phoneTextEditingController,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w400,
                          color: Colors.blue,
                          fontSize: 16.0,
                        ),

                        decoration: InputDecoration(
                          border: InputBorder.none,
                          suffixIcon: phoneTextEditingController.text.isEmpty
                              ? Container(width: 0)
                              : IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () =>
                                phoneTextEditingController.clear(),
                          ),
                          hintText: 'Enter Phone Number',
                          hintStyle: GoogleFonts.raleway(
                            fontWeight: FontWeight.w400,
                            color: Colors.blue.withOpacity(0.8),
                            fontSize: 12.0,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "The field is empty";
                          }

                          else {
                            return null;
                          }
                        },
                      ),),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02,),


              button('Continue', Alignment.centerLeft, () async {
                if (isValidPhoneNumber(countryCode!, phoneTextEditingController.text)) {
                  temp = await sendOTP(phoneTextEditingController.text);
                  if (temp != null) {
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(temp: temp)));
                    debugPrint(temp.toString());
                  }
                }

                else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Wrong phone number format")));
                }

              })
            ],
          ),
        ),
      ),
    );
  }

  // Text
  Widget text(String text,double fontSize){
    return Text(
      text,
      style: GoogleFonts.raleway(
        fontWeight: FontWeight.w800,
        color: Colors.blue,
        fontSize: fontSize,
      ),
    );
  }

  Widget textMain(String text,double fontSize){
    return Text(
      text,
      style: GoogleFonts.raleway(
        fontWeight: FontWeight.w800,
        color: Colors.black,
        fontSize: fontSize,
      ),
    );
  }


  // Button
  Widget button(String text, Alignment alignment, void Function()? onTap){
    return Align(
      alignment: alignment,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.0),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
              border: Border.all(color: Colors.blue.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: Text(
              text,
              style: GoogleFonts.raleway(
                fontWeight: FontWeight.w700,
                color: Colors.blue,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      ),
    );
  }


}

class PhoneMenuItem {
  final String text;
  final String image;

  PhoneMenuItem(this.text, this.image);
}

List<PhoneMenuItem> menuItems = [
  PhoneMenuItem('+88', 'assets/bangladesh_flag.png'),
  PhoneMenuItem('+91', 'assets/india_flag.png'),
];
