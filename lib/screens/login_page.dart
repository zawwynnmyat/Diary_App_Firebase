import 'package:diary/database.dart';
import 'package:diary/screens/diary_screen.dart';
import 'package:diary/screens/profile_page.dart';
import 'package:diary/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diary/auth_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../custom_widgets.dart';
import '../validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _formKey = GlobalKey<FormState>();

  final Color facebookColor = const Color(0xff39579A);

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  bool _isShowPasswordText = true;

  Future<FirebaseApp> _initializedFirebase() async {
     FirebaseApp firebaseApp = await Firebase.initializeApp();

     User? user = FirebaseAuth.instance.currentUser;
     if(user != null) {
       Database.userEmailId = user.email;
       Navigator.of(context).pushReplacement(
         MaterialPageRoute(builder: (context) {
            return DiaryScreen(title: 'Diary', user: user,);
         })
       );
     }


     return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _focusEmail.unfocus();
        _focusPassword.unfocus();
      },
      child: Scaffold(
        body: ListView(

          children: [

            Padding(
                padding: EdgeInsets.only(top: 30, left: 20),
              child: Text('Login', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
            ),
            SizedBox(height: 20,),
            FutureBuilder(
              future: _initializedFirebase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: SvgPicture.asset(
                              'assets/login.svg',
                              height: MediaQuery.of(context).size.height / 3.3,
                            )
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              //Email Field
                              TextFormField(
                                controller: _emailTextController,
                                focusNode: _focusEmail,
                                validator: (value) => Validator.validateEmail(
                                  email: value.toString(),
                                ),
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  icon: Icon(Icons.mail_outline, color: Colors.deepPurple,),
                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(
                                      color: Colors.deepPurple,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.0),
                              //Password Field
                              TextFormField(
                                controller: _passwordTextController,
                                focusNode: _focusPassword,
                                obscureText: true,
                                validator: (value) => Validator.validatePassword(
                                  password: value.toString(),
                                ),
                                decoration: InputDecoration(
                                  icon: Icon(Icons.lock, color: Colors.deepPurple,),
                                  hintText: "Password",

                                  errorBorder: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 24.0),
                              _isProcessing
                                  ? CircularProgressIndicator()
                                  : Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  //Sign In Button
                                  Expanded(
                                    child: MaterialButton(
                                      onPressed: () async {
                                        _focusEmail.unfocus();
                                        _focusPassword.unfocus();

                                        if (_formKey.currentState!
                                            .validate()) {
                                          setState(() {
                                            _isProcessing = true;
                                          });

                                          User? user = await FireAuth
                                              .signInUsingEmailPassword(
                                            email: _emailTextController.text,
                                            password:
                                            _passwordTextController.text,
                                          );

                                          setState(() {
                                            _isProcessing = false;
                                          });

                                          if(FireAuth.loginErrors == 'network-request-failed') {
                                            showDialog<String>(context: context, builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Opps!'),
                                                content: Text('Check your internet connection and please try again!'),
                                                actions: [
                                                  TextButton(onPressed: () {
                                                    Navigator.pop(context, 'OK');
                                                  }, child: Text('OK')),
                                                  TextButton(onPressed: () {
                                                    Navigator.pop(context, 'Cancel');
                                                  }, child: Text('Cancel')),
                                                ],
                                              );
                                            });
                                          }
                                          if(FireAuth.loginErrors == 'user-not-found'){
                                            showDialog<String>(context: context, builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Opps!'),
                                                content: Text('Account is not registered! Please Regsiter now.'),
                                                actions: [
                                                  TextButton(onPressed: () {
                                                    Navigator.pop(context, 'Register');
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            RegisterPage(),
                                                      ),
                                                    );
                                                  }, child: Text('Register')),
                                                  TextButton(onPressed: () {
                                                    Navigator.pop(context, 'Cancel');
                                                  }, child: Text('Cancel')),
                                                ],
                                              );
                                            });
                                          }
                                          if(FireAuth.loginErrors == 'wrong-password') {
                                            showDialog<String>(context: context, builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Opps!'),
                                                content: Text('Wrong Password!'),
                                                actions: [
                                                  TextButton(onPressed: () {
                                                    Navigator.pop(context, 'OK');
                                                  }, child: Text('OK')),
                                                ],
                                              );
                                            });
                                          }
                                          if (user != null) {

                                            Database.userEmailId = user.email;
                                            Navigator.of(context)
                                                .pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      DiaryScreen(title: 'Diary Screen', user:  user,)
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: Text(
                                        'Sign In',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: Colors.deepPurple,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12)
                                      ),
                                      elevation: 10,
                                    ),
                                  ),
                                  SizedBox(width: 24.0),
                                  //Register Button
                                  Expanded(
                                    child: MaterialButton(

                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterPage(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Register',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      color: Colors.deepPurple,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)
                                      ),
                                      elevation: 10,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height:30,),
                              Row(
                                children: const [
                                  Expanded(
                                      child: Divider(
                                         color: Colors.deepPurple,
                                        height: 2.0,
                                      ),
                                  ),
                                  Text(
                                      " OR ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      color: Colors.deepPurple
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      color: Colors.deepPurple,
                                      height: 2.0,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:20,),
                              CustomWidgets.socialButtonRect(
                                  'Login with Facebook', facebookColor, FontAwesomeIcons.facebookF,
                                  onTap: () async {
                                    User? user = await FireAuth.signInWithFacebook();

                                    if(user != null) {

                                      Database.userEmailId = user.email;

                                      Navigator.of(context)
                                          .pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DiaryScreen(title: 'Diary Screen', user: user,),
                                        ),
                                      );
                                    }
                                  }
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }

                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            )
          ],
        )
      ),
    );
  }
}