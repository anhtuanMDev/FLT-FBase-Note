import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  // get collection of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');

  // Create: add a new note
  Future<void>? addNote(String note) {
    try {
      print(note);
      return notes.add({'note': note, 'timestamp': Timestamp.now()});
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Read: get all notes
  Stream<QuerySnapshot> getNotes() {
    return notes.orderBy('timestamp', descending: true).snapshots();
  }

  // Update: update a note
  Future<void>? updateNote(String id, String note) {
    try {
      return notes.doc(id).update({'note': note});
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // Delete: delete a note
  Future<void>? deleteNote(String id) {
    try {
      return notes.doc(id).delete();
    } catch (e) {
      print(e.toString());
    }
    return null;
  }
}
