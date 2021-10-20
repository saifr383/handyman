import 'package:booking_system_flutter/utils/Colors.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:booking_system_flutter/utils/admob_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

Widget cachedImage(String? url, {double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment, bool usePlaceholderIfUrlEmpty = true}) {
  if (url.validate().isEmpty) {
    return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment);
  } else if (url.validate().startsWith('http')) {
    return CachedNetworkImage(
      imageUrl: url!,
      height: height,
      width: width,
      fit: fit,
      alignment: alignment as Alignment? ?? Alignment.center,
      errorWidget: (_, s, d) {
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment);
      },
      placeholder: (_, s) {
        if (!usePlaceholderIfUrlEmpty) return SizedBox();
        return placeHolderWidget(height: height, width: width, fit: fit, alignment: alignment);
      },
    );
  } else {
    return Image.asset(url!, height: height, width: width, fit: fit, alignment: alignment ?? Alignment.center);
  }
}

Widget placeHolderWidget({double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment}) {
  return Image.asset('images/placeholder.jpg', height: height, width: width, fit: fit ?? BoxFit.cover, alignment: alignment ?? Alignment.center);
}

class PriceWidget extends StatefulWidget {
  final num? price;
  final double? size;
  final Color? color;
  final bool isLineThroughEnabled;

  PriceWidget({this.price, this.size = 16.0, this.color, this.isLineThroughEnabled = false});

  @override
  PriceWidgetState createState() => PriceWidgetState();
}

class PriceWidgetState extends State<PriceWidget> {
  String currency = '₹';
  Color? primaryColor;

  @override
  void initState() {
    super.initState();
    get();
  }

  get() async {
    currency = getStringAsync(CURRENCY_COUNTRY_SYMBOL);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLineThroughEnabled) {
      return Text('$currency${widget.price.validate().toInt()}', style: boldTextStyle(size: widget.size!.toInt(), color: widget.color != null ? widget.color : primaryColor));
    } else {
      return widget.price.toString().isNotEmpty
          ? Text('$currency${widget.price.validate().toInt()}', style: TextStyle(fontSize: widget.size, color: widget.color ?? textPrimaryColor, decoration: TextDecoration.lineThrough))
          : Text('');
    }
  }
}

Widget couponView(BuildContext context,String val) {
  return DottedBorderWidget(
    color: primaryColor,
    child: Container(
      padding: EdgeInsets.all(4),
     color: context.cardColor,
      child: Text(val.validate(), style: boldTextStyle(color: primaryColor)),
    ),
  );
}


Future<void> bannerAds(BuildContext context) async {
  final AnchoredAdaptiveBannerAdSize? size = await AdSize.getAnchoredAdaptiveBannerAdSize(
    Orientation.portrait,
    MediaQuery.of(context).size.width.truncate(),
  );

  if (size == null) {
    log('Unable to get height of anchored banner.');
    return;
  }

  final BannerAd banner = BannerAd(
    size: size,
    request: AdRequest(),
    adUnitId: getBannerAdUnitId()!,
    listener: BannerAdListener(
      onAdLoaded: (Ad ad) {
        log('${ad.runtimeType} loaded.');
        myBanner = ad as BannerAd?;
        myBanner!.load();
      },
      onAdFailedToLoad: (Ad ad, LoadAdError error) {
        log('${ad.runtimeType} failed to load: $error.');
        ad.dispose();
        bannerReady = true;
        bannerAds(context);
      },
      onAdOpened: (Ad ad) {
        log('${ad.runtimeType} onAdOpened.');
      },
      onAdClosed: (Ad ad) {
        log('${ad.runtimeType} closed.');
        ad.dispose();
        bannerAds(context);
      },
    ),
  );
  return banner.load();
}

void createInterstitialAd() {
  int numInterstitialLoadAttempts = 0;
  InterstitialAd.load(
      adUnitId: InterstitialAd.testAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          log('${ad.runtimeType} loaded.');
          interstitialReady = true;
          interstitialAd = ad;
          numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          log('InterstitialAd failed to load: $error.');
          numInterstitialLoadAttempts += 1;
          interstitialAd = null;
          if (numInterstitialLoadAttempts <= maxFailedLoadAttempts) {
            createInterstitialAd();
          }
        },
      ));
}

void showInterstitialAd(BuildContext context) {
  if (interstitialAd == null) {
    log('attempt to show interstitial before loaded.');
    finish(context);
    return;
  }
  interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (InterstitialAd ad) => print('ad onAdShowedFullScreenContent.'),
    onAdDismissedFullScreenContent: (InterstitialAd ad) {
      log('$ad onAdDismissedFullScreenContent.');
      ad.dispose();
      createInterstitialAd();
    },
    onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
      log('$ad onAdFailedToShowFullScreenContent: $error');
      ad.dispose();
      createInterstitialAd();
    },
  );
  interstitialAd!.show();
  interstitialAd = null;
}