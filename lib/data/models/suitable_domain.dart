import 'dart:convert';

class SuitableDomains {
  SuitableDomains({
    required this.mirrors,
  });

  final List<String> mirrors;

  factory SuitableDomains.fromJson(String str) => SuitableDomains.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SuitableDomains.fromMap(Map<String, dynamic> json) => SuitableDomains(
    mirrors: List<String>.from(json["mirrors"].map((x) => x)),
  );

  Map<String, dynamic> toMap() => {
    "mirrors": List<dynamic>.from(mirrors.map((x) => x)),
  };
}
