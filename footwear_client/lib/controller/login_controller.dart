import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footwear_client/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:otp_text_field_v2/otp_field_v2.dart';

import '../models/user/user.dart';

class LoginController extends GetxController {

  GetStorage box = GetStorage();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference userCollection;

  TextEditingController registerNameCtrl = TextEditingController();
  TextEditingController registerNumberCtrl = TextEditingController();

  TextEditingController loginNumberCtrl = TextEditingController();

  OtpFieldControllerV2 otpController = OtpFieldControllerV2();
  bool otpFieldShown = false;
  int? otpSend;
  int? otpEnter;

  User? loginUser;

  @override
  void onReady(){
    Map<String,dynamic>? user = box.read('LoginUser');
    if(user != null){
      loginUser = User.fromJson(user);
      Get.to(const HomePage());
    }
    super.onReady();
  }

  @override
  void onInit() {
    userCollection = firestore.collection('users');
    super.onInit();
  }

  void addUser() {
    if (otpSend == otpEnter) {
      try {
        DocumentReference doc = userCollection.doc();
        User user = User(
          id: doc.id,
          name: registerNameCtrl.text,
          number: int.tryParse(registerNumberCtrl.text) ?? 0, // Use tryParse to handle invalid input
        );
        final userJson = user.toJson();
        doc.set(userJson).then((_) {
          Get.snackbar('Success', 'User added successfully', colorText: Colors.green);
          registerNumberCtrl.clear();
          registerNameCtrl.clear();
          otpController.clear();
        }).catchError((e) {
          Get.snackbar('Error', 'Failed to add user: $e', colorText: Colors.red);
          print('Error adding user: $e');
        });
      } catch (e) {
        Get.snackbar('Error', 'Failed to add user: $e', colorText: Colors.red);
        print('Error: $e');
      }
    } else {
      Get.snackbar('Error', 'OTP is incorrect', colorText: Colors.red);
    }
  }

  void sendOtp() {
    if (registerNameCtrl.text.isEmpty || registerNumberCtrl.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields', colorText: Colors.red);
      return;
    }

    try {
      final random = Random();
      int otp = 1000 + random.nextInt(9000);
      //String mobileNumber = registerNumberCtrl.text;
      //String url = "";
      //Response response = await GetConnect().get(url);
      print(otp);
      //if(response.body['message'][0]='SMS sent successfully.')
      if(otp != null){
      otpFieldShown = true;
      otpSend = otp;
      print('Generated OTP: $otp'); // Debug: Check if OTP is generated correctly
      Get.snackbar('Success', 'OTP sent successfully', colorText: Colors.green);}
    } catch (e) {
      Get.snackbar('Error', 'Failed to send OTP: $e', colorText: Colors.red);
      print('Error: $e');
    } finally {
      update(); // Update UI state
    }
  }

  Future<void> loginWithPhone() async {
    try{
      String phoneNumber = loginNumberCtrl.text;
      if(phoneNumber.isNotEmpty) {
        var querySnapshot = await userCollection.where(
            'number', isEqualTo: int.tryParse(phoneNumber)).limit(1).get();
        if (querySnapshot.docs.isNotEmpty) {
          var userDoc = querySnapshot.docs.first;
          var userData = userDoc.data() as Map<String, dynamic>;
          box.write('LoginUser', userData);
          loginNumberCtrl.clear();
          Get.to(const HomePage());
          Get.snackbar('Success', 'Login Successful', colorText: Colors.green);
        } else {
          Get.snackbar(
              'Error', 'User not found,please register', colorText: Colors.red);
        }
      } else {
        Get.snackbar('Error', 'Please enter a phone number', colorText: Colors.red);

        }
    } catch(error){
      print("Failed to login: $error");
      Get.snackbar('Error', 'Failed to login', colorText: Colors.red);
    }
  }



}
