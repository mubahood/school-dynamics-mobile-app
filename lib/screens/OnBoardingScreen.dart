import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:schooldynamics/models/LoggedInUserModel.dart';

import '../../../theme/app_theme.dart';
import '../controllers/MainController.dart';
import '../utils/AppConfig.dart';
import '../utils/Utils.dart';
import '../utils/my_widgets.dart';
import 'google_sign_in.dart';

class OnBoardingScreen extends StatefulWidget {
  OnBoardingScreen({Key? key}) : super(key: key);

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
                          child: Container(
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
                                MyButtonIcon(
                                  "Continue with Google",
                                  Utils.icon('google.png'),
                                  () async {

                                    final GoogleSignIn _googleSignIn = GoogleSignIn();
                                    if (_googleSignIn == null){
                                      Utils.toast("Google Sign In is null");
                                      return;
                                    }
                                    if(_googleSignIn.currentUser != null){
                                      Utils.toast("Good to go");
                                      return;
                                    }
                                    final GoogleSignInAccount? googleUser;
                                    try {
                                      googleUser = await _googleSignIn.signIn();
                                    } catch (e) {
                                      print("===> DP ERROR: $e");
                                      Utils.toast("failed because Google Sign In because of $e");
                                      return;
                                    }

                                    if (googleUser == null) {
                                      Utils.toast("failed because Google Sign In is null");
                                      return;
                                    }
                                    final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
                                    if (googleAuth == null) {
                                      Utils.toast("failed because Google Sign In Auth is null");
                                      return;
                                    }
                                    final credential = GoogleAuthProvider.credential(
                                      accessToken: googleAuth.accessToken,
                                      idToken: googleAuth.idToken,
                                    );
                                    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
                                    if (userCredential == null) {
                                      Utils.toast("failed because User Credential is null");
                                      return;
                                    }
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
                                    //Navigator.pushNamed(context, AppConfig.Login);
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Don't have account? ",
                                style: TextStyle(
                                  color: Colors.grey,
                                )),
                            InkWell(
                              onTap: () {
                                //Navigator.pushNamed(context, AppConfig.Register);
                              },
                              child: Text(
                                "Create Account",
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
  Future<dynamic> my_init() async {
    String token = await Utils.getToken();
    if (token.toString().length < 20) {
      is_not_logged_in = "Yes";
      setState(() {});
/*      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));*/
      return;
    }

    logged_in_user = (await LoggedInUserModel.getLoggedInUser());

    if (logged_in_user.id < 1) {
      is_not_logged_in = "Yes";
      setState(() {});
      /*Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));*/
      return;
    }
    Get.put(MainController());
    await Utils.init_theme();
    Utils.boot_system();
    Utils.initOneSignal(logged_in_user);
    Navigator.pushNamedAndRemoveUntil(context, AppConfig.FullApp, (r) => false);

    return "Done";
  }

  bool is_loading = true;
  LoggedInUserModel logged_in_user = new LoggedInUserModel();

  void re_load() {
    setState(() {
      futureInit = my_init();
    });
  }
}
