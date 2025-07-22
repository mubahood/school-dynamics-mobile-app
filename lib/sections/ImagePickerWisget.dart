import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schooldynamics/sections/widgets.dart';

import '../theme/custom_theme.dart';
import '../utils/AppConfig.dart';
import '../utils/Utils.dart';

class ImagePickerWidget extends StatefulWidget {
  String path;
  String src;
  String title;
  Function(String) onImageSelected;

  ImagePickerWidget(
    this.path,
    this.src,
    this.title, this.onImageSelected,
      {super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  String imgPath = '';

  @override
  Widget build(BuildContext context) {
    return FxContainer(
      onTap: () {
        showImagePicker(context);
      },
      padding: FxSpacing.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      bordered: true,
      borderRadiusAll: 10,
      border: Border.all(
        color: CustomTheme.primary,
        width: 1,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: imgPath.isNotEmpty
                ? Image.file(
                    File(imgPath),
                    fit: BoxFit.cover,
                    width: 70,
                    height: 70,
                  )
                : widget.src.length > 3
                    ? CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: 70,
                        height: 70,
                        imageUrl: Utils.getImageUrl(widget.src),
                        placeholder: (context, url) =>
                            ShimmerLoadingWidget(height: 70, width: 70),
                        errorWidget: (context, url, error) => const Image(
                              image: AssetImage(
                                AppConfig.NO_IMAGE,
                              ),
                              fit: BoxFit.cover,
                              height: 60,
                            ))
                    : imgPath.isEmpty
                        ? Icon(
                            FeatherIcons.camera,
                            color: CustomTheme.primary,
                            size: 50,
                          )
                        : Image.file(
                            File(imgPath),
                            fit: BoxFit.cover,
                          ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: FxText.bodyLarge(
              '${imgPath.isEmpty ? 'Select' : 'Change'} ${widget.title}',
              color: CustomTheme.primary,
              fontWeight: 700,
            ),
          ),
        ],
      ),
    );
  }

  void showImagePicker(context) {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        backgroundColor: Colors.transparent,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(15),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Padding(
                padding: FxSpacing.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        _onImageButtonPressed(ImageSource.camera);
                      },
                      dense: false,
                      leading: Icon(FeatherIcons.camera,
                          size: 30, color: CustomTheme.primary),
                      title: FxText(
                        "Use camera",
                        fontWeight: 500,
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                    ListTile(
                        dense: false,
                        onTap: () {
                          Navigator.pop(context);
                          _onImageButtonPressed(ImageSource.gallery);
                        },
                        leading: Icon(FeatherIcons.image,
                            size: 28, color: CustomTheme.primary),
                        title: FxText(
                          "Pick from gallery",
                          fontWeight: 500,
                          color: Colors.black,
                          fontSize: 18,
                        )),
                  ],
                ),
              ),
            ),
          );
        });
  }

  final ImagePicker _picker = ImagePicker();
  XFile? pickedFile;

  Future<void> _onImageButtonPressed(
    ImageSource source,
  ) async {
    try {
      pickedFile = await _picker.pickImage(
        source: source,
      );
      displayPickedPhoto();
    } catch (e) {
      Utils.toast("Failed to get photo because $e");
    }
  }

  Future<void> displayPickedPhoto() async {
    if (pickedFile == null) {
      return;
    }
    if (pickedFile?.path == null) {
      return;
    }
    if (pickedFile?.name == null) {
      return;
    }

    var tempFile = pickedFile?.path.toString();
    if (!(await (File(tempFile.toString()).exists()))) {
      return;
    }
    imgPath = tempFile.toString();
    widget.onImageSelected(imgPath);
    setState(() {});
  }
}
