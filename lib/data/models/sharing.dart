import 'dart:convert';

class Sharing {
  Sharing({
    required this.text,
    required this.link,
  });

  final String text;
  final String link;

  factory Sharing.fromJson(String str) => Sharing.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Sharing.fromMap(Map<String, dynamic> json) => Sharing(
    text: json["text"],
    link: json["link"],
  );

  Map<String, dynamic> toMap() => {
    "text": text,
    "link": link,
  };
}
