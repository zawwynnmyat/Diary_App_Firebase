import 'package:flutter/material.dart';
import '../database.dart';
import 'edit_item_form.dart';

class EditScreen extends StatefulWidget {
  final String currentDate;
  final String diaryText;
  final String documentId;

  EditScreen({
    required this.currentDate,
    required this.diaryText,
    required this.documentId,
  });

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final FocusNode _titleFocusNode = FocusNode();

  final FocusNode _descriptionFocusNode = FocusNode();

  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _titleFocusNode.unfocus();
        _descriptionFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.pink,
          title: Text('Edit & Read Diary'),
          actions: [
            _isDeleting
                ? Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                bottom: 10.0,
                right: 16.0,
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white,
                ),
                strokeWidth: 3,
              ),
            )
                : IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () async {
                setState(() {
                  _isDeleting = true;
                });

                await Database.deleteDiary(
                  docId: widget.documentId,
                );

                setState(() {
                  _isDeleting = false;
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16.0,
              bottom: 20.0,
            ),
            child: EditItemForm(
              documentId: widget.documentId,
              titleFocusNode: _titleFocusNode,
              descriptionFocusNode: _descriptionFocusNode,
              currentDate: widget.currentDate,
              diaryText: widget.diaryText,
            ),
          ),
        ),
      ),
    );
  }
}