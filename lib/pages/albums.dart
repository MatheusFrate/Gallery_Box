import 'package:flutter/material.dart';
import 'package:gallerybox/pages/organizer.dart';

import '../file_manager.dart';
import 'home.dart';

class Albums extends StatefulWidget {
  const Albums({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AlbumsState();
  }
}

class _AlbumsState extends State<Albums> {
  Widget albumsView = Container();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Gallerybox'), actions: [
          TextButton(
              child: Row(
                children: const [
                  Icon(Icons.folder),
                  Text(' Target folder'),
                ],
              ),
              onPressed: _addFolder)
        ]),
        body: Column(children: [albumsView = _buildFolderGrid()]));
  }

  Widget _buildFolderGrid() {
    if (FileManager.targetFolders.isEmpty) {
      return const Flexible(
          child: Center(child: Text('Please select a target folder')));
    }

    return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        shrinkWrap: true,
        padding: const EdgeInsets.all(5.0),
        children: FileManager.targetFolders
            .map((folder) => _buildFolderGridTile(folder))
            .toList());
  }

  Widget _buildFolderGridTile(Folder folder) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Card(
          child: SizedBox(height: 70, width: 70, child: Icon(Icons.folder))),
      Expanded(
        child: Text(folder.name,
            maxLines: 2,
            style: const TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              child: const Text('Use', style: TextStyle(color: Colors.black)),
              onPressed: () => _useAsSourceFolder(folder)),
          ElevatedButton(
              child: const Icon(Icons.delete, color: Colors.black),
              onPressed: () => _removeFolder(folder)),
        ],
      ),
    ]);
  }

  _updateState() {
    setState(() {
      albumsView = _buildFolderGrid();
      Organizer.updateCallback!();
    });
  }

  _addFolder() async {
    final folder = Folder();
    await folder.selectFolder();
    if (folder.path != null &&
        !FileManager.targetFolders.any((f) => f.path == folder.path)) {
      FileManager.addTargetFolder(folder);
      FileManager.targetFolders.sort((a, b) => a.path!.compareTo(b.path!));
      _updateState();
    }
  }

  _removeFolder(Folder folder) async {
    FileManager.targetFolders.remove(folder);
    _updateState();
  }

  _useAsSourceFolder(Folder folder) async {
    FileManager.sourceFolder.updatePath(folder.path!, update: true);
    HomePage.homePageGoToPageCallback!(0);
    _updateState();
  }
}
