class CustomerModel {
  String firstName;
  String lastName;
  String password;
  String email;

  CustomerModel({this.email, this.firstName, this.lastName, this.password});

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map.addAll({
      "email": email,
      "first_name": firstName,
      "last_name": lastName,
      "password": password,
      "username": email
    });

    return map;
  }
}
