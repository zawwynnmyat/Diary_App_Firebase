import 'package:diary/diary_form.dart';
import 'package:diary/custom_widgets.dart';
import 'package:diary/screens/diary_list_screen.dart';
import 'package:diary/screens/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

class DiaryScreen extends StatefulWidget {
  final User user;

  const DiaryScreen({Key? key, required this.title, required this.user}) : super(key: key);
  final String title;


  @override
  State<DiaryScreen> createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {

  static int selectedIndex = 0;


  List<Widget> pages = [
    DiaryForm(),
   DiaryListScreen(),
    ProfilePage(user: FirebaseAuth.instance.currentUser!),
  ];

  @override
  void initState() {
    // TODO: implement initState;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
        bottomNavigationBar: BottomNavyBar(
          selectedIndex: selectedIndex,
          showElevation: true, // use this to remove appBar's elevation
          onItemSelected: (index) => setState(() {
            selectedIndex = index;
          }),
          items: [
            BottomNavyBarItem(
              icon: Icon(Icons.edit),
              title: Text('Write'),
              activeColor: Colors.red,
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.list_alt_rounded),
                title: Text('Diaries'),
                activeColor: Colors.purpleAccent
            ),
            BottomNavyBarItem(
                icon: Icon(Icons.person),
                title: Text('Profile'),
                activeColor: Colors.pink
            ),
          ],
        )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}