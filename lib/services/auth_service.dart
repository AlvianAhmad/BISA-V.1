import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // REGISTER EMAIL
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    String role = 'user',
  }) async {
    UserCredential cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(cred.user!.uid)
        .set({'email': email, 'role': role});

    return cred;
  }

  // LOGIN EMAIL
  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // LOGIN GOOGLE (FIX UNTUK WEB DAN MOBILE)
  Future<UserCredential> loginWithGoogle() async {
    if (kIsWeb) {
      // ==== LOGIN GOOGLE KHUSUS WEB ====
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      UserCredential userCred = await FirebaseAuth.instance.signInWithPopup(
        authProvider,
      );

      await _saveUserIfNotExists(userCred);

      return userCred;
    } else {
      // ==== LOGIN GOOGLE ANDROID/IOS ====
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) throw Exception("Login Google dibatalkan");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCred = await FirebaseAuth.instance
          .signInWithCredential(credential);

      await _saveUserIfNotExists(userCred);

      return userCred;
    }
  }

  // Simpan user jika belum ada
  Future<void> _saveUserIfNotExists(UserCredential userCred) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userCred.user!.uid)
        .get();

    if (!doc.exists) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCred.user!.uid)
          .set({"email": userCred.user!.email, "role": "user"});
    }
  }

  // SIGN OUT GOOGLE + EMAIL
  Future<void> signOut() async {
    await _auth.signOut();

    if (!kIsWeb) {
      // hanya mobile yang perlu googleSignIn.signOut()
      await GoogleSignIn().signOut();
    }
  }
}
