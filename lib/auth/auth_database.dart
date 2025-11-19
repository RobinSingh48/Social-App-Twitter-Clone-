import 'package:firebase_auth/firebase_auth.dart';
import 'package:social_app/database/database.dart';

class AuthDatabase {
  final _auth = FirebaseAuth.instance;
  User? get user => _auth.currentUser;
  String get currentUserId => user!.uid;

  Future<void> registerUserInFirebase(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> loginUserInFirebase(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> deleteUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await DatabaseService().deleteProfileFromFirebase(user.uid);
      await user.delete();
    }
  }
}
