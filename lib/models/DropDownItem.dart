import 'dart:convert';

class DropDownItem {
  final int id;
  final String title;
  final String sub_title;
  final int price;
  final String image_item;
  final int total_time;

  DropDownItem({
    required this.id,
    required this.title,
    required this.sub_title,
    required this.price,
    required this.image_item,
    required this.total_time,
  });

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'title' : title,
      'sub_title': sub_title,
      'price': price,
      'image_item': image_item,
      'total_time': total_time,
    };
  }

  factory DropDownItem.fromMap(Map<String, dynamic> map) {
    List<List<int>>? item;


    if (map['graph'] != null) {
      item = jsonDecode(map['graph']).cast<List<dynamic>>().map<List<int>>(
              (row) => (row as List<dynamic>).cast<int>().toList()
      ).toList();
    }

    return DropDownItem(
        id: map['id'] ?? 0,
        title: map['title'] ?? '',
        sub_title: map['sub_title'] ?? '',
        price: map['price'] ?? 0,
        image_item: map['image_item'] ?? '',
      total_time: map['total_time'] ?? 0
    );
  }
}