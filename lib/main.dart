import 'package:chatpdm_app/ui/chat_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  //inicializar o FireBase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //FireBaseHelper helper = FireBaseHelper();
  //helper.sendMessage("oi");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CHAT APP',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          iconTheme: IconThemeData(color: Colors.blue)),
      home: ChatPage(),
    );
  }
}
