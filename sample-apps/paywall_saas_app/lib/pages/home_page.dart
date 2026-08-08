import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/entitlements.dart';
import '../state/notes_controller.dart';
import 'paywall_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _addNote(BuildContext context) async {
    final notes = context.read<NotesController>();
    final ent = context.read<Entitlements>();

    if (!ent.canAddNote(notes.notes.length)) {
      await Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const PaywallPage()),
      );
      if (!context.mounted) return;
      if (!context.read<Entitlements>().canAddNote(notes.notes.length)) {
        return;
      }
    }

    final title = TextEditingController();
    final body = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: title, decoration: const InputDecoration(labelText: 'Title')),
            TextField(controller: body, decoration: const InputDecoration(labelText: 'Body')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    if (ok == true && title.text.trim().isNotEmpty) {
      notes.add(title.text.trim(), body.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NotesController>();
    final ent = context.watch<Entitlements>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes SaaS'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Chip(label: Text(ent.isPro ? 'PRO' : 'FREE')),
            ),
          ),
        ],
      ),
      body: notes.notes.isEmpty
          ? const Center(child: Text('No notes yet. Free plan: 3 notes max.'))
          : ListView.builder(
              itemCount: notes.notes.length,
              itemBuilder: (context, i) {
                final n = notes.notes[i];
                return ListTile(
                  title: Text(n.title),
                  subtitle: Text(n.body, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => context.read<NotesController>().remove(n.id),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNote(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
