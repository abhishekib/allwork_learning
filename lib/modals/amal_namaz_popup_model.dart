class AmalNamazPopupModel {
  final String data;

  AmalNamazPopupModel(this.data);

  factory AmalNamazPopupModel.fromJson(Map<String, dynamic> json) {
    return AmalNamazPopupModel(json['data']);
  }
}
