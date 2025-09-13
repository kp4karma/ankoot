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
  String? token;
  String? refreshToken;

  UserData({this.msg, this.user, this.token, this.refreshToken});

  UserData.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    token = json['token'];
    refreshToken = json['refreshToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
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
