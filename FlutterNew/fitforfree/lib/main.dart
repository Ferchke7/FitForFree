import 'package:fitforfree/pages/home_page.dart';
import 'package:fitforfree/pages/start_page.dart';
import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://ksinlwplkjexoipqpose.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImtzaW5sd3Bsa2pleG9pcHFwb3NlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MDI3Mjg2MjgsImV4cCI6MjAxODMwNDYyOH0.whWKHDaYAQ17OjmZk2mF_HxixCXwA2BDAvYp3zgVeuE',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Authentication',
      theme: ThemeData(
       primarySwatch: Colors.blueGrey
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  User? _user;
  @override
  void initState() {
    _getAuth();
    super.initState();
  }

  Future<void> _getAuth() async {
    setState(() {
      _user = client.auth.currentUser;
    });
    client.auth.onAuthStateChange.listen((event) {
      setState(() {
        _user = event.session?.user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _user == null ? const StartPage() 
      : const HomePage(),
    );
  }

  
}