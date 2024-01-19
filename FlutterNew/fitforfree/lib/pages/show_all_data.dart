import 'package:fitforfree/database/exercise_json_helper.dart';
import 'package:fitforfree/database/sqlite_service.dart';
import 'package:fitforfree/models/exercise.dart';
import 'package:fitforfree/models/records.dart';
import 'package:fitforfree/pages/show_week_list.dart';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';

class ShowAllData extends StatefulWidget {
  const ShowAllData({super.key});

  @override
  State<ShowAllData> createState() => _ShowAllDataState();
}

class _ShowAllDataState extends State<ShowAllData> {
  UserService userService = UserService();
  ExerciseService exerciseService = ExerciseService();
  List<Records> listOfRecords = [];
  List<Exercise> justExercise = [];

  @override
  void initState() {
    super.initState();
  }

  Future<void> initListOfRecords() async {
    listOfRecords = await userService.getRecordsByUserId(userId);
    debugPrint(listOfRecords.toList().toString());
    if (listOfRecords.isNotEmpty) {
      for (int i = 0; i < listOfRecords.length; i++) {
        List<Exercise> tempExer =
            await exerciseService.decodeExercises(listOfRecords[i].record);

        populateExerciseList(tempExer);
        debugPrint(tempExer.toString());
      }
    } else {
      debugPrint("LIST IS EMPTY");
    }
  }

  Future<void> populateExerciseList(List<Exercise> ex) async {
    if (ex.isNotEmpty) {
      for (int i = 0; i < ex.length; i++) {
        justExercise.add(ex[i]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Records list"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: initListOfRecords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: listOfRecords.length,
                itemBuilder: (BuildContext context, index) {
                  return Card(
                    child: ListTile(
                      title: Text("Day of saved record: ${listOfRecords[index].date.substring(0,10)}\nWeekday: ${listOfRecords[index].weekName}"),
                      onTap: () {
                        String recordsTemp = listOfRecords[index].record;
                        Navigator.push(context, MaterialPageRoute(builder: (context) =>  ShowWeekList(recordsTemp: recordsTemp,)));
                      },
                      trailing: const Icon(Icons.read_more),
                    ),
                  );
                });
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
