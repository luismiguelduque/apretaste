import 'dart:convert';

class Ping {
  Ping({
    required this.code,
    required this.timestamp,
  });

  final String code;
  final int timestamp;

  factory Ping.fromJson(String str) => Ping.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ping.fromMap(Map<String, dynamic> json) => Ping(
    code: json["code"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toMap() => {
    "code": code,
    "timestamp": timestamp,
  };
}