import 'package:flutter/material.dart';
import 'package:fitforfree/database/exercise_json_helper.dart';
import 'package:fitforfree/database/sqlite_service.dart';
import 'package:fitforfree/models/exercise.dart';
import 'package:fitforfree/models/user.dart';
import 'package:fitforfree/utils/common.dart';

ExerciseService exerciseService = ExerciseService();
UserService userService = UserService();

class EditRoutine extends StatelessWidget {
  final String day;
  const EditRoutine({Key? key, required this.day}) : super(key: key);
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
      
      const DataColumn(label: 
       Text("Edit"),
       tooltip: "Edit"),
      const DataColumn(
        label: Text("Delete"),
        tooltip: "Include reps of weight",
      ),
      
    ];
  }

  Future<List<Exercise>> getExercise() async {
    User? currentUser = await userService.getUserByUsername(my_username);
    var exerciseListTemp;
    switch (day.toLowerCase()) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('DataTable'),
        ),
        body: Container(
          child: FutureBuilder<List<Exercise>>(
            future: getExercise(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: _createColumns(),
                    rows: snapshot.data!.map<DataRow>((e) {
                      return DataRow(
                        cells: <DataCell>[
                          DataCell(Text('${e.name}')),
                          DataCell(Text('${e.reps}')),
                          
                          DataCell(Icon(Icons.edit_note), 
                          onTap: () {
                            print("tapped");
                          },),
                          DataCell(Icon(Icons.delete)),
                          
                        ],
                      );
                    }).toList(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.small(
          backgroundColor: Colors.black,
          onPressed: () {

          },
          child: const Icon(Icons.add, color: Color.fromARGB(249, 248, 246, 246),),
        ),
      );
  }
}
