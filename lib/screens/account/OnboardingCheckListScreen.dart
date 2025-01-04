import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/screens/account/EnterpriseUpdateScreen.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../controllers/MainController.dart';
import '../../theme/custom_theme.dart';
import '../employees/EmployeesScreen.dart';

class OnboardingCheckListScreen extends StatefulWidget {
  OnboardingCheckListScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingCheckListScreen> createState() =>
      _OnboardingCheckListScreenState();
}

class _OnboardingCheckListScreenState extends State<OnboardingCheckListScreen> {
  final MainController main = Get.find<MainController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: Utils.overlay(),
        backgroundColor: CustomTheme.primary,
        title: const Text('Checklist'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image(
                image: AssetImage(
                  Utils.icon('checklist.png'),
                ),
                height: 85,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Important Steps',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: CustomTheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'You should complete the following steps to set up your school account.',
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 20),
            Divider(
              color: CustomTheme.primary,
              thickness: 4,
              indent: Get.width * .25,
              endIndent: Get.width * .25,
            ),
            const SizedBox(height: 8),
            ListTile(
              dense: true,
              onTap: () async {
                await Get.to(() => EnterpriseUpdateScreen({'item': main.ent}));
                main.getEnt();
                setState(() {});
              },
              contentPadding: EdgeInsets.zero,
              leading: main.ent.type.length > 2
                  ? Icon(
                      Icons.check_circle,
                      size: 35,
                      color: CustomTheme.primary,
                    )
                  : Icon(
                      Icons.circle_outlined,
                      size: 35,
                      color: Colors.grey.shade600,
                    ),
              title: FxText.titleMedium(
                '1. Basic School Information',
                fontWeight: 800,
              ),
              subtitle: FxText.bodySmall(
                'Set all details of your school.',
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 28,
                color: main.ent.type.length > 2
                    ? CustomTheme.primary
                    : Colors.grey.shade600,
              ),
            ),
            ListTile(
              dense: true,
              onTap: () {
                Get.to(EmployeesScreen(const {
                  'task': 'ADD',
                }));
              },
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.circle_outlined,
                size: 35,
                color: Colors.grey.shade600,
              ),
              title: FxText.titleMedium(
                '2. Add Teachers',
                fontWeight: 800,
              ),
              subtitle: FxText.bodySmall(
                'Add teachers to your school.',
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 28,
                color: Colors.grey.shade600,
              ),
            ),
            //manage subjects
            ListTile(
              dense: true,
              onTap: () {
                // Get.to(UserAccountCreateScreen());
              },
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.circle_outlined,
                size: 35,
                color: Colors.grey.shade600,
              ),
              title: FxText.titleMedium(
                '3. Manage Subjects',
                fontWeight: 800,
              ),
              subtitle: FxText.bodySmall(
                'Set subjects and teachers of different classes.',
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 28,
                color: Colors.grey.shade600,
              ),
            ),
            //set school fees
            ListTile(
              dense: true,
              onTap: () {
                // Get.to(UserAccountCreateScreen());
              },
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.circle_outlined,
                size: 35,
                color: Colors.grey.shade600,
              ),
              title: FxText.titleMedium(
                '4. Set School Fees',
                fontWeight: 800,
              ),
              subtitle: FxText.bodySmall(
                'Set fees for different classes.',
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 28,
                color: Colors.grey.shade600,
              ),
            ),
            //add students
            ListTile(
              dense: true,
              onTap: () {
                // Get.to(UserAccountCreateScreen());
              },
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.circle_outlined,
                size: 35,
                color: Colors.grey.shade600,
              ),
              title: FxText.titleMedium(
                '5. Add Students',
                fontWeight: 800,
              ),
              subtitle: FxText.bodySmall(
                'Add students to your school.',
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 28,
                color: Colors.grey.shade600,
              ),
            ),
            //watch videos and learn
            ListTile(
              dense: true,
              onTap: () {
                // Get.to(UserAccountCreateScreen());
              },
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                Icons.circle_outlined,
                size: 35,
                color: Colors.grey.shade600,
              ),
              title: FxText.titleMedium(
                '6. Watch Videos and Learn',
                fontWeight: 800,
              ),
              subtitle: FxText.bodySmall(
                'Watch videos to learn how to use the app.',
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 28,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Get.to(UserAccountCreateScreen());
                },
                child: const Text('Get Started',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomTheme.primary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 15,
                  ),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
