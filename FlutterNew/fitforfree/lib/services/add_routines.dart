import 'package:fitforfree/database/database_helper.dart';
import 'package:fitforfree/models/routine.dart';
import 'package:fitforfree/services/edit_routines_service.dart';



import 'package:flutter/material.dart';

class AddRoutines extends StatefulWidget {
  const AddRoutines({super.key});

  @override
  _AddRoutinesState createState() => _AddRoutinesState();
}

class _AddRoutinesState extends State<AddRoutines> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  TextEditingController nameOfRoutine = TextEditingController();

  Future showDialogAdding() {
    return showDialog(
      context: context, 
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Routine"),
          content: TextField(
            controller: nameOfRoutine,
            decoration: const InputDecoration(
              hintText: "Name of Routine"
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Colors.blue,
              textColor: Colors.white,
              child: const Text("Add"),
              onPressed: () async {
                String tempText = nameOfRoutine.text;
                Routine routine = Routine(name: tempText);
                await _databaseHelper.insertRoutine(routine);
                
                refreshPage();
                setState(() {
                  Navigator.pop(context);
                });
              }
              ),
            MaterialButton(
              color: Colors.black,
              textColor: Colors.white,
              child: const Text("Cancel"),
              onPressed:(){
                setState(() {
                  Navigator.pop(context);
                });
              }),
            
          ],
        );
      });
  }
  String? valueText; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Routines'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Routine>>(
        future: _databaseHelper.getRoutines(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Routine>? routines = snapshot.data;
            return ListView.builder(
              itemCount: routines!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(routines[index].name),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) => _handleMenuClick(value,routines[index].id),
                      itemBuilder: (BuildContext context) {
                        return ['edit','delete'].map((String option) {
                          return PopupMenuItem(
                            value: option,
                            child: Text(option));
                        }).toList();
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      
      floatingActionButton: Column(
        
        mainAxisAlignment: MainAxisAlignment.end,
        
        children: [
          
          FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              showDialogAdding();
              setState(() {
                
              });
              
            }),
        ],
      )
    );
  }

  void _handleMenuClick(String value,int? id) {
    if (value == 'edit') {
      Navigator.push(context,
      MaterialPageRoute(builder: (context) => EditRoutine(id: id)));
    }
    else if (value == 'delete') {
      _databaseHelper.deleteRoutine(id!);
      refreshPage();
    }
  }
  void refreshPage() {
  setState(() {
    
  });
}
  
}
