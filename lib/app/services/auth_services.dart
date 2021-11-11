import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth auth;

  AuthService(this.auth);

  Stream<User?> get authStateChanges => auth.idTokenChanges();

  Future<String> login(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return "Logged In";
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> signUp(String email, String password, String username,
      String fullname, String phoneNumber, String title) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        User? user = FirebaseAuth.instance.currentUser;

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .set({
          'userId': user.uid,
          'email': email,
          'password': password,
          'nama pengguna': username,
          'nama lengkap': fullname,
          'nomor HP': phoneNumber,
          'jenis pengguna': title
        });
      });
      return "Signed Up";
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
}
