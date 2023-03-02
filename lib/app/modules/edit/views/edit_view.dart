import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:notesapp/app/constanst/color.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:notesapp/app/modules/notes/views/notes_view.dart';
import '../controllers/edit_controller.dart';

class EditView extends GetView<EditController> {
  final _key = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[4],
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
      body: FutureBuilder<DocumentSnapshot<Object?>>(
          future: controller.getData(Get.arguments),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var data = snapshot.data!.data() as Map<String, dynamic>;
              controller.title.text = data['title'];
              controller.deskripsi.text = data['deskripsi'];
              return Form(
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
                                'Your Notes',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              InkWell(
                                onTap: () => controller.updatedata(
                                    controller.title.text,
                                    controller.deskripsi.text,
                                    Get.arguments),
                                child: Container(
                                    height: 50,
                                    width: 50,
                                    child: Icon(Icons.save)),
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
                            controller: controller.title,
                            decoration: InputDecoration(
                              labelText: 'Title',
                              labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                              filled: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              fillColor: AppStyle.cardsColor[4],
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
                            controller: controller.deskripsi,
                            maxLines: 20,
                            decoration: InputDecoration(
                              alignLabelWithHint: true,
                              labelText: 'deskripsi',
                              labelStyle: TextStyle(
                                color: Colors.black,
                              ),
                              filled: true,
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.never,
                              fillColor: AppStyle.cardsColor[4],
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
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
