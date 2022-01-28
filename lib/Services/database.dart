import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection('notes');

class Database {
  Database({required this.uid});
  final String? uid;
  Future<void> addItem({required String title}) async {
    DocumentReference documentReference =
        _mainCollection.doc(uid).collection('tasks').doc();
    Map<String, dynamic> data = <String, dynamic>{
      'title': title,
      'timeStamp': DateTime.now().millisecondsSinceEpoch
    };
    await documentReference
        .set(data)
        .whenComplete(() => print("cool"))
        .catchError((e) => print(e));
  }

  Future<void> updateItem({required String title, required String? id}) async {
    DocumentReference documentReference =
        _mainCollection.doc(uid).collection('tasks').doc(id);
    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      'timeStamp': DateTime.now().millisecondsSinceEpoch
    };
    await documentReference
        .update(data)
        .whenComplete(() => print("cool"))
        .catchError((e) => print(e));
  }

  Stream<QuerySnapshot> readItems() {
    CollectionReference notesItem =
        _mainCollection.doc(uid).collection('tasks');
    return notesItem.snapshots();
  }

  Future<void> deleteItem({required String? id}) async {
    DocumentReference docRef =
        _mainCollection.doc(uid).collection('tasks').doc(id);
    await docRef
        .delete()
        .whenComplete(() => print("item deleted"))
        .catchError((e) => print(e));
  }
}
