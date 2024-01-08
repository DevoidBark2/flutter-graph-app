import 'dart:convert';

class News {
  final int id;
  final String title;
  final String sub_title;
  final String news_image;

  News({
    required this.id,
    required this.title,
    required this.sub_title,
    required this.news_image,
  });

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'title' : title,
      'sub_title': sub_title,
      'news_image': news_image
    };
  }

  factory News.fromMap(Map<String, dynamic> map) {
    List<List<int>>? graph;


    if (map['graph'] != null) {
      graph = jsonDecode(map['graph']).cast<List<dynamic>>().map<List<int>>(
              (row) => (row as List<dynamic>).cast<int>().toList()
      ).toList();
    }

    return News(
        id: map['id'] ?? 0,
      title: map['title'] ?? '',
      sub_title: map['sub_title'] ?? '',
      news_image: map['news_image'] ?? 'https://i.pinimg.com/736x/8b/16/7a/8b167af653c2399dd93b952a48740620.jpg'
    );
  }
}