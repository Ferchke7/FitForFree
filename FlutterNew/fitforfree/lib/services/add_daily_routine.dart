import 'package:fitforfree/database/exercise_json_helper.dart';
import 'package:fitforfree/database/sqlite_service.dart';
import 'package:fitforfree/models/exercise.dart';
import 'package:fitforfree/models/records.dart';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';

class MyInputForm extends StatefulWidget //__
{
  final Exercise exercise;

  const MyInputForm({Key? key, required this.exercise}) : super(key: key);

  @override
  State<MyInputForm> createState() => _MyInputFormState();
}

class _MyInputFormState extends State<MyInputForm> {
  List<Exercise> exercises = [];
  List<TextEditingController> controllers = [];
  List<int> addedList = [];
  ExerciseService exerciseService = ExerciseService();
  UserService userService = UserService();
  

  @override
  void initState() {
    super.initState();
    createControllers(widget.exercise.reps);
  }

  String getWeekDayString() {
    DateTime now = DateTime.now();
    switch (now.weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Unknown';
    }
  }

  void disposeControllers() {
    for (TextEditingController controller in controllers) {
      controller.dispose();
    }
  }

  @override
  dispose() {
    disposeControllers();
    super.dispose();
  }

  void createControllers(int numberOfControllers) {
    for (int i = 0; i < numberOfControllers; i++) {
      TextEditingController controller = TextEditingController();
      controllers.add(controller);
    }
  }

  @override
  Widget build(context) 
  {
    return SingleChildScrollView(
    child: Column(children: <Widget>[
      Column(
        children: List.generate(controllers.length, (index) {
          return Column(
            children: <Widget>[
              Column(children: <Widget>[
                TextField(
                  controller: controllers[index],
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(hintText: 'Add reps info ${index + 1}'),
                ),
                if (addedList.contains(index))
                const Icon(Icons.done, color: Colors.green)
                else
                ElevatedButton(
                    onPressed: () {
                      int weightTemp = int.parse(controllers[index].text);
                      Exercise tempExer = Exercise(
                          name: widget.exercise.name,
                          reps: index + 1,
                          weight: weightTemp);
                      exercises.add(tempExer);
                      Records recorsTemp = Records(
                          userId: userId,
                          record: tempExer.toString(),
                          weekName: getWeekDayString(),
                          date: DateTime.now().toString());
                      setState(() {
                        addedList.add(index);  
                      });
                      
                      debugPrint(recorsTemp.userId.toString());
                      debugPrint(exercises.toString());
                    },
                    child: Text("Add for reps ${index + 1}")),
              ])
            ],
          );
        }),
      ),
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black
          ),
          onPressed: () {
            debugPrint(exerciseService.encodeExercises(exercises).toString());
            userService.insertRecord(Records(userId: userId, record: exerciseService.encodeExercises(exercises), weekName: getWeekDayString(), date: DateTime.now().toString()));
            const snackBar = SnackBar(
              content:  Text("Exercise added"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }, 
          child: const Text("Add to database", style: TextStyle(color: Colors.white),))
    ]));
  }
}
