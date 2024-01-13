import 'dart:convert';
import 'dart:io';

import 'package:fitforfree/database/sqlite_service.dart';
import 'package:fitforfree/models/routine_dto.dart';
import 'package:fitforfree/models/user.dart';
import 'package:fitforfree/pages/routine_download.dart';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShareRoutinePage extends StatefulWidget {
  const ShareRoutinePage({super.key});

  @override
  State<ShareRoutinePage> createState() => _ShareRoutinePageState();
}

class _ShareRoutinePageState extends State<ShareRoutinePage> {
  UserService userService = UserService();
  late Future<List<RoutineDTO>> routinesBack;
  TextEditingController routineName = TextEditingController();
  TextEditingController routineDescription = TextEditingController();
  @override
  void initState() {
    super.initState();
    routinesBack = fetchRoutines();
  }

  @override dispose() {
    super.dispose();
    routineName.dispose();
    routineDescription.dispose();
  }

  // Future<void> deleteCard(int postId) {
    
  // }
  Future<void> postData(RoutineDTO routineDTO) async {
  final accessToken = client.auth.currentSession?.accessToken;
  const String apiUrl =
      'http://192.227.152.231:3333/Exercise';
  final response = await http.post(
    Uri.parse(apiUrl),
    headers: {
      HttpHeaders.contentTypeHeader: "application/json",
      HttpHeaders.authorizationHeader: "Bearer $accessToken"
    },
    body: jsonEncode(routineDTO.toJson()),
  );

  if (response.statusCode == 200) {
    debugPrint('Post Successful!');
  } else {
    debugPrint('Failed to post data. Error: ${response.statusCode}');
  }
}


  Future<List<RoutineDTO>> fetchRoutines() async {
    try {
      final accessToken = client.auth.currentSession?.accessToken;
      debugPrint(accessToken);
      if (accessToken == null) {
        throw Exception('Access token is null.');
      }

      final response = await http.get(
        Uri.parse('http://192.227.152.231:3333/Exercise'),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json",
          HttpHeaders.authorizationHeader: "Bearer $accessToken"
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<RoutineDTO> routines =
            data.map((item) => RoutineDTO.fromJson(item)).toList();
        debugPrint(routines.length.toString());
        return routines;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      debugPrint('Error fetching posts: $e');
      throw Exception('Failed to load posts');
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    
    body: Column(
      children: <Widget>[
        Expanded( 
          child: FutureBuilder(
            future: routinesBack,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No routines available.')
                );
              } else {
                List<RoutineDTO> routinesTemp = snapshot.data!;
                return ListView.builder(
                  itemCount: routinesTemp.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        
                      },
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[

                            ListTile(
                              title: Text(routinesTemp[index].routineName, 
                              style: const TextStyle(color: Colors.indigo,)),
                              subtitle: Text(
                                'Created by: ${routinesTemp[index].user}\n\n${routinesTemp[index].routineDescription}...',
                                style: const TextStyle(color: Colors.indigo),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                const SizedBox(
                                  width: 3,
                                  height: 10,
                                ),
                                routinesTemp[index].user == my_username ?
                                IconButton(onPressed: () {},
                                 icon: const Icon(Icons.delete), color: Colors.indigo,)
                                : Container(),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                                  child: const Text("donwload", style: TextStyle(color: Colors.white),),
                                  onPressed: () {
                                    Navigator.push(context,
                                     MaterialPageRoute(builder: (context) => RoutineDonwload(routineDTO: routinesTemp[index],)
                                     ));
                                  },
                                ),
                                const SizedBox(
                                  width: 3,
                                  height: 10,
                                ),
                                
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    ),
    floatingActionButton: FloatingActionButton.small(
      backgroundColor: Colors.indigo,
      onPressed: () => showDialog(context: context, 
      builder: (BuildContext context) => Dialog.fullscreen(
        child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Text('Share your routine\nYour current routine will be shared'),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: const Text("Name of Routine"),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 250,
                child: TextFormField(
                controller: routineName,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  labelText: "Name of Routine"
                ),
              ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: const Text("Description of routine"),
            ),
            SizedBox(
              width: 300,
              child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              controller: routineDescription,
              autofocus: true,
              
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 100),
                border: OutlineInputBorder(),
                labelText: "Description"
              ),
            ),
            ),
            const Divider(),
            ElevatedButton(onPressed: () async {
              User? user = await userService.getUserByUsername(my_username!);
              
              debugPrint("GET USER SERVICE:");
              debugPrint(user?.monday.toString());
              RoutineDTO routineDTO = RoutineDTO
              (routineName: routineName.text, routineDescription: routineDescription.text,
               monday: user?.monday, 
               tuesday: user?.tuesday, 
               wednesday: user?.wednesday, 
               thursday: user?.thursday, 
               friday: user?.friday, 
               saturday: user?.saturday, 
               sunday: user?.sunday,
                user: my_username!);
              
              debugPrint(routineDTO.tuesday.toString());
              routineDescription.clear();
              routineName.clear();
              await postData(routineDTO);
              
              setState(() {
                routinesBack = fetchRoutines();
                Navigator.pop(context);
                
              });
              
            }, child: const Text("Share ")),
            ElevatedButton(onPressed: () {
              Navigator.pop(context);
            }, child: const Text("Cancel"))
          ],
        ),
      ))
    ),
      child: const Icon(Icons.add, color: Colors.white),
  ));
}

}
