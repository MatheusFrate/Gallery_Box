import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:gallerybox/pages/home.dart';

class FileManager {
  static final sourceFolder = Folder(); // folder with images to move
  static final targetFolders = <Folder>[]; // folders to move images to

  static void addTargetFolder(Folder folder) {
    targetFolders.add(folder);
  }

  static moveFile(File file, String targetPath) async {
    try {
      HomePage.requestPermissionCallback!();
      DateTime modificationTime = file.lastModifiedSync();
      File newFile = await file.copy(targetPath);
      await newFile.setLastModified(modificationTime);
      await file.delete();
      sourceFolder.updateFiles();
    } catch (e) {
      print(e);
    }
  }

  static deleteFileAt(int index) async {
    HomePage.requestPermissionCallback!();
    await sourceFolder.fileAt(index).delete();
    sourceFolder.removeFileAt(index);
  }
}

class Folder {
  String? path;
  List files = <File>[];

  String get name => path!.split('/').last;

  Future<void> selectFolder() async {
    FilePicker.platform.clearTemporaryFiles();
    String? directoryPath = await FilePicker.platform.getDirectoryPath();

    if (directoryPath != null) {
      path = directoryPath;
      updateFiles();
    }
  }

  void updateFiles() {
    List filesInDirectory = Directory(path!).listSync();

    files.clear();
    for (File file in filesInDirectory) {
      if (file.path.endsWith('.jpg') || file.path.endsWith('.jpeg')) {
        files.add(file);
      }
    }
  }

  void updatePath(String newPath, {bool update = false}) {
    path = newPath;
    if (update) {
      updateFiles();
    }
  }

  void removeFileAt(int index) {
    files.removeAt(index);
    updateFiles();
  }

  bool hasFiles() {
    return files.isNotEmpty;
  }

  File fileAt(int index) {
    return files.elementAt(index);
  }

  Image getImage(int index) {
    return Image.file(fileAt(index));
  }

  ImageProvider getImageProvider(int index) {
    return getImage(index).image;
  }
}
