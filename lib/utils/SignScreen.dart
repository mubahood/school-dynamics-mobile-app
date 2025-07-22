import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:schooldynamics/theme/app_theme.dart';
import 'package:signature/signature.dart';

import 'Utils.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  // initialize the signature controller
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 1,
    penColor: Colors.red,
    exportBackgroundColor: Colors.transparent,
    exportPenColor: Colors.black,
  );

  @override
  void initState() {
    super.initState();
    _controller.onDrawEnd = () => setState(
          () {
            // setState for build to update value of "empty label" in gui
          },
        );
  }

  @override
  void dispose() {
    // IMPORTANT to dispose of the controller
    _controller.dispose();
    super.dispose();
  }

  //size_in_mb
  String size_in_mb = "0.0 MB";

  Future<void> exportImage(BuildContext context) async {
    if (_controller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('snack barPNG'),
          content: Text('No content'),
        ),
      );
      return;
    }

    final Uint8List? data = await _controller.toPngBytes();
    if (data == null) {
      return;
    }

    if (!mounted) return;
    //save data to file
    String basePath = await Utils.get_temp_dir();
    if (basePath.length < 2) {
      Utils.toast("Error getting temp dir");
      return;
    }

    if (basePath[basePath.length - 1] != "/") {
      basePath += "/";
    }
    //check if directory exists
    Directory dir = Directory(basePath);
    if (!dir.existsSync()) {
      dir.createSync();
    }
    if (!dir.existsSync()) {
      Utils.toast("Error creating temp dir");
      return;
    }
    //CHECK IF FILE EXISTS

    String filePath =
        "$basePath${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1000000)}-${Random().nextInt(1000000)}-signature.png";
    File file = File(filePath);
    if (file.existsSync()) {
      file.deleteSync();
    }
    //add content to file
    file.writeAsBytesSync(data);
    //check if file exists
    if (!file.existsSync()) {
      Utils.toast("Error saving signature");
      return;
    }
    Utils.toast("Signature saved");
    dp_path = filePath;
    size_in_mb = Utils.get_file_size(filePath);
    setState(() {});
    //beck with file path
    Navigator.pop(context, filePath);
  }

  String dp_path = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.primary,
      appBar: AppBar(
        title: FxText.titleLarge(
          'Signature',
          color: Colors.white,
          fontWeight: 800,
        ),
        backgroundColor: CustomTheme.primary,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.check,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () {
              exportImage(context);
            },
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Signature(
              key: const Key('signature'),
              controller: _controller,
              height: 300,
              backgroundColor: Colors.grey[300]!,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 15, right: 20),
            decoration: const BoxDecoration(color: Colors.white),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.undo),
                  color: Colors.black,
                  onPressed: () {
                    setState(() => _controller.undo());
                  },
                  tooltip: 'Undo',
                ),
                IconButton(
                  icon: const Icon(Icons.redo),
                  color: Colors.black,
                  onPressed: () {
                    setState(() => _controller.redo());
                  },
                  tooltip: 'Redo',
                ),
                //CLEAR CANVAS
                IconButton(
                  key: const Key('clear'),
                  icon: const Icon(Icons.clear),
                  color: Colors.red,
                  onPressed: () {
                    setState(() => _controller.clear());
                  },
                  tooltip: 'Clear',
                ),
              ],
            ),
          ),
          FxText(
            _controller.isEmpty ? "Signature pad is empty" : "",
            color: Colors.white,
            textAlign: TextAlign.center,
          ),
          const Spacer(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: FxButton.block(
            onPressed: () {
              exportImage(context);
            },
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FxText.titleLarge(
                  "Done",
                  color: Colors.white,
                  fontWeight: 900,
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            )),
      ),
    );
  }
}
