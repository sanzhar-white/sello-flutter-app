import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:selo/core/constants.dart';
import 'package:selo/core/shared_prefs_utils.dart';

class UserRepo {
  final fire = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> create(UserData user) async {
    try {
      final userRef = fire.collection(FireCollections.users);
      await userRef.doc(user.phoneNumber).set(user.toMap());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<void> update(UserData user) async {
    try {
      final userRef = fire.collection(FireCollections.users);
      await userRef.doc(user.phoneNumber).update(user.toMap());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<UserData?> getUserData(String phoneNumber) async {
    try {
      final data =
          await fire.collection(FireCollections.users).doc(phoneNumber).get();
      final Map<String, dynamic>? userData = data.data();

      return userData != null ? UserData.fromMap(userData) : null;
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
  }

  Future<void> deleteAccount({required UserData userData}) async {
    try {
      final usersRef = fire.collection(FireCollections.users);
      await usersRef.doc(userData.phoneNumber).delete();
      await SharedPrefs.instance.remove('user');

      final User? user = auth.currentUser;
      if (user != null) {
        await user.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete account: $e');
    }
  }
}

class UserData {
  final String phoneNumber;
  final String? name;
  final String? lastName;
  final String? region;
  final String? city;
  final String? photo;
  final int? amount;

  UserData({
    required this.phoneNumber,
    this.name,
    this.lastName,
    this.region,
    this.city,
    this.photo,
    this.amount,
  });

  UserData copyWith({
    String? phoneNumber,
    String? name,
    String? lastName,
    String? region,
    String? city,
    String? photo,
    int? amount,
  }) {
    return UserData(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      region: region ?? this.region,
      city: city ?? this.city,
      photo: photo ?? this.photo,
      amount: amount ?? this.amount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'phoneNumber': phoneNumber,
      'name': name,
      'lastName': lastName,
      'region': region,
      'city': city,
      'photo': photo,
      'amount': amount,
    };
  }

  String toJson() => json.encode(toMap());

  factory UserData.fromMap(Map<String, dynamic> map) {
    return UserData(
      phoneNumber: map['phoneNumber'] ?? '',
      name: map['name'],
      lastName: map['lastName'],
      region: map['region'],
      city: map['city'],
      photo: map['photo'],
      amount: map['amount']?.toInt(),
    );
  }

  factory UserData.fromJson(String source) =>
      UserData.fromMap(json.decode(source));
}
