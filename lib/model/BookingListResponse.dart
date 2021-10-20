import 'PaginationModel.dart';

class BookingListResponse {
  List<Booking>? data;
  Pagination? pagination;

  BookingListResponse({this.data, this.pagination});

  factory BookingListResponse.fromJson(Map<String, dynamic> json) {
    return BookingListResponse(
      data: json['data'] != null ? (json['data'] as List).map((i) => Booking.fromJson(i)).toList() : null,
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

class Booking {
  int? id;
  String? address;
  int? customerId;
  int? serviceId;
  int? providerId;
  num? price;
  String? type;
  String? date;
  num? discount;
  String? status;
  String? statusLabel;
  String? description;
  String? providerName;
  String? customerName;
  String? serviceName;
  String? paymentStatus;
  String? paymentMethod;

  Booking({
    this.id,
    this.address,
    this.customerId,
    this.serviceId,
    this.providerId,
    this.price,
    this.type,
    this.date,
    this.discount,
    this.status,
    this.statusLabel,
    this.description,
    this.providerName,
    this.customerName,
    this.serviceName,
    this.paymentStatus,
    this.paymentMethod,
  });

  Booking.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    address = json['address'];
    customerId = json['customer_id'];
    serviceId = json['service_id'];
    providerId = json['provider_id'];
    price = json['price'];
    type = json['type'];
    date = json['date'];
    discount = json['discount'];
    status = json['status'];
    statusLabel = json['status_label'];
    description = json['description'];
    providerName = json['provider_name'];
    customerName = json['customer_name'];
    serviceName = json['service_name'];
    paymentStatus = json['payment_status'];
    paymentMethod = json['payment_method'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['address'] = this.address;
    data['customer_id'] = this.customerId;
    data['service_id'] = this.serviceId;
    data['provider_id'] = this.providerId;
    data['price'] = this.price;
    data['type'] = this.type;
    data['date'] = this.date;
    data['discount'] = this.discount;
    data['status'] = this.status;
    data['status_label'] = this.statusLabel;
    data['description'] = this.description;
    data['provider_name'] = this.providerName;
    data['customer_name'] = this.customerName;
    data['service_name'] = this.serviceName;
    data['payment_status'] = this.paymentStatus;
    data['payment_method'] = this.paymentMethod;
    return data;
  }
}
