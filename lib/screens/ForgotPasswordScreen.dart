import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:booking_system_flutter/utils/ModelKeys.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailCont = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> forgotPwd() async {
    if (formKey.currentState!.validate()) {
      Map req = {
        UserKeys.email: emailCont.text.validate(),
      };

      forgotPassword(req).then((res) {
        appStore.setLoading(false);

        snackBar(context, title: res.message!);
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString(), print: true);
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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(language!.hintEmailAddressTxt, style: primaryTextStyle(size: 24,color: primaryColor).copyWith(height: 1.5)),
              24.height,
              AppTextField(
                textFieldType: TextFieldType.EMAIL,
                controller: emailCont,
                autoFocus: true,
                decoration: inputDecoration(context, hint: language!.txtemail),
              ),
              24.height,
              AppButton(
                text: language!.resetPassword,
                height: 40,
                color: primaryColor,
                textStyle: primaryTextStyle(color: white),
                width: context.width() - context.navigationBarHeight,
                onTap: () {
                  appStore.setLoading(true);
                  if (getStringAsync(USER_EMAIL) != email) {
                    forgotPwd();
                  } else {
                    snackBar(context, title: language!.lblUnAuthorized);

                    finish(context);
                  }
                },
              ),
              24.height,
            ],
          ),
        ),
      ),
    );
  }
}
