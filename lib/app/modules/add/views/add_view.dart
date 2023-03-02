import 'dart:math';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notesapp/app/constanst/color.dart';
import 'package:notesapp/app/modules/notes/views/notes_view.dart';
import '../controllers/add_controller.dart';

class AddView extends GetView<AddController> {
  int color_id = Random().nextInt(AppStyle.cardsColor.length);
  final titleController = TextEditingController();
  final deskripsiController = TextEditingController();
  final _key = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference notes = firestore.collection('notes');
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      floatingActionButton: SpeedDial(
        direction: SpeedDialDirection.left,
        icon: Icons.menu,
        animatedIcon: AnimatedIcons.menu_close,
        backgroundColor: Colors.black,
        children: [
          SpeedDialChild(child: Icon(Icons.photo)),
          SpeedDialChild(child: Icon(Icons.list)),
        ],
      ),
      body: Form(
        key: _key,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
                child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                      Text(
                        'Add Notes',
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          if (_key.currentState!.validate()) {
                            notes.add({
                              'Tanggal': DateFormat('dd-MM-yyyy')
                                  .format(DateTime.now()),
                              'title': titleController.text,
                              'deskripsi': deskripsiController.text,
                              'color_id': color_id,
                            });

                            titleController.text = '';
                            deskripsiController.text = '';
                            Get.to(() => NotesView(),
                                transition: Transition.circularReveal,
                                duration: Duration(seconds: 2));
                          }
                        },
                        child: Container(
                            height: 50, width: 50, child: Icon(Icons.save)),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  TextFormField(
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Please Insert title";
                      }
                    },
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: AppStyle.cardsColor[color_id],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none)),
                    ),
                    onChanged: (value) {},
                  ),
                  TextFormField(
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w400),
                    textInputAction: TextInputAction.newline,
                    validator: (e) {
                      if (e!.isEmpty) {
                        return "Please Insert deskripsi";
                      }
                    },
                    controller: deskripsiController,
                    maxLines: 20,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'deskripsi',
                      labelStyle: TextStyle(
                        color: Colors.black,
                      ),
                      filled: true,
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      fillColor: AppStyle.cardsColor[color_id],
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: const BorderSide(
                              width: 0, style: BorderStyle.none)),
                    ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                ],
              ),
            )),
          ),
        ),
      ),
    );
  }
}
