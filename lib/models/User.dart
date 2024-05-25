import 'package:test_project/models/DropDownItem.dart';

class UserData {
  final String uid;
  final String email;
  final String first_name;
  final String second_name;
  final int user_total;
  final String profile_image;
  final List<dynamic> skills;
  final List<dynamic> tips;

  UserData({
    required this.uid,
    required this.email,
    required this.first_name,
    required this.second_name,
    required this.user_total,
    required this.profile_image,
    required this.skills,
    required this.tips
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'first_name': first_name,
      'second_name': second_name,
      'user_total' : user_total,
      'profile_image' : profile_image,
      'skills' : skills.map((skill) => skill.toJson()).toList(),
      'tips' : tips.map((tip) => tip.toJson()).toList(),
    };
  }

  factory UserData.fromMap(Map<String, dynamic> map) {
    List<DropDownItem> skills = [];
    List<DropDownItem> tips = [];
    if (map['skills'] != null) {
      skills = List<DropDownItem>.from(map['skills'].map((e) => DropDownItem.fromMap(e as Map<String, dynamic>)));
    }

    if (map['tips'] != null) {
      skills = List<DropDownItem>.from(map['tips'].map((e) => DropDownItem.fromMap(e as Map<String, dynamic>)));
    }

    return UserData(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      first_name: map['first_name'] ?? '',
      second_name: map['second_name'] ?? '',
      user_total: map['user_total'] ?? 0,
      profile_image: map['profile_image'] ?? 'https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg',
      skills: skills,
      tips: tips
    );
  }
}