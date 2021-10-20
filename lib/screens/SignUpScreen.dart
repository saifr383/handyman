import 'package:booking_system_flutter/ChatServices/AuthSertvices.dart';
import 'package:booking_system_flutter/components/LoaderWidget.dart';
import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nb_utils/nb_utils.dart';

class SignUpScreen extends StatefulWidget {
  @override
  SignUpScreenState createState() => SignUpScreenState();
}

class SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AuthServices authService = AuthServices();

  TextEditingController fNameCont = TextEditingController();
  TextEditingController lNameCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();
  TextEditingController userNameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();
  TextEditingController cPasswordCont = TextEditingController();

  FocusNode fNameFocus = FocusNode();
  FocusNode lNameFocus = FocusNode();
  FocusNode emailFocus = FocusNode();
  FocusNode userNameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();
  FocusNode cPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> register() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      appStore.setLoading(true);
      authService
          .signUpWithEmailPassword(
        context,
        lName: lNameCont.text,
        userName: userNameCont.text,
        name: fNameCont.text.trim(),
        email: emailCont.text.trim(),
        password: passwordCont.text.trim(),
        mobileNumber: mobileCont.text.trim(),
      )
          .then((res) async {
        appStore.setLoading(false);
        //
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget('', elevation: 0.0, color: transparentColor),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Image.asset('images/ic_app_logo.png',height: 80,width: 80,)),
                  24.height,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: fNameCont,
                    focus: fNameFocus,
                    nextFocus: lNameFocus,
                    errorThisFieldRequired: language!.requiredText,
                    decoration: inputDecoration(context, hint: language!.hintFirstNameTxt),
                    suffix: Icon(AntDesign.user, color: context.iconColor),
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: lNameCont,
                    focus: lNameFocus,
                    nextFocus: userNameFocus,
                    errorThisFieldRequired: language!.requiredText,
                    decoration: inputDecoration(context, hint: language!.hintLastNameTxt),
                    suffix: Icon(AntDesign.user, color: context.iconColor),
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.USERNAME,
                    controller: userNameCont,
                    focus: userNameFocus,
                    nextFocus: emailFocus,
                    errorThisFieldRequired: language!.requiredText,
                    decoration: inputDecoration(context, hint: language!.hintUserNameTxt),
                    suffix: Icon(AntDesign.user, color: context.iconColor),
                  ),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.EMAIL,
                    controller: emailCont,
                    focus: emailFocus,
                    errorThisFieldRequired: language!.requiredText,
                    nextFocus: mobileFocus,
                    decoration: inputDecoration(context, hint: language!.hintEmailTxt),
                    suffix: Icon(Fontisto.email, color: context.iconColor),
                  ),
                  16.height,
                  AppTextField(
                      textFieldType: TextFieldType.PHONE,
                      controller: mobileCont,
                      focus: mobileFocus,
                      errorThisFieldRequired: language!.requiredText,
                      nextFocus: passwordFocus,
                      decoration: inputDecoration(context, hint: language!.hintContactNumberTxt),
                      suffix: Icon(Ionicons.call_outline, color: context.iconColor),
                      validator: (mobileCont) {
                        String value = mobileCont.toString();
                        String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                        RegExp regExp = new RegExp(pattern);
                        if (value.length == 0) {
                          return language!.phnrequiredtext;
                        } else if (!regExp.hasMatch(value.toString())) {
                          return language!.phnvalidation;
                        }
                      }),
                  16.height,
                  AppTextField(
                    textFieldType: TextFieldType.PASSWORD,
                    controller: passwordCont,
                    focus: passwordFocus,
                    errorThisFieldRequired: language!.requiredText,
                    decoration: inputDecoration(context, hint: language!.hintPasswordTxt),
                    onFieldSubmitted: (s) {
                      register();
                    },
                  ),
                  24.height,
                  AppButton(
                    text: language!.signUp,
                    height: 40,
                    color: primaryColor,
                    textStyle: primaryTextStyle(color: white),
                    width: context.width() - context.navigationBarHeight,
                    onTap: () {
                      register();
                    },
                  ),
                  24.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      4.width,
                      TextButton(
                          onPressed: () {
                            finish(context);
                          },
                          child: Text(language!.signIn, style: secondaryTextStyle(color: primaryColor))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
