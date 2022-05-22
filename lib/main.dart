import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MyHomePage(title: 'Gallery Box'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String directory = '';
  String ImagePath = '';

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);

    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: Icon(Icons.attach_file),
          actions: <Widget>[
            TextButton(
              style: style,
              onPressed: () {
                selecionarPasta();
              },
              child: const Text('Image'),
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                deleteImagem();
              },
            ),
            IconButton(
              icon: const Icon(Icons.navigate_next),
              tooltip: 'Go to the next page',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Next page'),
                      ),
                      body: const Center(
                        child: Text(
                          'This is the next page',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  },
                ));
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image(
                  image: ImagePath != '' ? Image
                      .file(File(ImagePath))
                      .image : AssetImage('assets/attach.png'),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 170,
                      height: 100,
                      child: ListTile(
                        leading: Icon(Icons.download),
                        title: Text('Mover para a pasta 1'),
                        onTap: selecionarImagem,
                        iconColor: Colors.white,
                        textColor: Colors.white,
                      ),
                    ),
                    Container(
                      width: 170,
                      height: 100,
                      child: ListTile(
                        leading: Icon(Icons.download),
                        title: Text('Pasta 2'),
                        onTap: selecionarImagem,
                        iconColor: Colors.white,
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ]
          ),
        )
    );
  }

  selecionarImagem() async {
    final ImagePicker picker = ImagePicker();

    try {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() => {
          ImagePath = file.path
        });
      }
    } catch (e) {
      print(e);
    }
  }

  selecionarPasta() async {
    FilePicker.platform.clearTemporaryFiles();
    String? directoryPath = await FilePicker.platform.getDirectoryPath();
    directory = directoryPath!;
    await changeImage();
  }
  changeImage() async {
    List files = Directory(directory.toString()).listSync();
    setState(() =>{
      ImagePath = files[0].toString().substring(7, files[0].toString().length - 1)
    });
  }



  Future<void> deleteImagem() async {
    try {
      FileSystemEntity x = await File(ImagePath);
      print(directory);
      if (x.existsSync()) {
        x.deleteSync();
        setState(() =>
        {
          ImagePath = '',1
        });
        //     await file.delete();
      }
    } catch (e) {
      print(e);
    }
  }
}


