import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'provider_screen.dart';

class Send extends StatefulWidget {
  const Send({super.key});

  @override
  State<Send> createState() => _SendState();
}

class _SendState extends State<Send> with TickerProviderStateMixin {
  TextEditingController cont1 = TextEditingController();
  TextEditingController cont3 = TextEditingController();
  TextEditingController cont2 = TextEditingController();

  ImagePicker imag = ImagePicker();
  File? tostore;
  XFile? storedimg = null;

  void getimage() async {
    storedimg = await imag.pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      if (storedimg != null) {
        tostore = File(
          storedimg!.path,
        );
      } else {
        print('No image selected.');
      }
    });
  }

  late TabController tabcontroller;

  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    tabcontroller = TabController(vsync: this, length: tabs.length);
  }

  List<Tab> tabs = [
    Tab(
      icon: Icon(
        Icons.chat,
        size: 30,
      ),
      text: '',
    ),
    Tab(
      icon: Icon(
        Icons.broken_image_outlined,
        size: 30,
      ),
      text: '',
    ),
  ];
  void getdata() async {
    var data = await FirebaseFirestore.instance
        .collection('Users')
        .doc('${FirebaseAuth.instance.currentUser?.email}')
        .get();
    balance = data['Balance'];
  }

  var temp = 0;
  int balance = 0;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //  getdata();
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient:
                      LinearGradient(colors: [Colors.black, Colors.pink])),
              margin: EdgeInsets.all(8),
              width: width * 0.46,
              height: height * 0.308,
              child: ElevatedButton(
                  style: ButtonStyle(
                      shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.black))),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.transparent)),
                  onPressed: () {},
                  child: Stack(children: [
                    ChangeNotifierProvider<Provide>(
                        create: (context) => Provide(),
                        child: Consumer<Provide>(
                            builder: (context, provider, child) {
                          if (temp == 0) {
                            temp = 1;
                            provider.getbalance();
                          }

                          return Align(
                              alignment: AlignmentDirectional(-1, 0),
                              child: Text(
                                '${provider.balance} Crdt.',
                                style: TextStyle(fontSize: 30),
                              ));
                        })),
                    Align(
                        alignment: AlignmentDirectional(-1, 0.8),
                        child: Text(
                          'Current Credits',
                          style: TextStyle(fontSize: 20),
                        )),
                  ]))),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(colors: [Colors.pink, Colors.blue])),
            margin: EdgeInsets.fromLTRB(width * 0.5, 8, width * 0.03, 0),
            width: width * 0.5,
            height: height * 0.15,
            child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.black))),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.transparent)),
                onPressed: () {
                  Navigator.pushNamed(context, '/additem');
                },
                child: Align(
                    alignment: AlignmentDirectional(-1, 0.8),
                    child: Text(
                      'Add Item',
                      style: TextStyle(fontSize: 20),
                    ))),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(colors: [Colors.pink, Colors.blue])),
            margin: EdgeInsets.fromLTRB(
                width * 0.5, 8 + height * 0.16, width * 0.03, 0),
            width: width * 0.6,
            height: height * 0.15,
            child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.black))),
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.transparent)),
                onPressed: () {
 var snackBar = SnackBar(
                          content: Text(
                              'Request Sent,your share would be sent to the account No. provided '),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);

                },
                child: Align(
                    alignment: AlignmentDirectional(-1, 0.8),
                    child: Text(
                      'Withdraw',
                      style: TextStyle(fontSize: 20),
                    ))),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(width * 0.05, height * 0.38, 0, 0),
            child: Text(
              'Recent History',
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(
                  width * 0.05, height * 0.45, width * 0.01, 0),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc('${FirebaseAuth.instance.currentUser?.email}')
                      .collection('Order_details')
                      .snapshots(),
                  builder: (context, AsyncSnapshot snapshot) {
                    return (snapshot.connectionState == ConnectionState.waiting)
                        ? Padding(
                            padding: const EdgeInsets.fromLTRB(170, 220, 0, 0),
                            child: CircularProgressIndicator(
                              backgroundColor: Colors.grey,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blueAccent),
                              strokeWidth: 2,
                            ))
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.docs.length,
                            reverse: false,
                            itemBuilder: (context, index) {
                              // print('prvoder ${provider.temp}');
                              var dat = snapshot.data!.docs[index];

                              return Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      width * 0.0, 10, width * 0.00, 0),
                                  child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.black,
                                      ),
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              shape: MaterialStatePropertyAll(
                                                  RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5.0),
                                                      side: BorderSide(
                                                          color:
                                                              Colors.black))),
                                              backgroundColor:
                                                  MaterialStatePropertyAll(
                                                      Colors.transparent)),
                                          onPressed: () {},
                                          child: Stack(children: [
                                            Align(
                                                alignment: AlignmentDirectional(
                                                    1, 0.8),
                                                child: Text(
                                                  '+5',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                )),
                                            Align(
                                                alignment: AlignmentDirectional(
                                                    -1, 0.8),
                                                child: Text(
                                                  '${dat['Name']}',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ))
                                          ]))));
                            });
                  }))
        ],
      ),
    ));
  }
}
