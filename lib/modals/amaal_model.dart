class AmaalModel {
  Map<String, dynamic>? data;

  AmaalModel({this.data});

  AmaalModel.fromJson(Map<String, dynamic> json) {
    data = json;
  }

  Map<String, dynamic> toJson() {
    return data ?? {};
  }
}

class AmaalListModel {
  List<dynamic>? data;

  AmaalListModel({this.data});

  AmaalListModel.fromJson(List<dynamic> json) {
    data = json;
  }

  List<dynamic> toJson() {
    return data ?? [];
  }
}
