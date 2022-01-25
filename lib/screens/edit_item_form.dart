import 'package:flutter/material.dart';

import '../custom_form_field.dart';
import '../database.dart';

class EditItemForm extends StatefulWidget {
  final FocusNode titleFocusNode;
  final FocusNode descriptionFocusNode;
  final String currentDate;
  final String diaryText;
  final String documentId;

  const EditItemForm({
    required this.titleFocusNode,
    required this.descriptionFocusNode,
    required this.currentDate,
    required this.diaryText,
    required this.documentId,
  });

  @override
  _EditItemFormState createState() => _EditItemFormState();
}

class _EditItemFormState extends State<EditItemForm> {
  final _editItemFormKey = GlobalKey<FormState>();

  bool _isProcessing = false;

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    _titleController = TextEditingController(
      text: widget.currentDate,
    );

    _descriptionController = TextEditingController(
      text: widget.diaryText,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _editItemFormKey,
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
              bottom: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 24.0),
                Text(
                  'Date',
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                CustomFormField(
                  isLabelEnabled: false,
                  controller: _titleController,
                  focusNode: widget.titleFocusNode,
                  keyboardType: TextInputType.text,
                  inputAction: TextInputAction.next,
                  label: 'Date',
                  hint: 'Date',
                ),
                SizedBox(height: 24.0),
                Text(
                  'Diary',
                  style: TextStyle(
                    color: Colors.pink,
                    fontSize: 22.0,
                    letterSpacing: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                CustomFormField(
                  maxLines: 14,
                  isLabelEnabled: false,
                  controller: _descriptionController,
                  focusNode: widget.descriptionFocusNode,
                  keyboardType: TextInputType.text,
                  inputAction: TextInputAction.done,
                  label: 'Your Diary',
                  hint: 'Your Diary',
                ),
              ],
            ),
          ),
          _isProcessing
              ? Center(
            child: CircularProgressIndicator(
              color: Colors.pink,
            ),
          )
              : Container(
            width: double.maxFinite,
            child: MaterialButton(
              color: Colors.pink,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)
              ),
              elevation: 10,
              onPressed: () async {
                widget.titleFocusNode.unfocus();
                widget.descriptionFocusNode.unfocus();

                if (_editItemFormKey.currentState!.validate()) {
                  setState(() {
                    _isProcessing = true;
                  });

                  await Database.updateDiary(
                      currentDate: _titleController.text,
                      diaryText: _descriptionController.text.replaceAll(',', ' '),
                      docId: widget.documentId);

                  setState(() {
                    _isProcessing = false;
                  });

                  Navigator.of(context).pop();
                }
              },
              child: Padding(
                padding: EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: Text(
                  'Save Diary',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
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