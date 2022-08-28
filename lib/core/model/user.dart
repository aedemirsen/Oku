class User {
  bool? notificationStatus;
  String? id;
  String? device;

  User({this.notificationStatus, this.id, this.device});

  User.fromJson(Map<String, dynamic> json) {
    notificationStatus = json['notificationStatus'];
    id = json['id'];
    device = json['device'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['notificationStatus'] = notificationStatus;
    data['id'] = id;
    data['device'] = device;
    return data;
  }
}
