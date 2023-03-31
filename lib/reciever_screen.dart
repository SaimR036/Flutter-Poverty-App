import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
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

class recieve extends StatefulWidget {
  const recieve({super.key});

  @override
  State<recieve> createState() => _recieveState();
}

class _recieveState extends State<recieve> {
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
            body: ChangeNotifierProvider<Provide>(
                create: (context) => Provide(),
                child: Consumer<Provide>(builder: (context, provider, child) {
                  return Stack(children: [
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('Category')
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          return (snapshot.connectionState ==
                                  ConnectionState.waiting)
                              ? Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      width * 0.45, height * 0.5, 0, 0),
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.grey,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.blueAccent),
                                    strokeWidth: 2,
                                  ))
                              : ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.docs.length,
                                  reverse: false,
                                  itemBuilder: (context, index) {
                                    // print('prvoder ${provider.temp}');
                                    var dat = snapshot.data!.docs[index];

                                    return Container(
                                      margin: EdgeInsets.fromLTRB(
                                          10, 10, 0, height * 0.9),
                                      height: 50,
                                      width: 100,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            provider.getimage(dat['Name']);
                                          },
                                          child: Text(dat['Name'])),
                                    );
                                  });
                        }),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          width * 0.1, height * 0.2, width * 0.1, height * 0.1),
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('Items')
                              .doc('${provider.value}')
                              .collection('Items')
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshot) {
                            return (snapshot.connectionState ==
                                    ConnectionState.waiting)
                                ? Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        width * 0.45, 10, 0, 0),
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
                                        padding:
                                            const EdgeInsets.only(bottom: 20),
                                        child: TextButton(
                                            style: ButtonStyle(
                                                backgroundColor: dat[
                                                            'Status'] ==
                                                        '0'
                                                    ? MaterialStatePropertyAll(
                                                        Colors.blueGrey)
                                                    : MaterialStatePropertyAll(
                                                        Color.fromRGBO(121, 85, 72, 1))),
                                            onPressed: () async{
                                              if (dat['Status'] == '0') {
                                                dynamic se = await FirebaseFirestore.instance
                              .collection('Users')
                              .doc('${FirebaseAuth.instance.currentUser?.email}').get();
                              DateTime now = DateTime.now();
                              var x = se['Currdate'].toDate();
                              var diff = now.difference(x).inDays;
                    if(diff>1)
                    {

                                                Navigator.pushNamed(
                                                    context, '/iteminfo',
                                                    arguments: {
                                                      'Name': dat['Name'],
                                                      'url': dat['url'],
                                                      'Description':
                                                          dat['Description'],
                                                      'Email': dat['Email'],
                                                      'Category': provider.value
                                                    });
                                              } 
                                              else 
                                              {
                                                  var snackBar = SnackBar(
                                                  content: Text(
                                                      'Ordering Limit Reached, Comeback after a day'),
                                                );

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                              
                                              }else {
                                                var snackBar = SnackBar(
                                                  content: Text(
                                                      'Item already donated!'),
                                                );

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            },
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                                  child: CachedNetworkImage(
                                                      imageUrl: dat['url'],
                                                      key: UniqueKey(),
                                                      imageBuilder: (context,
                                                              imageProvider) =>
                                                          Container(
                                                            height: 200,
                                                            padding: EdgeInsets
                                                                .fromLTRB(0,
                                                                    100, 0, 0),
                                                            width: 400,
                                                            decoration:
                                                                BoxDecoration(
                                                              image:
                                                                  DecorationImage(
                                                                image:
                                                                    imageProvider,
                                                                fit: BoxFit
                                                                    .cover,
                                                              ),
                                                            ),
                                                          ),
                                                      cacheManager: cachemanage,
                                                      placeholder:
                                                          (context, img) =>
                                                              Container(
                                                                width: 400,
                                                                height: 200,
                                                                color: Color.fromRGBO(
                                                                    Random()
                                                                        .nextInt(
                                                                            255),
                                                                    Random()
                                                                        .nextInt(
                                                                            255),
                                                                    Random()
                                                                        .nextInt(
                                                                            255),
                                                                    1),
                                                              )),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.fromLTRB(
                                                      5, height * 0.25, 5, 0),
                                                  child: Text(
                                                    '${dat['Name']}',
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                )
                                              ],
                                            )),
                                      );
                                    });
                          }),
                    )
                  ]);
                }))));
  }
}
