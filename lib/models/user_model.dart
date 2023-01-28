class UserModel {
  int? id;
  String? name, status, email;

  UserModel({this.id, this.name, this.status, this.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], name: json['name'], email: json['email']);
  }
}
