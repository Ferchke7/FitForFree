import 'package:flutter/material.dart';
import 'package:my_fitt_app/training/training_databasehelper.dart';

class TrainingPage extends StatefulWidget {
  @override
  _TrainingPageState createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  final TextEditingController userIdController = TextEditingController();
  final TextEditingController activityNameController = TextEditingController();
  final TextEditingController repNumberController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Training Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: userIdController,
              decoration: InputDecoration(labelText: 'User ID'),
            ),
            TextField(
              controller: activityNameController,
              decoration: InputDecoration(labelText: 'Activity Name'),
            ),
            TextField(
              controller: repNumberController,
              decoration: InputDecoration(labelText: 'Rep Number'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Weight'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await saveTraining();
              },
              child: Text('Save Training'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await displayTrainings();
              },
              child: Text('Display Trainings'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveTraining() async {
    String userId = userIdController.text;
    String activityName = activityNameController.text;
    int repNumber = int.tryParse(repNumberController.text) ?? 0;
    int weight = int.tryParse(weightController.text) ?? 0;

    await TrainingDatabaseHelper.createItem(userId, repNumber, weight);
    // You can add further logic or UI updates after saving
  }

  Future<void> displayTrainings() async {
    List<Map<String, dynamic>> trainings = await TrainingDatabaseHelper.getItems();
    // Display or manipulate the retrieved trainings as needed
    print(trainings);
  }
}

void main() {
  runApp(MaterialApp(
    home: TrainingPage(),
  ));
}
