import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventura/config/app_logger.dart';
import 'package:ventura/core/data/models/business_model.dart';
import 'package:ventura/core/data/models/user_model.dart';

class DatabaseService {
  final AppLogger _logger = AppLogger('DatabaseService');

  static const String _userKey = 'user';
  static const String _businessKey = 'business';

  static final DatabaseService instance = DatabaseService._internal();

  factory DatabaseService() => instance;

  DatabaseService._internal();

  Future<UserModel> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    return user;
  }

  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);

    if (userString == null) return null;

    final Map<String, dynamic> userJson = jsonDecode(userString);

    final businessString = prefs.getString(_businessKey);
    if (businessString != null) {
      userJson['business'] = jsonDecode(businessString);
    }

    debugPrint('DatabaseService: Retrieved user data: $userJson');
    return UserModel.fromJson(userJson);
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  Future<BusinessModel> saveBusiness(BusinessModel business) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_businessKey, jsonEncode(business.toJson()));
    return business;
  }

  Future<BusinessModel> getBusiness() async {
    final prefs = await SharedPreferences.getInstance();
    final businessString = prefs.getString(_businessKey);

    if (businessString == null) {
      throw Exception('No business data found');
    }

    final data = jsonDecode(businessString);
    _logger.info('DatabaseService: Retrieved business data: $data');
    return BusinessModel.fromJson(data);
  }

  Future<void> clearBusiness() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_businessKey);
  }
}
