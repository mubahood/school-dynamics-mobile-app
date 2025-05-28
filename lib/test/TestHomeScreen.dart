import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/theme/app_theme.dart';


class TestHomeScreen extends StatelessWidget {
  const TestHomeScreen({super.key});

  @override
  Widget build(context) {
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final Controller c = Get.put(Controller());

    return Scaffold(
        appBar: AppBar(
            title: Obx(
          () => FxText(
            "Clicks: ${c.count}",
            color: CustomTheme.primary,
          ),
        )),

        // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
        body: Center(
            child: ElevatedButton(
                child: const Text("Go to Other"),
                onPressed: () => Get.to(const OtherScreen()))),
        floatingActionButton: FloatingActionButton(
            onPressed: c.increment,
            child: const Icon(Icons.add)));
  }
}

class OtherScreen extends StatelessWidget {
  const OtherScreen({super.key});

  @override
  Widget build(context) {
    // Instantiate your class using Get.put() to make it available for all "child" routes there.
    final Controller c = Get.find();

    return WillPopScope(
      onWillPop: () async {
        print("pressed");
        return true;
      },
      child: Scaffold(
          appBar: AppBar(
              title: Obx(
            () => FxText(
              "Clicks: ${c.count} OtherScreen",
              color: CustomTheme.primary,
            ),
          )),

          // Replace the 8 lines Navigator.push by a simple Get.to(). You don't need context
          body: const Center(
              child: Column(
            children: [

            ],
          )),
          floatingActionButton: FloatingActionButton(
              onPressed: c.decrement,
              child: const Icon(Icons.add))),
    );
  }
}

class Controller extends GetxController {
  var count = 0.obs;

  increment() => count++;

  decrement() => count--;
}
