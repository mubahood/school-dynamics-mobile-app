import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class AnalyzeImageFromGalleryButton extends StatelessWidget {
  Function onSuccessfulScan;

  AnalyzeImageFromGalleryButton(this.onSuccessfulScan,
      {required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 5,
        ),
        IconButton(
          color: Colors.white,
          icon: const Icon(Icons.image),
          iconSize: 32.0,
          onPressed: () async {
            final ImagePicker picker = ImagePicker();

            final XFile? image = await picker.pickImage(
              source: ImageSource.gallery,
            );

            if (image == null) {
              return;
            }

            final BarcodeCapture? barcodes = await controller.analyzeImage(
              image.path,
            );

            if (!context.mounted) {
              return;
            }

            if (barcodes != null) {
              if (barcodes.barcodes.isNotEmpty) {
                if (barcodes.barcodes.firstOrNull != null) {
                  if (barcodes.barcodes.firstOrNull!.displayValue != null) {
                    onSuccessfulScan(
                        barcodes.barcodes.firstOrNull!.displayValue.toString());
                    return;
                  }
                }
              }
            }

            final SnackBar snackbar = barcodes != null
                ? const SnackBar(
                    content: Text('Barcode found!'),
                    backgroundColor: Colors.green,
                  )
                : const SnackBar(
                    content: Text('No code found!'),
                    backgroundColor: Colors.red,
                  );

            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          },
        ),
        FxText(
          'Pick\nFrom Gallery',
          fontSize: 12,
          height: 1,
          textAlign: TextAlign.center,
          color: Colors.white,
          fontWeight: 900,
        ),
      ],
    );
  }
}

class StartStopMobileScannerButton extends StatelessWidget {
  const StartStopMobileScannerButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return FxContainer(
            color: Colors.black,
            paddingAll: 5,
            child: Column(
              children: [
                const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 35,
                ),
                FxText(
                  'Start Scanning',
                  fontSize: 12,
                  height: 1,
                  color: Colors.white,
                  fontWeight: 900,
                ),
              ],
            ),
            onTap: () async {
              await controller.start();
            },
          );
        }

        return FxContainer(
          color: Colors.black,
          paddingAll: 5,
          child: Column(
            children: [
              const Icon(
                Icons.stop,
                color: Colors.white,
                size: 35,
              ),
              FxText(
                'Stop Scanning',
                fontSize: 12,
                height: 1,
                color: Colors.white,
                fontWeight: 900,
              ),
            ],
          ),
          onTap: () async {
            await controller.stop();
          },
        );
      },
    );
  }
}

class SwitchCameraButton extends StatelessWidget {
  const SwitchCameraButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        final int? availableCameras = state.availableCameras;

        if (availableCameras != null && availableCameras < 2) {
          return const SizedBox.shrink();
        }

        final Widget icon;

        switch (state.cameraDirection) {
          case CameraFacing.front:
            icon = const Icon(
              Icons.camera_front,
              color: Colors.white,
            );
          case CameraFacing.back:
            icon = const Icon(
              Icons.camera_rear,
              color: Colors.white,
            );
        }

        return FxContainer(
          color: Colors.black,
          paddingAll: 5,
          child: Column(
            children: [
              const SizedBox(
                height: 15,
              ),
              icon,
              FxText(
                'Switch Camera',
                fontSize: 12,
                height: 1,
                color: Colors.white,
                fontWeight: 900,
              ),
            ],
          ),
          onTap: () async {
            await controller.switchCamera();
          },
        );

        return IconButton(
          color: Colors.white,
          iconSize: 32.0,
          icon: icon,
          onPressed: () async {
            await controller.switchCamera();
          },
        );
      },
    );
  }
}

class ToggleFlashlightButton extends StatelessWidget {
  const ToggleFlashlightButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {

        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        switch (state.torchState) {
          case TorchState.auto:
            return FxContainer(
              color: Colors.black,
              paddingAll: 5,
              child: Column(
                children: [
                  const Icon(
                    Icons.flash_auto,
                    color: Colors.white,
                    size: 35,
                  ),
                  FxText(
                    'light auto',
                    fontSize: 12,
                    height: 1,
                    color: Colors.white,
                    fontWeight: 900,
                  ),
                ],
              ),
              onTap: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.off:
            return FxContainer(
              color: Colors.black,
              paddingAll: 5,
              child: Column(
                children: [
                  const Icon(
                    Icons.flash_off,
                    color: Colors.white,
                    size: 35,
                  ),
                  FxText(
                    'light off',
                    fontSize: 12,
                    height: 1,
                    color: Colors.white,
                    fontWeight: 900,
                  ),
                ],
              ),
              onTap: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.on:
            return FxContainer(
              color: Colors.black,
              paddingAll: 5,
              child: Column(
                children: [
                  const Icon(
                    Icons.flash_on,
                    color: Colors.white,
                    size: 35,
                  ),
                  FxText(
                    'light on',
                    fontSize: 12,
                    height: 1,
                    color: Colors.white,
                    fontWeight: 900,
                  ),
                ],
              ),
              onTap: () async {
                await controller.toggleTorch();
              },
            );
          case TorchState.unavailable:
            return FxContainer(
              color: Colors.black,
              paddingAll: 5,
              child: Column(
                children: [
                  const Icon(
                    Icons.no_flash,
                    color: Colors.white,
                    size: 35,
                  ),
                  FxText(
                    'no light',
                    fontSize: 12,
                    height: 1,
                    color: Colors.white,
                    fontWeight: 900,
                  ),
                ],
              ),
            );
        }
      },
    );
  }
}
