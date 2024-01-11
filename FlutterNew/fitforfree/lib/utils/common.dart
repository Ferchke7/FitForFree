import 'package:supabase_flutter/supabase_flutter.dart';

final client = Supabase.instance.client;
late int userId;
String? my_username;
String? weekDay;
String getUser() {
  String? email = client.auth.currentUser?.email;
  String username = email?.split('@')[0] ?? '';

  return username;
}
