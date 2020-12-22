class LoginResponseModel {
  bool success;
  int statusCode;
  String code;
  String message;
  Data data;

  LoginResponseModel(
      {this.success, this.code, this.data, this.message, this.statusCode});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    statusCode = json['statuscode'];
    code = json['code'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['success'] = this.success;
    data['statusCode'] = this.statusCode;
    data['code'] = this.code;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  String token;
  int id;
  String email;
  String nicename;
  String firstname;
  String lastname;
  String displayname;

  Data(
      {this.displayname,
      this.email,
      this.firstname,
      this.id,
      this.lastname,
      this.nicename,
      this.token});

  Data.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['id'];
    email = json['email'];
    nicename = json['nicename'];
    firstname = json['firstname'];
    displayname = json['displayname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['displayname'] = this.displayname;
    data['email'] = this.email;
    data['firstname'] = this.firstname;
    data['id'] = this.id;
    data['nicename'] = this.nicename;
    data['lastname'] = this.lastname;
    return data;
  }
}
