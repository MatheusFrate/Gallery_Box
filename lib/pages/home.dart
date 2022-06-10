import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../folder.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0; // bottom navigation bar index
  int currentFileIndex = 0; // photo view index

  final sourceFolder = Folder(); // folder with images to move
  final targetFolders = <Folder>[]; // folders to move images to

  @override
  void initState() {
    _requestPermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: Column(children: <Widget>[
          Flexible(child: images),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          items: bottomNavigationBarItems,
          currentIndex: 0, // todo: implement bottom navigation bar paging
          onTap: _onItemTapped,
        ));
  }

  /* Widgets */

  Widget images = const Center(child: Text('Please select a source folder'));

  static const bottomNavigationBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.photo_album),
      label: 'Albums',
    ),
  ];

  /* Functions */

  _requestPermissions() async {
    if (!await Permission.storage.isGranted) {
      await Permission.storage.request();
    }

    if (!await Permission.manageExternalStorage.isGranted) {
      await Permission.manageExternalStorage.request();
    }
  }

  _onItemTapped(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  _onFileChanged(int index) {
    setState(() {
      currentFileIndex = index;
    });
  }

  _selectFolder() async {
    if (await sourceFolder.selectFolder()) {
      await _loadImages();
    }
  }

  _loadImages() async {
    setState(() {
      final pageController = PageController(initialPage: 0);
      images = PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        pageController: pageController,
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
