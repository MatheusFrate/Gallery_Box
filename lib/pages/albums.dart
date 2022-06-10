import 'package:flutter/material.dart';

class Albums extends StatefulWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AlbumsState();
  }
}

class _AlbumsState extends State<Albums> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Gallerybox')),
        body: const Center(child: Text('Albums')));
  }
}
