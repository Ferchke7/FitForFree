
import 'package:flutter/material.dart';
import 'package:fitforfree/database/exercise_json_helper.dart';
import 'package:fitforfree/database/sqlite_service.dart';
import 'package:fitforfree/models/exercise.dart';
import 'package:fitforfree/models/user.dart';
import 'package:fitforfree/utils/common.dart';

ExerciseService exerciseService = ExerciseService();
UserService userService = UserService();

class EditRoutine extends StatefulWidget {
  final String day;

  const EditRoutine({super.key, required this.day});

  @override
  _EditRoutineState createState() => _EditRoutineState();
}

class _EditRoutineState extends State<EditRoutine> {
  late Future<List<Exercise>> exerlist;
  
  final TextEditingController _newExerController = TextEditingController();
  final TextEditingController _newRepsController = TextEditingController();
  @override
  void initState() {
    exerlist = getExercise();
    super.initState();
  }
  @override
  void dispose() {
    _newExerController.dispose();
    _newRepsController.dispose();
    super.dispose();
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn(
        label: Text("Name"),
        tooltip: "Name of Routine",
      ),
      const DataColumn(
        label: Text("Reps"),
        tooltip: "Reps",
      ),
      const DataColumn(label: Text("Edit"), tooltip: "Edit"),
      const DataColumn(
        label: Text("Delete"),
        tooltip: "Include reps of weight",
      ),
    ];
  }
    Future<void> updateExercise(List<Exercise> updatedList) async {
    User? currentUser = await userService.getUserByUsername(my_username!);
    
    switch (widget.day.toLowerCase()) {
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

  

  Future<bool> ifExerciseIsEmpty () async {
    User? currentUser = await userService.getUserByUsername(my_username!);
    bool result = false;
    switch (widget.day.toLowerCase()) {
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


  Future<List<Exercise>> getExercise() async {
    User? currentUser = await userService.getUserByUsername(my_username!);
    var exerciseListTemp;
    switch (widget.day.toLowerCase()) {
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
  String? validateInteger(String value) {
  try {
    int.parse(value);
    return null; 
  } catch (e) {
    return 'Please enter a valid integer'; 
  }
  }

  int? parseReps(String value) {
  try {
    return int.parse(value);
  } catch (e) {
    return null; // Return null if parsing fails
  }
}
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Routine'),
          content: Column(
            children: [
               TextFormField(
            controller: _newExerController,
            
            onChanged: (value) {},
            
            decoration: const InputDecoration(hintText: "Put the name of Routine"),
          ),
           TextFormField(
            controller: _newRepsController,
            validator: (value) => validateInteger(value!),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              
            },
            
            decoration: const InputDecoration(hintText: "Put the reps"),
          ),
            ],
          ),
          actions: <Widget>[
            MaterialButton(
              color: Colors.green,
              textColor: Colors.white,
              child: const Text('Add'),
              
              onPressed: () async {
                int? repsTemp = parseReps(_newRepsController.text);
                
                
                List<Exercise> tempExercise = [Exercise(name: _newExerController.text, reps: repsTemp!, weight: 0)];
                bool isEmptyX = await ifExerciseIsEmpty();
                if (isEmptyX == true) { //changed here move from down to top if want to change
                exerciseService.addExercise
                (tempExercise, 
                _newExerController.text, 
                repsTemp, 
                0);
               
                print(tempExercise.toString());
                updateExercise(tempExercise);
                _newExerController.clear();
                _newRepsController.clear();
                }
                else {
                  List<Exercise> currentList = await exerlist;

                exerciseService.addExercise
                (currentList, 
                _newExerController.text, 
                repsTemp, 
                0);
               
                print(currentList.toString());
                updateExercise(currentList);
                _newExerController.clear();
                _newRepsController.clear();
                }
                
                // List<Exercise> currentList = await exerlist;
                
                setState(() {
                  Navigator.pop(context);  
                });
                
              },
              
            ),
            MaterialButton(
              color: const Color.fromARGB(255, 0, 0, 0),
              textColor: Colors.white,
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DataTable'),
      ),
      body: FutureBuilder<List<Exercise>>(
        future: exerlist,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              
              child: Center(
                child: DataTable(
                  showBottomBorder: true,
                  
                  columns: _createColumns(),
                  rows: snapshot.data!.map<DataRow>((e) {
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(e.name)),
                        DataCell(Text('${e.reps}')),
                        DataCell(
                          const Icon(Icons.edit_note),
                          onTap: () {
                            print("tapped");
                          },
                        ),
                        DataCell(
                          Icon(Icons.delete),
                          onTap: () {
                            print("DELETE");
                          },
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center
            (child: Text("List is empty"),);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton.small(
        backgroundColor: Colors.black,
        onPressed: () {
          _displayTextInputDialog(context);
        },
        child: const Icon(Icons.add, color: Color.fromARGB(249, 248, 246, 246)),
      ),
    );
  }
}
