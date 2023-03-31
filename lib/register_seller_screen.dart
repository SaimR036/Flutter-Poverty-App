import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class register_s extends StatefulWidget {
  @override
  State<register_s> createState() => _register_sState();
}

class _register_sState extends State<register_s> {
  bool show = false;
  TextEditingController save1 = TextEditingController();
  TextEditingController save2 = TextEditingController();
  Map data = {};
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)?.settings.arguments as dynamic;
    var wid = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.pink,
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: EdgeInsets.fromLTRB(wid * 0.1, height * 0.1, wid * 0.1, 0),
            child: TextField(
              controller: save1,
              decoration: InputDecoration(hintText: 'Enter Account No'),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(wid * 0.1, height * 0.1, wid * 0.1, 0),
            child: TextField(
              controller: save2,
              decoration: InputDecoration(hintText: 'Enter Bank Name'),
            ),
          ),
          Padding(
              padding:
                  EdgeInsets.fromLTRB(wid * 0.1, height * 0.1, wid * 0.1, 0),
              child: TextButton(
                child: Text('Register'),
                onPressed: () async {
                  try {
                    var snackBar = SnackBar(
                      content: Text('Please Wait'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);

                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: data['Email'], password: data['Pass']);
                    await FirebaseFirestore.instance
                        .collection('Users')
                        .doc('${data['Email']}')
                        .set({
                      'Balance': 0,
                      'Type': 'Donor',
                      'Acc-No': save1.text,
                      'Bank-Name': save2.text
                    });
                    snackBar = SnackBar(
                      content: Text('Account Created Successfully'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Future.delayed(Duration(seconds: 1), () {
                      Navigator.pushReplacementNamed(context, '/home');
                    });
                  } on FirebaseAuthException catch (e) {
                    var snackBar = SnackBar(
                      content: Text('${e.message}'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
              )),
          Padding(
              padding:
                  EdgeInsets.fromLTRB(wid * 0.1, height * 0.1, wid * 0.1, 0),
              child: TextButton(
                child: Text('Why do we need it?'),
                onPressed: () {
                  setState(() {
                    show = !show;
                  });
                },
              )),
          if (show)
            Padding(
                padding: EdgeInsets.fromLTRB(
                    wid * 0.1, height * 0.1, wid * 0.1, height * 0.1),
                child: Text(
                    'The app works on the basis of benefiting both the clients and the senders of this app, the client is given the product that the donors have posted and as for the Donor side, you will be paid for your contribution towards the needy. The app works on how many items you donate and you would be given credits in your wallet for the number of items the clients have recieved,however,a point to be noted is that you will be rewarded credits for the delivery of the item to the client not just listing an item. As far as the pay is concerned you will be paid monthly and the formula we will use is (your credits)/ (total credits of all users combined) * A Variable Amount(which depends on the number of users of the app),for this payment we need your bank account details to transfer the money')),
        ]),
      ),
    ));
  }
}
