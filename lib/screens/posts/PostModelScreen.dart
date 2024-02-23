import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutx/flutx.dart';
import "package:get/get.dart";
import 'package:schooldynamics/models/PostModel.dart';

import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';

class PostModelScreen extends StatelessWidget {
  final PostModel item;

  const PostModelScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxText.titleLarge(
              '${item.type} Details',
              color: Colors.white,
              fontWeight: 800,
              height: 1,
            ),
            FxText.titleMedium(
              "Published on ${Utils.to_date_1(item.created_at)}",
              color: Colors.white,
              fontWeight: 600,
            ),
          ],
        ),
        backgroundColor: CustomTheme.primary,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: CustomTheme.primary,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Container(
            color: Colors.white,
            child: //
                Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    _buildContentWidget(),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, top: 10),
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                          letterSpacing: .01,
                          height: 1,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(
                      height: 0,
                    ),
                    item.type == 'Event'
                        ? Column(
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(
                                        left: 0, top: 0, right: 15),
                                    child: Text(
                                      'Event Date:',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 22,
                                        letterSpacing: .01,
                                        height: 1,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  FxText.bodyLarge(
                                    Utils.to_date_1(item.event_date),
                                    color: Colors.grey.shade900,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              const Divider(
                                height: 0,
                              ),
                            ],
                          )
                        : const SizedBox(),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Html(
                        data: item.description,
                        style: {
                          '*': Style(
                            color: Colors.grey.shade700,
                          ),
                          "strong": Style(
                              color: CustomTheme.primary,
                              fontSize: FontSize(18),
                              fontWeight: FontWeight.normal),
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void downLoadResource() {
    if (item.file.isNotEmpty) {
      _downloadDocument(item.file);
    } else if (item.photo.isNotEmpty) {
      _downloadDocument(item.photo);
    } else {
      Get.snackbar('No Resource', 'No resource to download.');
    }
  }

  Widget _buildContentWidget() {
    return CachedNetworkImage(
      imageUrl: item.getLogo(),
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => ShimmerLoadingWidget(
        height: 220,
      ),
      errorWidget: (context, url, error) => const Image(
        image: AssetImage('assets/images/logo.png'),
        fit: BoxFit.contain,
        width: double.infinity,
        height: 200,
      ),
    );
  }

  String? extractVideoId(String youtubeUrl) {
    final Uri uri = Uri.parse(youtubeUrl);

    if (uri.host == 'youtu.be') {
      return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : null;
    }

    if (uri.host == 'www.youtube.com' || uri.host == 'youtube.com') {
      if (uri.queryParameters.containsKey('v')) {
        return uri.queryParameters['v'];
      }

      if (uri.pathSegments.isNotEmpty && uri.pathSegments.first == 'embed') {
        return uri.pathSegments.length > 1 ? uri.pathSegments[1] : null;
      }
    }

    return null;
  }
}

Future<void> _downloadDocument(String filePathFromResponse) async {
  // Extract the filename from the file path
  final fileName = filePathFromResponse.split('/').last;

  // Join the base URL with the file path to get the full download URL
  const baseUrl = 'https://unified.m-omulimisa.com/storage/';
  final fullUrl = baseUrl + filePathFromResponse;
}
