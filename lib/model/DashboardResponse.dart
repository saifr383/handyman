import 'ServiceModel.dart';

class DashboardResponse {
  List<Category>? category;
  List<Configuration>? configurations;
  List<ProviderData>? provider;
  List<Service>? service;
  List<SliderModel>? slider;
  bool? status;
  bool? is_paypal_configuration;

  DashboardResponse({this.category, this.configurations, this.is_paypal_configuration, this.provider, this.service, this.slider, this.status});

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      category: json['category'] != null ? (json['category'] as List).map((i) => Category.fromJson(i)).toList() : null,
      configurations: json['configurations'] != null ? (json['configurations'] as List).map((i) => Configuration.fromJson(i)).toList() : null,
      is_paypal_configuration: json['is_paypal_configuration'],
      provider: json['provider'] != null ? (json['provider'] as List).map((i) => ProviderData.fromJson(i)).toList() : null,
      service: json['service'] != null ? (json['service'] as List).map((i) => Service.fromJson(i)).toList() : null,
      slider: json['slider'] != null ? (json['slider'] as List).map((i) => SliderModel.fromJson(i)).toList() : null,
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_paypal_configuration'] = this.is_paypal_configuration;
    data['status'] = this.status;
    if (this.category != null) {
      data['category'] = this.category!.map((v) => v.toJson()).toList();
    }
    if (this.configurations != null) {
      data['configurations'] = this.configurations!.map((v) => v.toJson()).toList();
    }
    if (this.provider != null) {
      data['provider'] = this.provider!.map((v) => v.toJson()).toList();
    }
    if (this.service != null) {
      data['service'] = this.service!.map((v) => v.toJson()).toList();
    }
    if (this.slider != null) {
      data['slider'] = this.slider!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  String? category_image;
  String? color;
  String? description;
  int? id;
  int? is_featured;
  String? name;
  int? status;

  Category({this.category_image, this.color, this.description, this.id, this.is_featured, this.name, this.status});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      category_image: json['category_image'],
      color: json['color'],
      description: json['description'],
      id: json['id'],
      is_featured: json['is_featured'],
      name: json['name'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_image'] = this.category_image;
    data['color'] = this.color;
    data['description'] = this.description;
    data['id'] = this.id;
    data['is_featured'] = this.is_featured;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}


class ProviderData {
  int? id;
  String? firstName;
  String? lastName;
  String? username;
  String? providerId;
  int? status;
  String? description;
  String? userType;
  String? email;
  String? contactNumber;
  int? countryId;
  int? stateId;
  int? cityId;
  String? cityName;
  String? address;
  int? providertypeId;
  String? providertype;
  int? isFeatured;
  String? displayName;
  String? createdAt;
  String? updatedAt;
  String? profileImage;
  String? timeZone;
  String? lastNotificationSeen;

  ProviderData(
      {this.id,
        this.firstName,
        this.lastName,
        this.username,
        this.providerId,
        this.status,
        this.description,
        this.userType,
        this.email,
        this.contactNumber,
        this.countryId,
        this.stateId,
        this.cityId,
        this.cityName,
        this.address,
        this.providertypeId,
        this.providertype,
        this.isFeatured,
        this.displayName,
        this.createdAt,
        this.updatedAt,
        this.profileImage,
        this.timeZone,
        this.lastNotificationSeen});

  ProviderData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    providerId = json['provider_id'];
    status = json['status'];
    description = json['description'];
    userType = json['user_type'];
    email = json['email'];
    contactNumber = json['contact_number'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    address = json['address'];
    providertypeId = json['providertype_id'];
    providertype = json['providertype'];
    isFeatured = json['is_featured'];
    displayName = json['display_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    profileImage = json['profile_image'];
    timeZone = json['time_zone'];
    lastNotificationSeen = json['last_notification_seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['username'] = this.username;
    data['provider_id'] = this.providerId;
    data['status'] = this.status;
    data['description'] = this.description;
    data['user_type'] = this.userType;
    data['email'] = this.email;
    data['contact_number'] = this.contactNumber;
    data['country_id'] = this.countryId;
    data['state_id'] = this.stateId;
    data['city_id'] = this.cityId;
    data['city_name'] = this.cityName;
    data['address'] = this.address;
    data['providertype_id'] = this.providertypeId;
    data['providertype'] = this.providertype;
    data['is_featured'] = this.isFeatured;
    data['display_name'] = this.displayName;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['profile_image'] = this.profileImage;
    data['time_zone'] = this.timeZone;
    data['last_notification_seen'] = this.lastNotificationSeen;
    return data;
  }
}

class Configuration {
  Country? country;
  int? id;
  String? key;
  String? type;
  String? value;

  Configuration({this.country, this.id, this.key, this.type, this.value});

  factory Configuration.fromJson(Map<String, dynamic> json) {
    return Configuration(
      country: json['country'] != null ? Country.fromJson(json['country']) : null,
      id: json['id'],
      key: json['key'],
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['key'] = this.key;
    data['type'] = this.type;
    data['value'] = this.value;
    if (this.country != null) {
      data['country'] = this.country!.toJson();
    }
    return data;
  }
}

class Country {
  String? code;
  String? currency_code;
  String? currency_name;
  int? dial_code;
  int? id;
  String? name;
  String? symbol;

  Country({this.code, this.currency_code, this.currency_name, this.dial_code, this.id, this.name, this.symbol});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      code: json['code'],
      currency_code: json['currency_code'],
      currency_name: json['currency_name'],
      dial_code: json['dial_code'],
      id: json['id'],
      name: json['name'],
      symbol: json['symbol'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['currency_code'] = this.currency_code;
    data['currency_name'] = this.currency_name;
    data['dial_code'] = this.dial_code;
    data['id'] = this.id;
    data['name'] = this.name;
    data['symbol'] = this.symbol;
    return data;
  }
}

class SliderModel {
  String? description;
  int? id;
  String? service_name;
  String? slider_image;
  int? status;
  String? title;
  String? type;
  String? type_id;

  SliderModel({this.description, this.id, this.service_name, this.slider_image, this.status, this.title, this.type, this.type_id});

  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      description: json['description'],
      id: json['id'],
      service_name: json['service_name'],
      slider_image: json['slider_image'],
      status: json['status'],
      title: json['title'],
      type: json['type'],
      type_id: json['type_id'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['id'] = this.id;
    data['service_name'] = this.service_name;
    data['slider_image'] = this.slider_image;
    data['status'] = this.status;
    data['title'] = this.title;
    data['type'] = this.type;
    data['type_id'] = this.type_id;
    return data;
  }
}
