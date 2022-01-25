import 'package:diary/screens/diary_screen.dart';
import 'package:diary/screens/register_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:diary/auth_helper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../validator.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final User user;

  const ProfilePage({required this.user});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isSendingVerification = false;
  bool _isSigningOut = false;

  late User _currentUser;

  TimeOfDay _time = TimeOfDay(hour: 7, minute: 15);

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


  void _selectTime() async {
    final TimeOfDay? newTime = await showTimePicker(
      context: context,
      initialTime: _time,
    );
    if (newTime != null) {
      setState(() {
        _time = newTime;
        saveDiaryTime(_time.format(context).toString());
        getDiaryTime();
      });
    }
  }

  String diaryTimeKey = 'diaryTimeKey';
  String dTime = '7:15 PM';

  void saveDiaryTime(String time) async {
     final sharedPreferences = await SharedPreferences.getInstance();
     sharedPreferences.setString(diaryTimeKey, time);
  }

  void getDiaryTime() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.containsKey(diaryTimeKey)) {
      setState(() {
        dTime = sharedPreferences.getString(diaryTimeKey)!;
      });

    }
  }

  @override
  void initState() {
    _currentUser = widget.user;
    getDiaryTime();
    super.initState();
    var androidInitializationSetting = AndroidInitializationSettings('Diary');
    var iosInitializationSetting = IOSInitializationSettings();
    var initSettings = InitializationSettings(android: androidInitializationSetting, iOS: iosInitializationSetting);

    flutterLocalNotificationsPlugin.initialize(initSettings, onSelectNotification: (payload) {

    });
  }

  Future<void> scheduleNotification() async {
    var scheduleNotificationDateTime = DateTime.now().add(Duration(seconds: 1));

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      channelDescription: 'channel description',
      icon: 'app_icon',
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics
    );

    await flutterLocalNotificationsPlugin.schedule(
        0,
        "Diary",
        "It\'s time to write diary. 😉📚",
        scheduleNotificationDateTime,
        platformChannelSpecifics);
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 30, left: 20),
          child: Text('Welcome, ${_currentUser.displayName}', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
        ),
        Padding(
          padding: EdgeInsets.only(top: 30, left: 20),
          child: SvgPicture.asset('assets/pp.svg', height: MediaQuery.of(context).size.height / 3.3,)
        ),
        Padding(
            padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your Diary Time', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dTime),
                  TextButton(onPressed: (){
                    _selectTime();
                    scheduleNotification();
                  }, child: Text('Select'))
                ],
              )
            ],
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.all(16.0),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                '${_currentUser.displayName}',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                )

                            ),
                            SizedBox(height: 16.0),
                            //Email
                            Text(
                                '${_currentUser.email}',
                                style: TextStyle(
                                  fontSize: 15,

                                )
                            ),
                          ],
                        ),
                        _isSigningOut
                            ? CircularProgressIndicator()
                            : GestureDetector(
                          onTap: () async {
                            setState(() {
                              _isSigningOut = true;
                            });
                            await FirebaseAuth.instance.signOut();
                            setState(() {
                              _isSigningOut = false;
                            });
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => LoginPage(title: 'Log In',),
                              ),
                            );
                          },
                          child: Container(

                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.deepPurple.shade100
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Icon(Icons.logout),
                                  SizedBox(height: 7,),
                                  Text('Log Out')
                                ],
                              ),
                            )
                          )
                        )
                      ],
                    ),
                  ),


                ],
              ),
              //Name

              SizedBox(height: 16.0),
              //VerificationStatus
              _currentUser.emailVerified
                  ? Text(
                'Email verified',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.green),
              )
                  : Text(
                'Email not verified',
                style: Theme.of(context)
                    .textTheme
                    .bodyText1!
                    .copyWith(color: Colors.red),
              ),
              SizedBox(height: 16.0),
              _isSendingVerification
                  ? CircularProgressIndicator()
                  : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  MaterialButton(
                    color: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    elevation: 10,
                    onPressed: () async {
                      setState(() {
                        _isSendingVerification = true;
                      });
                      await _currentUser.sendEmailVerification();
                      setState(() {
                        _isSendingVerification = false;
                      });
                      showDialog(barrierDismissible: false, context: context, builder: (BuildContext context) {
                         return AlertDialog(
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(12.0)
                           ),
                           title: Text('Verification Email Sent'),
                           content: Text('Hello, ${_currentUser.displayName}, verfication email sent to ${_currentUser.email}. Please check mail and verify.'),
                           actions: [
                             TextButton(onPressed: () {
                               Navigator.pop(context, 'OK');
                             }, child: Text('OK'))
                           ],
                         );
                      });
                    },
                    child: Text('Verify email', style: TextStyle(color: Colors.white),),
                  ),

                  SizedBox(width: 8.0),
                  IconButton(
                    icon: Icon(Icons.refresh),
                    onPressed: () async {
                      User? user = await FireAuth.refreshUser(_currentUser);

                      if (user != null) {
                        setState(() {
                          _currentUser = user;
                        });
                      }
                    },
                  ),
                ],
              ),

            ],
          ),
        ),

      ],
    );
  }
}