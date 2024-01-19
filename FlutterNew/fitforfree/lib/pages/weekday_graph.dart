import 'package:fitforfree/database/exercise_json_helper.dart';
import 'package:fitforfree/database/sqlite_service.dart';
import 'package:fitforfree/models/exercise.dart';
import 'package:fitforfree/models/records.dart';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:tiny_charts/tiny_charts.dart';

class WeekDayGraph extends StatefulWidget {
  const WeekDayGraph({Key? key}) : super(key: key);

  @override
  State<WeekDayGraph> createState() => _WeekDayGraphState();
}

class _WeekDayGraphState extends State<WeekDayGraph> {
  UserService userService = UserService();
  List<Records> records = [];
  bool isDataInitialized = false;
  ExerciseService exerciseService = ExerciseService();
  List<Exercise> exercisesList = [];

  @override
  void initState() {
    super.initState();
    if (!isDataInitialized) {
      initRecords();
      
    }
  }

  Future<void> initRecords() async {
    try {
      List<Records> fetchedRecords =
          await userService.getRecordsByUserIdAndWeekName(userId, weekDay.toString());
      debugPrint(fetchedRecords[0].record);
      setState(() {
        records = fetchedRecords;
        isDataInitialized = true;
      });
    } catch (error) {
      debugPrint("Error fetching records: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Your Graph"),
      ),
      body: isDataInitialized
          ? 
          ListView.builder(
            itemCount: records.length,
            itemBuilder: (context, index) {
              return Card(
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(100.0),
                      child: Text(records[index].weekName),
                    ),
                    
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TinyColumnChart(
                          data: const [20, 22, 14, 12, 19, 28, 1, 11],
                          width: 120,
                          height: 28,
                        ),
                    )
                  ],
                ),
              );

            })
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
