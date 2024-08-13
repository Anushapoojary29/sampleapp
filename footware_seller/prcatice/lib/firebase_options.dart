import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

// Firebase options specific to Android
final FirebaseOptions firebaseOptions = FirebaseOptions(
  apiKey: 'AIzaSyAH33MYDJMst_9yd5wA76o1z8djHn-kqY4',
  appId: '1:751438317594:android:2d95eda81355ad994b69a3',
  messagingSenderId: '751438317594',
  projectId: 'practice-project-bbb9a',
);

// Function to initialize Firebase
Future<void> initializeFirebase() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await Firebase.initializeApp(options: firebaseOptions);
  } else {
    // Handle other platforms or show an error if not supported
    throw UnsupportedError('Firebase is only supported on Android in this setup.');
  }
}