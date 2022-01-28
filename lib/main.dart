import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_list/Services/email.dart';
import 'Widgets/roundedbutton.dart';
import 'Widgets/textfield.dart';
import 'Screens/email_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:todo_list/Services/email.dart';
import 'Screens/todo.dart';
import 'Screens/phone.dart';
import 'Services/google.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Splash(),
      theme: ThemeData.light(),
    );
  }
}

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: Home(),
      title: Text("To-Do List",
          style: GoogleFonts.oswald(
            fontSize: 20,
            color: Colors.black,
          )),
      image: Image.asset(
        'images/splash.png',
      ),
      photoSize: 100,
      loaderColor: Colors.purpleAccent,
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FocusNode myfocus = FocusNode();
  final AuthenticationServices _auth = AuthenticationServices();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  "Sign In",
                  textAlign: TextAlign.left,
                  style: GoogleFonts.oswald(fontSize: 30, color: Colors.black),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Center(
                child: Image(
                  image: AssetImage(
                    'images/login.png',
                  ),
                  height: size.height * 0.3,
                  width: size.width * 0.7,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  EntryField(
                    textEditingController: _emailController,
                    label: "Email Address",
                    hide: false,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  EntryField(
                    textEditingController: _passwordController,
                    label: "Password",
                    hide: true,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  RoundedButton(
                    text: "Sign In",
                    onPressed: () async {
                      dynamic result = await _auth.loginUser(
                          _emailController.text, _passwordController.text);
                      if (result == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Login Unsucessful!")));
                      } else {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => Todo(
                                      uid: _auth.getUid(),
                                      auth: _auth.user(),
                                    )));
                      }
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                      Text(
                        "OR",
                        style: GoogleFonts.oswald(
                            fontSize: 10, fontWeight: FontWeight.w700),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.google,
                                color: Colors.grey[300],
                              ),
                              SizedBox(
                                width: 6,
                              ),
                              Text(
                                "Sign In With Google",
                                style: GoogleFonts.oswald(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        signUp(context);
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.phone,
                                color: Colors.grey[300],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "Sign In With Phone",
                                style: GoogleFonts.oswald(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              )
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (_) => Phone()));
                      },
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Divider(
                  thickness: 2,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not Registered?",
                    style: GoogleFonts.oswald(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return Email();
                      }));
                    },
                    child: Text(
                      "Create Account",
                      style: GoogleFonts.oswald(
                          fontWeight: FontWeight.w700,
                          color: Colors.blueAccent),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
