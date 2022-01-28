import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/Screens/todo.dart';
import 'package:todo_list/Services/google.dart';

class Phone extends StatefulWidget {
  const Phone({Key? key}) : super(key: key);

  @override
  _PhoneState createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  late String phone;
  late String verif;
  late String userid;
  bool codeSent = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.only(bottom: size.height * 0.2),
                child: Text(
                  "Sign Up With Phone Number",
                  style: GoogleFonts.oswald(fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            codeSent
                ? Column(
                    children: [
                      OTPTextField(
                        length: 6,
                        width: MediaQuery.of(context).size.width,
                        fieldWidth: 20,
                        style: GoogleFonts.oswald(fontSize: 20),
                        onCompleted: (pin) {
                          verifyPin(pin);
                        },
                      ),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              verifyPhone();
                            });
                          },
                          child: Text("Resend Code"))
                    ],
                  )
                : IntlPhoneField(
                    initialCountryCode: "IN",
                    onChanged: (phoneNumber) {
                      setState(() {
                        phone = phoneNumber.completeNumber;
                      });
                    },
                    decoration: InputDecoration(
                        labelText: "Phone Number",
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none)),
                  ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  verifyPhone();
                },
                child: Text("Verify")),
          ],
        ),
      ),
    );
  }

  void verifyPin(String pin) async {
    PhoneAuthCredential credential =
        PhoneAuthProvider.credential(verificationId: verif, smsCode: pin);
    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (_) => Todo(
                    uid: auth.currentUser?.uid,
                    auth: auth,
                  )));
    } on FirebaseAuthException catch (e) {
      final snackBar = SnackBar(content: Text("Verification Failed!"));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void verifyPhone() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Phone Verified...")));
        },
        verificationFailed: (FirebaseAuthException e) {
          final snackBar = SnackBar(content: Text("${e.message}"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        },
        codeSent: (String verificationId, int? resendToken) async {
          setState(() {
            verif = verificationId;
            codeSent = true;
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            verif = verificationId;
          });
        },
        timeout: Duration(seconds: 60));
  }
}
