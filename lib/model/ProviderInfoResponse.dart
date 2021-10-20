import 'ServiceModel.dart';

class ProviderInfoResponse {
  Data? data;
  List<Service>? service;

  ProviderInfoResponse({this.data, this.service});

  factory ProviderInfoResponse.fromJson(Map<String, dynamic> json) {
    return ProviderInfoResponse(
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
      service: json['service'] != null ? (json['service'] as List).map((i) => Service.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    if (this.service != null) {
      data['service'] = this.service!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
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

  Data(
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

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
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
