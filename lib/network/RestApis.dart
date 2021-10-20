import 'package:booking_system_flutter/main.dart';
import 'package:booking_system_flutter/model/BookingDetailResponse.dart';
import 'package:booking_system_flutter/model/BookingListResponse.dart';
import 'package:booking_system_flutter/model/BookingStatusResponse.dart';
import 'package:booking_system_flutter/model/CategoryResponse.dart';
import 'package:booking_system_flutter/model/ChangePasswordResponse.dart';
import 'package:booking_system_flutter/model/CityListResponse.dart';
import 'package:booking_system_flutter/model/CountryListResponse.dart';
import 'package:booking_system_flutter/model/DashboardResponse.dart';
import 'package:booking_system_flutter/model/LoginResponse.dart';
import 'package:booking_system_flutter/model/NotificationResponse.dart';
import 'package:booking_system_flutter/model/ProviderInfoResponse.dart';
import 'package:booking_system_flutter/model/ProviderListResponse.dart';
import 'package:booking_system_flutter/model/RegisterResponse.dart';
import 'package:booking_system_flutter/model/ServiceDetailResponse.dart';
import 'package:booking_system_flutter/model/ServiceResponse.dart';
import 'package:booking_system_flutter/model/StateListResponse.dart';
import 'package:booking_system_flutter/model/UserData.dart';
import 'package:booking_system_flutter/model/wishListResponse.dart';
import 'package:booking_system_flutter/network/NetworkUtils.dart';
import 'package:booking_system_flutter/screens/DashboardScreen.dart';
import 'package:booking_system_flutter/utils/Common.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

Future<RegisterResponse> createUser(Map request) async {
  return RegisterResponse.fromJson(await (handleResponse(await buildHttpResponse('register', request: request, method: HttpMethod.POST))));
}

Future<LoginResponse> loginUser(Map request, {bool isSocialLogin = false}) async {
  if (!isSocialLogin) await setValue(LOGIN_TYPE, LoginTypeUser);

  LoginResponse res = LoginResponse.fromJson(await handleResponse(await buildHttpResponse(isSocialLogin ? 'social-login' : 'login', request: request, method: HttpMethod.POST)));

  log('Current User Data : ${res.data!}');
  await saveUserData(res.data!);
  await appStore.setLoggedIn(true);

  return res;
}

Future<void> saveUserData(UserData data) async {
  if (data.api_token.validate().isNotEmpty) await appStore.setToken(data.api_token.validate());
  await appStore.setUserId(data.id.validate());
  await appStore.setFirstName(data.first_name.validate());
  await appStore.setLastName(data.last_name.validate());
  await appStore.setUserEmail(data.email.validate());
  await appStore.setUserName(data.username.validate());
  await appStore.setCountryId(data.country_id.validate());
  await appStore.setStateId(data.state_id.validate());
  await appStore.setCityId(data.city_id.validate());
  await appStore.setContactNumber('${data.contact_number.validate()}');
  if (!isSocialLogin) await appStore.setUserProfile(data.profile_image.validate());
  await appStore.setUId(data.uid.validate());
  await appStore.setAddress(data.address != null ? data.address.validate() : '');
}

Future<void> logout(BuildContext context) async {
  showConfirmDialogCustom(
    context,
    title: language!.afterLogoutTxt,
    positiveText: language!.lblYes,
    negativeText: language!.lblNo,
    onAccept: (context) async {
      await appStore.setFirstName('');
      await appStore.setLastName('');
      await appStore.setUserEmail('');
      await appStore.setUserName('');
      await appStore.setContactNumber('');
      await appStore.setCountryId(0);
      await appStore.setStateId(0);
      await appStore.setCityId(0);
      await appStore.setUId('');
      await appStore.setLatitude(0.0);
      await appStore.setLongitude(0.0);
      await appStore.setCurrentAddress('');
      await appStore.setToken('');
      await appStore.setLoggedIn(false);
      await removeKey(LOGIN_TYPE);

      DashboardScreen(index: 0).launch(context);
    },
  );
}

Future<List<CountryListResponse>> getCountryList() async {
  Iterable res = await (handleResponse(await buildHttpResponse('country-list', method: HttpMethod.POST)));
  return res.map((e) => CountryListResponse.fromJson(e)).toList();
}

Future<List<StateListResponse>> getStateList(Map request) async {
  Iterable res = await (handleResponse(await buildHttpResponse('state-list', request: request, method: HttpMethod.POST)));
  return res.map((e) => StateListResponse.fromJson(e)).toList();
}

Future<List<CityListResponse>> getCityList(Map request) async {
  Iterable res = await (handleResponse(await buildHttpResponse('city-list', request: request, method: HttpMethod.POST)));
  return res.map((e) => CityListResponse.fromJson(e)).toList();
}

Future<DashboardResponse> userDashboard({bool isCurrentLocation = false, double? lat, double? long}) async {
  if (isCurrentLocation) {
    return DashboardResponse.fromJson(await handleResponse(await buildHttpResponse('dashboard-detail?latitude=$lat&longitude=$long', method: HttpMethod.GET)));
  } else {
    return DashboardResponse.fromJson(await handleResponse(await buildHttpResponse('dashboard-detail', method: HttpMethod.GET)));
  }
}

