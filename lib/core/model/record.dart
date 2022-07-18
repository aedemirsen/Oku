class Record {
  String? title;
  String? body;
  String? dateHicri;
  String? dateMiladi;
  String? category;
  String? author;
  String? group;

  Record(
      {this.title,
      this.body,
      this.dateHicri,
      this.dateMiladi,
      this.category,
      this.author,
      this.group});

  Record.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    dateHicri = json['dateHicri'];
    dateMiladi = json['dateMiladi'];
    category = json['category'];
    author = json['author'];
    group = json['group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    data['dateHicri'] = dateHicri;
    data['dateMiladi'] = dateMiladi;
    data['category'] = category;
    data['author'] = author;
    data['group'] = group;
    return data;
  }
}
