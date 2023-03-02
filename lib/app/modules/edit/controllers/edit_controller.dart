import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late TextEditingController title;
  late TextEditingController deskripsi;
  Future<DocumentSnapshot<Object?>> getData(String docID) async {
    DocumentReference docRef = firestore.collection('notes').doc(docID);
    return docRef.get();
  }

  void updatedata(String title, String deskripsi, String docID) async {
    DocumentReference docData = firestore.collection('notes').doc(docID);

    try {
      await docData.update({
        'title': title,
        'deskripsi': deskripsi,
      });

      Get.back();
    } catch (e) {
      print(e);
      Get.defaultDialog(
        title: "Terjadi kesalahan",
        middleText: 'Tidak berhasil mengubah data',
      );
    }
  }

  @override
  void onInit() {
    title = TextEditingController();
    deskripsi = TextEditingController();

    super.onInit();
  }

  @override
  void onClose() {
    title.dispose();
    deskripsi.dispose();
    super.onClose();
  }
}
