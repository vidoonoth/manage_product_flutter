import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String content;
  final DateTime date;

  Note({required this.id, required this.content, required this.date});

  factory Note.fromMap(Map<String, dynamic> data, String id) {
    return Note(
      id: id,
      content: data['content'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'date': date,
    };
  }
}