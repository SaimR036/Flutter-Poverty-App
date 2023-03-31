import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Provide with ChangeNotifier {
  var value;

  void getimage(String text) {
    value = text;
    notifyListeners();
  }

  int balance = 0;
  void getbalance() async {
    var data = await FirebaseFirestore.instance
        .collection('Users')
        .doc('${FirebaseAuth.instance.currentUser?.email}')
        .get();
    balance = data['Balance'];
    notifyListeners();
  }
}
