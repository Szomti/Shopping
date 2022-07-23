import 'dart:convert';

class IsCheckedModel {
  bool isChecked;

  IsCheckedModel({
    required this.isChecked,
  });

  factory IsCheckedModel.fromJson(Map<String, dynamic> jsonData) {
    return IsCheckedModel(isChecked: jsonData['isChecked']);
  }

  static Map<String, dynamic> toMap(IsCheckedModel isChecked) => {
        'isChecked': isChecked.isChecked,
      };

  static String encode(List<IsCheckedModel> isCheckedList) => json.encode(
        isCheckedList
            .map<Map<String, dynamic>>(
                (isChecked) => IsCheckedModel.toMap(isChecked))
            .toList(),
      );

  static List<IsCheckedModel> decode(String isCheckedList) =>
      (json.decode(isCheckedList) as List<dynamic>)
          .map<IsCheckedModel>((item) => IsCheckedModel.fromJson(item))
          .toList();
}
