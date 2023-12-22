import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:fitforfree/database/routine_models.dart';
import 'package:fitforfree/database/user_models.dart';
import 'package:fitforfree/database/database_helper.dart'; // Import the database helper

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? email = client.auth.currentUser?.email.toString();
    String emailTemp = email.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('FitForFree'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Welcome "),
            RoutineForm(userEmail: emailTemp),
            OutlinedButton(
              onPressed: () {
                client.auth.signOut();
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}

class RoutineForm extends StatefulWidget {
  final String userEmail;

  const RoutineForm({Key? key, required this.userEmail}) : super(key: key);

  @override
  _RoutineFormState createState() => _RoutineFormState();
}

class _RoutineFormState extends State<RoutineForm> {
  final TextEditingController mondayController = TextEditingController();
  final TextEditingController tuesdayController = TextEditingController();
  final TextEditingController wednesdayController = TextEditingController();
  final TextEditingController thursdayController = TextEditingController();
  final TextEditingController fridayController = TextEditingController();
  final TextEditingController saturdayController = TextEditingController();
  final TextEditingController sundayController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Monday:'),
          TextFormField(controller: mondayController),
          const SizedBox(height: 10),
          Text('Tuesday:'),
          TextFormField(controller: tuesdayController),
          const SizedBox(height: 10),
          Text('Wednesday:'),
          TextFormField(controller: wednesdayController),
          const SizedBox(height: 10),
          Text('Thursday:'),
          TextFormField(controller: thursdayController),
          const SizedBox(height: 10),
          Text('Friday:'),
          TextFormField(controller: fridayController),
          const SizedBox(height: 10),
          Text('Saturday:'),
          TextFormField(controller: saturdayController),
          const SizedBox(height: 10),
          Text('Sunday:'),
          TextFormField(controller: sundayController),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              // Create a Routine object with the entered data
              Routine newRoutine = Routine(
            
                userEmail: widget.userEmail,
                monday: mondayController.text,
                tuesday: tuesdayController.text,
                wednesday: wednesdayController.text,
                thursday: thursdayController.text,
                friday: fridayController.text,
                saturday: saturdayController.text,
                sunday: sundayController.text,
              );

              // Insert the newRoutine into the database
              await DatabaseHelper.instance.insertRoutine(newRoutine);

              // Clear the text controllers
              mondayController.clear();
              tuesdayController.clear();
              wednesdayController.clear();
              thursdayController.clear();
              fridayController.clear();
              saturdayController.clear();
              sundayController.clear();

              // Optional: Reload the routines from the database and update the UI
              // This step is optional and depends on your specific requirements
              // If you want to update the UI with the latest data after adding a routine
              List<Routine> updatedRoutines =
                  await DatabaseHelper.instance.getAllRoutinesForUser(widget.userEmail);
              
              List<Routine> getAllRoutines = await DatabaseHelper.instance.getAllRoutines();
                  print(getAllRoutines);
                  print(updatedRoutines.toList());
              // Handle the updated routines as needed
            },
            child: const Text('Add Routine'),
          ),
        ],
      ),
    );
  }
}
