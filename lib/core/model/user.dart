class User {
  bool? notificationStatus;
  String? id;

  User({this.notificationStatus, this.id});

  User.fromJson(Map<String, dynamic> json) {
    notificationStatus = json['notificationStatus'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notificationStatus'] = notificationStatus;
    data['id'] = id;
    return data;
  }
}
