import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:footwear_client/controller/login_controller.dart';
import 'package:footwear_client/pages/home_page.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../models/user/user.dart';

class PurchaseController extends GetxController {

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late CollectionReference orderCollection;

  TextEditingController addressController = TextEditingController();

  double orderPrice = 0;
  String itemName = '';
  String orderAddress = '';

  late Razorpay _razorpay; // Define _razorpay as an instance variable

  @override
  void onInit() {
    orderCollection = firestore.collection('orders');
    super.onInit();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
  }

  void submitOrder({
    required double price,
    required String item,
    required String description,
  }) {
    orderPrice = price;
    itemName = item;
    orderAddress = addressController.text;

    var options = {
      'key': 'rzp_test_56G792QDZ1UzS8',
      'amount': price * 100,
      'name': item,
      'description': description,
    };

    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    orderSuccess(transactionId: response.paymentId);
    Get.snackbar('Success', 'Payment is successfully', colorText: Colors.green);
    // Do something when payment succeeds
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar('Success', '${response.message}', colorText: Colors.green);
    // Do something when payment fails
  }
  Future<void> orderSuccess({required String? transactionId}) async{
    User? loginUse = Get.find<LoginController>().loginUser;
    try{
      if(transactionId != null) {
        DocumentReference docRef = await orderCollection.add({
          'customer': loginUse?.name ?? '',
          'phone': loginUse?.number ?? '',
          'item': itemName,
          'price': orderPrice,
          'address': orderAddress,
          'transactionId': transactionId,
          'dateTime': DateTime.now().toString(),
        });
        print("Order Created Successfully: ${docRef.id}");
        showOrderSuccessDialog(docRef.id);
        Get.snackbar(
            'Success', 'Order Created Successfully', colorText: Colors.green);
      } else {
        Get.snackbar(
            'Error', 'Please fill all fields', colorText: Colors.red);
      }
    } catch(error) {
      print("Failed to register user: $error");
      Get.snackbar('Error', 'Failed to Create Order',colorText: Colors.red);
    }
  }

  void showOrderSuccessDialog(String orderId){
    Get.defaultDialog(
      title: "Order Success",
      content: Text("YourOrderId is $orderId"),
      confirm: ElevatedButton(
          onPressed: (){
            Get.off(const HomePage());
          },
          child: const Text("Close"),

      ),
    );
  }

  @override
  void onClose() {
    _razorpay.clear(); // Make sure to clear the listeners when the controller is disposed
    super.onClose();
  }
}
