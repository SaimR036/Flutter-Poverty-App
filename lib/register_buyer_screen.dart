import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class register_b extends StatefulWidget {
  const register_b({super.key});

  @override
  State<register_b> createState() => _register_bState();
}

class _register_bState extends State<register_b> {
  Map data = {};
  var show = false;
  TextEditingController save1 = TextEditingController();
  TextEditingController save2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context)?.settings.arguments as dynamic;
    var wid = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.pink,
            body: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      wid * 0.1, height * 0.1, wid * 0.1, 0),
                  child: TextField(
                    controller: save1,
                    decoration: InputDecoration(hintText: 'Enter Phone'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      wid * 0.1, height * 0.2, wid * 0.1, 0),
                  child: TextField(
                    controller: save2,
                    decoration: InputDecoration(hintText: 'Enter Address'),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(
                        wid * 0.40, height * 0.4, wid * 0.1, 0),
                    child: TextButton(
                      child: Text('Register'),
                      onPressed: () async {
                        try {
                          var snackBar = SnackBar(
                            content: Text('Please Wait'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: data['Email'], password: data['Pass']);
                          await FirebaseFirestore.instance
                              .collection('Users')
                              .doc('${data['Email']}')
                              .set({
                            'Type': 'Needy',
                            'Phone': save1.text,
                            'Address': save2.text,
                            'Currdate':DateTime(1967, 10, 12)
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
                    padding: EdgeInsets.fromLTRB(
                        wid * 0.3, height * 0.55, wid * 0.1, 0),
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
                          wid * 0.1, height * 0.65, wid * 0.1, height * 0.1),
                      child: Text(
                          'As a client you need to enter your details to get a full use of the app that is the item you selected based on your need will be delivered to you at your address'))
              ],
            )));
  }
}
