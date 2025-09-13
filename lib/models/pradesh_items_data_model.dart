class PradeshItemsDataModel {
  bool? errorStatus;
  Data? data;

  PradeshItemsDataModel({this.errorStatus, this.data});

  PradeshItemsDataModel.fromJson(Map<String, dynamic> json) {
    errorStatus = json['errorStatus'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['errorStatus'] = this.errorStatus;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? msg;
  int? count;
  List<PradeshData>? data;

  Data({this.msg, this.count, this.data});

  Data.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    count = json['count'];
    if (json['data'] != null) {
      data = <PradeshData>[];
      json['data'].forEach((v) {
        data!.add(new PradeshData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['count'] = this.count;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PradeshData {
  int? pradeshId;
  String? pradeshEngName;
  String? pradeshGujName;
  List<PradeshUsers>? pradeshUsers;
  String? status;
  List<Items>? items;
  int? totalItemsCount;

  PradeshData(
      {this.pradeshId,
        this.pradeshEngName,
        this.pradeshGujName,
        this.pradeshUsers,
        this.status,
        this.items,
        this.totalItemsCount});

  PradeshData.fromJson(Map<String, dynamic> json) {
    pradeshId = json['pradesh_id'];
    pradeshEngName = json['pradesh_eng_name'];
    pradeshGujName = json['pradesh_guj_name'];
    if (json['pradeshUsers'] != null) {
      pradeshUsers = <PradeshUsers>[];
      json['pradeshUsers'].forEach((v) {
        pradeshUsers!.add(new PradeshUsers.fromJson(v));
      });
    }
    status = json['status'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    totalItemsCount = json['total_items_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pradesh_id'] = this.pradeshId;
    data['pradesh_eng_name'] = this.pradeshEngName;
    data['pradesh_guj_name'] = this.pradeshGujName;
    if (this.pradeshUsers != null) {
      data['pradeshUsers'] = this.pradeshUsers!.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['total_items_count'] = this.totalItemsCount;
    return data;
  }
}

class PradeshUsers {
  int? userId;
  String? userName;
  String? userMobile;
  String? userPassword;
  String? userType;
  String? status;
  String? cdt;
  String? udt;

  PradeshUsers(
      {this.userId,
        this.userName,
        this.userMobile,
        this.userPassword,
        this.userType,
        this.status,
        this.cdt,
        this.udt});

  PradeshUsers.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userMobile = json['user_mobile'];
    userPassword = json['user_password'];
    userType = json['user_type'];
    status = json['status'];
    cdt = json['cdt'];
    udt = json['udt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['user_mobile'] = this.userMobile;
    data['user_password'] = this.userPassword;
    data['user_type'] = this.userType;
    data['status'] = this.status;
    data['cdt'] = this.cdt;
    data['udt'] = this.udt;
    return data;
  }
}

class Items {
  int? foodItemId;
  String? foodEngName;
  String? foodGujName;
  String? foodUnit;
  String? foodCategory;
  int? totalQty;
  int? totalassigned;
  int? stockRecordsCount;

  Items(
      {this.foodItemId,
        this.foodEngName,
        this.foodGujName,
        this.foodUnit,
        this.foodCategory,
        this.totalQty,
        this.totalassigned,
        this.stockRecordsCount});

  Items.fromJson(Map<String, dynamic> json) {
    foodItemId = json['food_item_id'];
    foodEngName = json['food_eng_name'];
    foodGujName = json['food_guj_name'];
    foodUnit = json['food_unit'];
    foodCategory = json['food_category'];
    totalQty = json['total_qty'];
    totalassigned = json['totalassigned'];
    stockRecordsCount = json['stock_records_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['food_item_id'] = this.foodItemId;
    data['food_eng_name'] = this.foodEngName;
    data['food_guj_name'] = this.foodGujName;
    data['food_unit'] = this.foodUnit;
    data['food_category'] = this.foodCategory;
    data['total_qty'] = this.totalQty;
    data['totalassigned'] = this.totalassigned;
    data['stock_records_count'] = this.stockRecordsCount;
    return data;
  }
}
