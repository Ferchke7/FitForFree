import 'package:fitforfree/utils/common.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Center(
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Welcome'),
          OutlinedButton(onPressed: () {
            client.auth.signOut();
          }, 
          child: const Text('sign-out'))
        ],
      ),
    );
  }
}