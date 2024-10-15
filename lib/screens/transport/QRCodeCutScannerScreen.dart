import 'package:flutter/cupertino.dart';

class QRCodeCutScannerScreen extends StatelessWidget {
  const QRCodeCutScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


/*
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../utils/Utils.dart';

class QRCodeCutScannerScreen extends StatefulWidget {
  Function on_success;

  QRCodeCutScannerScreen(this.on_success, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRCodeCutScannerScreenState();
}

class _QRCodeCutScannerScreenState extends State<QRCodeCutScannerScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Column(
        children: <Widget>[
              Expanded(flex: 4, child: _buildQrView(context)),
              Expanded(
                flex: 1,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                  const SizedBox(
                    height: 15,
                      ),
                      if (result != null)
                        Text('Data: ${result!.code}')
                  else
                        const Text('SCAN QR CODE or BAR CODE'),
                  true
                      ? SizedBox()
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 15, right: 15),
                            child: FxButton.small(
                              onPressed: () async {
                                await controller?.toggleFlash();
                                setState(() {});
                              },
                              borderRadiusAll: 100,
                              padding: const EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: 15,
                              ),
                              child: FutureBuilder(
                                future: controller?.getFlashStatus(),
                                builder: (context, snapshot) {
                                  return FxText.bodySmall(
                                    'Flash: ${snapshot.data.toString().toLowerCase() == 'true' ? 'on' : 'off'}',
                                    color: Colors.white,
                                    fontWeight: 100,
                                    fontSize: 10,
                                  );
                                },
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(8),
                            child: FxButton.small(
                                onPressed: () async {
                                  await controller?.flipCamera();
                                  setState(() {});
                                },
                                borderRadiusAll: 100,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 0,
                                  horizontal: 15,
                                ),
                                child: FutureBuilder(
                                  future: controller?.getCameraInfo(),
                                  builder: (context, snapshot) {
                                    if (snapshot.data != null) {
                                      return FxText(
                                        'Camera: ${describeEnum(snapshot.data!)}',
                                        color: Colors.white,
                                        fontWeight: 100,
                                        fontSize: 10,
                                      );
                                    } else {
                                      return const Text('loading');
                                    }
                                  },
                                )),
                          )
                        ],
                      ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                      true
                          ? SizedBox()
                          : Container(
                              margin: const EdgeInsets.all(8),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      await controller?.pauseCamera();
                                    },
                                    child: const Text('pause',
                                        style: TextStyle(fontSize: 20)),
                                  ),
                                ),
                      Container(
                        margin: const EdgeInsets.all(8),
                        child: ElevatedButton(
                                    onPressed: () async {
                            try {
                              await controller?.resumeCamera();
                            } catch (e) {
                              Utils.log(e.toString());
                            }
                          },
                          child: const Text('SCAN',
                              style: TextStyle(fontSize: 20)),
                        ),
                                )
                              ],
                            ),
                    ],
                  ),
                ),
              )
            ],
          );
    }
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  bool isLoading = false;
  String id = '';

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() async {
        result = scanData;
        if (result != null) {
          await controller.pauseCamera();
          widget.on_success(result!.code.toString());
        }
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    Utils.log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
*/
