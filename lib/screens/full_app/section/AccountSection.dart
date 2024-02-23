import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/screens/OnBoardingScreen.dart';
import 'package:schooldynamics/utils/AppConfig.dart';

import '../../../../../../controllers/MainController.dart';
import '../../../theme/custom_theme.dart';
import '../../../utils/Utils.dart';
import '../../account/AboutSchoolScreen.dart';
import '../../account/AboutUsScreen.dart';
import '../../account/AccountChangePassword.dart';
import '../../account/AccountEdit.dart';

class AccountSection extends StatefulWidget {
  const AccountSection({Key? key}) : super(key: key);

  @override
  _AccountSectionState createState() => _AccountSectionState();
}

class _AccountSectionState extends State<AccountSection> {
  late CustomTheme theme;

  @override
  void initState() {
    super.initState();
    theme = CustomTheme();
    myInit();
  }

  final MainController mainController = Get.find<MainController>();

  myInit() async {
    mainController.initialized;
    mainController.init();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        systemOverlayStyle: Utils.overlay(),
        elevation: .5,
        automaticallyImplyLeading: false,
        title: FxText.titleLarge(
          "Account",
          fontWeight: 800,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Icon(
                FeatherIcons.user,
                color: CustomTheme.primary,
              ),
              title: FxText.bodyLarge(
                "Update My Profile",
              ),
              onTap: () {
                Get.to(() => const AccountEdit());
              },
              trailing: Icon(
                FeatherIcons.chevronRight,
                color: CustomTheme.primary,
              ),
            ),
            ListTile(
              title: FxText.bodyLarge(
                "Change Password",
              ),
              onTap: () {
                Get.to(() => const AccountChangePassword());
              },
              leading: Icon(
                FeatherIcons.key,
                color: CustomTheme.primary,
              ),
              trailing: Icon(
                FeatherIcons.chevronRight,
                color: CustomTheme.primary,
              ),
            ),
            ListTile(
              title: FxText.bodyLarge(
                "About ${mainController.ent.name}",
              ),
              leading: Icon(
                FeatherIcons.info,
                color: CustomTheme.primary,
              ),
              onTap: () {
                Get.to(() => AboutSchoolScreen(item: mainController.ent));
              },
              trailing: Icon(
                FeatherIcons.chevronRight,
                color: CustomTheme.primary,
              ),
            ),
            ListTile(
              title: FxText.bodyLarge(
                "Contact ${mainController.ent.name}",
              ),
              leading: Icon(
                FeatherIcons.phoneCall,
                color: CustomTheme.primary,
              ),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 210,
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            ListTile(
                              leading: Icon(
                                FeatherIcons.phone,
                                color: CustomTheme.primary,
                              ),
                              title: FxText.bodyLarge(
                                "Call ${mainController.ent.name}",
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                Utils.launchPhone(
                                    '${mainController.ent.phone_number}');
                              },
                              trailing: Icon(
                                FeatherIcons.chevronRight,
                                color: CustomTheme.primary,
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                FeatherIcons.phone,
                                color: CustomTheme.primary,
                              ),
                              title: FxText.bodyLarge(
                                "Whatsapp ${mainController.ent.name}",
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                //+14379803253
                                Utils.launchBrowser(
                                    'https://wa.me/${mainController.ent.phone_number}?text=Hello%20\n\n');
                              },
                              trailing: Icon(
                                FeatherIcons.chevronRight,
                                color: CustomTheme.primary,
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                FeatherIcons.mail,
                                color: CustomTheme.primary,
                              ),
                              title: FxText.bodyLarge(
                                "Email Us",
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                Utils.launchBrowser(
                                    'mailto:${mainController.ent.email}?subject=Hello\n\n');
                              },
                              trailing: Icon(
                                FeatherIcons.chevronRight,
                                color: CustomTheme.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              trailing: Icon(
                FeatherIcons.chevronRight,
                color: CustomTheme.primary,
              ),
            ),
            const Divider(),
            ListTile(
              title: FxText.bodyLarge(
                "About School Dynamics - App",
              ),
              leading: Icon(
                Icons.info,
                size: 28,
                color: CustomTheme.primary,
              ),
              onTap: () {
                Get.to(() => AboutUsScreen());
              },
              trailing: Icon(
                FeatherIcons.chevronRight,
                color: CustomTheme.primary,
              ),
            ),
            ListTile(
              title: FxText.bodyLarge(
                "Privacy Policy",
              ),
              leading: Icon(
                Icons.info,
                size: 28,
                color: CustomTheme.primary,
              ),
              onTap: () {
                Utils.launchURL(AppConfig.TERMS);
              },
              trailing: Icon(
                FeatherIcons.chevronRight,
                color: CustomTheme.primary,
              ),
            ),
            ListTile(
              title: FxText.bodyLarge(
                "Contact Us",
              ),
              leading: Icon(
                FeatherIcons.phone,
                color: CustomTheme.primary,
              ),
              onTap: () {
                //show bottomsheet with phone call, whatsapp and email
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return Container(
                        height: 210,
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 5,
                            ),
                            ListTile(
                              leading: Icon(
                                FeatherIcons.phone,
                                color: CustomTheme.primary,
                              ),
                              title: FxText.bodyLarge(
                                "Call ${AppConfig.APP_NAME} Team",
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                Utils.launchPhone('${AppConfig.CONTACT_PHONE}');
                              },
                              trailing: Icon(
                                FeatherIcons.chevronRight,
                                color: CustomTheme.primary,
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                FeatherIcons.phone,
                                color: CustomTheme.primary,
                              ),
                              title: FxText.bodyLarge(
                                "Whatsapp ${AppConfig.APP_NAME} Team",
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                //+14379803253
                                Utils.launchBrowser(
                                    'https://wa.me/${AppConfig.CONTACT_PHONE}?text=Hello%20Hambren%20Team\n\n');
                              },
                              trailing: Icon(
                                FeatherIcons.chevronRight,
                                color: CustomTheme.primary,
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                FeatherIcons.mail,
                                color: CustomTheme.primary,
                              ),
                              title: FxText.bodyLarge(
                                "Email Us",
                              ),
                              onTap: () {
                                Navigator.pop(context);
                                Utils.launchBrowser(
                                    'mailto:${AppConfig.CONTACT_EMAIL}?subject=Hello%20Hambren%20Team&body=Hello%20Hambren%20Team\n\n');
                              },
                              trailing: Icon(
                                FeatherIcons.chevronRight,
                                color: CustomTheme.primary,
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
              trailing: Icon(
                FeatherIcons.chevronRight,
                color: CustomTheme.primary,
              ),
            ),
            ListTile(
              title: FxText.bodyLarge(
                "Delete Account",
                color: Colors.red,
              ),
              leading: Icon(
                FeatherIcons.trash2,
                color: Colors.red,
              ),
              onTap: () {
                Get.defaultDialog(
                    middleText:
                        "Are you sure you want to request for your account to be deleted?",
                    titleStyle: const TextStyle(color: Colors.black),
                    actions: <Widget>[
                      FxButton.outlined(
                        onPressed: () {
                          Navigator.pop(context);
                          do_logout();
                          Utils.launchURL(
                              'https://forms.gle/Xpi9wjKxNXDGa57w9');
                        },
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        borderColor: Colors.red,
                        child: FxText(
                          'DELETE ACCOUNT',
                          color: Colors.red,
                        ),
                      ),
                      FxButton.small(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: FxText(
                          'CANCEL',
                          color: Colors.white,
                        ),
                      )
                    ]);
              },
            ),
            ListTile(
              title: FxText.bodyLarge(
                "Logout",
              ),
              leading: Icon(
                FeatherIcons.logOut,
                color: CustomTheme.primary,
              ),
              onTap: () {
                Get.defaultDialog(
                    middleText: "Are you sure you want to logout?",
                    titleStyle: const TextStyle(color: Colors.black),
                    actions: <Widget>[
                      FxButton.outlined(
                        onPressed: () {
                          Navigator.pop(context);
                          do_logout();
                        },
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        borderColor: CustomTheme.primary,
                        child: FxText(
                          'LOGOUT',
                          color: CustomTheme.primary,
                        ),
                      ),
                      FxButton.small(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: FxText(
                          'CANCEL',
                          color: Colors.white,
                        ),
                      )
                    ]);
              },
              trailing: Icon(
                FeatherIcons.chevronRight,
                color: CustomTheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> do_logout() async {
    Utils.logout();
    Utils.toast("Logged you out!");
    Get.offAll(() => OnBoardingScreen());
  }
}
