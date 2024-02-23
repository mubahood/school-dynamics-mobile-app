import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/EnterpriseModel.dart';

import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';

class AboutSchoolScreen extends StatelessWidget {
  final EnterpriseModel item;

  const AboutSchoolScreen({super.key, required this.item});

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
                    Center(
                      child: CachedNetworkImage(
                        imageUrl: item.getLogo(),
                        width: Get.width / 3,
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
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 0, top: 10),
                      child: Text(
                        item.name,
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
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Html(
                        data: item.details,
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
}

Future<void> _downloadDocument(String filePathFromResponse) async {
  // Extract the filename from the file path
  final fileName = filePathFromResponse.split('/').last;

  // Join the base URL with the file path to get the full download URL
  const baseUrl = 'https://unified.m-omulimisa.com/storage/';
  final fullUrl = baseUrl + filePathFromResponse;
}