Future<ServiceDetailResponse> getServiceDetail(Map request) async {
  return ServiceDetailResponse.fromJson(await handleResponse(await buildHttpResponse('service-detail', request: request, method: HttpMethod.POST)));
}

Future<BaseResponse> changeUserPassword(Map request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('change-password', request: request, method: HttpMethod.POST)));
}

Future<BaseResponse> forgotPassword(Map request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('forgot-password', request: request, method: HttpMethod.POST)));
}

Future<ServiceResponse> getServiceList(int page,
    {bool isCurrentLocation = false, String? searchTxt, bool isSearch = false, int? categoryId, bool isCategoryWise = false, int? customerId, double? lat, double? long}) async {
  if (isCategoryWise) {
    if (isCurrentLocation) {
      return ServiceResponse.fromJson(await handleResponse(
          await buildHttpResponse('service-list?per_page=$perPageItem&category_id=$categoryId&page=$page&customer_id=$customerId&latitude=$lat&longitude=$long', method: HttpMethod.GET)));
    } else {
      return ServiceResponse.fromJson(
          await handleResponse(await buildHttpResponse('service-list?per_page=$perPageItem&category_id=$categoryId&page=$page&customer_id=$customerId', method: HttpMethod.GET)));
    }
  } else if (isSearch) {
    if (isCurrentLocation)
      return ServiceResponse.fromJson(await handleResponse(
          await buildHttpResponse('service-list?per_page=$perPageItem&page=$page&customer_id=$customerId&search=$searchTxt&latitude=$lat&longitude=$long', method: HttpMethod.GET)));
    else
      return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse('service-list?per_page=$perPageItem&page=$page&customer_id=$customerId&search=$searchTxt', method: HttpMethod.GET)));
  } else {
    if (isCurrentLocation)
      return ServiceResponse.fromJson(
          await handleResponse(await buildHttpResponse('service-list?per_page=$perPageItem&page=$page&customer_id=$customerId&latitude=$lat&longitude=$long', method: HttpMethod.GET)));
    else
      return ServiceResponse.fromJson(await handleResponse(await buildHttpResponse('service-list?per_page=$perPageItem&page=$page&customer_id=$customerId', method: HttpMethod.GET)));
  }
}

Future<CategoryResponse> getCategoryList(int page, {var perPage = perPageItem}) async {
  return CategoryResponse.fromJson(await handleResponse(await buildHttpResponse('category-list?per_page=$perPage&page=$page', method: HttpMethod.GET)));
}

Future<ProviderInfoResponse> getProviderDetail(int id) async {
  return ProviderInfoResponse.fromJson(await handleResponse(await buildHttpResponse('user-detail?id=$id', method: HttpMethod.GET)));
}

Future bookTheServices(Map request) async {
  return await handleResponse(await buildHttpResponse('booking-save', request: request, method: HttpMethod.POST));
}

Future<List<BookingStatusResponse>> bookingStatus() async {
  Iterable res = await (handleResponse(await buildHttpResponse('booking-status', method: HttpMethod.GET)));
  return res.map((e) => BookingStatusResponse.fromJson(e)).toList();
}

Future<BookingListResponse> getBookingList(int page, {var perPage = perPageItem, String status = ''}) async {
  return BookingListResponse.fromJson(await handleResponse(await buildHttpResponse('booking-list?status=$status&per_page=$perPage&page=$page', method: HttpMethod.GET)));
}

Future<BookingDetailResponse> getBookingDetail(Map request) async {
  return BookingDetailResponse.fromJson(await handleResponse(await buildHttpResponse('booking-detail', request: request, method: HttpMethod.POST)));
}

Future<BaseResponse> updateBooking(Map request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('booking-update', request: request, method: HttpMethod.POST)));
}

Future<BaseResponse> savePayment(Map request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('save-payment', request: request, method: HttpMethod.POST)));
}

Future<NotificationListResponse> getNotification(Map request, {int? page = 1}) async {
  return NotificationListResponse.fromJson(await handleResponse(await buildHttpResponse('notification-list?page=$page', request: request, method: HttpMethod.POST)));
}

Future<BaseResponse> updateReview(Map request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('save-booking-rating', request: request, method: HttpMethod.POST)));
}

Future<WishListResponse> getWishlist() async {
  return WishListResponse.fromJson(await (handleResponse(await buildHttpResponse('user-favourite-service', method: HttpMethod.GET))));
}

Future<BaseResponse> addWishList(request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('save-favourite', method: HttpMethod.POST, request: request)));
}

Future<BaseResponse> removeWishList(request) async {
  return BaseResponse.fromJson(await handleResponse(await buildHttpResponse('delete-favourite', method: HttpMethod.POST, request: request)));
}

Future<ProviderListResponse> getProvider({String? userType = "provider"}) async {
  return ProviderListResponse.fromJson(await handleResponse(await buildHttpResponse('user-list?user_type=$userType', method: HttpMethod.GET)));
}
