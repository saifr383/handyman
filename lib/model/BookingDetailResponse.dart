import 'package:booking_system_flutter/model/UserData.dart';

import 'ServiceDetailResponse.dart';

class BookingDetailResponse {
  List<BookingActivity>? booking_activity;
  BookingDetail? booking_detail;
  CouponData? coupon_data;
  Customer? customer;
  List<UserData>? handyman_data;
  UserData? provider_data;
  List<RatingData>? rating_data;
  ServiceDetail? service;
  CustomerReview? customer_review;


  BookingDetailResponse({this.booking_activity, this.booking_detail, this.coupon_data, this.customer, this.handyman_data, this.provider_data, this.service, this.rating_data,this.customer_review});

  factory BookingDetailResponse.fromJson(Map<String, dynamic> json) {
    return BookingDetailResponse(
      booking_activity: json['booking_activity'] != null ? (json['booking_activity'] as List).map((i) => BookingActivity.fromJson(i)).toList() : null,
      booking_detail: json['booking_detail'] != null ? BookingDetail.fromJson(json['booking_detail']) : null,
      coupon_data: json['coupon_data'] != null ? CouponData.fromJson(json['coupon_data']) : null,
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      handyman_data: json['handyman_data'] != null ? (json['handyman_data'] as List).map((i) => UserData.fromJson(i)).toList() : null,
      rating_data: json['rating_data'] != null ? (json['rating_data'] as List).map((i) => RatingData.fromJson(i)).toList() : null,
      provider_data: json['provider_data'] != null ? UserData.fromJson(json['provider_data']) : null,
      service: json['service'] != null ? ServiceDetail.fromJson(json['service']) : null,
      customer_review: json['customer_review'] != null ? CustomerReview.fromJson(json['customer_review']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.booking_activity != null) {
      data['booking_activity'] = this.booking_activity!.map((v) => v.toJson()).toList();
    }
    if (this.booking_detail != null) {
      data['booking_detail'] = this.booking_detail!.toJson();
    }
    if (this.coupon_data != null) {
      data['coupon_data'] = this.coupon_data!.toJson();
    }
    if (this.customer != null) {
      data['customer'] = this.customer!.toJson();
    }
    if (this.handyman_data != null) {
      data['handyman_data'] = this.handyman_data!.map((v) => v.toJson()).toList();
    }
    if (this.provider_data != null) {
      data['provider_data'] = this.provider_data!.toJson();
    }
    if (this.rating_data != null) {
      data['rating_data'] = this.rating_data!.map((v) => v.toJson()).toList();
    }
    if (this.service != null) {
      data['service'] = this.service!.toJson();
    }
    if (this.customer_review != null) {
      data['customer_review'] = this.customer_review!.toJson();
    }
    return data;
  }
}

class BookingActivity {
  String? activity_data;
  String? activity_message;
  String? activity_type;
  int? booking_id;
  String? created_at;
  String? datetime;
  String? deleted_at;
  int? id;
  String? updated_at;

  BookingActivity({this.activity_data, this.activity_message, this.activity_type, this.booking_id, this.created_at, this.datetime, this.deleted_at, this.id, this.updated_at});

