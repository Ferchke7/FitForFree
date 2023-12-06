import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_fitt_app/homepage.dart';
import 'package:my_fitt_app/show_routine.dart';
import 'package:my_fitt_app/user_data.dart';
import 'package:openid_client/openid_client.dart';
import 'openid_io.dart';
import 'package:http/http.dart' as http;
const keycloakUri = 'http://localhost:28080/realms/fitness-realm';
const scopes = ['profile'];

Credential? credential;

late final Client client;

Future<Client> getClient() async {
  var uri = Uri.parse(keycloakUri);
  if (!kIsWeb && Platform.isAndroid) uri = uri.replace(host: '10.0.2.2');
  var clientId = 'flutter-app-client';

  var issuer = await Issuer.discover(uri);
  return Client(issuer, clientId);
}

Future<void> main() async {
  client = await getClient();
  credential = await getRedirectResult(client, scopes: scopes);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Free fitness',
      home: MyHomePage(title: 'Welcome'),
      
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  UserInfo? userInfo;
  int _currentIndex = 0;
  @override
  void initState() {
    if (credential != null) {
      credential!.getUserInfo().then((userInfo) {
        setState(() {
          this.userInfo = userInfo;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        
        backgroundColor: Colors.black,
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          icon: const Icon(Icons.account_circle),
          onPressed: () {
            // Handle leading icon press
          },
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              handleAction(value);
            },
            itemBuilder: (BuildContext context) {
              return [
                if (userInfo != null)
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Logout'),
                  ),
                const PopupMenuItem<String>(
                  value: 'get_hello',
                  child: Text('Get Hello from Backend'),
                ),
                const PopupMenuItem<String>(
                  value: 'add_routine',
                  child: Text('Add Routine'),
                ),
                const PopupMenuItem<String>(
                  value: 'show_routine',
                  child: Text('Show Routine'),
                ),
                if (userInfo == null)
                  const PopupMenuItem<String>(
                    value: 'login',
                    child: Text('Login'),
                  ),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (userInfo != null) ...[
              Text('Hello ${userInfo!.name}}'),
              Text(userInfo!.email ?? ''),
            ],
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          
        },
       items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper),
            label: 'News',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.forum),
            label: 'Forum',
          ),
        ],
        
        ),
    );
  }

  void handleAction(String action) async {
    switch (action) {
      case 'logout':
        setState(() {
          userInfo = null;
        });
        break;
      // case 'get_hello':
      //   final response = await http.get(
      //     Uri.parse('http://10.0.2.2:5258/weatherforecast/Testable'),
      //   );
      //   if (response.statusCode == 200) {
      //     final text = response.body;
      //     print(text);
      //   } else {
      //     print('Error: ${response.statusCode}');
      //   }
      //   break;
      case 'add_routine':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddRoutine()),
        );
        break;
      case 'show_routine':
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const UserTraining()),
        );
        break;
      case 'login':
        var credential = await authenticate(client, scopes: scopes);
        var userInfo = await credential.getUserInfo();
        setState(() {
          this.userInfo = userInfo;
        });
        break;
    }
  }
}
