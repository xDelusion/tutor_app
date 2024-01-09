import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // get current user
  User? getCurrentUser() {
    return _auth
        .currentUser; // .currentUser is a method from firebase_auth (hover over it)
  }

  Future<UserCredential> userLogin(String email, String password) async {
    try {
      print('Attempting login with email: $email');
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      print('Login successful for user: ${userCredential.user?.email}');

      // save user info if it doesn't already exist
      _firestore
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set({'uid': userCredential.user!.uid, 'email': email});

      return userCredential;
    } on FirebaseAuthException catch (error) {
      print('Login failed. Error code: ${error.code}');
      throw Exception(error.code);
    }
  }

  Future<UserCredential> userRegister(String email, String password) async {
    try {
      print('Attempting registration with email: $email');

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      print('Registration successful for user: ${userCredential.user?.email}');

      // save user info in a serperate document
      _firestore
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set({'uid': userCredential.user!.uid, 'email': email});

      return userCredential;
    } on FirebaseAuthException catch (error) {
      print('Registration failed. Error code: ${error.code}');
      throw Exception(error.code);
    }
  }

  Future<void> userLogout() async {
    print('Logging out user: ${_auth.currentUser?.email}');
    await _auth.signOut();
    print('Logout successful');
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        await saveUserInfoToFirebase(
            userCredential.user!.uid.toString(),
            userCredential.user!.displayName.toString(),
            userCredential.user!.email.toString());
      }

      return userCredential.user;
    } catch (error) {
      print(error.toString());
      throw AuthException(error.toString());
    }
  }

  Future<void> saveUserInfoToFirebase(
      String userId, String userName, String email) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set(
        {
          'username': userName,
          'email': email,
          'id': userId,
          'userLocation': null,
        },
      );
    } catch (error) {
      throw AuthException(error.toString());
    }
  }
}

class AuthException implements Exception {
  AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
