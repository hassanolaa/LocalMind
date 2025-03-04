

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class picker{

  static Future<void> uploadimage(BuildContext context) async {
   
      try {
        FilePickerResult? filePickerResult =
            await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'png', 'jpeg', 'gif'],
        );
        if (filePickerResult != null) {
          File file = File(filePickerResult.files.single.path!);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('This Model does not support images'),
            backgroundColor: Colors.red,
          ));
          }
      } catch (e) {
        print(e);
      }
    
  }


  static Future<void> uploadfile(BuildContext context) async {
  
      try {
        FilePickerResult? filePickerResult =
            await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx'],
        );
        if (filePickerResult != null) {
          File file = File(filePickerResult.files.single.path!);
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('This Model does not support this file type'),
            backgroundColor: Colors.red,
          ));
          }
      } catch (e) {
        print(e);
      
    }
  }
}