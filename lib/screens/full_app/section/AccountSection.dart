import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/theme/app_theme.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../OnBoardingScreen.dart';

class AccountSection extends StatefulWidget {
  const AccountSection({Key? key}) : super(key: key);

  @override
  _AccountSectionState createState() => _AccountSectionState();
}

class _AccountSectionState extends State<AccountSection> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildSingleRow(String name, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
        ),
        FxSpacing.width(20),
        Expanded(
            child: FxText.bodyMedium(
          name,
          fontWeight: 600,
        )),
        FxSpacing.width(20),
        Icon(
          FeatherIcons.chevronRight,
          size: 20,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding:
            FxSpacing.fromLTRB(20, FxSpacing.safeAreaTop(context) + 20, 20, 20),
        children: [
          FxText.bodySmall(
            'ACCOUNT',
            fontWeight: 700,
            letterSpacing: 0.2,
            muted: true,
          ),
          FxSpacing.height(20),
          Row(
            children: [
              Icon(
                FeatherIcons.user,
                size: 20,
                color: CustomTheme.primary,
              ),
              FxSpacing.width(20),
              Expanded(child: FxText.bodyMedium('My account', fontWeight: 600)),
              FxSpacing.width(20),
              FxContainer(
                onTap: () {
                  do_logout();
                },
                padding: FxSpacing.xy(20, 8),
                borderRadiusAll: 4,
                color: CustomTheme.primary,
                child: FxText.bodySmall(
                  'Log Out',
                  fontWeight: 700,
                  letterSpacing: 0.3,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          FxSpacing.height(20),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  FeatherIcons.userCheck,
                  size: 20,
                  color: CustomTheme.primary,
                ),
                FxSpacing.width(20),
                FxText.bodyMedium('Edit profile',
                    color: CustomTheme.primary, fontWeight: 600),
              ],
            ),
          ),
        /*  FxSpacing.height(20),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  FeatherIcons.key,
                  size: 20,
                  color: CustomTheme.primary,
                ),
                FxSpacing.width(20),
                FxText.bodyMedium(
                  'Change password',
                  fontWeight: 600,
                ),
              ],
            ),
          ),
          FxSpacing.height(20),
          FxText.bodySmall(
            'MY CONTENT & ACTIVITY',
            fontWeight: 700,
            letterSpacing: 0.2,
            muted: true,
          ),
          FxSpacing.height(20),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  FeatherIcons.plus,
                  size: 20,
                  color: CustomTheme.primary,
                ),
                FxSpacing.width(20),
                Expanded(
                    child: FxText.bodyMedium(
                  'Post drugs for sale',
                  fontWeight: 600,
                )),
                FxSpacing.width(20),
                FxSpacing.width(4),
                Icon(
                  FeatherIcons.chevronRight,
                  size: 20,
                  color: CustomTheme.primary,
                ),
              ],
            ),
          ),
          FxSpacing.height(20),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  FeatherIcons.file,
                  size: 20,
                  color: CustomTheme.primary,
                ),
                FxSpacing.width(20),
                Expanded(
                    child: FxText.bodyMedium(
                  'Draft cases',
                  fontWeight: 600,
                )),
                FxSpacing.width(20),
                FxContainer(
                  color: Colors.red.shade700,
                  paddingAll: 3,
                  borderRadiusAll: 50,
                  child: FxText.bodyMedium(
                    '${32}',
                    color: Colors.white,
                    fontWeight: 600,
                    muted: true,
                  ),
                ),
                FxSpacing.width(4),
                Icon(
                  FeatherIcons.chevronRight,
                  size: 20,
                ),
              ],
            ),
          ),
          FxSpacing.height(20),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  FeatherIcons.file,
                  size: 20,
                  color: CustomTheme.primary,
                ),
                FxSpacing.width(20),
                Expanded(
                    child: FxText.bodyMedium(
                  'Draft cases',
                  fontWeight: 600,
                )),
                FxSpacing.width(20),
                FxContainer(
                  color: Colors.red.shade700,
                  paddingAll: 3,
                  borderRadiusAll: 50,
                  child: FxText.bodyMedium(
                    '${32}',
                    color: Colors.white,
                    fontWeight: 600,
                    muted: true,
                  ),
                ),
                FxSpacing.width(4),
                Icon(
                  FeatherIcons.chevronRight,
                  size: 20,
                ),
              ],
            ),
          ),
          FxSpacing.height(20),
          FxText.bodySmall(
            'MY ROLES & PROFILES',
            fontWeight: 700,
            letterSpacing: 0.2,
            muted: true,
          ),
          FxSpacing.height(20),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  FeatherIcons.award,
                  size: 20,
                  color: CustomTheme.primary,
                ),
                FxSpacing.width(20),
                Expanded(
                    child: FxText.bodyMedium(
                  'My roles',
                  fontWeight: 600,
                )),
                Icon(
                  FeatherIcons.chevronRight,
                  size: 20,
                  color: CustomTheme.primary,
                ),
              ],
            ),
          ),
          FxSpacing.height(20),
          InkWell(
            onTap: () {},
            child: Row(
              children: [
                Icon(
                  FeatherIcons.checkCircle,
                  size: 20,
                  color: CustomTheme.primary,
                ),
                FxSpacing.width(20),
                Expanded(
                    child: FxText.bodyMedium(
                  'My veterinary profile',
                  fontWeight: 600,
                )),
                Icon(
                  FeatherIcons.chevronRight,
                  size: 20,
                  color: CustomTheme.primary,
                ),
              ],
            ),
          ),
          FxSpacing.height(20),
          Divider(
            thickness: 0.8,
          ),
          FxSpacing.height(10),
          FxContainer(
            color: CustomTheme.primary.withAlpha(28),
            borderRadiusAll: 4,
            child: FxText.bodyMedium(
              "© 2023 U-LITS, Uganda Livestock Traceability System",
              textAlign: TextAlign.center,
              fontWeight: 700,
              letterSpacing: 0.2,
              color: CustomTheme.primaryDark,
            ),
          ),*/
        ],
      ),
    );
  }

  Future<void> do_logout() async {
    /* u = await Utils.get_logged_user();
    print(u.roles);
    return;

    return;
    */
    await Utils.logout();
    Get.off(OnBoardingScreen());
    return;
  }
}
