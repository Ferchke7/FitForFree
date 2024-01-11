import 'package:fitforfree/database/sqlite_service.dart';
import 'package:fitforfree/models/records.dart';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:tiny_charts/tiny_charts.dart';

class WeekDayGraph extends StatefulWidget {
  const WeekDayGraph({super.key});

  @override
  State<WeekDayGraph> createState() => _WeekDayGraphState();
}

class _WeekDayGraphState extends State<WeekDayGraph> {
  UserService userService = UserService();
  List<Records> records = [];

  @override
  void initState() {
    super.initState();
    initRecords();
    debugPrint(records.length.toString());
  }

  Future<void> initRecords() async {
  try {
    List<Records> result = await userService.getRecordsByUserIdAndWeekName(userId, weekDay!.toLowerCase());
    setState(() {
      records = result;
    });
  } catch (error) {
    debugPrint("Error fetching records: $error");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BLA"),
      ),
      body: records.isEmpty 
      ? Center(child: CircularProgressIndicator())
      : Center(
        child: TinyLineChart(
          width: 100,
          height: 28,
          dataPoints: records.map((records) {
            return const Offset(0, 1);
          })),
      )
      
    );
  }
}
