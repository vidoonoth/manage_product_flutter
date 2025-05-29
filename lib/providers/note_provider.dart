import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteProvider with ChangeNotifier {
  final _notesRef = FirebaseFirestore.instance.collection('notes');
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> fetchNotes() async {
    final snapshot = await _notesRef.orderBy('date', descending: true).get();
    _notes =
        snapshot.docs.map((doc) => Note.fromMap(doc.data(), doc.id)).toList();
    notifyListeners();
  }

  Future<void> addNote(String content) async {
    final note = {'content': content, 'date': DateTime.now()};
    await _notesRef.add(note);
    await fetchNotes();
  }

  Future<void> deleteNote(String id) async {
    await _notesRef.doc(id).delete();
    await fetchNotes();
  }

  Future<void> updateNote(String id, String newContent) async {
    await _notesRef.doc(id).update({'content': newContent});
    await fetchNotes();
  }
}
