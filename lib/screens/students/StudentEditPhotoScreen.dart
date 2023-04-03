import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schooldynamics/models/UserModel.dart';
import 'package:schooldynamics/utils/AppConfig.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../models/LocalImageToUploadModel.dart';
import '../../sections/widgets.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';

class StudentEditPhotoScreen extends StatefulWidget {
  const StudentEditPhotoScreen({Key? key, required this.data})
      : super(key: key);
  final dynamic data;

  @override
  _StudentEditPhotoScreenState createState() => _StudentEditPhotoScreenState();
}

class _StudentEditPhotoScreenState extends State<StudentEditPhotoScreen> {
  late ThemeData themeData;

  _StudentEditPhotoScreenState();

  late Future<dynamic> futureInit;

  Future<Null> _my_init() async {
    futureInit = my_init();
    setState(() {});
  }

  UserModel item = UserModel();

  Future<dynamic> my_init() async {
    item = widget.data;
    setState(() {});
    return "Done";
  }

  @override
  void initState() {
    _my_init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        titleSpacing: 0,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        // remove back button in appbar.

        title: FxText.titleLarge(
          "${item.name}",
          color: Colors.white,
        ),
      ),
      body: mainFragment(),
    );
  }

  mainFragment() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: FxContainer(
              margin: EdgeInsets.all(15),
              bordered: true,
              color: CustomTheme.primary.withAlpha(30),
              borderColor: CustomTheme.primary,
              borderRadiusAll: 0,
              child: Center(
                child: local_image_path.isNotEmpty
                    ? Image.file(
                        File(local_image_path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                      )
                    : CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: item.avatar,
                        placeholder: (context, url) => ShimmerLoadingWidget(
                          height: double.infinity,
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: const Image(
                            image: AssetImage(AppConfig.USER_IMAGE),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: 15,
            ),
            child: (isUploading)
                ? Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 2.0,
                          valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.red.shade700),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FxButton.text(
                          child: FxText.bodyMedium(
                            'upload in background',
                            color: CustomTheme.primary,
                            fontWeight: 700,
                          ),
                          onPressed: () {
                            Get.back();
                          },
                          borderRadiusAll: 0,
                        )
                      ],
                    ),
                  )
                : local_image_path.isNotEmpty
                    ? Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: FxButton.block(
                              backgroundColor: Colors.red.shade700,
                              child: FxText.titleLarge(
                                'CANCEL',
                                color: Colors.white,
                                fontWeight: 700,
                              ),
                              onPressed: () {
                                deleteLocalImage();
                              },
                              borderRadiusAll: 0,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: FxButton.block(
                              child: FxText.titleLarge(
                                'UPDATE',
                                color: Colors.white,
                                fontWeight: 700,
                              ),
                              onPressed: () {
                                saveImage();
                              },
                              borderRadiusAll: 0,
                            ),
                          )
                        ],
                      )
                    : FxButton.block(
                        child: FxText.titleLarge(
                          'CHANGE PHOTO',
                          color: Colors.white,
                          fontWeight: 700,
                        ),
                        onPressed: () {
                          showImagePicker(context);
                        },
                        borderRadiusAll: 0,
                      ),
          ),
        ],
      ),
    );
  }

  bool isUploading = false;

  void showImagePicker(context) {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            padding: EdgeInsets.all(15),
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
      Utils.toast("Failed to get photo because ${e}");
    }
  }

  String local_image_path = "";
  String local_image_name = "";

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

    var temp_file = pickedFile?.path.toString();
    if (!(await (File(temp_file.toString()).exists()))) {
      return;
    }
    local_image_path = temp_file.toString();
    local_image_name = pickedFile!.name.toString();
    setState(() {});
  }

  void deleteLocalImage() async {
    local_image_path = "";
    local_image_name = "";
    setState(() {});
    return;
    if (!(await (File(local_image_path.toString()).exists()))) {
      return;
    }

    try {
      final file = File(local_image_path);
      await file.delete();
      print("success delete");
    } catch (e) {
      print("failed delete");
    }
    local_image_path = "";
    setState(() {});
  }

  Future<void> saveImage() async {
    await Future.delayed(Duration(seconds: 1));

    LocalImageToUploadModel img = new LocalImageToUploadModel();
    img.id = DateTime.now().millisecondsSinceEpoch;
    img.name = local_image_name;
    img.path = local_image_path;
    img.parent_id_online = item.id.toString();
    img.parent_type = 'user-photo';
    await img.save();

    if (!(await Utils.is_connected())) {
      Utils.toast(
          "The photo will be uploaded when you will connect to internet.",
          isLong: true);
      return;
    }

    setState(() {
      isUploading = true;
    });

    if (await img.upload()) {

      setState(() {
        isUploading = false;
      });

      Get.back();
      Utils.toast("Photo updated successfully!");
      return;

    }
    setState(() {
      isUploading = false;
    });

    Utils.toast("Failed to upload photo. Please try again.", color: Colors.red);
  }
}
