import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Folder {
  String? path;
  int imageIndex = 0;
  List files = [];

  selectFolder() async {
    FilePicker.platform.clearTemporaryFiles();
    String? directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath != null) {
      List filesInDirectory = Directory(directoryPath).listSync();

      files.clear();
      for (File file in filesInDirectory) {
        files.add(file);
      }

      path = directoryPath;
    }
  }

  getImage(int index) {
    return Image.file(files[index]).image;
  }
}
