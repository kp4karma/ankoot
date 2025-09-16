class UserDataModel {
  bool? errorStatus;
  UserData? data;

  UserDataModel({this.errorStatus, this.data});

  UserDataModel.fromJson(Map<String, dynamic> json) {
    errorStatus = json['errorStatus'];
    data = json['data'] != null ? new UserData.fromJson(json['data']) : null;
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

class UserData {
  String? msg;
  User? user;
  PradeshAssignment? pradeshAssignment;
  String? token;
  String? refreshToken;

  UserData(
      {this.msg,
        this.user,
        this.pradeshAssignment,
        this.token,
        this.refreshToken});

  UserData.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    pradeshAssignment = json['pradesh_assignment'] != null
        ? new PradeshAssignment.fromJson(json['pradesh_assignment'])
        : null;
    token = json['token'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.pradeshAssignment != null) {
      data['pradesh_assignment'] = this.pradeshAssignment!.toJson();
    }
    data['token'] = this.token;
    data['refreshToken'] = this.refreshToken;
    return data;
  }
}

class User {
  int? userId;
  String? userName;
  String? userMobile;
  String? userType;
  String? status;
  String? cdt;
  String? udt;

  User(
      {this.userId,
        this.userName,
        this.userMobile,
        this.userType,
        this.status,
        this.cdt,
        this.udt});

  User.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    userName = json['user_name'];
    userMobile = json['user_mobile'];
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
    data['user_type'] = this.userType;
    data['status'] = this.status;
    data['cdt'] = this.cdt;
    data['udt'] = this.udt;
    return data;
  }
}

class PradeshAssignment {
  int? pradeshId;
  String? pradeshEngName;
  String? pradeshGujName;
  String? pradeshOldEngName;
  String? pradeshNewGujName;
  String? status;

  PradeshAssignment(
      {this.pradeshId,
        this.pradeshEngName,
        this.pradeshGujName,
        this.pradeshOldEngName,
        this.pradeshNewGujName,
        this.status});

  PradeshAssignment.fromJson(Map<String, dynamic> json) {
    pradeshId = json['pradesh_id'];
    pradeshEngName = json['pradesh_eng_name'];
    pradeshGujName = json['pradesh_guj_name'];
    pradeshOldEngName = json['pradesh_old_eng_name'];
    pradeshNewGujName = json['pradesh_new_guj_name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pradesh_id'] = this.pradeshId;
    data['pradesh_eng_name'] = this.pradeshEngName;
    data['pradesh_guj_name'] = this.pradeshGujName;
    data['pradesh_old_eng_name'] = this.pradeshOldEngName;
    data['pradesh_new_guj_name'] = this.pradeshNewGujName;
    data['status'] = this.status;
    return data;
  }
}
