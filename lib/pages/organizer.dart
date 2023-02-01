import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../file_manager.dart';
import 'home.dart';

class Action {
  String type;
  String oldPath;
  String? newPath;

  Action({required this.type, required this.oldPath, this.newPath});
}

class Organizer extends StatefulWidget {
  const Organizer({Key? key}) : super(key: key);

  static Function? updateCallback;
  static Function? organizerGoToPageCallback;

  static List<Action> lastActions = [];

  @override
  State<StatefulWidget> createState() {
    return _OrganizerState();
  }
}

class _OrganizerState extends State<Organizer> {
  int currentFileIndex = 0; // photo view index

  PreferredSizeWidget? photoViewHeader;

  Widget? photoView;

  Widget? targetFoldersCarrousel;

  @override
  void initState() {
    super.initState();

    _updateState();
    Organizer.updateCallback = _updateState;
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
        body: Column(children: [
          photoViewHeader = _buildPhotoViewHeader(),
          Flexible(child: photoView = _buildPhotoView()),
          targetFoldersCarrousel = _buildTargetFoldersCarrousel(),
        ]));
  }

  PreferredSizeWidget _buildPhotoViewHeader() {
    if (FileManager.sourceFolder.path == null) {
      return PreferredSize(
          preferredSize: const Size.fromHeight(0), child: Container());
    }

    bool hasFiles = FileManager.sourceFolder.hasFiles();
    bool hasLastActions = Organizer.lastActions.isNotEmpty;

    return AppBar(
        title: Text(
            hasFiles ? "${currentFileIndex + 1} out of ${FileManager.sourceFolder.files.length}" : '',
            style: const TextStyle(fontSize: 12)),
        leading: IconButton(
          icon: const Icon(Icons.undo),
          onPressed: hasLastActions ? _undoLastAction() : null,
        ),
        actions: [
          // IconButton(icon: const Icon(Icons.delete), onPressed: _deleteFile)
          // disable if no file in source folder
          IconButton(
              icon: const Icon(Icons.delete),
              onPressed: hasFiles ? _deleteFile : null)
        ],
        centerTitle: true,
        backgroundColor: Colors.black);
  }

  Widget _buildPhotoView() {
    if (!FileManager.sourceFolder.hasFiles()) {
      return const Center(child: Text('No files in source folder'));
    }

    if (FileManager.sourceFolder.path == null) {
      return const Center(child: Text('Please select a source folder'));
    }

    if (photoView is PhotoViewGallery &&
        (photoView as PhotoViewGallery).pageController!.hasClients) {
      (photoView as PhotoViewGallery).pageController!.jumpToPage(0);
    }

    return PhotoViewGallery.builder(
      scrollPhysics: const BouncingScrollPhysics(),
      pageController: PageController(initialPage: 0),
      builder: (BuildContext context, int index) {
        return PhotoViewGalleryPageOptions(
            imageProvider: FileManager.sourceFolder.getImageProvider(index));
      },
      onPageChanged: _onFileChanged,
      itemCount: FileManager.sourceFolder.files.length,
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
  }

  Widget _buildTargetFoldersCarrousel() {
    List<Folder> albums = FileManager.targetFolders
        .where((folder) => folder.path != FileManager.sourceFolder.path)
        .toList();

    if (albums.isEmpty) {
      return const SizedBox(
          height: 100,
          child: Center(
              child: Text('No albums to move to. Try adding one.',
                  style: TextStyle(fontSize: 12))));
    }

    return SizedBox(
        height: 100,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: albums.length,
            itemBuilder: (context, index) {
              final folder = albums[index];
              return _buildTargetFolderTile(folder);
            }));
  }

  _buildTargetFolderTile(Folder folder) {
    Widget placeHolder = folder.hasFiles()
        ? Image.file(folder.fileAt(0), fit: BoxFit.fitHeight)
        : const Icon(Icons.folder);

    return TextButton(
        child: Column(children: [
          SizedBox(
              height: 70,
              width: 70,
              child: placeHolder),
          Text(folder.name, style: const TextStyle(fontSize: 12))
        ]),
        onPressed: () => _moveFileToFolder(folder));
  }

  SnackBar _buildErrorSnackBar() {
    return const SnackBar(content: Text('Something went wrong'));
  }

  _updateState() {
    setState(() {
      photoViewHeader = _buildPhotoViewHeader();
      photoView = _buildPhotoView();
      targetFoldersCarrousel = _buildTargetFoldersCarrousel();
    });
  }

  _onFileChanged(int index) {
    setState(() {
     currentFileIndex = index;
    });
  }

  _selectFolder() async {
    await FileManager.sourceFolder.selectFolder();
    _updateState();
  }

  _deleteFile() async {
    try {
      await FileManager.deleteFileAt(currentFileIndex);
      _updateState();
    } catch (e) {
      HomePage.scaffoldMessenger?.showSnackBar(_buildErrorSnackBar());
    }
  }

  _moveFileToFolder(Folder folder) async {
    if (!FileManager.sourceFolder.hasFiles()) {
      return;
    }

    File file = FileManager.sourceFolder.fileAt(currentFileIndex);
    String targetPath = folder.path! + '/' + file.path.split('/').last;

    try {
      await FileManager.moveFile(file, targetPath);
      FileManager.sourceFolder.updateFiles();
      _updateState();
    } catch (e) {
      HomePage.scaffoldMessenger?.showSnackBar(_buildErrorSnackBar());
    }
  }

  _undoLastAction() {
    var lastAction = Organizer.lastActions.last;
    if (lastAction.newPath != null) {
      FileManager.moveFile(
          File(lastAction.newPath ?? ""), lastAction.oldPath);
    }
    Organizer.lastActions.removeLast();
    _updateState();
  }
}
