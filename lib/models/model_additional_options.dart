class AdditionalOptionsModel {
  bool? usersPrice = false;

  AdditionalOptionsModel({this.usersPrice});

  AdditionalOptionsModel.fromJson(Map<String, dynamic> json)
      : usersPrice = json['usersPrice'];

  Map<String, dynamic> toJson() => {
        'usersPrice': usersPrice,
      };
}
