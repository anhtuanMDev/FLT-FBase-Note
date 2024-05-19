import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fltnote/services/firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textController = TextEditingController();
  void openNote({String? id}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Center(child: Text(id == null ? "Add Note" : "Update Note")),
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
              onPressed: () => {
                    id == null
                        ? firestoreService.addNote(textController.text)
                        : firestoreService.updateNote(id, textController.text),
                    textController.clear(),
                    Navigator.of(context).pop()
                  },
              child: Text(id == null ? "Add" : "Update"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNote,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: firestoreService.getNotes(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List noteList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot note = noteList[index];
                String id = note.id;

                Map<String, dynamic> noteData =
                    note.data() as Map<String, dynamic>;
                String noteText = noteData["note"];
                return ListTile(
                    title: Text(noteText),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          child: const Icon(Icons.edit),
                          onPressed: () {
                            openNote(id: id);
                          },
                        ),
                        ElevatedButton(
                          child: const Icon(Icons.delete),
                          onPressed: () {
                            firestoreService.deleteNote(id);
                          },
                        ),
                      ],
                    ));
              },
            );
          } else {
            return const Center(
              child: Text("No notes found..."),
            );
          }
        },
      ),
    );
  }
}
