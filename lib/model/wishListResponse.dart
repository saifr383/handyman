class WishListResponse {
  Pagination? pagination;
  List<Wishlist>? data;

  WishListResponse({this.pagination, this.data});

  WishListResponse.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null ? new Pagination.fromJson(json['pagination']) : null;
    if (json['data'] != null) {
      data = json['data'] != null ? (json['data'] as List).map((i) => Wishlist.fromJson(i)).toList() : null;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? totalItems;
  int? perPage;
  int? currentPage;
  int? totalPages;
  int? from;
  int? to;
  String? nextPage;
  String? previousPage;

  Pagination({this.totalItems, this.perPage, this.currentPage, this.totalPages, this.from, this.to, this.nextPage, this.previousPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    totalItems = json['total_items'];
    perPage = json['per_page'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    from = json['from'];
    to = json['to'];
    nextPage = json['next_page'];
    previousPage = json['previous_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_items'] = this.totalItems;
    data['per_page'] = this.perPage;
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['from'] = this.from;
    data['to'] = this.to;
    data['next_page'] = this.nextPage;
    data['previous_page'] = this.previousPage;
    return data;
  }
}

class Wishlist {
  int? id;
  int? serviceId;
  int? userId;
  String? createdAt;
  String? customerName;
  String? name;
  int? price;
  String? priceFormat;
  String? type;
  double? discount;
  String? duration;
  List<String>? serviceAttchments;

  Wishlist({this.id, this.serviceId, this.userId, this.createdAt, this.customerName, this.name, this.price, this.priceFormat, this.type, this.discount, this.duration, this.serviceAttchments});

  Wishlist.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    serviceId = json['service_id'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    customerName = json['customer_name'];
    name = json['name'];
    price = json['price'];
    priceFormat = json['price_format'];
    type = json['type'];
    // discount = json['discount'];
    duration = json['duration'];
    serviceAttchments = json['service_attchments'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['service_id'] = this.serviceId;
    data['user_id'] = this.userId;
    data['created_at'] = this.createdAt;
    data['customer_name'] = this.customerName;
    data['name'] = this.name;
    data['price'] = this.price;
    data['price_format'] = this.priceFormat;
    data['type'] = this.type;
    data['discount'] = this.discount;
    data['duration'] = this.duration;
    data['service_attchments'] = this.serviceAttchments;
    return data;
  }
}
