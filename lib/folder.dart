import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Folder {
  String _path = '';
  int imageIndex = 0;
  List files = [];

  String getPath() {
    return _path;
  }

  setPath(String newPath) {
    _path = newPath;
  }

  selectFolder() async {
    FilePicker.platform.clearTemporaryFiles();
    String? directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath != null) {
      List filesInDirectory = Directory(directoryPath).listSync();
      files = filesInDirectory.whereType<File>().toList();
      setPath(directoryPath);
      return true;
    }

    return false;
  }

  getImage(int index) {
    return Image.file(files[index]).image;
  }
}
