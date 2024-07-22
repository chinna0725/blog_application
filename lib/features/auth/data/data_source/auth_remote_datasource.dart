import 'package:blog_application/core/error/excepetions.dart';
import 'package:blog_application/features/auth/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpEmailWithPassword(
      {required String name, required String email, required String password});
  Future<UserModel> signInEmailWithPassword(
      {required String email, required String password});

  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImplimentation implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;

  final FirebaseFirestore dp;
  AuthRemoteDataSourceImplimentation(
      {required this.firebaseAuth, required this.dp});

  @override
  Future<UserModel> signInEmailWithPassword({
    required String email,
    required String password,
  }) async {
    try {
      final respone = await firebaseAuth.signInWithEmailAndPassword(
        password: password,
        email: email,
      );

      if (respone.user == null) {
        throw const ServerExceptions("User is null");
      }
      final DocumentSnapshot snapshot =
          await dp.collection("user").doc(respone.user!.uid).get();

      // print(snapshot.data());
      UserModel userModel =
          UserModel.fromJson(snapshot.data() as Map<String, dynamic>);

      return userModel;
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

//  -----------   sign up   -------
  @override
  Future<UserModel> signUpEmailWithPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final respone = await firebaseAuth.createUserWithEmailAndPassword(
        password: password,
        email: email,
      );

      if (respone.user == null) {
        throw const ServerExceptions("User is null");
      }
      final CollectionReference dpref = dp.collection("user");

      final Map<String, dynamic> user = {
        'name': name,
        'email': email,
        'uid': respone.user!.uid
      };

      await dpref.doc(respone.user!.uid).set(user);

      return UserModel(id: respone.user!.uid, name: name, email: email);
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }

  //  ----------   getting user data   -----------
  @override
  Future<UserModel?> getCurrentUserData() async {
    try {
      if (firebaseAuth.currentUser != null) {
        DocumentSnapshot snapshot = await dp
            .collection("user")
            .doc(firebaseAuth.currentUser!.uid)
            .get();

        print(
            '----------------------user data ${snapshot.data() as Map<String, dynamic>} ');
        return UserModel.fromJson(snapshot.data() as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      throw ServerExceptions(e.toString());
    }
  }
}
