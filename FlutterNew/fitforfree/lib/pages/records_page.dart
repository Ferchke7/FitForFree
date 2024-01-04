import 'package:accordion/accordion.dart';
import 'package:fitforfree/database/exercise_json_helper.dart';
import 'package:fitforfree/database/sqlite_service.dart';
import 'package:fitforfree/models/exercise.dart';
import 'package:fitforfree/models/user.dart';
import 'package:fitforfree/pages/edit_routine.dart';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';
List<String> daysOfWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
class AddRecords extends StatefulWidget {
  const AddRecords({super.key});

  @override
  State<AddRecords> createState() => _AddRecordsState();
}

class _AddRecordsState extends State<AddRecords> {
  UserService userService = UserService();
  late User currentUser;
  
  @override
  void initState() {
    super.initState();
    _initCurrentUser();
  }

  Future<void> _initCurrentUser() async {
    User? loadedUser = await userService.getUserByUsername(my_username);

    setState(() {
      currentUser = loadedUser!;
    });
  }

 
  @override
  Widget build(BuildContext context) {
    ExerciseService exerciseService = ExerciseService();
    return Scaffold(
      appBar: AppBar(
        title: Text("The routine"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: daysOfWeek.length,
        itemBuilder: (context, index) {
          String day = daysOfWeek[index];
          return Card(
            
            child: ListTile(
              title: Text(day),
              onTap: () async {
                  // List<Exercise> initialExercises = [
                  //   Exercise(name: 'dsdsd', reps: 3, weight: 14),
                  //   Exercise(name: 'squats', reps: 5, weight: 12),
                  //   Exercise(name: 'bench', reps: 5, weight: 12),
                    
                  //   Exercise(name: '44', reps: 5, weight: 12),
                  // ];
                  // String jsonString = exerciseService.encodeExercises(initialExercises);
                  // currentUser.monday = jsonString;
                  // await userService.updateUser(currentUser);
                Navigator.push(context,
                 MaterialPageRoute(builder: (context) => EditRoutine(day: day,)
                 )
                 );
              },
            ),
            
          );
        })

      ,
      floatingActionButton: 
      FloatingActionButton.small(
        backgroundColor: const Color.fromARGB(255, 24, 6, 97),
        onPressed: () {
          if (currentUser != null) {
          print(currentUser.monday.toString());
          String? tempDay = currentUser.monday;
          
          currentUser.monday = null;
          userService.updateUser(currentUser);
          }
          else {
            print("USER NOT BEING INIT");
          }
          
      },
        child: const Icon(Icons.sync,color: Colors.white,) ),
    );
  }
}
