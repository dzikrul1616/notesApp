import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:notesapp/app/constanst/color.dart';
import 'package:notesapp/app/modules/add/views/add_view.dart';
import 'package:notesapp/app/modules/edit/views/edit_view.dart';
import 'package:notesapp/app/routes/app_pages.dart';

import '../controllers/notes_controller.dart';

class NotesView extends GetView<NotesController> {
  deletedata(id) async {
    await FirebaseFirestore.instance.collection('notes').doc(id).delete();
  }

  showAlertDialog(BuildContext context, String id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Tidak"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Ya"),
      onPressed: () async {
        await FirebaseFirestore.instance.collection('notes').doc(id).delete();
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Hapus notes"),
      content: Text("Apakah anda yakin ingin menghapus notes ini?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          "Notes APP",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddView()));
        },
        backgroundColor: Colors.blueGrey[900],
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("Andrew Garfield"),
              accountEmail: const Text("capek@ngoding.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://images.unsplash.com/photo-1600486913747-55e5470d6f40?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80"),
              ),
              decoration: BoxDecoration(
                color: Colors.blueGrey[900],
              ),
              otherAccountsPictures: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/women/74.jpg"),
                ),
                CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(
                      "https://randomuser.me/api/portraits/men/47.jpg"),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text("About"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text("Privacy Policy"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
              ),
              title: const Text("Logout"),
              onTap: () {},
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('notes').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  var listAllDocs = snapshot.data!.docs;

                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('notes')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasData) {
                        var listAllDocs = snapshot.data!.docs;

                        return GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 10.0,
                          ),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) => Container(
                            child: InkWell(
                              onTap: () => Get.toNamed(
                                Routes.EDIT,
                                arguments: listAllDocs[index].id,
                              ),
                              onLongPress: () {},
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppStyle.cardsColor[
                                      snapshot.data!.docs[index]['color_id']],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        snapshot.data!.docs[index]['title'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 16,
                                            overflow: TextOverflow.ellipsis),
                                      ),
                                      subtitle: Text(
                                        snapshot.data!.docs[index]['deskripsi'],
                                        style: const TextStyle(
                                            overflow: TextOverflow.ellipsis,
                                            fontSize: 14),
                                      ),
                                    ),
                                    // Padding(
                                    //   padding: const EdgeInsets.symmetric(
                                    //       horizontal: 5.0),
                                    //   child: ClipRRect(
                                    //     borderRadius: BorderRadius.only(
                                    //         topRight: Radius.circular(5),
                                    //         topLeft: Radius.circular(5),
                                    //         bottomLeft: Radius.circular(5),
                                    //         bottomRight: Radius.circular(5)),
                                    //     child: Image.asset(
                                    //       'assets/logo.jpg',
                                    //       height: 80,
                                    //       width: double.infinity,
                                    //       fit: BoxFit.cover,
                                    //     ),
                                    //   ),
                                    // ),
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(snapshot.data!.docs[index]
                                              ['Tanggal']),
                                          InkWell(
                                            onTap: () {
                                              showAlertDialog(
                                                  context,
                                                  snapshot
                                                      .data!.docs[index].id);
                                            },
                                            child: Icon(
                                              Icons.delete,
                                              color: Colors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20.0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }
}
