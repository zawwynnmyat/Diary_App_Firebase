import 'package:diary/database.dart';
import 'package:diary/screens/diary_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diary/auth_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../validator.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();

  final _nameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final _focusName = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  bool _isProcessing = false;

  bool _isShowPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        foregroundColor: Colors.deepPurple,
        backgroundColor: Color.fromRGBO(250, 250, 250, 1),
        elevation: 0,
        actions: [

        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, left: 20),
            child: Text('Sign up', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
          ),
          Center(
            child: GestureDetector(
              onTap: () {
                _focusName.unfocus();
                _focusEmail.unfocus();
                _focusPassword.unfocus();
              },
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Column(

                    children: [
                      Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: SvgPicture.asset(
                            'assets/signup.svg',
                            height: MediaQuery.of(context).size.height / 3.3,
                          )
                      ),
                      Form(
                        key: _registerFormKey,
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _nameTextController,
                              focusNode: _focusName,
                              validator: (value) => Validator.validateName(
                                name: value.toString(),
                              ),
                              decoration: InputDecoration(
                                icon: Icon(Icons.person, color: Colors.deepPurple,),
                                hintText: "Name",
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: BorderSide(
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _emailTextController,
                              focusNode: _focusEmail,
                              validator: (value) => Validator.validateEmail(
                                email: value.toString(),
                              ),
                              decoration: InputDecoration(
                                focusColor: Colors.deepPurple,
                                icon: Icon(Icons.mail_outline, color: Colors.deepPurple,),
                                hintText: "Email",
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.0),
                            TextFormField(
                              controller: _passwordTextController,
                              focusNode: _focusPassword,
                              obscureText: _isShowPassword,
                              validator: (value) => Validator.validatePassword(
                                password: value.toString(),
                              ),
                              decoration: InputDecoration(
                                icon: Icon(Icons.lock, color: Colors.deepPurple,),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isShowPassword = !_isShowPassword;
                                    });
                                  },
                                  icon: _isShowPassword ? Icon(Icons.visibility, color: Colors.deepPurple,) : Icon(Icons.visibility_off, color: Colors.deepPurple,),
                                ),
                                hintText: "Password",
                                errorBorder: UnderlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 32.0),
                            Row(
                              children: [
                                Expanded(
                                  child: MaterialButton(
                                    color: Colors.deepPurple,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12)
                                    ),
                                    elevation: 10,
                                    onPressed: () async {
                                      setState(() {
                                        _isProcessing = true;
                                      });

                                      if (_registerFormKey.currentState!
                                          .validate()) {
                                        User? user = await FireAuth
                                            .registerUsingEmailPassword(
                                          name: _nameTextController.text,
                                          email: _emailTextController.text,
                                          password:
                                          _passwordTextController.text,
                                        );

                                        if(FireAuth.errors == 'network-request-failed') {
                                          setState(() {
                                            _isProcessing = false;
                                          });
                                          showDialog<String>(context: context, builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Opps!'),
                                              content: Text('Check your internet connection and please try again!'),
                                              actions: [
                                                TextButton(onPressed: () {
                                                  Navigator.pop(context, 'OK');
                                                }, child: Text('OK')),
                                              ],
                                            );
                                          });
                                        }

                                        if(FireAuth.errors == 'email-already-in-use') {
                                          setState(() {
                                            _isProcessing = false;
                                          });
                                          showDialog<String>(context: context, builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('Opps!'),
                                              content: Text('This account already exists!'),
                                              actions: [
                                                TextButton(onPressed: () {
                                                  Navigator.pop(context, 'OK');
                                                }, child: Text('OK')),
                                              ],
                                            );
                                          });
                                        }


                                        setState(() {
                                          _isProcessing = false;
                                        });

                                        if (user != null) {
                                          Database.userEmailId = user.email;
                                          Navigator.of(context)
                                              .pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    DiaryScreen(title: 'Diary', user: user,)
                                            ),
                                            ModalRoute.withName('/'),
                                          );
                                        }
                                      }

                                    },
                                    child: Text(
                                      'Sign up',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                _isProcessing ? Padding(padding: EdgeInsets.all(10.0),
                                  child: CircularProgressIndicator(),) : Container(width: 0,)
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}