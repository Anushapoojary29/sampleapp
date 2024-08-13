import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:prcatice/controller/home_controller.dart';
import 'package:prcatice/firebase_options.dart';
import 'package:prcatice/pages/home_page.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: firebaseOptions);
  //? registering my controller
  Get.put(HomeController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),//const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

