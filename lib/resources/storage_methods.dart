import 'dart:ffi';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> uploadImageToFirebase(
      String childName, Uint8List file, bool isPost) async {
        
    Reference ref =
        _storage.ref().child(childName).child(_firebaseAuth.currentUser!.uid);

    if(isPost){
      String id = Uuid().v1() ;
      ref = ref.child(id);  
    }    

    UploadTask _uploadTask = ref.putData(file);

    TaskSnapshot snap = await _uploadTask;
    final downloadUrl = await snap.ref.getDownloadURL();

    return downloadUrl;
  }
}
