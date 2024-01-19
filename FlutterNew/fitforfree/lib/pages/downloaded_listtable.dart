import 'package:fitforfree/models/exercise.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DowloadedListTable extends StatefulWidget
{
  List<List<Exercise>> listOfExercises = [];
  DowloadedListTable({super.key, required this.listOfExercises});

  @override
  State<DowloadedListTable> createState() => _DowloadedListTableState();
}
class _DowloadedListTableState extends State<DowloadedListTable> {
  String weekDay (int index) {
    switch(index) {
      case 0 :
      return "Monday";
      case 1 :
      return "Tuesday";
      case 2 :
      return "Wednesday";
      case 3 :
      return "Thursday";
      case 4 :
      return "Friday";
      case 5 :
      return "Saturday";
      case 6 :
      return "Sunday";
      
    }
    return "Nothing";
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true, 
            itemCount: widget.listOfExercises.length,
            itemBuilder: (context, index) {
              return DataTable(
                sortAscending: true,
                sortColumnIndex: 1,
                showBottomBorder: false,
                columns: const [
                  DataColumn(label: Text('Reps'), numeric: true),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Weekday'))
                ],
                rows: widget.listOfExercises[index].map((exercise) {
                  return DataRow(
                    cells: [
                      DataCell(Text(
                        exercise.reps.toString(),
                        textAlign: TextAlign.right,
                      )),
                      DataCell(Text(exercise.name)),
                      DataCell(Text(weekDay(index)))
                    ],
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}