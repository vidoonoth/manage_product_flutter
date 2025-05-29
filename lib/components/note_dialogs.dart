import 'package:flutter/material.dart';
import '../models/note.dart';

Future<void> showEditNoteDialog(
  BuildContext context,
  Note note,
  Future<void> Function(String) onSave,
) async {
  final controller = TextEditingController(text: note.content);
  final result = await showDialog<String>(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Edit Catatan'),
          content: TextField(
            controller: controller,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Catatan',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
              ),
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text(
                'Simpan',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
  );
  if (result != null && result.isNotEmpty) {
    await onSave(result);
  }
}

Future<void> showDeleteNoteDialog(
  BuildContext context,
  Note note,
  Future<void> Function() onDelete,
) async {
  await showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Hapus Catatan?'),
          content: const Text('Yakin ingin menghapus catatan ini?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal', style: TextStyle(color: Colors.black)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.pop(context);
                await onDelete();
              },
              child: const Text('Hapus', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
  );
}
