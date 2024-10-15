import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:schooldynamics/theme/app_theme.dart';
import 'package:schooldynamics/utils/Utils.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

/// Represents PdfViewerScreen for Navigation
class PdfViewerScreen extends StatefulWidget {
  String url, title;

  PdfViewerScreen(this.url, this.title, {super.key});

  @override
  _PdfViewerScreen createState() => _PdfViewerScreen();
}

class _PdfViewerScreen extends State<PdfViewerScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.primary,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        systemOverlayStyle: Utils.get_theme(),
        centerTitle: false,
        title: FxText.titleLarge(
          widget.title,
          fontSize: 20,
          fontWeight: 900,
          color: Colors.white,
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.download,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              Utils.launchURL(widget.url);
              //_pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.url,
        currentSearchTextHighlightColor: CustomTheme.primary,
        key: _pdfViewerKey,
        enableDocumentLinkAnnotation: true,
        enableDoubleTapZooming: true,
        enableHyperlinkNavigation: true,
        enableTextSelection: true,
      ),
    );
  }
}
