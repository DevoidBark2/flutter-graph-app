import 'dart:convert';

class UserData {
  final String uid;
  final String email;
  final String first_name;
  final String second_name;
  final int total_user;
  final String profile_image;

  UserData({
    required this.uid,
    required this.email,
    required this.first_name,
    required this.second_name,
    required this.total_user,
    required this.profile_image,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'first_name': first_name,
      'second_name': second_name,
      'user_total' : total_user,
      'profile_image' : profile_image
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    List<List<int>>? graph;


    if (map['graph'] != null) {
      graph = jsonDecode(map['graph']).cast<List<dynamic>>().map<List<int>>(
              (row) => (row as List<dynamic>).cast<int>().toList()
      ).toList();
    }
    print(graph);
    return UserData(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      first_name: map['first_name'] ?? '',
      second_name: map['second_name'] ?? '',
      total_user: map['total_user'] ?? 0,
      profile_image: map['profile_image'] ?? 'https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg'
    );
  }
}