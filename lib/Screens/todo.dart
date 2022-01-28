import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/Services/database.dart';
import 'package:todo_list/main.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class Todo extends StatelessWidget {
  TextEditingController _textFieldController = TextEditingController();
  Todo({required this.uid, required this.auth});
  final String? uid;
  final FirebaseAuth auth;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("To-Do List"),
          centerTitle: true,
          leading: TextButton(
            onPressed: () async {
              await auth.signOut();
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) {
                return Home();
              }));
            },
            child: Text(
              "Logout",
              style: GoogleFonts.oswald(fontSize: 10),
            ),
          ),
        ),
        body: _getTasks(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _displayDialog(context, "Add Tasks", () {
            Database(uid: uid).addItem(title: _textFieldController.text);
            Navigator.pop(context);
            _textFieldController.clear();
          }, "Submit"),
          tooltip: "Add Item",
          child: Icon(FontAwesomeIcons.plus),
        ),
      ),
    );
  }

  Widget _getTasks() {
    bool check = false;
    return StreamBuilder(
        stream: Database(uid: uid).readItems(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(_).primaryColor,
              ),
            );
          }
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data!.docs;
            return Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: ListView(
                children: documents
                    .map((doc) => Dismissible(
                          background: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(left: 20),
                            color: Colors.grey[100],
                            child: Icon(Icons.delete, color: Colors.red),
                          ),
                          onDismissed: (direction) {
                            Database(uid: uid).deleteItem(id: doc.id);
                            print(doc.id);
                          },
                          key: UniqueKey(),
                          child: Card(
                            child: ListTile(
                              title: Text(
                                doc['title'],
                                style: GoogleFonts.oswald(fontSize: 15),
                              ),
                              trailing: GestureDetector(
                                child: Icon(FontAwesomeIcons.edit),
                                onTap: () {
                                  _displayDialog(_, "Edit Tasks", () {
                                    Database(uid: uid).updateItem(
                                        title: _textFieldController.text,
                                        id: doc.id);
                                    Navigator.pop(_);
                                    _textFieldController.clear();
                                  }, "Edit");
                                },
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            );
          }
          return Container(
            child: Column(
              children: [
                Text("Add Tasks...."),
                Text("+ to add Tasks \n\n Slide To Dismiss Task"),
              ],
            ),
          );
        });
  }

  Future<void> _displayDialog(BuildContext context, @required String title,
      @required VoidCallback onPressed, @required String clue) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: TextField(
              autofocus: true,
              controller: _textFieldController,
              textInputAction: TextInputAction.go,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                  hintText: "Eg. Buy Bread",
                  hintStyle: GoogleFonts.oswald(
                      fontSize: 20, fontWeight: FontWeight.w600)),
            ),
            actions: [
              ElevatedButton(onPressed: onPressed, child: Text(clue)),
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"))
            ],
          );
        });
  }
}
