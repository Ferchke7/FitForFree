import 'package:fitforfree/database/exercise_json_helper.dart';
import 'package:fitforfree/models/exercise.dart';
import 'package:fitforfree/models/records.dart';
import 'package:flutter/material.dart';

class ShowWeekList extends StatefulWidget {
  final String recordsTemp;
  const ShowWeekList({Key? key, required this.recordsTemp}) : super(key: key);

  @override
  State<ShowWeekList> createState() => _ShowWeekListState();
}

class _ShowWeekListState extends State<ShowWeekList> {
  List<Exercise> exerList = [];
  ExerciseService exerciseService = ExerciseService();
  @override
  void initState() {
    populateExerList();
  }

  Future<void> populateExerList() async {
    exerList = exerciseService.decodeExercises(widget.recordsTemp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details for this day"),
      ),
      body: ListView(
        children: <Widget>[
          
        ],
      ),
    );
  }
}