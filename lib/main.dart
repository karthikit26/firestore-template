import 'package:chordify_assignment/controller/form_controller.dart';
import 'package:chordify_assignment/view/message_form.dart';
import 'package:chordify_assignment/view/message_list.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(
      ChordAssignmentApp());
}

class ChordAssignmentApp extends StatelessWidget {
  ChordAssignmentApp({super.key});

  final FormController controller = Get.put(FormController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Get.to(() => MessageForm()),
              child: const Text('Submit Message'),
            ),
            ElevatedButton(
              onPressed: () => Get.to(() => MessagesList()),
              child: const Text('View Messages'),
            ),
          ],
        ),
      ),
    );
  }
}

