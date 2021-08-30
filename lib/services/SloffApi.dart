import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

String baseUrl = "https://sloff-api.herokuapp.com/api";

class SloffApi {
  // FOCUS
  static Future getAllFocus(String token) async {
    final response = await http.get(Uri.parse(baseUrl + '/focus'),
        headers: {"Authorization": "Bearer " + token});

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load data from the server.');
    }
  }

  static Future getFocus(String uuid, String token) async {
    final response = await http.get(
        Uri.parse(baseUrl + '/focus/search/' + uuid),
        headers: {"Authorization": "Bearer " + token});

    if (response.body.isEmpty) {
      return "NULL";
    } else {
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load data from the server.');
      }
    }
  }

  static Future createFocus(String uuid, int minutes, String token) async {
    return http.post(
      Uri.parse(baseUrl + '/focus'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer " + token
      },
      body: jsonEncode({'uuid': uuid, 'available': minutes}),
    );
  }

  static Future updateFocus(String uuid, int minutes, String token) async {
    var user = await getFocus(uuid, token);
    int currentMinutes = jsonDecode(user)['available'];

    return http.put(
      Uri.parse(baseUrl + '/focus/' + uuid),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer " + token
      },
      body: jsonEncode({'available': currentMinutes + minutes}),
    );
  }

  // SLOFF USERS
  static Future updateUser(
      {@required String uuid,
      @required String token,
      @required String body}) async {
    return http.put(Uri.parse(baseUrl + '/users/' + uuid),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token
        },
        body: body);
  }

  static Future getUser(String uuid, String token) async {
    final response = await http.get(
        Uri.parse(baseUrl + '/users/search/' + uuid),
        headers: {"Authorization": "Bearer " + token});

    if (response.body.isEmpty) {
      return "NULL";
    } else {
      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load data from the server.');
      }
    }
  }

  static Future createUser(
      {@required String token,
      @required String uuid,
      @required String firstName,
      @required String lastName,
      @required String email,
      @required String companyID,
      @required String profilePicture,
      Timestamp lastAppUsage,
      Timestamp lastLogin,
      @required String os}) async {
    return http.post(
      Uri.parse(baseUrl + '/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        "Authorization": "Bearer " + token
      },
      body: jsonEncode({
        'uuid': uuid,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'company_id': companyID,
        'profile_picture': profilePicture,
        'last_app_usage': lastAppUsage,
        'last_login': lastLogin,
        'os': os
      }),
    );
  }

  static Future<bool> checkIfUserExists(
      {@required String uuid, @required String token}) async {
    final response = await http.get(
        Uri.parse(baseUrl + '/users/search/' + uuid),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token
        });

    if (response.body.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  static Stream<http.Response> getRandomNumberFact() async* {
    yield* Stream.periodic(Duration(seconds: 5), (_) {
      return http.get(Uri.parse("http://numbersapi.com/random/"));
    }).asyncMap((event) async => await event);
  }

  // OTHER METHODS
  static Stream<int> getCompanyGroupFocusStream(
      {@required String companyID}) async* {
    yield* Stream.periodic(Duration(milliseconds: 500), (_) async {
      var token = await FirebaseAuth.instance.currentUser.getIdToken();

      final groupFocus = await http.get(
          Uri.parse(baseUrl + '/focus/group-focus/' + companyID),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "Authorization": "Bearer " + token
          });

      return int.parse(groupFocus.body);
    }).asyncMap((event) async => await event);
  }

  static Future<int> getCompanyGroupFocus({@required String companyID}) async {
    var token = await FirebaseAuth.instance.currentUser.getIdToken();

    final groupFocus = await http.get(
        Uri.parse(baseUrl + '/focus/group-focus/' + companyID),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer " + token
        });

    return int.parse(groupFocus.body);
  }
}
