import 'package:booking_system_flutter/model/ServiceModel.dart';

import 'PaginationModel.dart';

class GetServiceListResponse {
    List<Service>? data;
    Pagination? pagination;

    GetServiceListResponse({this.data, this.pagination});

    factory GetServiceListResponse.fromJson(Map<String, dynamic> json) {
        return GetServiceListResponse(
            data: json['data'] != null ? (json['data'] as List).map((i) => Service.fromJson(i)).toList() : null,
            pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.data != null) {
            data['data'] = this.data!.map((v) => v.toJson()).toList();
        }
        if (this.pagination != null) {
            data['pagination'] = this.pagination!.toJson();
        }
        return data;
    }
}