  factory BookingActivity.fromJson(Map<String, dynamic> json) {
    return BookingActivity(
      activity_data: json['activity_data'],
      activity_message: json['activity_message'],
      activity_type: json['activity_type'],
      booking_id: json['booking_id'],
      created_at: json['created_at'],
      datetime: json['datetime'],
      deleted_at: json['deleted_at'],
      id: json['id'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['activity_data'] = this.activity_data;
    data['activity_message'] = this.activity_message;
    data['activity_type'] = this.activity_type;
    data['booking_id'] = this.booking_id;
    data['created_at'] = this.created_at;
    data['datetime'] = this.datetime;
    data['deleted_at'] = this.deleted_at;
    data['id'] = this.id;
    data['updated_at'] = this.updated_at;
    return data;
  }
}

class HandymanData {
  String? address;
  int? city_id;
  String? city_name;
  String? contact_number;
  int? country_id;
  String? created_at;
  String? description;
  String? display_name;
  String? email;
  String? first_name;
  int? id;
  int? is_featured;
  String? last_name;
  String? profile_image;
  int? provider_id;
  String? providertype;
  String? providertype_id;
  int? state_id;
  int? status;
  String? updated_at;
  String? user_type;
  String? username;

  HandymanData(
      {this.address,
      this.city_id,
      this.city_name,
      this.contact_number,
      this.country_id,
      this.created_at,
      this.description,
      this.display_name,
      this.email,
      this.first_name,
      this.id,
      this.is_featured,
      this.last_name,
      this.profile_image,
      this.provider_id,
      this.providertype,
      this.providertype_id,
      this.state_id,
      this.status,
      this.updated_at,
      this.user_type,
      this.username});

  factory HandymanData.fromJson(Map<String, dynamic> json) {
    return HandymanData(
      address: json['address'],
      city_id: json['city_id'],
      city_name: json['city_name'],
      contact_number: json['contact_number'],
      country_id: json['country_id'],
      created_at: json['created_at'],
      description: json['description'],
      display_name: json['display_name'],
      email: json['email'],
      first_name: json['first_name'],
      id: json['id'],
      is_featured: json['is_featured'],
      last_name: json['last_name'],
      profile_image: json['profile_image'],
      provider_id: json['provider_id'],
      providertype: json['providertype'],
      providertype_id: json['providertype_id'],
      state_id: json['state_id'],
      status: json['status'],
      updated_at: json['updated_at'],
      user_type: json['user_type'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['city_id'] = this.city_id;
    data['city_name'] = this.city_name;
    data['contact_number'] = this.contact_number;
    data['country_id'] = this.country_id;
    data['created_at'] = this.created_at;
    data['description'] = this.description;
    data['display_name'] = this.display_name;
    data['email'] = this.email;
    data['first_name'] = this.first_name;
    data['id'] = this.id;
    data['is_featured'] = this.is_featured;
    data['last_name'] = this.last_name;
    data['profile_image'] = this.profile_image;
    data['provider_id'] = this.provider_id;
    data['providertype'] = this.providertype;
    data['providertype_id'] = this.providertype_id;
    data['state_id'] = this.state_id;
    data['status'] = this.status;
    data['updated_at'] = this.updated_at;
    data['user_type'] = this.user_type;
    data['username'] = this.username;
    return data;
  }
}

class ProviderData {
  String? address;
  int? city_id;
  String? city_name;
  String? contact_number;
  int? country_id;
  String? created_at;
  String? description;
  String? display_name;
  String? email;
  String? first_name;
  int? id;
  int? is_featured;
  String? last_name;
  String? profile_image;
  String? provider_id;
  String? providertype;
  int? providertype_id;
  int? state_id;
  int? status;
  String? updated_at;
  String? user_type;
  String? username;

  ProviderData(
      {this.address,
      this.city_id,
      this.city_name,
      this.contact_number,
      this.country_id,
      this.created_at,
      this.description,
      this.display_name,
      this.email,
      this.first_name,
      this.id,
      this.is_featured,
      this.last_name,
      this.profile_image,
      this.provider_id,
      this.providertype,
      this.providertype_id,
      this.state_id,
      this.status,
      this.updated_at,
      this.user_type,
      this.username});

  factory ProviderData.fromJson(Map<String, dynamic> json) {
    return ProviderData(
      address: json['address'],
      city_id: json['city_id'],
      city_name: json['city_name'],
      contact_number: json['contact_number'],
      country_id: json['country_id'],
      created_at: json['created_at'],
      description: json['description'],
      display_name: json['display_name'],
      email: json['email'],
      first_name: json['first_name'],
      id: json['id'],
      is_featured: json['is_featured'],
      last_name: json['last_name'],
      profile_image: json['profile_image'],
      provider_id: json['provider_id'],
      providertype: json['providertype'],
      providertype_id: json['providertype_id'],
      state_id: json['state_id'],
      status: json['status'],
      updated_at: json['updated_at'],
      user_type: json['user_type'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['city_id'] = this.city_id;
    data['city_name'] = this.city_name;
    data['contact_number'] = this.contact_number;
    data['country_id'] = this.country_id;
    data['created_at'] = this.created_at;
    data['description'] = this.description;
    data['display_name'] = this.display_name;
    data['email'] = this.email;
    data['first_name'] = this.first_name;
    data['id'] = this.id;
    data['is_featured'] = this.is_featured;
    data['last_name'] = this.last_name;
    data['profile_image'] = this.profile_image;
    data['provider_id'] = this.provider_id;
    data['providertype'] = this.providertype;
    data['providertype_id'] = this.providertype_id;
    data['state_id'] = this.state_id;
    data['status'] = this.status;
    data['updated_at'] = this.updated_at;
    data['user_type'] = this.user_type;
    data['username'] = this.username;
    return data;
  }
}

class Customer {
  String? address;
  int? city_id;
  String? city_name;
  String? contact_number;
  int? country_id;
  String? created_at;
  String? description;
  String? display_name;
  String? email;
  String? first_name;
  int? id;
  int? is_featured;
  String? last_name;
  String? profile_image;
  String? provider_id;
  String? providertype;
  String? providertype_id;
  int? state_id;
  int? status;
  String? updated_at;
  String? user_type;
  String? username;

  Customer(
      {this.address,
      this.city_id,
      this.city_name,
      this.contact_number,
      this.country_id,
      this.created_at,
      this.description,
      this.display_name,
      this.email,
      this.first_name,
      this.id,
      this.is_featured,
      this.last_name,
      this.profile_image,
      this.provider_id,
      this.providertype,
      this.providertype_id,
      this.state_id,
      this.status,
      this.updated_at,
      this.user_type,
      this.username});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      address: json['address'],
      city_id: json['city_id'],
      city_name: json['city_name'],
      contact_number: json['contact_number'],
      country_id: json['country_id'],
      created_at: json['created_at'],
      description: json['description'],
      display_name: json['display_name'],
      email: json['email'],
      first_name: json['first_name'],
      id: json['id'],
      is_featured: json['is_featured'],
      last_name: json['last_name'],
      profile_image: json['profile_image'],
      provider_id: json['provider_id'],
      providertype: json['providertype'],
      providertype_id: json['providertype_id'],
      state_id: json['state_id'],
      status: json['status'],
      updated_at: json['updated_at'],
      user_type: json['user_type'],
      username: json['username'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['city_id'] = this.city_id;
    data['city_name'] = this.city_name;
    data['contact_number'] = this.contact_number;
    data['country_id'] = this.country_id;
    data['created_at'] = this.created_at;
    data['description'] = this.description;
    data['display_name'] = this.display_name;
    data['email'] = this.email;
    data['first_name'] = this.first_name;
    data['id'] = this.id;
    data['is_featured'] = this.is_featured;
    data['last_name'] = this.last_name;
    data['profile_image'] = this.profile_image;
    data['provider_id'] = this.provider_id;
    data['providertype'] = this.providertype;
    data['providertype_id'] = this.providertype_id;
    data['state_id'] = this.state_id;
    data['status'] = this.status;
    data['updated_at'] = this.updated_at;
    data['user_type'] = this.user_type;
    data['username'] = this.username;
    return data;
  }
}

class BookingDetail {
  String? address;
  int? customer_id;
  String? customer_name;
  String? date;
  String? description;
  num? discount;
  String? duration_diff;
  String? end_at;
  int? id;
  String? payment_method;
  String? payment_status;
  num? price;
  int? provider_id;
  int? quantity;
  String? provider_name;
  String? reason;
  int? service_id;
  String? service_name;
  String? start_at;
  String? status;
  String? status_label;
  num? total_rating;
  num? total_review;
  String? type;
  String? startAt;
  String? endAt;
  String? durationDiff;
  String? durationDiffHour;

  BookingDetail(
      {this.address,
      this.customer_id,
      this.customer_name,
      this.date,
      this.description,
      this.discount,
      this.duration_diff,
      this.end_at,
      this.id,
      this.payment_method,
      this.payment_status,
      this.price,
      this.provider_id,
      this.quantity,
      this.provider_name,
      this.reason,
      this.service_id,
      this.service_name,
      this.start_at,
      this.status,
      this.status_label,
      this.total_rating,
      this.total_review,
      this.type,
      this.startAt,
      this.endAt,
      this.durationDiff,
      this.durationDiffHour});

  factory BookingDetail.fromJson(Map<String, dynamic> json) {
    return BookingDetail(
      address: json['address'],
      customer_id: json['customer_id'],
      customer_name: json['customer_name'],
      date: json['date'],
      description: json['description'],
      discount: json['discount'],
      duration_diff: json['duration_diff'],
      end_at: json['end_at'],
      id: json['id'],
      payment_method: json['payment_method'],
      payment_status: json['payment_status'],
      price: json['price'],
      provider_id: json['provider_id'],
      quantity: json['quantity'],
      provider_name: json['provider_name'],
      reason: json['reason'],
      service_id: json['service_id'],
      service_name: json['service_name'],
      start_at: json['start_at'],
      status: json['status'],
      status_label: json['status_label'],
      total_rating: json['total_rating'],
      total_review: json['total_review'],
      type: json['type'],
      startAt: json['start_at'],
      endAt: json['end_at'],
      durationDiff: json['duration_diff'],
      durationDiffHour: json['duration_diff_hour'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['customer_id'] = this.customer_id;
    data['customer_name'] = this.customer_name;
    data['date'] = this.date;
    data['description'] = this.description;
    data['discount'] = this.discount;
    data['duration_diff'] = this.duration_diff;
    data['end_at'] = this.end_at;
    data['id'] = this.id;
    data['payment_method'] = this.payment_method;
    data['payment_status'] = this.payment_status;
    data['price'] = this.price;
    data['provider_id'] = this.provider_id;
    data['quantity'] = this.quantity;
    data['provider_name'] = this.provider_name;
    data['reason'] = this.reason;
    data['service_id'] = this.service_id;
    data['service_name'] = this.service_name;
    data['start_at'] = this.start_at;
    data['status'] = this.status;
    data['status_label'] = this.status_label;
    data['total_rating'] = this.total_rating;
    data['total_review'] = this.total_review;
    data['type'] = this.type;
    data['start_at'] = this.startAt;
    data['end_at'] = this.endAt;
    data['duration_diff'] = this.durationDiff;
    data['duration_diff_hour']= this.durationDiffHour;
    return data;
  }
}
