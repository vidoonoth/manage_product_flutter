import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart'; // Tambahkan import ini
import '../providers/note_provider.dart';
import '../components/note_card.dart';
import '../components/note_dialogs.dart'; // Import note_dialogs.dart

class NoteScreen extends StatefulWidget {
  const NoteScreen({super.key});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    Provider.of<NoteProvider>(context, listen: false).fetchNotes();
  }

  @override
  Widget build(BuildContext context) {
    final noteProvider = Provider.of<NoteProvider>(context);
    final notes = noteProvider.notes;
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade50, // Ubah dari deepPurple ke blue
              Colors.blue.shade100,
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child:
                  notes.isEmpty
                      ? Center(
                        child: Text(
                          'Belum ada catatan hari ini.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      )
                      : RefreshIndicator(
                        onRefresh: noteProvider.fetchNotes,
                        child: ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: notes.length,
                          separatorBuilder:
                              (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return NoteCard(
                              note: note,
                              onEdit:
                                  () => showEditNoteDialog(
                                    context,
                                    note,
                                    (newContent) => Provider.of<NoteProvider>(
                                      context,
                                      listen: false,
                                    ).updateNote(note.id, newContent),
                                  ),
                              onDelete:
                                  () => showDeleteNoteDialog(
                                    context,
                                    note,
                                    () => Provider.of<NoteProvider>(
                                      context,
                                      listen: false,
                                    ).deleteNote(note.id),
                                  ),
                            );
                          },
                        ),
                      ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              color: Colors.white.withAlpha(229),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Tulis catatan aktivitas...',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue[400], // Ubah dari deepPurple ke blue
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                    ),
                    onPressed: () async {
                      if (_controller.text.trim().isNotEmpty) {
                        await noteProvider.addNote(_controller.text.trim());
                        _controller.clear();
                      }
                    },
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
