import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('diaries');

class Database {
   static String? userEmailId;

   static Future<void> addDiary({
     required String currentDate,
     required String diaryText,
   }) async {
     DocumentReference documentReferencer = _mainCollection.doc(userEmailId).collection('diaries').doc();

     Map<String, dynamic> data = <String, dynamic> {
        "currentDate" : currentDate,
       "diaryText" : diaryText
     };

     await documentReferencer
         .set(data).whenComplete(() => print('Diary Added to database'))
         .catchError((e) => print(e));
   }

   static Stream<QuerySnapshot> readDiaries() {
      CollectionReference dirariesItemCollection =
          _mainCollection.doc(userEmailId).collection('diaries');

      return dirariesItemCollection.snapshots();
   }

   static Future<void> updateDiary({
  required String currentDate,
     required String diaryText,
     required String docId,
    }) async {
     print("..............");
     print(currentDate);
     print(diaryText);
     print("...............");
         DocumentReference documentReferencer = 
             _mainCollection.doc(userEmailId).collection('diaries').doc(docId);

         Map<String, dynamic> data = <String, dynamic> {
            "currentDate" : currentDate,
           "diaryText" : diaryText
         };

         await documentReferencer.update(data).whenComplete(() => print('Updated')).catchError((e) => print(e));
    }

   static Future<void> deleteDiary({
     required String docId,
   }) async {
     DocumentReference documentReferencer =
     _mainCollection.doc(userEmailId).collection('diaries').doc(docId);

     await documentReferencer
         .delete()
         .whenComplete(() => print('deleted from the database'))
         .catchError((e) => print(e));
   }

}