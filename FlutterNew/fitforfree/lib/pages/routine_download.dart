import 'package:fitforfree/models/routine_dto.dart';
import 'package:flutter/material.dart';

class DownloadRoutine extends StatefulWidget {
  final RoutineDTO routineDTO;
  const DownloadRoutine(Key? key, this.routineDTO) : super(key: key);

  @override
  State<DownloadRoutine> createState() => _DownloadRoutineState();
}

class _DownloadRoutineState extends State<DownloadRoutine> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Download"),
      ),
    );
  }
}