import 'dart:convert';

import 'package:booking_system_flutter/ChatServices/AuthSertvices.dart';
import 'package:booking_system_flutter/components/LoaderWidget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/ProfileUpdateResponse.dart';
import 'package:booking_system_flutter/network/NetworkUtils.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/screens/DashboardScreen.dart';
import 'package:booking_system_flutter/screens/ForgotPasswordScreen.dart';
import 'package:booking_system_flutter/screens/SignUpScreen.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:booking_system_flutter/utils/ModelKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

class SignInScreen extends StatefulWidget {
  final bool isFromRegister;

  SignInScreen({this.isFromRegister = false});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthServices authService = AuthServices();

  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController numberController = TextEditingController();

  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  String? countryCode = '';
  bool isCodeSent = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    afterBuildCreated(() {
      if (getStringAsync(PLAYERID).isEmpty) saveOneSignalPlayerId();
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      var request = {
        UserKeys.email: emailCont.text,
        UserKeys.password: passwordCont.text,
        UserKeys.playerId: getStringAsync(PLAYERID),
      };

      appStore.setLoading(true);
      await loginUser(request).then((res) async {
        if (res.data!.uid.validate().isNotEmpty) {

          authService.signInWithEmailPassword(context, email: emailCont.text, password: passwordCont.text).then((value) {
            appStore.setLoading(false);
            snackBar(context, title: language!.loginSuccessfully);

            if (res.data!.status.validate() != 0) {
              if (res.data!.user_type == LoginTypeUser) {
                DashboardScreen(index: 0).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
              } else {
                snackBar(context, title: language!.cantLogin);
              }
            } else {
              snackBar(context, title: language!.contactAdmin);
            }
          });
        } else {
          print('check////////////');

          authService.signIn(context, res: res, email: emailCont.text, password: passwordCont.text).then((value) async {
            snackBar(context, title: language!.loginSuccessfully);

            if (res.data!.status.validate() != 0) {
              if (res.data!.user_role!.first == LoginTypeUser) {
                log(email);
                log(getStringAsync(PLAYERID));

                MultipartRequest multiPartRequest = await getMultiPartRequest('update-profile');
                multiPartRequest.fields[UserKeys.uid] = getStringAsync(UID);

                multiPartRequest.headers.addAll(buildHeaderTokens());
                appStore.setLoading(true);
                sendMultiPartRequest(
                  multiPartRequest,
                  onSuccess: (data) async {
                    appStore.setLoading(false);
                    if (data != null) {
                      if ((data as String).isJson()) {
                        ProfileUpdateResponse res = ProfileUpdateResponse.fromJson(jsonDecode(data));
                        saveUserData(res.data!);
                        DashboardScreen(index: 0).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
                        snackBar(context, title: res.message!);

                        finish(context);
                      }
                    }
                  },
                  onError: (error) {
                    toast(error.toString(), print: true);
                    appStore.setLoading(false);
                  },
                );
              } else {
                snackBar(context, title: language!.cantLogin);
              }
            } else {
              snackBar(context, title: language!.contactAdmin);
            }
          });
        }
      }).catchError((e) {
        toast(e.toString(), print: true);
      });
      appStore.setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('', elevation: 0.0, color: appStore.isDarkMode ? transparentColor : white),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: AutofillGroup(
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Image.asset('images/ic_app_logo.png',height: 100,width: 100,)),
                    24.height,
                    AppTextField(
                      textFieldType: TextFieldType.EMAIL,
                      controller: emailCont,
                      focus: emailFocus,
                      nextFocus: passwordFocus,
                      errorThisFieldRequired: language!.requiredText,
                      decoration: inputDecoration(context, hint: language!.hintEmailTxt),
                      suffix: Icon(Fontisto.email, color: context.iconColor),
                      autoFillHints: [AutofillHints.email],
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: passwordCont,
                      focus: passwordFocus,
                      errorThisFieldRequired: language!.requiredText,
                      decoration: inputDecoration(context, hint: language!.hintPasswordTxt),
                      autoFillHints: [AutofillHints.password],
                      onFieldSubmitted: (s) {
                        login();
                      },
                    ),
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: getBoolAsync(IS_REMEMBERED, defaultValue: true),
                              activeColor: primaryColor,
                              onChanged: (v) async {
                                await setValue(IS_REMEMBERED, v);
                                setState(() {});
                              },
                            ),
                            TextButton(
                              onPressed: () async {
                                await setValue(IS_REMEMBERED, !getBoolAsync(IS_REMEMBERED));
                                setState(() {});
                              },
                              child: Text(language!.rememberMe, style: secondaryTextStyle()),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {
                            ForgotPasswordScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                          },
                          child: Text(language!.forgotPassword, style: secondaryTextStyle()),
                        ),
                      ],
                    ),
                    24.height,
                    AppButton(
                      text: language!.signIn,
                      height: 40,
                      color: primaryColor,
                      textStyle: primaryTextStyle(color: white),
                      width: context.width() - context.navigationBarHeight,
                      onTap: () {
                        login();
                      },
                    ),
                    16.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              SignUpScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                            },
                            child: Text(language!.signUp, style: secondaryTextStyle(color: primaryColor)))
                      ],
                    ),
                    24.height,
                    Row(
                      children: [
                        Divider(color: viewLineColor, thickness: 2).expand(),
                        4.width,
                        Text('${language!.signInWithTxt}: ', style: secondaryTextStyle()),
                        4.width,
                        Divider(color: viewLineColor, thickness: 2).expand(),
                      ],
                    ),
                    16.height,
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     GoogleLogoWidget(size: 24).onTap(() async {
                    //       hideKeyboard(context);
                    //
                    //       appStore.setLoading(true);
                    //
                    //       await authService.signInWithGoogle().then((user) {
                    //         DashboardScreen().launch(context, isNewTask: true);
                    //       }).catchError((e) {
                    //         toast(e.toString(), print: true);
                    //       });
                    //
                    //       appStore.setLoading(false);
                    //     }),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
