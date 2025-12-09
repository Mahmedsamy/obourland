class UserModel {
  final String token;
  final int id;
  final String email;


  UserModel({required this.token, required this.id, required this.email});


  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    token: json['token'] ?? '',
    id: json['id'] ?? 0,
    email: json['email'] ?? '',
  );
}