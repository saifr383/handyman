class Service {
  List<String>? attchments;
  int? category_id;
  String? category_name;
  int? city_id;
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
  num? total_review;
  String? type;
  String? providerImage;
  int? isFavourite;

  Service(
      {this.attchments,
      this.category_id,
      this.category_name,
      this.city_id,
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
      this.providerImage,
      this.type,
      this.isFavourite});

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      attchments: json['attchments'] != null ? new List<String>.from(json['attchments']) : null,
      category_id: json['category_id'],
      category_name: json['category_name'],
      city_id: json['city_id'],
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
      providerImage: json['provider_image'],
      type: json['type'],
      isFavourite: json['is_favourite'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.category_id;
    data['category_name'] = this.category_name;
    data['city_id'] = this.city_id;
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
    data['provider_image'] = this.providerImage;

    data['type'] = this.type;
    if (this.attchments != null) {
      data['attchments'] = this.attchments;
    }
    data['is_favourite'] = this.isFavourite;
    return data;
  }
}
