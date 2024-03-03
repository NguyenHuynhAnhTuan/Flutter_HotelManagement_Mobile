class UserDto {
  int? id;
  String? username;
  String? email;
  String? password;
  String? address;
  String? phone;
  int? role_id;
  // other fields...

  UserDto({
    this.id,
    this.username,
    this.email,
    this.password,
    this.address,
    this.phone,
    this.role_id = 3,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) {
    return UserDto(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      address: json['address'],
      phone: json['phone'],
      role_id: json['role_id'],
      // map other fields here...
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'address': address,
      'phone': phone,
      'role_id': role_id,
      // include other fields as needed...
    };
  }
}
