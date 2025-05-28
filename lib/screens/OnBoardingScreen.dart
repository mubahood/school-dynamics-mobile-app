import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:schooldynamics/models/LoggedInUserModel.dart';
import 'package:schooldynamics/screens/account/login_screen.dart';

import '../../../theme/app_theme.dart';
import '../controllers/MainController.dart';
import '../utils/AppConfig.dart';
import '../utils/Utils.dart';
import '../utils/my_widgets.dart';
import 'account/ConfirmCreateNewSchoolAccountScreen.dart';
import 'account/EmailVerificationScreen.dart';
import 'account/EnterpriseRegisterScreen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    futureInit = my_init();
    super.initState();
    AppTheme.init();
  }

  late Future<dynamic> futureInit;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: CustomTheme.primary));

      return SafeArea(
        child: Scaffold(
          body: FutureBuilder(
              future: futureInit,
              builder: (context, snapshot) {
                if (ready_to_create_ent == 'Yes') {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          FxText.titleLarge(
                              "Congrats! You are ready to register your school!",
                              textAlign: TextAlign.center,
                              fontWeight: 900,
                              color: Colors.green.shade700),
                          const SizedBox(
                            height: 20,
                          ),
                          Divider(
                            height: 2,
                            color: Colors.grey,
                            indent: Get.width * 0.3,
                            endIndent: Get.width * 0.3,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FxText.bodyMedium(
                              "You have successfully created and verified school admin account. Now you are ready to register your school and start using the system."),
                          const SizedBox(
                            height: 25,
                          ),
                          FxButton.block(
                            onPressed: () {
                              Get.to(() => EnterpriseModelEditScreen(const {}));
                            },
                            child: FxText.titleMedium(
                              "Register School".toUpperCase(),
                              color: Colors.white,
                              fontWeight: 900,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FxButton.text(
                            onPressed: () {
                              //are you sure you want to logout
                              Get.dialog(AlertDialog(
                                title: const Text("Logout"),
                                content: const Text(
                                    "Are you sure you want to logout?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await Utils.logout();
                                      Get.to(() => const OnBoardingScreen(),
                                          preventDuplicates: false);
                                    },
                                    child: const Text("Logout"),
                                  ),
                                ],
                              ));
                            },
                            child: FxText.titleMedium("Logout",
                                color: CustomTheme.accent, fontWeight: 900),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (account_not_verified == 'Yes') {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          FxText.titleLarge("Email not verified"),
                          const SizedBox(
                            height: 20,
                          ),
                          Divider(
                            height: 2,
                            color: Colors.grey,
                            indent: Get.width * 0.3,
                            endIndent: Get.width * 0.3,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FxText.bodyMedium(
                              "Your email (${logged_in_user.email}) is not verified. Please verify your email to continue."),
                          const SizedBox(
                            height: 50,
                          ),
                          FxButton.block(
                            onPressed: () {
                              Get.to(() => EmailVerificationScreen(
                                    logged_in_user,
                                    'VERIFY_EMAIL',
                                  ));
                            },
                            child: FxText.titleMedium(
                              "Verify Email",
                              color: Colors.white,
                              fontWeight: 900,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          FxButton.text(
                            onPressed: () {
                              //are you sure you want to logout
                              Get.dialog(AlertDialog(
                                title: const Text("Logout"),
                                content: const Text(
                                    "Are you sure you want to logout?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await Utils.logout();
                                      Get.to(() => const OnBoardingScreen(),
                                          preventDuplicates: false);
                                    },
                                    child: const Text("Logout"),
                                  ),
                                ],
                              ));
                            },
                            child: FxText.titleMedium("Logout",
                                color: CustomTheme.accent, fontWeight: 900),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (is_not_logged_in != 'Yes') {
                  return Center(
                    child: InkWell(
                      onTap: () {
                        re_load();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                              image: AssetImage(
                                AppConfig.logo,
                              ),
                              fit: BoxFit.cover,
                              width: 200),
                          const SizedBox(
                            height: 50,
                          ),
                          const Text("⌛ Loading...")
                        ],
                      ),
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 50,
                                ),
                                Image(
                                    image: AssetImage(
                                      AppConfig.logo,
                                    ),
                                    fit: BoxFit.cover,
                                    width: 100),
                                FxText("Login to continue"),
                                const SizedBox(
                                  height: 50,
                                ),
                                //icon button
                                true
                                    ? SizedBox()
                                    : MyButtonIcon(
                                  "Continue with Google",
                                  Utils.icon('google.png'),
                                  () async {
                                          final GoogleSignIn googleSignIn =
                                              GoogleSignIn();
                                          if (googleSignIn.currentUser !=
                                              null) {
                                            Utils.toast("Good to go");
                                      return;
                                    }
                                    final GoogleSignInAccount? googleUser;
                                    try {
                                            googleUser =
                                                await googleSignIn.signIn();
                                          } catch (e) {
                                      print(e.toString());
                                      Utils.toast("failed because Google Sign In because of $e");
                                      return;
                                    }

                                    if (googleUser == null) {
                                      Utils.toast("failed because Google Sign In is null");
                                      return;
                                    }
                                          final GoogleSignInAuthentication
                                              googleAuth =
                                              await googleUser.authentication;
                                          final credential = GoogleAuthProvider.credential(
                                      accessToken: googleAuth.accessToken,
                                      idToken: googleAuth.idToken,
                                    );
                                    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
                                    final User? user = userCredential.user;
                                    if (user == null) {
                                      Utils.toast("failed because User is null");
                                      return;
                                    }

                                    Utils.toast("===> DP NAME: ${user.displayName}");
                                    Utils.toast("===> DP EMAIL: ${user.email}");
                                    Utils.toast("===> DP PHOTO: ${user.photoURL}");
                                    Utils.toast("===> DP PHONE: ${user.phoneNumber}");
                                    Utils.toast("===> DP UID: ${user.uid}");
                                    Utils.toast("===> DP TOKEN: ${user.refreshToken}");
                                    Utils.toast("===> DP TOKEN: ${user.getIdToken()}");

                                    return;

                                   /* //create userCredential
                                    final UserCredential userCredential = await GoogleSignInProvider().signInWithGoogle();
                                    // Handle successful sign-in
                                    if (userCredential != null) {
                                      final User? user = userCredential.user;
                                      if (user != null) {
                                        print("===> DP NAME: ${user.displayName}");
                                        print("===> DP EMAIL: ${user.email}");
                                        print("===> DP PHOTO: ${user.photoURL}");
                                        print("===> DP PHONE: ${user.phoneNumber}");
                                        print("===> DP UID: ${user.uid}");
                                        print("===> DP TOKEN: ${user.refreshToken}");
                                        print("===> DP TOKEN: ${user.getIdToken()}");
                                      } else {
                                        print("===> DP NAME: NULL");
                                      }
                                    } else {
                                      // Handle sign-in errors
                                      print("===> DP NAME: NULL");
                                    }
                                    return;

                                    //Navigator.pushNamed(context, AppConfig.Login);

                                    final GoogleSignInProvider googleSignInProvider = GoogleSignInProvider();

                                    if (googleSignInProvider == null) {
                                      return;
                                    }


                                    try {
                                      final UserCredential userCredential = await googleSignInProvider.signInWithGoogle();
                                      // Handle successful sign-in (e.g., navigate to the home screen)
                                      if(userCredential.user!= null){
                                        print("===> DP NAME: ${userCredential.user!.displayName}");
                                        print("===> DP EMAIL: ${userCredential.user!.email}");
                                        print("===> DP PHOTO: ${userCredential.user!.photoURL}");
                                        print("===> DP PHONE: ${userCredential.user!.phoneNumber}");
                                        print("===> DP UID: ${userCredential.user!.uid}");
                                        print("===> DP TOKEN: ${userCredential.user!.refreshToken}");
                                        print("===> DP TOKEN: ${userCredential.user!.getIdToken()}");
                                      }else{
                                        print("===> DP NAME: NULL");
                                      }
                                    } catch (e) {
                                      // Handle sign-in errors
                                    }*/
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                MyButtonIcon(
                                  "Use Email or Phone Number",
                                  Utils.icon('user.png'),
                                  () {
                                    Get.to(() => const LoginScreen());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const Divider(
                        height: 2,
                        color: Colors.grey,
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("New School? ",
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            const SizedBox(
                              height: 2,
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(() =>
                                    const ConfirmCreateNewSchoolAccountScreen());
                              },
                              child: Text(
                                "Create New School Account",
                                style: TextStyle(
                                  color: CustomTheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  );
                }
              }),
        ),
      );
    });
  }

  String is_not_logged_in = "";
  String account_not_verified = "";
  String ready_to_create_ent = "";
  Future<dynamic> my_init() async {
    Get.put(MainController());
    String token = await Utils.getToken();
    if (token.toString().length < 20) {
      is_not_logged_in = "Yes";
      setState(() {});
      return;
    }

    logged_in_user = (await LoggedInUserModel.getLoggedInUser());

    if (logged_in_user.id < 1) {
      is_not_logged_in = "Yes";
      setState(() {});
      return;
    }

    await Utils.init_theme();
    Utils.boot_system();
    Utils.initOneSignal(logged_in_user);

    if (logged_in_user.enterprise_id == '1' &&
        logged_in_user.verification == '1' &&
        logged_in_user.user_type.toLowerCase() == 'employee') {
      ready_to_create_ent = "Yes";
      setState(() {});
      return;
    }

    if (logged_in_user.verification != '1' &&
        logged_in_user.user_type.toLowerCase() == 'employee') {
      account_not_verified = "Yes";
      setState(() {});
      return;
    }

    Navigator.pushNamedAndRemoveUntil(context, AppConfig.FullApp, (r) => false);

    return "Done";
  }

  bool is_loading = true;
  LoggedInUserModel logged_in_user = LoggedInUserModel();

  void re_load() {
    setState(() {
      futureInit = my_init();
    });
  }
}
