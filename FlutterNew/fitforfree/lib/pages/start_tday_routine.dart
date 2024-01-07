import 'package:fitforfree/database/exercise_json_helper.dart';
import 'package:fitforfree/database/sqlite_service.dart';
import 'package:fitforfree/models/exercise.dart';
import 'package:fitforfree/models/user.dart';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';
UserService userService = UserService();
ExerciseService exerciseService = ExerciseService();
late Future<List<Exercise>> exerlist;
class TodayRoutine extends StatefulWidget {
  const TodayRoutine({super.key});

  @override
  State<TodayRoutine> createState() => _TodayRoutineState();
}

class _TodayRoutineState extends State<TodayRoutine> {
  List<TextEditingController> controllers = [];
  
  @override
  void initState() {
    super.initState();
    createControllers(5);
  }

  @override dispose() {
    disposeControllers();
    super.dispose();
  }
  void createControllers(int numberOfControllers) {
    for (int i = 0; i < numberOfControllers; i++) {
      TextEditingController controller = TextEditingController();
      controllers.add(controller);
    }
  }
  void disposeControllers() {
    for (TextEditingController controller in controllers) {
      controller.dispose();
    }
  }

  Future<void> updateExercise(List<Exercise> updatedList, String dayOfWeek) async {
    User? currentUser = await userService.getUserByUsername(my_username!);
    
    switch (dayOfWeek.toLowerCase()) {
      case 'monday':
        currentUser?.monday = exerciseService.encodeExercises(updatedList);
        userService.updateUser(currentUser!);
        print("ADDED MONDAY");
        break;
      case 'tuesday':
        currentUser?.tuesday = exerciseService.encodeExercises(updatedList);
        userService.updateUser(currentUser!);
        break;
      case 'wednesday':
        currentUser?.wednesday = exerciseService.encodeExercises(updatedList);
        userService.updateUser(currentUser!);
        break;
      case 'thursday':
        currentUser?.thursday = exerciseService.encodeExercises(updatedList);
        userService.updateUser(currentUser!);
        break;
      case 'friday':
        currentUser?.friday = exerciseService.encodeExercises(updatedList);
        userService.updateUser(currentUser!);
        break;
      case 'sunday':
        currentUser?.sunday = exerciseService.encodeExercises(updatedList);
        userService.updateUser(currentUser!);
        break;
      case 'saturday':
        currentUser?.saturday = exerciseService.encodeExercises(updatedList);
        userService.updateUser(currentUser!);
        break;
      default:
        
        break;
    }
    
  }

  Future<List<Exercise>> getExercise(String dayOfWeek) async {
    User? currentUser = await userService.getUserByUsername(my_username!);
    var exerciseListTemp;
    switch (dayOfWeek.toLowerCase()) {
      case 'monday':
        exerciseListTemp = exerciseService.decodeExercises(currentUser!.monday!);
        break;
      case 'tuesday':
        exerciseListTemp = exerciseService.decodeExercises(currentUser!.tuesday!);
        break;
      case 'wednesday':
        exerciseListTemp = exerciseService.decodeExercises(currentUser!.wednesday!);
        break;
      case 'thursday':
        exerciseListTemp = exerciseService.decodeExercises(currentUser!.thursday!);
        break;
      case 'friday':
        exerciseListTemp = exerciseService.decodeExercises(currentUser!.friday!);
        break;
      case 'sunday':
        exerciseListTemp = exerciseService.decodeExercises(currentUser!.sunday!);
        break;
      case 'saturday':
        exerciseListTemp = exerciseService.decodeExercises(currentUser!.saturday!);
        break;
      default:
        exerciseListTemp = [];
        break;
    }
    return exerciseListTemp;
  }

  Future<bool> ifExerciseIsEmpty (String dayOfWeek) async {
    User? currentUser = await userService.getUserByUsername(my_username!);
    bool result = false;
    switch (dayOfWeek.toLowerCase()) {
      case 'monday':
        result = currentUser?.monday == null;
        
        break;
      case 'tuesday':
        result = currentUser?.tuesday == null;

        break;
      case 'wednesday':
        result = currentUser?.wednesday == null;
        break;
      case 'thursday':
        result = currentUser?.thursday == null;
        break;
      case 'friday':
        result = currentUser?.friday == null;
        break;
      case 'sunday':
        result = currentUser?.sunday == null;
        break;
      case 'saturday':
        result = currentUser?.saturday == null;
        break;
      default:
        result = false;
        break;
    }
    return result;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your today routine"),
        centerTitle: true,
      ),
      body: Column(
        children: List.generate(controllers.length, (index) {
          return TextField(
            controller: controllers[index],
            decoration: InputDecoration(
              hintText: my_username,

            ),
          );
        }),
      ),
    );
  }
}