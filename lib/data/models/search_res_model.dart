class SearchResultModel {
  int? count;
  String? next;
  String? previous;
  List<Results>? results;

  SearchResultModel({this.count, this.next, this.previous, this.results});

  SearchResultModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['next'] = next;
    data['previous'] = previous;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Results {
  int? id;
  ProductCategory? productCategory;
  String? productName;
  String? productDesc;
  String? productPrice;
  String? productImgSm;
  String? productImgMd;
  String? productImgLg;
  int? productRating;
  int? productQuantity;
  String? productSales;

  Results(
      {this.id,
      this.productCategory,
      this.productName,
      this.productDesc,
      this.productPrice,
      this.productImgSm,
      this.productImgMd,
      this.productImgLg,
      this.productRating,
      this.productQuantity,
      this.productSales});

  Results.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productCategory = json['product_category'] != null
        ? ProductCategory.fromJson(json['product_category'])
        : null;
    productName = json['product_name'];
    productDesc = json['product_desc'];
    productPrice = json['product_price'];
    productImgSm = json['product_img_sm'];
    productImgMd = json['product_img_md'];
    productImgLg = json['product_img_lg'];
    productRating = json['product_rating'];
    productQuantity = json['product_quantity'];
    productSales = json['product_sales'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (productCategory != null) {
      data['product_category'] = productCategory!.toJson();
    }
    data['product_name'] = productName;
    data['product_desc'] = productDesc;
    data['product_price'] = productPrice;
    data['product_img_sm'] = productImgSm;
    data['product_img_md'] = productImgMd;
    data['product_img_lg'] = productImgLg;
    data['product_rating'] = productRating;
    data['product_quantity'] = productQuantity;
    data['product_sales'] = productSales;
    return data;
  }
}

class ProductCategory {
  int? id;
  String? categoryName;
  String? categoryId;

  ProductCategory({this.id, this.categoryName, this.categoryId});

  ProductCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_name'] = categoryName;
    data['category_id'] = categoryId;
    return data;
  }
}

