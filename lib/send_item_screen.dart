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
import 'Sender_page.dart';

class SendItem extends StatefulWidget {
  const SendItem({super.key});

  @override
  State<SendItem> createState() => _SendItemState();
}

class _SendItemState extends State<SendItem> {
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

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(children: [
          SingleChildScrollView(
            child: Column(children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                    width * 0.3, height * 0.05, width * 0.3, 0),
                child: storedimg == null
                    ? Image.asset('assets/sol1.png')
                    : Container(
                        width: 300, height: 300, child: Image.file(tostore!)),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(width * 0.60, height * 0, 0, 0),
                child: IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: () {
                      getimage();
                    }),
              ),
              Padding(
                  padding: EdgeInsets.fromLTRB(
                      width * 0.1, height * 0.05, width * 0.1, 0),
                  child: TextField(
                    decoration:
                        const InputDecoration(hintText: 'Enter Name of Item'),
                    controller: cont1,
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(
                      width * 0.1, height * 0.05, width * 0.1, 0),
                  child: TextField(
                    decoration: const InputDecoration(
                        hintText: 'Enter Description of Item'),
                    controller: cont2,
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(
                      width * 0.1, height * 0.05, width * 0.1, 0),
                  child: TextField(
                    decoration: const InputDecoration(
                        hintText:
                            'Enter Category of Item (Shoes,Books,Furniture etc)'),
                    controller: cont3,
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(
                    width * 0.05, height * 0.04, width * 0.05, 0),
                child: Container(
                  height: 80,
                  child: Builder(
                    builder: (context) {
                      final GlobalKey<SlideActionState> _key = GlobalKey();
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SlideAction(
                          outerColor: Colors.black,
                          text: 'Slide To Submit',
                          innerColor: Colors.white,
                          key: _key,
                          onSubmit: () async {
                            var snackBar = SnackBar(
                              content: Text('Please Wait!'),
                              duration: Duration(seconds: 20),
                            );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            var firebaseStorageRef =
                                await FirebaseStorage.instance.ref().child(
                                    '${FirebaseAuth.instance.currentUser?.email}/${storedimg?.name}');
                            var uploadTask =
                                await firebaseStorageRef.putFile(File(
                              tostore!.path,
                            ));

                            var downurl = await uploadTask.ref.getDownloadURL();
                            await FirebaseFirestore.instance
                                .collection('Items')
                                .doc('${cont3.text}')
                                .collection('Items')
                                .add({
                              'Email':
                                  '${FirebaseAuth.instance.currentUser?.email}',
                              'Name': cont1.text,
                              'Description': cont2.text,
                              'url': downurl,
                              'Status': '0'
                            });
                            await FirebaseFirestore.instance
                                .collection('Category')
                                .doc('${cont1.text}')
                                .set({
                               'Name': '${cont3.text}'
                                });
                             

                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(
                                    '${FirebaseAuth.instance.currentUser?.email}')
                                .collection('Items')
                                .add({
                              'Email':
                                  '${FirebaseAuth.instance.currentUser?.email}',
                              'Name': cont1.text,
                              'Description': cont2.text,
                              'url': downurl
                            });

                            cont1.clear();
                            cont2.clear();
                            cont3.clear();
                            storedimg = null;

                            snackBar = SnackBar(
                              content: Text('Product Submitted Successfully'),
                            );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            setState(() {});
                          },
                          height: 100,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ]),
          )
        ]),
      ),
    );
  }
}
