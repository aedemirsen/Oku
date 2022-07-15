class Record {
  String? title;
  String? body;
  String? date;
  String? category;
  String? author;
  String? group;

  Record(
      {this.title,
      this.body,
      this.date,
      this.category,
      this.author,
      this.group});

  Record.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    body = json['body'];
    date = json['date'];
    category = json['category'];
    author = json['author'];
    group = json['group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['body'] = body;
    data['date'] = date;
    data['category'] = category;
    data['author'] = author;
    data['group'] = group;
    return data;
  }
}
