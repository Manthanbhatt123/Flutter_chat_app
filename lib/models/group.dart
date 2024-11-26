import 'package:cloud_firestore/cloud_firestore.dart';

class Group {
  String id;
  List<String> members;
  Timestamp lastMessageTime;
  String name;
  Timestamp createdAt;
  String lastMessage;

  Group({
    required this.id,
    required this.members,
    required this.lastMessageTime,
    required this.name,
    required this.createdAt,
    required this.lastMessage,
  });

  // From JSON
  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'] ?? '',
      createdAt: json['created_at'] ??  Timestamp.now(),
      lastMessage: json['last_message'] ?? '',
      lastMessageTime: json['last_message_time'] ?? Timestamp.now(),
      members: List<String>.from(json['members']) ?? [],
      name: json['name'] ?? '',
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id':id,
      'members': members,
      'last_message_time': lastMessageTime,
      'name': name,
      'created_at': createdAt,
      'last_message': lastMessage,
    };
  }
}
