import 'package:booking_system_flutter/model/ServiceDetailResponse.dart';
import 'package:booking_system_flutter/screens/BookingSummaryScreen.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

class BookServiceScreen extends StatefulWidget {
  final ServiceDetailResponse? data;
  final int? bookingAddressId;

  BookServiceScreen({this.data, this.bookingAddressId});

  @override
  BookServiceScreenState createState() => BookServiceScreenState();
}

class BookServiceScreenState extends State<BookServiceScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController addressCont = TextEditingController();
  TextEditingController descriptionCont = TextEditingController();
  TextEditingController couponCont = TextEditingController();
  TextEditingController dateCont = TextEditingController();

  String currentLocation = '';
  DateTime currentDateTime = DateTime.now().add(Duration(days: 1));

  @override
  void initState() {
    log(currentDateTime.add(Duration(days: 1)));
    super.initState();
    init();
  }

  Future<void> init() async {
    log(widget.bookingAddressId);
    dateCont.text = currentDateTime.toString();
    addressCont.text = appStore.address;
    setState(() {});
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.bookService, center: true, color: context.primaryColor, textColor: white),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              16.height,
              Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(language!.lblAddress, style: boldTextStyle()).expand(),
                        TextButton(
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          onPressed: () async {
                            addressCont.text = await getUserLocation();
                            setState(() {});
                          },
                          child: Container(
                            decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
                            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: Row(
                              children: [
                                Text(language!.lblNew, style: boldTextStyle()),
                                4.width,
                                Icon(Icons.location_on, size: 15),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    8.height,
                    AppTextField(
                      controller: addressCont,
                      textFieldType: TextFieldType.ADDRESS,
                      maxLines: 5,
                      minLines: 3,
                      isValidationRequired: true,
                      decoration: inputDecoration(context, hint: language!.hintAddress),
                    ),
                    8.height,
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.height,
                    Text(language!.lblDescription, style: boldTextStyle()),
                    16.height,
                    AppTextField(
                      isValidationRequired: true,
                      controller: descriptionCont,
                      textFieldType: TextFieldType.ADDRESS,
                      maxLines: 5,
                      minLines: 3,
                      errorThisFieldRequired: "Please add Address",
                      decoration: inputDecoration(context, hint: language!.hintDescription),
                    ),
                    8.height,
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.all(8),
                padding: EdgeInsets.all(8),
                width: context.width(),
                decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.height,
                    Text(language!.dateTime, style: boldTextStyle()),
                    8.height,
                    DateTimePicker(
                      dateMask: 'yyyy-MM-dd hh:mm',
                      type: DateTimePickerType.dateTime,
                      controller: dateCont,
                      style: primaryTextStyle(),
                      initialDate: currentDateTime,
                      firstDate: currentDateTime,
                      lastDate: DateTime(DateTime.now().year + 1),
                      decoration: inputDecoration(context, hint: language!.selectDateTime),
                      use24HourFormat: true,
                      locale: Locale('en', 'US'),
                      onChanged: (val) {
                        //
                      },
                      validator: (val) {
                        //
                      },
                      onSaved: (val) {
                        //
                      },
                    ),
                    8.height
                  ],
                ),
              ),
              16.height
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        width: context.width(),
        decoration: boxDecorationWithShadow(backgroundColor: context.scaffoldBackgroundColor),
        child: AppButton(
          text: language!.continueTxt,
          textStyle: boldTextStyle(color: white),
          color: primaryColor,
          onTap: () async {
            await appStore.setAddress(addressCont.text);
            if (await isNetworkAvailable()) {
              if (addressCont.text.isNotEmpty) {
                BookingSummaryScreen(data: widget.data, description: descriptionCont.text.validate(), dateTimeVal: dateCont.text, bookingAddressId: widget.bookingAddressId)
                    .launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
              } else {
                snackBar(context, title: language!.toastEnterAddress);
              }
            } else {
              snackBar(context, title: language!.lblCheckInternet);
            }
          },
        ),
      ),
    );
  }
}
