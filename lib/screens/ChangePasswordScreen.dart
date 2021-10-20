import 'package:booking_system_flutter/components/LoaderWidget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/screens/DashboardScreen.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:booking_system_flutter/utils/ModelKeys.dart';
import 'package:booking_system_flutter/utils/admob_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController oldPasswordCont = TextEditingController();
  TextEditingController newPasswordCont = TextEditingController();
  TextEditingController reenterPasswordCont = TextEditingController();

  FocusNode oldPasswordFocus = FocusNode();
  FocusNode newPasswordFocus = FocusNode();
  FocusNode reenterPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> changePassword() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      var request = {
        UserKeys.oldPassword: oldPasswordCont.text,
        UserKeys.newPassword: newPasswordCont.text,
      };
      appStore.setLoading(true);

      await changeUserPassword(request).then((res) async {
        snackBar(context, title: res.message!);

        DashboardScreen(index: 0).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
      }).catchError((e) {
        toast(e.toString(), print: true);
      });
      appStore.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget('', textColor: context.iconColor, color: appStore.isDarkMode ? context.scaffoldBackgroundColor : white, elevation: 0.0),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(language!.changePassword, style: primaryTextStyle(size: 24).copyWith(height: 1.5)),
                    24.height,
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: oldPasswordCont,
                      focus: oldPasswordFocus,
                      nextFocus: newPasswordFocus,
                      decoration: inputDecoration(context, hint: language!.hintOldPasswordTxt),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: newPasswordCont,
                      focus: newPasswordFocus,
                      nextFocus: reenterPasswordFocus,
                      decoration: inputDecoration(context, hint: language!.hintNewPasswordTxt),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: reenterPasswordCont,
                      focus: reenterPasswordFocus,
                      validator: (v) {
                        if (newPasswordCont.text != v) {
                          return language!.passwordNotMatch;
                        } else if (reenterPasswordCont.text.isEmpty) {
                          return errorThisFieldRequired;
                        }
                      },
                      onFieldSubmitted: (s) {
                        changePassword();
                      },
                      decoration: inputDecoration(context, hint: language!.hintReenterPasswordTxt),
                    ),
                    24.height,
                    AppButton(
                      text: language!.confirm,
                      height: 40,
                      color: primaryColor,
                      textStyle: primaryTextStyle(color: white),
                      width: context.width() - context.navigationBarHeight,
                      onTap: () {
                        if (getStringAsync(USER_EMAIL) != email) {
                          changePassword();
                        } else {
                          finish(context);
                        }
                      },
                    ),
                    24.height,
                  ],
                ),
              ),
            ),
            Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading))
          ],
        ),
        bottomNavigationBar: isMobile
            ? Container(
                height: 60,
                width: context.width(),
                child: AdWidget(
                  ad: BannerAd(
                    adUnitId: kReleaseMode ? getBannerAdUnitId()! : BannerAd.testAdUnitId,
                    size: AdSize.banner,
                    request: AdRequest(),
                    listener: BannerAdListener(),
                  )..load(),
                ),
              ).visible(enableAds == true)
            : SizedBox());
  }
}
