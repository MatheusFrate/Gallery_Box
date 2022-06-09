import 'package:flutter/material.dart';
import 'package:gallerybox/pages/home.dart';

void main() {
  runApp(const Gallerybox());
}

class Gallerybox extends StatelessWidget {
  const Gallerybox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Gallerybox', theme: ThemeData.dark(), home: const HomePage());
  }
}
