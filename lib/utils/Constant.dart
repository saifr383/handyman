import 'package:nb_utils/nb_utils.dart';

const mAppName = 'Booking System';

///REGION URLS & KEYS
const mBaseUrl =  'https://car.webxpertiz.com.my/api/';

const mOneSignalAppId = 'efac72b8-6ef5-40f7-848d-bb86de5773a4';
const mOneSignalChannelId = "158b8254-afd5-4bd3-b15f-f5a50590e9ba";
const mOneSignalRestKey = "OWRmMWNmNTgtOGYzMi00ZWUwLThlMzctYzllOWNiMmQxNzc3";

const mAppIconUrl = "images/ic_Home.png";
const stripePaymentKey = 'sk_test_51GrhA2Bz1ljKAgF9FIJPLupBUCHFCOy5rS6LCnYHSu6Od0Qyx3TElGbxIu8BGRvq14fgidGOYyNkQPivZGnzWoVt004fCZxVdk';

const termsConditionUrl = 'https://wordpress.iqonic.design/docs/product/booking-system-flutter/help-and-support/';
const helpSupportUrl = 'https://iqonic.desky.support/';

///REGION CONFIGS
const defaultLanguage = 'en';
const perPageItem = 5;

///REGION MESSAGES

var passwordLengthMsg = 'Password length should be more than $passwordLengthGlobal';

/// REGION LIVESTREAM KEYS
const tokenStream = 'tokenStream';
const streamTab = 'streamTab';

/// THEME MODE TYPE

const ThemeModeLight = 0;
const ThemeModeDark = 1;
const ThemeModeSystem = 2;

/// REGION SHARED PREFERENCES KEYS

const IS_FIRST_TIME = 'IsFirstTime';
const IS_LOGGED_IN = 'IS_LOGGED_IN';
const USER_ID = 'USER_ID';
const FIRST_NAME = 'FIRST_NAME';
const LAST_NAME = 'LAST_NAME';
const USER_EMAIL = 'USER_EMAIL';
const PROFILE_IMAGE = 'PROFILE_IMAGE';
const IS_REMEMBERED = "IS_REMEMBERED";
const TOKEN = 'TOKEN';
const USERNAME = 'USERNAME';
const DISPLAY_NAME = 'DISPLAY_NAME';
const CONTACT_NUMBER = 'CONTACT_NUMBER';
const COUNTRY_ID = 'COUNTRY_ID';
const STATE_ID = 'STATE_ID';
const CITY_ID = 'CITY_ID';
const ADDRESS = 'ADDRESS';
const PLAYERID = 'PLAYERID';
const UID = 'UID';
const LATITUDE = 'LATITUDE';
const LONGITUDE = 'LONGITUDE';
const CURRENT_ADDRESS = 'CURRENT_ADDRESS';
const LOGIN_TYPE = 'LOGIN_TYPE';


/// CONFIGURATION

const DEFAULT_CURRENCY = 'DEFAULT_CURRENCY';
const CURRENCY_POSITION = 'CURRENCY_POSITION';
const IS_PAYPAL_CONFIGURATION = 'IS_PAYPAL_CONFIGURATION';
const CURRENCY_COUNTRY_SYMBOL = 'CURRENCY_COUNTRY_SYMBOL';
const CURRENCY_COUNTRY_CODE = 'CURRENCY_COUNTRY_CODE';
const CURRENCY_COUNTRY_ID = 'CURRENCY_COUNTRY_ID';
const ADMOB_APP_ID = 'ADMOB_APP_ID';
const ADMOB_BANNER_ID = 'ADMOB_BANNER_ID';
const ADMOB_INTERSTITIAL_ID = 'ADMOB_INTERSTITIAL_ID';
const PAYTM_MERCHANT_ID = 'PAYTM_MERCHANT_ID';
const PAYTM_SECRET_KEY = 'PAYTM_SECRET_KEY';
const PAYTM_CHANNEL_ID = 'PAYTM_CHANNEL_ID';
const PAYTM_WEBSITE = 'PAYTM_WEBSITE';
const PAYTM_INDUSTRY_TYPE_ID = 'PAYTM_INDUSTRY_TYPE_ID';
const PAYTM_CALLBACK_URL = 'PAYTM_CALLBACK_URL';
const COLOR_PRIMARY_COLOR = 'COLOR_PRIMARY_COLOR';
const COLOR_SECONDARY_COLOR = 'COLOR_SECONDARY_COLOR';
const ONESIGNAL_ONESIGNAL_API_KEY = 'ONESIGNAL_ONESIGNAL_API_KEY';
const ONESIGNAL_ONESIGNAL_REST_API_KEY = 'ONESIGNAL_ONESIGNAL_REST_API_KEY';
const RAZORPAY_RAZORPAY_KEY = 'RAZORPAY_RAZORPAY_KEY';
const RAZORPAY_RAZORPAY_SECRET = 'RAZORPAY_RAZORPAY_SECRET';
const ONESIGNAL_API_KEY = 'ONESIGNAL_API_KEY';
const ONESIGNAL_REST_API_KEY = 'ONESIGNAL_REST_API_KEY';
const IS_CURRENT_LOCATION='CURRENT_LOCATION';

