import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../utils/Utils.dart';

class QRCodeCutScannerScreen extends StatefulWidget {
  final Function(String) onSuccess;

  QRCodeCutScannerScreen(this.onSuccess, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRCodeCutScannerScreenState();
}

class _QRCodeCutScannerScreenState extends State<QRCodeCutScannerScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool isLoading = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Column(
      children: [
        Expanded(flex: 4, child: _buildQrView(context)),
        Expanded(
          flex: 1,
          child: FittedBox(
            fit: BoxFit.contain,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 15),
                if (result != null)
                  Text('Data: ${result!.code}')
                else
                  const Text('SCAN QR CODE or BAR CODE'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FxButton.small(
                      onPressed: () async {
                        await controller?.toggleFlash();
                        setState(() {});
                      },
                      borderRadiusAll: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: FutureBuilder<bool?>(
                        future: controller?.getFlashStatus(),
                        builder: (context, snapshot) {
                          final isOn = snapshot.data == true;
                          return FxText.bodySmall(
                            'Flash: ${isOn ? 'on' : 'off'}',
                            color: Colors.white,
                            fontSize: 10,
                          );
                        },
                      ),
                    ),
                    FxButton.small(
                      onPressed: () async {
                        await controller?.flipCamera();
                        setState(() {});
                      },
                      borderRadiusAll: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: FutureBuilder<CameraFacing?>(
                        future: controller?.getCameraInfo(),
                        builder: (context, snapshot) {
                          final facing = snapshot.data;
                          return FxText(
                            'Camera: ${facing != null ? describeEnum(facing) : 'loading'}',
                            color: Colors.white,
                            fontSize: 10,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async => controller?.resumeCamera(),
                      child: const Text('SCAN', style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQrView(BuildContext context) {
    final scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
        borderColor: Colors.red,
        borderRadius: 10,
        borderLength: 30,
        borderWidth: 10,
        cutOutSize: scanArea,
      ),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (result == null) {
        setState(() => result = scanData);
        await controller.pauseCamera();
        widget.onSuccess(scanData.code ?? '');
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    Utils.log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No camera permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}