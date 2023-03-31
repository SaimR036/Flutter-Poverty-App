import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solution/Sender_page.dart';
import 'package:solution/item_info.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:solution/reciever_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:solution/register_buyer_screen.dart';
import 'package:solution/send_item_screen.dart';
import 'Sender_page.dart';
import 'send_item_screen.dart';
import 'item_info.dart';
import 'package:page_transition/page_transition.dart';
import 'register_seller_screen.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    routes: {
      '/send': (context) => Send(),
      '/additem': (context) => SendItem(),
      '/recieve': (context) => recieve(),
      '/iteminfo': (context) => iteminfo(),
      '/registerb': (context) => register_b(),
      '/registers': (context) => register_s(),
      '/home': (context) => MyApp()
    },
    
    home: AnimatedSplashScreen(
            duration: 1500,
            backgroundColor: Colors.black,
            splash: Stack(children: [
              Lottie.asset('assets/logo.json'),
              Positioned(
                top: 110,
                left: 50,
                child: Text(
                  'No More Poverty',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'Dance',
                  ),
                ),
              )
            ]),
            nextScreen: MyApp(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.bottomToTop,
          )
    
  ));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  TextEditingController cont1 = TextEditingController();
  bool signup = false;
  TextEditingController cont2 = TextEditingController();
  late TabController tabcontroller;

  void initState() {
    // TODO: implement initState
    super.initState();
    tabcontroller = TabController(vsync: this, length: tabs.length);
  }

  List<Tab> tabs = [
    Tab(
      icon: Icon(
        Icons.details,
        size: 30,
      ),
      text: '',
    ),
    Tab(
      icon: Icon(
        Icons.add_a_photo_outlined,
        size: 30,
      ),
      text: '',
    ),
  ];
  int daysBetween(DateTime from, DateTime to) {
     from = DateTime(from.year, from.month, from.day);
     to = DateTime(to.year, to.month, to.day);
   return (to.difference(from).inHours / 24).round();
  }

   //the birthday's date
  bool buyer = false;
  bool seller = true;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DateTime now = new DateTime.now();
    final x = now;
    print(now.difference(x).inDays);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(                                                                     
            backgroundColor: Colors.pink,
            body: Stack(children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(
                      width * 0.1, height * 0.2, width * 0.1, 0),
                  child: signup == false
                      ? TextField(
                          decoration:
                              const InputDecoration(hintText: 'Enter Email'),
                          controller: cont1,
                        )
                      : TextField(
                          decoration:
                              const InputDecoration(hintText: 'Enter an Email'),
                          controller: cont1,
                        )),
              Padding(
                  padding: EdgeInsets.fromLTRB(
                      width * 0.1, height * 0.3, width * 0.1, 0),
                  child: signup == false
                      ? TextField(
                          decoration:
                              const InputDecoration(hintText: 'Enter Password'),
                          controller: cont2,
                        )
                      : TextField(
                          decoration: const InputDecoration(
                              hintText: 'Create a Password'),
                          controller: cont2,
                        )),
              if (signup)
                Padding(
                    padding:
                        EdgeInsets.fromLTRB(width * 0.10, height * 0.40, 0, 0),
                    child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            buyer = !buyer;
                            seller = !seller;
                          });
                        },
                        icon: buyer ? Icon(Icons.check) : Icon(Icons.remove),
                        label: Text('As a Needy'))),
              if (signup)
                Padding(
                    padding:
                        EdgeInsets.fromLTRB(width * 0.50, height * 0.40, 0, 0),
                    child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            seller = !seller;
                            buyer = !buyer;
                          });
                        },
                        icon: seller ? Icon(Icons.check) : Icon(Icons.remove),
                        label: Text('As a Donor'))),

              Padding(
                  padding:
                      EdgeInsets.fromLTRB(width * 0.37, height * 0.7, 0, 0),
                  child: signup == false
                      ? ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              {
                                var snackBar = SnackBar(
                                  content:
                                      Text('Authenticating, Please Wait! '),
                                  duration: Duration(seconds: 10),
                                );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }

                              print('adsasd');
                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: cont1.text, password: cont2.text);
                                      print('${FirebaseAuth.instance.currentUser?.email}');
                              var x = await FirebaseFirestore.instance
                                  .collection('Users')
                                  .doc(
                                      '${FirebaseAuth.instance.currentUser?.email}')
                                  .get();
                             
                             
                              if (x['Type'] == 'Donor')
                                Navigator.pushNamed(context, '/send');
                              else if (x['Type'] == 'Needy')
                                Navigator.pushNamed(context, '/recieve');
                             
                            } on FirebaseAuthException catch (e) {
                              var snackBar = SnackBar(
                                content: Text('${e.message}'),
                              );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          icon: Icon(Icons.app_registration_rounded),
                          label: Text('Sign In'))
                      : ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              if (buyer == true) {
                                Navigator.pushNamed(context, '/registerb',
                                    arguments: {
                                      'Email': cont1.text,
                                      'Pass': cont2.text
                                    });
                              } else if (seller == true) {
                                Navigator.pushNamed(context, '/registers',
                                    arguments: {
                                      'Email': cont1.text,
                                      'Pass': cont2.text
                                    });
                              } else {
                                var snackBar = SnackBar(
                                  content: Text('Select An Option'),
                                );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            } on FirebaseAuthException catch (e) {
                              var snackBar = SnackBar(
                                content: Text('${e.message}'),
                              );

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          icon: Icon(Icons.app_registration_rounded),
                          label: Text('Sign Up'))),
              Padding(
                  padding: EdgeInsets.fromLTRB(
                      width * 0.43, height * 0.78, width * 0.3, 0),
                  child: TextButton(
                      onPressed: () {
                        cont1.clear();
                        cont2.clear();
                        setState(() {
                          signup = !signup;
                        });
                      },
                      child:
                          signup == false ? Text('Sign Up') : Text('Sign In'))),
            ])));
  }
}
