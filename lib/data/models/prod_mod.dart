class ProductModelX {
  int? count;
  String? next;
  String? previous;
  List<ResultsX>? results;
}

class ResultsX {
  int? id;
  String? productName;
  String? productDesc;
  String? productPrice;
  String? productImgSm;
  String? productImgMd;
  String? productImgLg;
  int? productRating;
  int? productQuantity;
  String? productSales;

  ResultsX(
      {this.id,
      this.productName,
      this.productDesc,
      this.productPrice,
      this.productImgSm,
      this.productImgMd,
      this.productImgLg,
      this.productRating,
      this.productQuantity,
      this.productSales});


}