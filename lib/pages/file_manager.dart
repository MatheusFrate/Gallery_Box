import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../folder.dart';

class FileManager extends StatefulWidget {
  const FileManager({Key? key}) : super(key: key);

  static final sourceFolder = Folder(); // folder with images to move
  static final targetFolders = <Folder>[]; // folders to move images to

  @override
  State<StatefulWidget> createState() {
    return _FileManagerState();
  }
}

class _FileManagerState extends State<FileManager> {
  int currentFileIndex = 0; // photo view index

  PreferredSizeWidget appBar = AppBar();
  Widget body = const Center(child: Text('Please select a source folder'));

  get sourceFolder => FileManager.sourceFolder;

  get targetFolders => FileManager.targetFolders;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(title: const Text('Gallerybox'), actions: [
          TextButton(
              child: Row(
                children: const [
                  Icon(Icons.folder),
                  Text(' Source folder'),
                ],
              ),
              onPressed: _selectFolder)
        ]),
        body: Column(children: [
          sourceFolder.path == null ? Container() : _buildFolderCounter(),
          Flexible(child: body)
        ]));
  }

  _buildFolderCounter() {
    return AppBar(
        title:
            Text("${currentFileIndex + 1} out of ${sourceFolder.files.length}"),
        centerTitle: true,
        backgroundColor: Colors.black);
  }

  _onFileChanged(int index) {
    setState(() {
      currentFileIndex = index;
    });
  }

  _selectFolder() async {
    await sourceFolder.selectFolder();
    await _loadImages();
  }

  _loadImages() async {
    setState(() {
      body = PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        pageController: PageController(initialPage: 0),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
              imageProvider: sourceFolder.getImage(index));
        },
        onPageChanged: _onFileChanged,
        itemCount: sourceFolder.files.length,
        loadingBuilder: (context, progress) => Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: (progress == null || progress.expectedTotalBytes == null)
                ? const CircularProgressIndicator()
                : CircularProgressIndicator(
                    value: progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!.toDouble()),
          ),
        ),
      );
    });
  }
}
