import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallerybox/pages/albums.dart';
import 'package:permission_handler/permission_handler.dart';

import 'organizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Function? requestPermissionCallback;
  static Function? homePageGoToPageCallback;

  static ScaffoldMessengerState? scaffoldMessenger;

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;



  @override
  void initState() {
    super.initState();

    _requestPermissions();
    HomePage.requestPermissionCallback = _requestPermissions;
    HomePage.homePageGoToPageCallback = _onItemTapped;
  }

  @override
  Widget build(BuildContext context) {
    const _pages = <Widget>[Organizer(), Albums()];

    HomePage.scaffoldMessenger = ScaffoldMessenger.of(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
          body: IndexedStack(
            index: currentPageIndex,
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: bottomNavigationBarItems,
            currentIndex: currentPageIndex,
            onTap: _onItemTapped,
          )),
    );
  }

  static const bottomNavigationBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.photo_album),
      label: 'Organize',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.folder),
      label: 'Albums',
    ),
  ];

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
}
