import 'package:hive/hive.dart';
part 'article.g.dart';

@HiveType(typeId: 1, adapterName: 'ArticleAdapter')
class Article extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? body;
  @HiveField(3)
  String? dateHicri;
  @HiveField(4)
  String? dateMiladi;
  @HiveField(5)
  String? category;
  @HiveField(6)
  String? author;
  @HiveField(7)
  String? group;
  @HiveField(8)
  Article(
      {this.id,
      this.title,
      this.body,
      this.dateHicri,
      this.dateMiladi,
      this.category,
      this.author,
      this.group});

  Article.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
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
    data['id'] = id.toString();
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
