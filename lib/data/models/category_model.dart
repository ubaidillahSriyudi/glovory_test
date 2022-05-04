class CategoryModel {
  int? count;
  String? next;
  String? previous;
  List<Results>? results;

  CategoryModel({this.count, this.next, this.previous, this.results});

  CategoryModel.fromJson(Map<String, dynamic> json) {
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
  String? categoryName;
  String? categoryId;

  Results({this.id, this.categoryName, this.categoryId});

  Results.fromJson(Map<String, dynamic> json) {
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

