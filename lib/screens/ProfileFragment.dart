import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/components/ThemeSelectionDaiLog.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/screens/ChangePasswordScreen.dart';
import 'package:booking_system_flutter/screens/EditProfileScreen.dart';
import 'package:booking_system_flutter/screens/SignInScreen.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

import 'AboutScreen.dart';
import 'WishlistScreen.dart';

class ProfileFragment extends StatefulWidget {
  @override
  ProfileFragmentState createState() => ProfileFragmentState();
}

class ProfileFragmentState extends State<ProfileFragment> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Observer(
          builder: (_) => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (appStore.userProfileImage.isNotEmpty) cachedImage(appStore.userProfileImage, height: 65, width: 65, fit: BoxFit.cover).cornerRadiusWithClipRRect(40),
                    16.width,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(appStore.userFullName, style: boldTextStyle(color: primaryColor)),
                        4.height,
                        Text(appStore.userEmail, style: secondaryTextStyle()),
                      ],
                    ).expand(),
                    IconButton(
                      icon: Icon(AntDesign.edit, color: primaryColor, size: 20),
                      onPressed: () {
                        EditProfileScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                      },
                    )
                  ],
                ).paddingOnly(left: 16, right: 8, top: 16, bottom: 8).visible(appStore.isLoggedIn),
                Divider(height: 5, thickness: 1.2).visible(appStore.isLoggedIn),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(FontAwesome.language, color: context.iconColor),
                  title: language!.language,
                  trailing: LanguageListWidget(
                    widgetType: WidgetType.DROPDOWN,
                    onLanguageChange: (v) async {
                      await appStore.setLanguage(v.languageCode!);

                      setState(() {});
                    },
                  ),
                ),
                Divider(height: 5),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(Ionicons.color_palette_outline, color: context.iconColor),
                  title: language!.appTheme,
                  onTap: () async {
                    await showInDialog(
                      context,
                      builder: (context) => ThemeSelectionDaiLog(),
                      contentPadding: EdgeInsets.zero,
                      title: Text(language!.chooseTheme, style: boldTextStyle(size: 20)),
                    );
                  },
                ),
                Divider(height: 5),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(MaterialIcons.favorite_border, color: context.iconColor),
                  title: language!.lblFavorite,
                  onTap: () {
                    WishListScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                  },
                ).visible(appStore.isLoggedIn),
                Divider(height: 5).visible(appStore.isLoggedIn),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(Ionicons.key_outline, color: context.iconColor),
                  title: language!.changePassword,
                  onTap: () {
                    ChangePasswordScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                  },
                ).visible(appStore.isLoggedIn),
                Divider(height: 5).visible(appStore.isLoggedIn),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(Icons.star_border, color: context.iconColor),
                  title: language!.rateUs,
                  onTap: () async {
                    PackageInfo.fromPlatform().then((value) {
                      String package = '';
                      if (isAndroid) package = value.packageName;
                      launch('${storeBaseURL()}$package');
                    });
                  },
                ),
                Divider(height: 5),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(Octicons.file, color: context.iconColor),
                  title: language!.termsCondition,
                  onTap: () {
                    launch(termsConditionUrl);
                  },
                ),
                Divider(height: 5),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(Ionicons.shield_checkmark_outline, color: context.iconColor),
                  title: language!.privacyPolicy,
                  onTap: () {
                    launch(termsConditionUrl);
                  },
                ),
                Divider(height: 5),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(MaterialIcons.help_outline, color: context.iconColor),
                  title: language!.helpSupport,
                  onTap: () {
                    launch(helpSupportUrl);
                  },
                ),
                Divider(height: 5),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(Icons.info_outline, color: context.iconColor),
                  title: language!.about,
                  onTap: () {
                    AboutScreen().launch(context);
                  },
                ),
                Divider(height: 5),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(MaterialCommunityIcons.logout, color: context.iconColor),
                  title: language!.logout,
                  onTap: () {
                    logout(context);
                  },
                ).visible(appStore.isLoggedIn),
                SettingItemWidget(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
                  leading: Icon(MaterialCommunityIcons.logout, color: context.iconColor),
                  title: language!.signIn,
                  onTap: () {
                    SignInScreen().launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop);
                  },
                ).visible(!appStore.isLoggedIn),
                24.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
