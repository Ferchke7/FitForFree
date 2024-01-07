import 'package:fitforfree/database/sqlite_service.dart';
import 'package:fitforfree/models/user.dart';
import 'package:fitforfree/pages/homer.dart';
import 'package:fitforfree/pages/records_page.dart';
import 'package:fitforfree/services/new_list.dart';
import 'package:fitforfree/services/user_api.dart';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    //String? email = client.auth.currentUser?.email.toString();
    //String emailTemp = email.toString();
    _initUser();
    client.auth.currentSession?.accessToken;
    return const BottomMainNavigator();
  }
}

void _initUser() async {
  String? email = client.auth.currentUser?.email;
  String username = email?.split('@')[0] ?? '';

  UserService userService = UserService();

  User? existingUser = await userService.getUserByUsername(username);

  if(existingUser == null) {
    User initialize = User(
      username: username,
      creationDate: DateTime.now().toString(),
    );
    await userService.insertUser(initialize);
    User? tempUser = await userService.getUserByUsername(username);
    userId = tempUser!.id!;
    my_username = tempUser.username!;
    print("SUCC ADDED");
  }
  else {
    var temp = existingUser.username;
    userId = existingUser.id!;
    my_username = temp!;
    print("ALREADY $temp");
  }
}


class BottomMainNavigator extends StatefulWidget {
  const BottomMainNavigator({super.key});
  
  @override
  State<BottomMainNavigator> createState() =>
      _BottomMainNavigatorState();
}

class _BottomMainNavigatorState extends State<BottomMainNavigator> {
  UserService userService = UserService();
  String? tempName = client.auth.currentUser?.email?.split('@')[0];
  


  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    HomerPage(),
    //Text("TEMP"),
    AddRecords(),
    NewsList(),
    Text(
      'Index 3: Settings',
      style: optionStyle,
    ),
    
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
    centerTitle: true,
    actions: [
      IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Do you want to Log out?"),
                content: const SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text("Do you want to sign-out?")
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      // Perform logout action here
                      client.auth.signOut();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Yes'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('No'),
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(Icons.logout_outlined),
      ),
      ],
    ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Home',
            backgroundColor: Colors.black,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.route_outlined),
            label: 'My Routine',
            backgroundColor: Colors.indigo,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Forum',
            backgroundColor:  Colors.black,
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books),
            label: 'Routine library',
            backgroundColor: Colors.indigo,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      drawer: Drawer(
                
        child: ListView(
          
          children: <Widget>[
            UserInformation(),            
            const ListTile(
              title: Text('Welcome '),
            
            ),
            const ListTile(
              title: Text("This part under development,\nit will include some function in the future.\n"),
            ),
            const ListTile(
              title: Text("If you want to quit, there is a button for sign-out"),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
              ),
              onPressed: ()
             {
              print("Pressed");
             },
            icon: const Icon(Icons.chat), 
            label: Text("Live Chatting"))
          ],
          
        ),
        
      )
    );
  }
}
