import 'dart:io';

import 'package:file_picker/file_picker.dart';

class Folder  {
  String _path = '';
  String _size = '';
  int ImageIndex = 0;

  String getPath() {
    return _path;
  }
  setPath(String newPath) {
    _path = newPath;
  }

  selectFolder() async {
    FilePicker.platform.clearTemporaryFiles();
    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    // directory = directoryPath!;
    setPath(directoryPath!);
  }
}
