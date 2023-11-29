import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            if (userInfo != null) ...[
              Text('Hello ${userInfo!.name}}'),
              Text(userInfo!.email ?? ''),
              
              OutlinedButton(
                child: const Text('Logout'),
                onPressed: () async {
                  setState(() {
                    userInfo = null;
                  });
                },
              ),
              OutlinedButton(
                onPressed: () async {
                    
                      final response = await http.get(
  Uri.parse('http://10.0.2.2:5258/weatherforecast/Testable'),
  headers: {
    'Authorization': 'Bearer ${credential?.idToken}'
  },
);
                      if (response.statusCode == 200) {
                      final text = response.body;
                      print(text);
                  } else {
                      print('Error: ${response.statusCode}');
                    }
                }, 
                child: const Text("get hello from backend"))
            ],
            if (userInfo == null)
              OutlinedButton(
                child: const Text('Login'),
                onPressed: () async {
                  var credential = await authenticate(client, scopes: scopes);
                  var userInfo = await credential.getUserInfo();
                  setState(() {
                    this.userInfo = userInfo;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}