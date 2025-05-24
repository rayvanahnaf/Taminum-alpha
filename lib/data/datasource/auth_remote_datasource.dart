import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_pos/data/model/response/auth_response_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteDataSource {
  Future<Either<String, AuthResponseModel>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('http://192.168.31.181:8000/api/login'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password
      } ),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Right(AuthResponseModel.fromJson(json));
    } else {
      return Left(response.body);
    }

  }
}