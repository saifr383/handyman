import 'package:booking_system_flutter/model/DashboardResponse.dart';

class CategoryResponse {
    List<Category>? data;
    Pagination? pagination;

    CategoryResponse({this.data, this.pagination});

    factory CategoryResponse.fromJson(Map<String, dynamic> json) {
        return CategoryResponse(
            data: json['data'] != null ? (json['data'] as List).map((i) => Category.fromJson(i)).toList() : null,
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

class Pagination {
    int? currentPage;
    int? from;
    String? next_page;
    int? per_page;
    String? previous_page;
    int? to;
    int? totalPages;
    int? total_items;

    Pagination({this.currentPage, this.from, this.next_page, this.per_page, this.previous_page, this.to, this.totalPages, this.total_items});

    factory Pagination.fromJson(Map<String, dynamic> json) {
        return Pagination(
            currentPage: json['currentPage'], 
            from: json['from'], 
            next_page: json['next_page'], 
            per_page: json['per_page'], 
            previous_page: json['previous_page'], 
            to: json['to'], 
            totalPages: json['totalPages'], 
            total_items: json['total_items'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['currentPage'] = this.currentPage;
        data['from'] = this.from;
        data['next_page'] = this.next_page;
        data['per_page'] = this.per_page;
        data['previous_page'] = this.previous_page;
        data['to'] = this.to;
        data['totalPages'] = this.totalPages;
        data['total_items'] = this.total_items;
        return data;
    }
}
