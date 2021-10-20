import 'dart:convert';
import 'dart:io';

import 'package:booking_system_flutter/components/AppWidgets.dart';
import 'package:booking_system_flutter/components/LoaderWidget.dart';
import 'package:booking_system_flutter/model/BookingDetailResponse.dart';
import 'package:booking_system_flutter/model/StripePayModel.dart';
import 'package:booking_system_flutter/network/NetworkUtils.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:booking_system_flutter/utils/ModelKeys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../main.dart';
import 'DashboardScreen.dart';

class PaymentScreen extends StatefulWidget {
  final BookingDetailResponse? data;

  PaymentScreen({this.data});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  List<String> mPaymentList = ["Cash On Delivery"];
  late Razorpay razorPay;

  int? currentTimeValue = 2;
  int? paymentIndex;

  int quantity = 1;

  num discount = 0;
  num originalRate = 0;
  num totalAmount = 0;
  num discountAmount = 0;

  num couponDiscount = 0;
  num couponDiscountAmount = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    if (IS_STRIPE) mPaymentList.add("Stripe Payment");
    if (IS_RAZORPAY) mPaymentList.add("RazorPay");

    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    totalPayment();
  }

  void totalPayment() {
    originalRate = widget.data!.booking_detail!.price.validate();
    discount = widget.data!.booking_detail!.discount.validate();

    if (widget.data!.booking_detail!.quantity != null) {
      quantity = widget.data!.booking_detail!.quantity.validate();
    }

    totalAmount = (widget.data!.booking_detail!.price.validate() * quantity) - (((widget.data!.booking_detail!.price.validate() * quantity) * widget.data!.booking_detail!.discount.validate()) / 100);
    discountAmount = widget.data!.booking_detail!.price.validate() * quantity - totalAmount;
    log(discountAmount);
    if (widget.data!.coupon_data != null) {
      couponDiscount = widget.data!.coupon_data!.discount.validate();
      couponDiscountAmount = ((totalAmount * couponDiscount) / 100);

      log("couponDiscount ${widget.data!.coupon_data!.discount.validate()}");

      if (widget.data!.coupon_data!.discount_type == Fixed) {
        totalAmount = totalAmount - widget.data!.coupon_data!.discount.validate();
        couponDiscountAmount = widget.data!.coupon_data!.discount.validate();
      } else {
        totalAmount = totalAmount - ((totalAmount * couponDiscount) / 100);
        couponDiscountAmount = ((totalAmount * couponDiscount) / 100);
      }
    }

    setState(() {});
  }

  void stripePay() async {
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: 'Bearer $stripePaymentKey',
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
    };

    var request = http.Request('POST', Uri.parse(stripeURL));

    request.bodyFields = {
      'amount': '${(totalAmount * 100).toInt()}',
      'currency': getStringAsync(CURRENCY_COUNTRY_CODE).toLowerCase(),
    };

    log(request.bodyFields);
    request.headers.addAll(headers);

    log(request);

    appStore.setLoading(true);

    await request.send().then((value) {
      appStore.setLoading(false);
      http.Response.fromStream(value).then((response) async {
        if (response.statusCode == 200) {
          var res = StripePayModel.fromJson(await handleResponse(response));

          await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              paymentIntentClientSecret: res.client_secret.validate(),
              style: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              applePay: true,
              googlePay: true,
              testEnv: true,
              merchantCountryCode: 'IN',
              merchantDisplayName: '',
              customerId: '1',
              customerEphemeralKeySecret: res.client_secret.validate(),
              setupIntentClientSecret: res.client_secret.validate(),
            ),
          );
          await Stripe.instance.presentPaymentSheet(parameters: PresentPaymentSheetParameters(clientSecret: res.client_secret!, confirmPayment: true)).then(
            (value) async {
              savePay(paymentMethod: StripePayment, paymentStatus: 'paid');
            },
          ).catchError((e) {
            log("presentPaymentSheet ${e.toString()}");
          });
        }
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString(), print: true);
      });
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString(), print: true);
    });
  }

  void razorPayPayment() async {
    String username = razorKey;
    String password = razorPayKeySecret;
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));

    print(basicAuth);

    var headers = {HttpHeaders.authorizationHeader: basicAuth, HttpHeaders.contentTypeHeader: 'application/json'};
    var request = http.Request('POST', Uri.parse(razorPayURL));
    request.body = json.encode({"amount": '${(totalAmount * 100).toInt()}', "currency": getStringAsync(CURRENCY_COUNTRY_SYMBOL), "receipt": "receipt#1"});
    request.headers.addAll(headers);

    await request.send().then((value) {
      http.Response.fromStream(value).then((response) async {
        var req = {
          'key': razorKey,
          'amount': (totalAmount * 100).toInt(),
          'name': 'Booking System',
          'theme.color': '#5f60b9',
          'description': 'Booking System',
          'image': 'https://razorpay.com/assets/razorpay-glyph.svg',
          'prefill': {'contact': widget.data!.customer!.contact_number, 'email': widget.data!.customer!.email},
          'external': {
            'wallets': ['paytm']
          }
        };

        log(req);

        try {
          razorPay.open(req);
        } catch (e) {
          debugPrint(e.toString());
        }
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString(), print: true);
      });
    }).catchError((e) {
      toast(e.toString(), print: true);
    });
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    log("Success:+$response");
    savePay(paymentMethod: RazorPayment, paymentStatus: 'paid', txnId: response.paymentId);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    snackBar(context, title: language!.toastPaymentFail);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    snackBar(context, title: "EXTERNAL_WALLET: " + response.walletName!);
  }

  void cod() {
    savePay(paymentMethod: COD);
  }

  Future<void> savePay({String? paymentMethod, String? txnId, String? paymentStatus = 'pending'}) async {
    Map request = {
      CommonKeys.bookingId: widget.data!.booking_detail!.id.validate(),
      CommonKeys.customerId: appStore.userId,
      CouponKeys.discount: widget.data!.booking_detail!.discount.validate(),
      BookingServiceKeys.totalAmount: totalAmount.validate(),
      CommonKeys.dateTime: DateFormat('yyyy-MM-dd hh:mm:ss').format(DateTime.now()),
      "txn_id": txnId != '' ? txnId : "#${widget.data!.booking_detail!.id.validate()}",
      "payment_status": paymentStatus,
      "payment_type": paymentMethod
    };

    appStore.setLoading(true);

    savePayment(request).then((value) {
      appStore.setLoading(false);

      snackBar(context, title: value.message.toString());

      DashboardScreen().launch(context, isNewTask: true);
    });
    log(request);
  }

  @override
  void dispose() {
    super.dispose();
    razorPay.clear();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.payment, color: context.primaryColor, textColor: white),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 16, top: 8),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  width: context.width(),
                  decoration: boxDecorationRoundedWithShadow(8, backgroundColor: context.cardColor),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.height,
                      Text(language!.priceDetail, style: boldTextStyle()),
                      Divider(thickness: 0.5),
                      16.height,
                      Row(
                        children: [
                          Text(language!.rate, style: primaryTextStyle()).expand(),
                          PriceWidget(price: widget.data!.booking_detail!.price.validate()),
                        ],
                      ),
                      4.height,
                      Row(
                        children: [
                          Text(language!.quantity, style: primaryTextStyle()).expand(),
                          Text('x${quantity.validate()}', style: boldTextStyle()),
                        ],
                      ).visible(widget.data!.booking_detail!.type.validate() == Fixed),
                      4.height,
                      Row(
                        children: [
                          Row(
                            children: [
                              Text(language!.discountOnMRP, style: primaryTextStyle()),
                              4.width,
                              Text('%${widget.data!.booking_detail!.discount.validate()} OFF', style: secondaryTextStyle(color: Colors.red)),
                            ],
                          ).expand(),
                          Text('${'- ${getStringAsync(CURRENCY_COUNTRY_SYMBOL)}${discountAmount.validate().toInt()}'}', style: boldTextStyle(color: Colors.green)),
                        ],
                      ).visible(discountAmount != 0),
                      4.height.visible(discountAmount != 0),
                      Row(
                        children: [
                          Row(
                            children: [
                              Text(language!.couponDiscount, style: primaryTextStyle()),
                              4.width,
                              if (widget.data!.coupon_data != null)
                                Text(
                                    widget.data!.coupon_data!.discount_type.validate() == Fixed
                                        ? '${getStringAsync(CURRENCY_COUNTRY_SYMBOL)} ${couponDiscount.validate()} OFF'
                                        : '%${couponDiscount.validate()} OFF',
                                    style: secondaryTextStyle(color: Colors.red)),
                            ],
                          ).expand(),
                          Text(
                            '${'- ${getStringAsync(CURRENCY_COUNTRY_SYMBOL)}${couponDiscountAmount.validate().toInt()}'}',
                            style: boldTextStyle(color: Colors.green),
                          )
                        ],
                      ).visible(couponDiscount != 0),
                      4.height.visible(couponDiscount != 0),
                      Divider(thickness: 0.5).visible(couponDiscount != 0),
                      4.height.visible(couponDiscount != 0),
                      Divider(thickness: 0.5),
                      Row(
                        children: [
                          Text(language!.totalAmount, style: primaryTextStyle()).expand(),
                          PriceWidget(price: totalAmount.validate()),
                        ],
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
                      Text(language!.paymentMethod, style: boldTextStyle()),
                      8.height,
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Theme(
                            data: Theme.of(context).copyWith(unselectedWidgetColor: Theme.of(context).iconTheme.color),
                            child: RadioListTile(
                              dense: true,
                              contentPadding: EdgeInsets.only(left: 0),
                              activeColor: primaryColor,
                              value: index,
                              groupValue: currentTimeValue,
                              onChanged: (dynamic ind) {
                                setState(() {
                                  currentTimeValue = ind;
                                  paymentIndex = index;
                                });
                              },
                              title: Text(mPaymentList[index], style: primaryTextStyle()),
                            ),
                          );
                        },
                        itemCount: mPaymentList.length,
                      ),
                    ],
                  ).paddingOnly(top: 8),
                ),
              ],
            ),
          ),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading))
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(8),
        decoration: boxDecorationWithShadow(backgroundColor: context.scaffoldBackgroundColor),
        child: AppButton(
          height: 50,
          color: primaryColor,
          width: context.width(),
          text: language!.done,
          onTap: () {
            if (currentTimeValue == 0) cod();
            if (currentTimeValue == 1) stripePay();
            if (currentTimeValue == 2) razorPayPayment();
          },
        ),
      ),
    );
  }
}
