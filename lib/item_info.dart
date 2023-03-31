import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cross_file_image/cross_file_image.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solution/Sender_page.dart';
import 'package:solution/send_item_screen.dart';
import 'Sender_page.dart';
import 'send_item_screen.dart';
import 'package:provider/provider.dart';
import 'provider_screen.dart';

class iteminfo extends StatefulWidget {
  @override
  State<iteminfo> createState() => _iteminfoState();
}

class _iteminfoState extends State<iteminfo> {
  static final cachemanage = CacheManager(
    Config(
      'customCacheKey',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 20,
      fileService: HttpFileService(),
    ),
  );
  @override
  Widget build(BuildContext context) {
    dynamic data = ModalRoute.of(context)?.settings.arguments;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.pink,
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                      imageUrl: data['url'],
                      key: UniqueKey(),
                      imageBuilder: (context, imageProvider) => Container(
                            height: height * 0.5,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      cacheManager: cachemanage,
                      placeholder: (context, img) => Container(
                            width: 400,
                            height: 200,
                            color: Color.fromRGBO(
                                Random().nextInt(255),
                                Random().nextInt(255),
                                Random().nextInt(255),
                                1),
                          )),
                  Container(
                      // width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.brown,
                      ),
                      // padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      margin: EdgeInsets.fromLTRB(10, height * 0.05, 10, 0),
                      child: Text(
                        '${data['Name']}',
                        style: TextStyle(fontSize: 30),
                      )),
                  Container(
                      // width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.brown,
                      ),
                      // padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      margin: EdgeInsets.fromLTRB(10, height * 0.05, 10, 0),
                      child: Text(
                        'Description: ${data['Description']}',
                        style: TextStyle(fontSize: 30),
                      )),
                  Container(
                    child: TextButton(
                      child: Text('Get Item'),
                      onPressed: () async {
                        var snackBar = SnackBar(
                          content: Text('Processing...'),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(data['Email'])
                            .collection('Order_details')
                            .add({
                          'Email': data['Email'],
                          'Remail': FirebaseAuth.instance.currentUser?.email,
                          'url': data['url'],
                          'Name':data['Name']

                        });
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(FirebaseAuth.instance.currentUser?.email)
                            .collection('Order_details')
                            .add({
                          'Email': FirebaseAuth.instance.currentUser?.email,
                          'Remail': data['Email'],
                          'url': data['url'],
                          'Name':data['Name']
                        });

                        var collection = await FirebaseFirestore.instance
                            .collection('Items')
                            .doc(data['Category'])
                            .collection('Items')
                            .where('url', isEqualTo: data['url'])
                            .get();
                        var documentID;
                        for (var snapshot in collection.docs) {
                          documentID = snapshot.id; // <-- Document ID
                        }
                        print(documentID);
                        await FirebaseFirestore.instance
                            .collection('Items')
                            .doc(data['Category'])
                            .collection('Items')
                            .doc(documentID)
                            .set({
                          'Description': collection.docs.first['Description'],
                          'Email': collection.docs.first['Email'],
                          'Name': collection.docs.first['Name'],
                          'Status': '1',
                          'url': collection.docs.first['url']
                        });
                        var balance = await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(data['Email'])
                            .get();
                        var bal = balance['Balance'];
                        bal = ++bal;
                        print(balance['Balance']);
                        await FirebaseFirestore.instance
                            .collection('Users')
                            .doc(data['Email'])
                            .update({'Balance': bal});
dynamic se = await FirebaseFirestore.instance
                              .collection('Users')
                              .doc('${FirebaseAuth.instance.currentUser?.email}').get();

await FirebaseFirestore.instance
                              .collection('Users')
                              .doc('${FirebaseAuth.instance.currentUser?.email}')
                              .set({
                            'Type': se['Type'],
                            'Phone': se['Phone'],
                            'Address': se['Address'],
                            'Currdate': DateTime.now()
                          });


                        snackBar = SnackBar(
                          content: Text(
                              'Transaction Successfull, The Item will be delivered within few days'),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                    ),
                  ),
                ],
              ),
            )));
  }
}
