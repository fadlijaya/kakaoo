import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth;

  AuthService(this.auth);

  Stream<User?> get authStateChanges => auth.idTokenChanges();

  Future<String> login({required String email, required String password}) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "Logged In";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signUp({required String email, required String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return "Signed Up";
    } catch (e) {
      print(e);
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }

  Future<String> uid() async {
    return auth.currentUser!.uid;
  }
}
