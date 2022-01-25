import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diary/database.dart';
import 'package:diary/screens/edit_item_form.dart';
import 'package:flutter/material.dart';
import 'dart:core';
import 'dart:convert';

import 'edit_screen.dart';

class DiaryListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Database.readDiaries(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData || snapshot.data != null) {
          return Stack(
             children: [
               Positioned(
                 top: 50,
                   left: 15,
                   child: Text('Diaries', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),)
               ),
               Positioned(
                 top: 100,
                   right: 15,
                   bottom: 15,
                   left: 15,
                   child: ListView.separated(
                     separatorBuilder: (context, index) => SizedBox(height: 16.0),
                     itemCount: snapshot.data!.docs.length,
                     itemBuilder: (context, index) {
                       var diary = snapshot.data!.docs[index].data()!;
                       String docID = snapshot.data!.docs[index].id;
                       // print(diary);
                       List<String> twoParts = diary.toString().split(',');

                       // print(diary.toString().replaceAll(RegExp('{currentDate:'), ''));

                       String currentDate =
                       twoParts[0].replaceAll(RegExp('{currentDate:'), '');
                       String diaryText = twoParts[1]
                           .replaceAll(RegExp('diaryText:'), '')
                           .replaceAll('}', '');
                       String day = currentDate.trim().split(' ')[0];

                       String month = "";

                       if (currentDate.contains('January')) {
                         month = 'JAN';
                       } else if (currentDate.contains('February')) {
                         month = 'FEB';
                       } else if (currentDate.contains('March')) {
                         month = 'MAR';
                       } else if (currentDate.contains('April')) {
                         month = 'APR';
                       } else if (currentDate.contains('May')) {
                         month = 'MAY';
                       } else if (currentDate.contains('June')) {
                         month = 'JUN';
                       } else if (currentDate.contains('July')) {
                         month = 'JUL';
                       } else if (currentDate.contains('August')) {
                         month = 'AUG';
                       } else if (currentDate.contains('September')) {
                         month = 'SEP';
                       } else if (currentDate.contains('October')) {
                         month = 'OCT';
                       } else if (currentDate.contains('November')) {
                         month = 'NOV';
                       } else if (currentDate.contains('December')) {
                         month = 'DEC';
                       }

                       return Ink(
                         decoration: BoxDecoration(
                           color: Colors.pink.shade50,
                           borderRadius: BorderRadius.circular(8.0),
                         ),
                         child: ListTile(
                           shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(8.0),
                           ),
                           onTap: () => Navigator.of(context).push(
                             MaterialPageRoute(
                                 builder: (context) => EditScreen(
                                     currentDate: currentDate,
                                     diaryText: diaryText,
                                     documentId: docID) //Edit Screen
                             ),
                           ),
                           leading: Container(
                               width: 65,
                               height: 56,
                               decoration: BoxDecoration(
                                 borderRadius: BorderRadius.circular(10),
                                 color: Colors.pink,
                               ),
                               child: Column(
                                 children: [
                                   Text(
                                     month,
                                     style: TextStyle(
                                         color: Colors.white,
                                         fontWeight: FontWeight.w600,
                                         fontSize: 18),
                                   ),
                                   Container(
                                       width: 65,
                                       height: 32,
                                       decoration: BoxDecoration(
                                         borderRadius: BorderRadius.only(
                                             bottomLeft: Radius.circular(10),
                                             bottomRight: Radius.circular(10)),
                                         color: Colors.pink.shade100,
                                       ),
                                       child: Center(
                                         child: Text(
                                           day,
                                           style: TextStyle(
                                               fontSize: 25,
                                               fontWeight: FontWeight.bold,
                                               color: Colors.black),
                                         ),
                                       ))
                                 ],
                               )),
                           title: Text(
                             currentDate,
                             maxLines: 1,
                             overflow: TextOverflow.ellipsis,
                           ),
                           subtitle: Text(
                             diaryText,
                             maxLines: 1,
                             overflow: TextOverflow.ellipsis,
                           ),
                         ),
                       );
                     },
                   )
               ),
             ],
          );
        }

        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.pink),
          ),
        );
      },
    );
  }
}
