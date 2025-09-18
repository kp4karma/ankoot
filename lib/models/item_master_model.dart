class ItemMasterDataModel {
  bool? errorStatus;
  List<ItemMasterData>? data;

  ItemMasterDataModel({this.errorStatus, this.data});

  ItemMasterDataModel.fromJson(Map<String, dynamic> json) {
    errorStatus = json['errorStatus'];
    if (json['data'] != null) {
      data = <ItemMasterData>[];
      json['data'].forEach((v) {
        data!.add(new ItemMasterData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorStatus'] = this.errorStatus;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemMasterData {
  int? foodItemId;
  String? foodEngName;
  String? foodGujName;
  String? foodUnit;
  String? foodImageUrl;
  String? foodCategory;
  String? foodRemark;
  String? status;
  String? cdt;
  String? udt;

  ItemMasterData(
      {this.foodItemId,
        this.foodEngName,
        this.foodGujName,
        this.foodUnit,
        this.foodImageUrl,
        this.foodCategory,
        this.foodRemark,
        this.status,
        this.cdt,
        this.udt});

  ItemMasterData.fromJson(Map<String, dynamic> json) {
    foodItemId = json['food_item_id'];
    foodEngName = json['food_eng_name'];
    foodGujName = json['food_guj_name'];
    foodUnit = json['food_unit'];
    foodImageUrl = json['food_image_url'];
    foodCategory = json['food_category'];
    foodRemark = json['food_remark'];
    status = json['status'];
    cdt = json['cdt'];
    udt = json['udt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['food_item_id'] = this.foodItemId;
    data['food_eng_name'] = this.foodEngName;
    data['food_guj_name'] = this.foodGujName;
    data['food_unit'] = this.foodUnit;
    data['food_image_url'] = this.foodImageUrl;
    data['food_category'] = this.foodCategory;
    data['food_remark'] = this.foodRemark;
    data['status'] = this.status;
    data['cdt'] = this.cdt;
    data['udt'] = this.udt;
    return data;
  }
}
