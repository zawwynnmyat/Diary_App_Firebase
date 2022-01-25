import 'package:flutter/material.dart';
import 'database.dart';
import 'dart:io';

class DiaryForm extends StatefulWidget {

  @override
  State<DiaryForm> createState() => _DiaryFormState();
}

class _DiaryFormState extends State<DiaryForm> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final TextEditingController _currentDateController = TextEditingController();

  final TextEditingController _diaryController = TextEditingController();

  List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  DateTime selectedDate = DateTime.now();

  bool _isSplash = false;
  bool _isSplashPDF = false;
  bool _isSplashSave = false;
  bool _isSplashSize = false;
  bool _isReadOnly = false;

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2010),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate)
      setState(() {
        selectedDate = selected;
        _currentDateController.text = ' '+ selectedDate.day.toString() + ' ' +
            months[selectedDate.month - 1] + ' ' + selectedDate.year.toString();
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentDateController.text = ''+ DateTime.now().day.toString()  + ' ' +
        months[DateTime.now().month - 1]+ ' ' +
        DateTime.now().year.toString();
  }
  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height,
      child: Stack(
        children: <Widget>[
          //Top Container
          Container(
            color: Colors.pink,
            width: MediaQuery
                .of(context)
                .size
                .width,
            height: 100.0,
            child: Center(
              child: Text(
                "Online Diary",
                style: TextStyle(color: Colors.white, fontSize: 18.0),
              ),
            ),
          ),
          //Buttons Container
          Positioned(
            top: 80.0,
            left: 0.0,
            right: 0.0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.5), width: 1.0),
                    color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //Font Size Button
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        child: IconButton(onPressed: () {
                          setState(() {
                            _isSplashSize = !_isSplashSize;
                            _isReadOnly = !_isReadOnly;
                          });

                        }, icon: Icon(_isReadOnly ? Icons.lock : Icons.lock_open, size: 30, color: Colors.white,)),
                        backgroundColor: !_isSplashSize ? Colors.pink : Colors.green,
                        radius: 28,
                      ),
                    ),
                    //Delete Button
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        child: IconButton(onPressed: () {
                          _currentDateController.text = '';
                          _diaryController.text = '';
                          setState(() {
                            _isSplash = !_isSplash;
                          });
                        }, icon: Icon(Icons.delete_forever_outlined, size: 30, color: Colors.white,)),
                        backgroundColor: !_isSplash ? Colors.pink : Colors.green,
                        radius: 28,
                      ),
                    ),
                    //Save Button
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        child: IconButton(onPressed: () async {
                          setState(() {
                            _isSplashSave = !_isSplashSave;
                          });
                           await Database.addDiary(
                               currentDate: ''+_currentDateController.text,
                               diaryText: _diaryController.text.replaceAll(',', ' '),
                           );
                           _diaryController.text = '';
                           _currentDateController.text = '';
                           showDialog(
                               context: context, builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Successfully Saved!'),
                                    content: Text('Your diary was saved successfully.'),
                                    actions: [
                                      TextButton(onPressed: () {
                                        Navigator.pop(context, 'OK');
                                      }, child: Text('OK'))
                                    ],
                                  );
                           });
                        }, icon: Icon(Icons.save, size: 30, color: Colors.white,)),
                        backgroundColor: !_isSplashSave ? Colors.pink : Colors.green,
                        radius: 28,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              top: 160,
              left: 20,
              child: Text('Date', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
          ),
          //Date Text Field
          Positioned(
            top: 200,
            left: 20,
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              height: MediaQuery.of(context).size.height / 19,
              child: TextField(
                enabled: !_isReadOnly,
                keyboardType: TextInputType.multiline,
                maxLines: 500,
                controller: _currentDateController,
                decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.pink, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      BorderSide(color: Colors.pink, width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  suffixIcon: IconButton(
                    icon: Icon(_isReadOnly ? Icons.lock : Icons.calendar_today_rounded, color: Colors.pink,),
                    onPressed: ()  {
                      _selectDate(context);
                    },
                  )
                ),
              ),
            ),


          ),
          Positioned(
              top: 250,
              left: 20,
              child: Text('Diary', style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
          ),
          //Diary Text Field
          Positioned(
            top: 290,
            left: 20,
            child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: MediaQuery.of(context).size.height / 1.9,
                  child: TextField(
                    enabled: !_isReadOnly,
                    keyboardType: TextInputType.multiline,
                    maxLines: 500,
                    controller: _diaryController,
                    decoration: InputDecoration(
                      suffixIcon: _isReadOnly ? Icon(Icons.lock, color: Colors.pink,) : Icon(Icons.edit, color: Colors.pink,),
                      hintText: 'Your Diary',
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.pink, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.pink, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(15.0)),
                        )
                    ),
                  ),
                ),


            ),
        ],
      ),
    );
  }
}