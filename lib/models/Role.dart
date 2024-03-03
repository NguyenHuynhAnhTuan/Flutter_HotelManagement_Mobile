class Role {
  int? id;
  String? roleName;

  Role({
    this.id,
    this.roleName,
  });

  Role.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    roleName = json['role_name'];
  }

  Role copyWith({
    int? id,
    String? roleName,
  }) =>
      Role(
        id: id ?? this.id,
        roleName: roleName ?? this.roleName,
      );

  int? get roleId => id;
  String? get roleType => roleName;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {};
    map['id'] = id;
    map['role_name'] = roleName;
    return map;
  }
}
