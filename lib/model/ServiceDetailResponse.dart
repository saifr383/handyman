class ServiceDetailResponse {
  List<CouponData>? coupon_data;
  CustomerReview? customer_review;
  Provider? provider;
  List<RatingData>? rating_data;
  ServiceDetail? service_detail;

  ServiceDetailResponse({this.coupon_data, this.customer_review, this.provider, this.rating_data, this.service_detail});

  factory ServiceDetailResponse.fromJson(Map<String, dynamic> json) {
    return ServiceDetailResponse(
      coupon_data: json['coupon_data'] != null ? (json['coupon_data'] as List).map((i) => CouponData.fromJson(i)).toList() : null,
      customer_review: json['customer_review'] != null ? CustomerReview.fromJson(json['customer_review']) : null,
      provider: json['provider'] != null ? Provider.fromJson(json['provider']) : null,
      rating_data: json['rating_data'] != null ? (json['rating_data'] as List).map((i) => RatingData.fromJson(i)).toList() : null,
      service_detail: json['service_detail'] != null ? ServiceDetail.fromJson(json['service_detail']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coupon_data != null) {
      data['coupon_data'] = this.coupon_data!.map((v) => v.toJson()).toList();
    }
    if (this.customer_review != null) {
      data['customer_review'] = this.customer_review!.toJson();
    }
    if (this.provider != null) {
      data['provider'] = this.provider!.toJson();
    }
    if (this.rating_data != null) {
      data['rating_data'] = this.rating_data!.map((v) => v.toJson()).toList();
    }
    if (this.service_detail != null) {
      data['service_detail'] = this.service_detail!.toJson();
    }
    return data;
  }
}

class CouponData {
  String? code;
  int? discount;
  String? discount_type;
  String? expire_date;
  int? id;
  int? status;

  CouponData({this.code, this.discount, this.discount_type, this.expire_date, this.id, this.status});

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      code: json['code'],
      discount: json['discount'],
      discount_type: json['discount_type'],
      expire_date: json['expire_date'],
      id: json['id'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['discount'] = this.discount;
    data['discount_type'] = this.discount_type;
    data['expire_date'] = this.expire_date;
    data['id'] = this.id;
    data['status'] = this.status;
    return data;
  }
}

class Provider {
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

  Provider(
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

  factory Provider.fromJson(Map<String, dynamic> json) {
    return Provider(
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

class CustomerReview {
  int? booking_id;
  String? created_at;
  int? customer_id;
  int? id;
  String? profile_image;
  num? rating;
  String? review;
  int? service_id;
  String? updated_at;

  CustomerReview({this.booking_id, this.created_at, this.customer_id, this.id, this.rating, this.review, this.service_id, this.updated_at, this.profile_image});

  factory CustomerReview.fromJson(Map<String, dynamic> json) {
    return CustomerReview(
      booking_id: json['booking_id'],
      created_at: json['created_at'],
      customer_id: json['customer_id'],
      id: json['id'],
      rating: json['rating'],
      profile_image: json['profile_image'],
      review: json['review'],
      service_id: json['service_id'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.booking_id;
    data['created_at'] = this.created_at;
    data['customer_id'] = this.customer_id;
    data['id'] = this.id;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['profile_image'] = this.profile_image;
    data['service_id'] = this.service_id;
    data['updated_at'] = this.updated_at;
    return data;
  }
}

class RatingData {
  int? booking_id;
  String? created_at;
  String? customer_name;
  int? id;
  String? profile_image;
  num? rating;
  String? review;
  int? service_id;

  RatingData({this.booking_id, this.created_at, this.customer_name, this.id, this.profile_image, this.rating, this.review, this.service_id});

  factory RatingData.fromJson(Map<String, dynamic> json) {
    return RatingData(
      booking_id: json['booking_id'],
      created_at: json['created_at'],
      customer_name: json['customer_name'],
      id: json['id'],
      profile_image: json['profile_image'],
      rating: json['rating'],
      review: json['review'],
      service_id: json['service_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.booking_id;
    data['created_at'] = this.created_at;
    data['customer_name'] = this.customer_name;
    data['id'] = this.id;
    data['profile_image'] = this.profile_image;
    data['rating'] = this.rating;
    data['review'] = this.review;
    data['service_id'] = this.service_id;
    return data;
  }
}

class ServiceDetail {
  List<String>? attchments;
  int? category_id;
  String? category_name;
  String? description;
  num? discount;
  String? duration;
  int? id;
  int? is_featured;
  String? name;
  num? price;
  String? price_format;
  int? provider_id;
  String? provider_name;
  int? status;
  num? total_rating;
  int? total_review;
  String? type;
  int? city_id;
  int? isFavourite;
  List<ServiceAddressMapping>? serviceAddressMapping;

  ServiceDetail(
      {this.attchments,
      this.category_id,
      this.category_name,
      this.description,
      this.discount,
      this.duration,
      this.id,
      this.is_featured,
      this.name,
      this.price,
      this.price_format,
      this.provider_id,
      this.provider_name,
      this.status,
      this.total_rating,
      this.total_review,
      this.type,
      this.city_id,
      this.isFavourite,
      this.serviceAddressMapping});

  factory ServiceDetail.fromJson(Map<String, dynamic> json) {
    return ServiceDetail(
      attchments: json['attchments'] != null ? new List<String>.from(json['attchments']) : null,
      category_id: json['category_id'],
      category_name: json['category_name'],
      description: json['description'],
      discount: json['discount'],
      duration: json['duration'],
      id: json['id'],
      is_featured: json['is_featured'],
      name: json['name'],
      price: json['price'],
      price_format: json['price_format'],
      provider_id: json['provider_id'],
      provider_name: json['provider_name'],
      status: json['status'],
      total_rating: json['total_rating'],
      total_review: json['total_review'],
      type: json['type'],
      city_id: json['city_id'],
      isFavourite: json['is_favourite'],
      serviceAddressMapping: json['service_address_mapping'] != null ? (json['service_address_mapping'] as List).map((i) => ServiceAddressMapping.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.category_id;
    data['category_name'] = this.category_name;
    data['description'] = this.description;
    data['discount'] = this.discount;
    data['duration'] = this.duration;
    data['id'] = this.id;
    data['is_featured'] = this.is_featured;
    data['name'] = this.name;
    data['price'] = this.price;
    data['price_format'] = this.price_format;
    data['provider_id'] = this.provider_id;
    data['provider_name'] = this.provider_name;
    data['status'] = this.status;
    data['total_rating'] = this.total_rating;
    data['total_review'] = this.total_review;
    data['type'] = this.type;
    data['city_id'] = this.city_id;
    data['is_favourite'] = this.isFavourite;
    if (this.attchments != null) {
      data['attchments'] = this.attchments;
    }
    if (this.serviceAddressMapping != null) {
      data['service_address_mapping'] = this.serviceAddressMapping!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ServiceAddressMapping {
  String? created_at;
  int? id;
  int? provider_address_id;
  ProviderAddressMapping? provider_address_mapping;
  int? service_id;
  String? updated_at;

  ServiceAddressMapping({this.created_at, this.id, this.provider_address_id, this.provider_address_mapping, this.service_id, this.updated_at});

  factory ServiceAddressMapping.fromJson(Map<String, dynamic> json) {
    return ServiceAddressMapping(
      created_at: json['created_at'] ,
      id: json['id'],
      provider_address_id: json['provider_address_id'],
      provider_address_mapping: json['provider_address_mapping'] != null ? ProviderAddressMapping.fromJson(json['provider_address_mapping']) : null,
      service_id: json['service_id'],
      updated_at: json['updated_at'] ,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provider_address_id'] = this.provider_address_id;
    data['service_id'] = this.service_id;
    if (this.created_at != null) {
      data['created_at'] = this.created_at;
    }
    if (this.provider_address_mapping != null) {
      data['provider_address_mapping'] = this.provider_address_mapping!.toJson();
    }
    if (this.updated_at != null) {
      data['updated_at'] = this.updated_at;
    }
    return data;
  }
}

class ProviderAddressMapping {
  String? address;
  String? created_at;
  int? id;
  String? latitude;
  String? longitude;
  int? provider_id;
  int? status;
  String? updated_at;

  ProviderAddressMapping({this.address, this.created_at, this.id, this.latitude, this.longitude, this.provider_id, this.status, this.updated_at});

  factory ProviderAddressMapping.fromJson(Map<String, dynamic> json) {
    return ProviderAddressMapping(
      address: json['address'],
      created_at: json['created_at'],
      id: json['id'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      provider_id: json['provider_id'],
      status: json['status'],
      updated_at: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['address'] = this.address;
    data['created_at'] = this.created_at;
    data['id'] = this.id;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['provider_id'] = this.provider_id;
    data['status'] = this.status;
    data['updated_at'] = this.updated_at;
    return data;
  }
}