///STRIPE PAYMENT DETAIL
const stripeURL = 'https://api.stripe.com/v1/payment_intents';
const STRIPE_PAYMENT_PUBLISH_KEY = 'pk_test_51GrhA2Bz1ljKAgF98fI6WfB2YUn4CewOB0DNQC1pSeXspUc1LlUYs3ou19oPF0ATcqa52FXTYmv6v0mkvPZb9BSD00SUpBj9tI';

///RAZORPAY DETAIL
const razorPayURL = 'https://api.razorpay.com/v1/orders';
const razorKey = "rzp_test_CLw7tH3O3P5eQM";
const razorPayKeySecret = 'QrVY94kUadOioIv2AXNA7JFu';

/// LOGIN TYPE
const LoginTypeUser = 'user';
const LoginTypeGoogle = 'google';
const LoginTypeOTP = 'otp';

/// SERVICE TYPE
const Fixed = 'fixed';
const Hourly = 'hourly';

/// PAYMENT METHOD
const COD = 'cash';
const StripePayment = 'stripe';
const RazorPayment = 'razorPay';

/// PAYMENT METHOD ENABLE AND DISABLE
const IS_STRIPE = true;
const IS_RAZORPAY = true;

/// SERVICE PAYMENT STATUS
const PAID = 'paid';
const PENDING = 'pending';

/// Action on service Button

const CANCEL = 'Cancel';
const START = 'Start';
const HOLD = 'Hold';
const RESUME = 'Resume';
const DONE = 'Done';
const END = 'End';
const COMPLETE = 'Complete';
const PAY = 'Pay Now';
const REVIEW = 'Rate Us';
const RESCHEDULE = 'Reschedule';

const accessAllowed = true;
const demoPurposeMsg = 'This action is not allowed in demo app.';
const MarkAsRead = 'markas_read';

const playStoreUrl = 'https://play.google.com/store/apps/details?id=';
const appStoreBaseUrl = 'https://www.apple.com/app-store/';

///ADs
const bannerIdForAndroid = "ca-app-pub-3940256099942544/6300978111";
const bannerIdForIos = "ca-app-pub-3940256099942544/2934735716";
const InterstitialIdForAndroid = "ca-app-pub-3940256099942544/1033173712";
const interstitialIdForIos = "ca-app-pub-3940256099942544/4411468910";

const enableAds = true;
const maxFailedLoadAttempts = 3;

const email = "demo@user.com";

///FireBase Collection Name
const MESSAGES_COLLECTION = "messages";
const USER_COLLECTION = "users";
const CONTACT_COLLECTION = "contact";
const CHAT_DATA_IMAGES = "chatImages";

const IS_ENTER_KEY = "IS_ENTER_KEY";
const SELECTED_WALLPAPER = "SELECTED_WALLPAPER";
const PER_PAGE_CHAT_COUNT = 50;

const TEXT = "TEXT";
const IMAGE = "IMAGE";

const VIDEO = "VIDEO";
const AUDIO = "AUDIO";

//chat
List<String> RTLLanguage = ['ar', 'ur'];

enum MessageType {
  TEXT,
  IMAGE,
  VIDEO,
  AUDIO,
}


extension MessageExtension on MessageType {
  String? get name {
    switch (this) {
      case MessageType.TEXT:
        return 'TEXT';
      case MessageType.IMAGE:
        return 'IMAGE';
      case MessageType.VIDEO:
        return 'VIDEO';
      case MessageType.AUDIO:
        return 'AUDIO';
      default:
        return null;
    }
  }
}
