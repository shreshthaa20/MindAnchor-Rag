import 'package:flutter/material.dart';
import '../../shared/models/mood_entry.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  String selectedMood = "";

  final moods = [
    "😊 Happy",
    "😌 Calm",
    "😟 Anxious",
    "😔 Sad",
    "😤 Stressed",
  ];

  List<MoodEntry> moodHistory = [];

  void saveMood() {
    if (selectedMood.isEmpty) return;

    setState(() {
      moodHistory.add(
  MoodEntry(
    mood: selectedMood,
    createdAt: DateTime.now(),
  ),
);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Saved: $selectedMood"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mood Tracker"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "How are you feeling today?",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ...moods.map(
              (mood) => RadioListTile(
                title: Text(mood),
                value: mood,
                groupValue: selectedMood,
                onChanged: (value) {
                  setState(() {
                    selectedMood = value.toString();
                  });
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: saveMood,
                child: const Text("Save Mood"),
              ),
            ),

            const SizedBox(height: 20),

            const Divider(),

            const Text(
              "Mood History",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: moodHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(Icons.favorite),
                    title: Text(moodHistory[index].mood),
subtitle: Text(
  moodHistory[index].createdAt.toString(),
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