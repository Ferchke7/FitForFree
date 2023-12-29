import 'package:accordion/accordion.dart';
import 'package:fitforfree/database/database_helper.dart';
import 'package:fitforfree/models/weeks_routine.dart';
import 'package:flutter/material.dart';

List<String> listOfWeek = <String>[
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday'
];

class EditRoutine extends StatefulWidget {
  final int? id;

  const EditRoutine({Key? key, required this.id}) : super(key: key);

  @override
  State<EditRoutine> createState() => _EditRoutineState();
}

class _EditRoutineState extends State<EditRoutine> {
  late DatabaseHelper _databaseHelper;
  late List<WeekRoutines> routines;
  static const headerStyle = TextStyle(
      color: Color(0xffffffff), fontSize: 18, fontWeight: FontWeight.bold);

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper();
    routines = []; // Initialize the list here to an empty list
    loadRoutines();
  }

  Future<void> loadRoutines() async {
    final loadedRoutines =
        await _databaseHelper.getRoutinesByForeignKey(widget.id);
    setState(() {
      routines = loadedRoutines;
    });
    print(routines);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit your routine ${widget.id}"),
      ),
      body: Accordion(
        children: List.generate(listOfWeek.length, (index) {
          final dayOfWeek = listOfWeek[index];
          return AccordionSection(
            isOpen: false,
            headerBackgroundColor: Colors.blueGrey,
            leftIcon: const Icon(
              Icons.change_circle,
              color: Colors.white,
            ),
            header: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dayOfWeek, style: headerStyle),
                ElevatedButton(
                  onPressed: () {
                    
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: const Text(
                    'Edit',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            content: MyDataTable(routines: routines),
          );
        }),
      ),
    );
  }
}

class MyDataTable extends StatelessWidget {
  final List<WeekRoutines> routines;

  const MyDataTable({Key? key, required this.routines}) : super(key: key);

  @override
  Widget build(context) {
    return DataTable(
      sortAscending: true,
      sortColumnIndex: 1,
      showBottomBorder: false,
      columns: const [
        DataColumn(
          label: Text('ID'),
          numeric: true,
        ),
        DataColumn(
          label: Text('Description'),
        ),
        DataColumn(
          label: Text('Reps'),
          numeric: true,
        ),
      ],
      rows: List.generate(routines.length, (index) {
        final weekRoutine = routines[index];
        return DataRow(
          cells: [
            DataCell(Text(
              weekRoutine.id.toString(),
              textAlign: TextAlign.right,
            )),
            DataCell(Text(
              weekRoutine.monday ?? '',
              textAlign: TextAlign.right,
            )),
            DataCell(Text(
              weekRoutine.tuesday ?? '',
              textAlign: TextAlign.right,
            )),
          ],
        );
      }),
    );
  }
}
