import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier{
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance ;

  late User user;

  late String userid ; 
  late String username;
  late String email ;
  late String bio;
  late String photoUrl;

  String get getUserId{
    return userid ; 
  }

  String get getUsername{
    return username ; 
  }

  String get getUserEmail{
    return email;
  }

  String get getUserBio{
    return bio;
  }

  String get getPhtotUrl{
    return photoUrl;
  }

  User? get getCurrUser{
    if(FirebaseAuth.instance.currentUser == null) return null ;
    userid = FirebaseAuth.instance.currentUser!.uid;

    return FirebaseAuth.instance.currentUser ;
  }

  Future<String> createUser(String email, String password) async {
    
    late String errorMessage;
    
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      user = userCredential.user!;
      userid = userCredential.user!.uid ;

      notifyListeners();
      return "Success" ;
    } on FirebaseAuthException catch(e){
       if(e.code == "email-already-in-use"){
           errorMessage = "email-already-in-use";
       }
       else if(e.code == "invalid-email"){
          errorMessage = "invalid-email" ;
       }
       else if(e.code == "operation-not-allowed"){
        errorMessage = "operation-not-allowed";
       }
       else if(e.code == "weak-password"){
        errorMessage = "weak-password" ;
       }
    }

    return errorMessage ;
  }

  Future<String> logInUser(String email, String password) async {
    late String errorMessage;

    try {
      UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);

    user = userCredential.user!;
    userid = userCredential.user!.uid ;
    print(userid);

    return "Success" ;

    } on FirebaseAuthException catch (e) {
      if(e.code == "wrong-password"){
         errorMessage = "wrong-password" ;
      }
      else if(e.code == "invalid-email"){
        errorMessage = "invalid-email";
      }
      else if(e.code == "user-disabled"){
        errorMessage = "user-disabled" ;
      }
      else if(e.code == "user-not-found"){
        errorMessage = "user-not-found" ;
      }
    }

    return errorMessage ;
  }

  
  Future<void> fetchUser() async{
    DocumentSnapshot _docData = await _firebaseFirestore.collection('users').doc(userid).get();
    username = _docData['username'];
    userid =_docData['uid'];
    email = _docData['email'];
    bio =_docData['bio'];
    photoUrl =_docData['photoUrl'];

    notifyListeners();
  }

  Future<void> storeUser({required String email,
      required String password,
      required String username,
      required String bio,
      required String photoUrl}) async{
    await _firebaseFirestore.collection('users').doc(userid).set({
      'username': username,
          'uid': userid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'photoUrl' : photoUrl
    });
  }

  Future<void> signOut() async{
      await  _firebaseAuth.signOut();
      notifyListeners();
   }


}