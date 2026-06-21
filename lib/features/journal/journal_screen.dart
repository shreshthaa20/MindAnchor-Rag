import 'package:flutter/material.dart';
import '../../shared/models/journal_entry.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  List<JournalEntry> journals = [];

  void saveJournal() {
    if (titleController.text.isEmpty ||
        contentController.text.isEmpty) {
      return;
    }

    setState(() {
      journals.add(
        JournalEntry(
          title: titleController.text,
          content: contentController.text,
          createdAt: DateTime.now(),
        ),
      );
    });

    titleController.clear();
    contentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Journal"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: "Title",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: contentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Write your thoughts...",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveJournal,
                child: const Text("Save Journal"),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: journals.length,
                itemBuilder: (context, index) {
                  final journal = journals[index];

                  return Card(
                    child: ListTile(
                      title: Text(journal.title),
                      subtitle: Text(journal.content),
                      trailing: Text(
                        "${journal.createdAt.hour}:${journal.createdAt.minute}",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}