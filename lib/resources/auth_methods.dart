// import 'dart:typed_data';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:insta_clone/resources/storage_methods.dart';

// class AuthMethods {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;


//   Future<String> signUpUser(
//       {required String email,
//       required String password,
//       required String username,
//       required String bio,
//       required Uint8List file}) async {
//     String res = "Some Error Occurred";
//     // print(l);
    
//     try {
//       if (email.isNotEmpty ||
//           password.isNotEmpty ||
//           username.isNotEmpty ||
//           bio.isNotEmpty) {
//             print('Function Called');
        
//         UserCredential cred = await _auth.createUserWithEmailAndPassword(
//             email: email, password: password);

//         String photoUrl = await StorageMethods().uploadImageToFirebase('profilePics', file, false);

//         model.User user = model.User(
//           username: username,
//           uid: cred.user!.uid,
//           photoUrl: photoUrl,
//           email: email,
//           bio: bio,
//           followers: [],
//           following: [],
//         );

//         await _firestore.collection('users').doc(cred.user!.uid).set(user.toJson()
//           // 'username': username,
//           // 'uid': cred.user!.uid,
//           // 'email': email,
//           // 'bio': bio,
//           // 'followers': [],
//           // 'following': [],
//           // 'photoUrl' : photoUrl
//         );
//         res = "Success";
//       } 
//     } on FirebaseAuthException catch(err){
//       if(err.code == 'invalid-email'){
//         res = 'The email is badly formatted' ;
//       }
//       else if(err.code == 'weak-password'){
//         res = 'Password is Weak' ;
//       }
//       print(err);
//     } 
//     catch (e) {
//       res = e.toString();
//     }
//     return res;
//   }

//    Future<String> logInUser({required String email, required String password}) async{
//      String res = "Some error occurred " ;

//      try {
//        if(email.isNotEmpty || password.isNotEmpty){
//          _auth.signInWithEmailAndPassword(email: email, password: password);
//          res = "Success" ;
//        }
//        else{
//          res = "Please enter all the fields" ;
//        }
//      } on FirebaseAuthException catch (e){
//        if(e.code == 'user-not-found'){

//        }
//        else if(e.code == ''){
         
//        }
//      } 
//      catch (e) {
//        res = e.toString() ;
//      }
//     return res ; 
//    }

//    Future<void> signOut() async{
//      await  _auth.signOut();
//    }
// }
