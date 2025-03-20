import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sehety/core/enums/user_type_enum.dart';
import 'package:sehety/features/auth/data/doctor_model.dart';


part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<RegisterEvent>(register);
    on<LoginEvent>(login);
    on<UpdateDoctorDataEvent>(updateDoctorData);
  }

  Future<void> login(LoginEvent event, Emitter<AuthState> emit) async {
    emit(LoginLoadingState());
    try {
      var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: event.email, password: event.password);

      emit(LoginSuccessState(userType: credential.user?.photoURL ?? ''));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(AuthErrorState(message: 'المستخدم غير موجود'));
      } else if (e.code == 'wrong-password') {
        emit(AuthErrorState(message: 'الباسورد ضعيف'));
      } else {
        emit(AuthErrorState(message: "حدث خطأ ما، يرجى المحاولة مرة أخرى"));
      }
    } catch (e) {
      emit(AuthErrorState(message: "حدث خطأ ما، يرجى المحاولة مرة أخرى"));
    }
  }

  Future<void> register(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(RegisterLoadingState());
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );
      User? user = credential.user;
      await user?.updateDisplayName(event.name);
      // use photo url as a user role
      await user?.updatePhotoURL(event.userType.toString());
      // store in firestore
      if (event.userType == UserType.doctor) {
        FirebaseFirestore.instance.collection('doctors').doc(user?.uid).set({
          'name': event.name,
          'image': '',
          'specialization': '',
          'rating': 3,
          'email': event.email,
          'phone1': '',
          'phone2': '',
          'bio': '',
          'openHour': '',
          'closeHour': '',
          'address': '',
          'uid': user?.uid,
        });
      } else {
        FirebaseFirestore.instance.collection('patients').doc(user?.uid).set({
          'name': event.name,
          'image': '',
          'age': '',
          'email': event.email,
          'phone': '',
          'bio': '',
          'city': '',
          'uid': user?.uid,
        });
      }

      emit(RegisterSuccessState());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthErrorState(message: 'الباسورد ضعيف'));
      } else if (e.code == 'email-already-in-use') {
        emit(AuthErrorState(message: 'الايميل مستخدم من قبل'));
      } else {
        emit(AuthErrorState(message: "حدث خطأ ما، يرجى المحاولة مرة أخرى"));
      }
    } catch (e) {
      emit(AuthErrorState(message: "حدث خطأ ما، يرجى المحاولة مرة أخرى"));
    }
  }

  Future<void> updateDoctorData(
      UpdateDoctorDataEvent event, Emitter<AuthState> emit) async {
    emit(DoctorRegistrationLoadingState());
    try {
      log(event.doctorModel.toJson().toString());
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(event.doctorModel.uid)
          .update(event.doctorModel.toJson());

      emit(DoctorRegistrationSuccessState());
    } catch (e) {
      log('---2----');

      emit(AuthErrorState(message: "حدث خطأ ما، يرجى المحاولة مرة أخرى"));
    }
  }
}