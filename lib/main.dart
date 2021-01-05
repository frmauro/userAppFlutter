import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:async/async.dart';
import 'package:user_app/helpers/user_helper.dart';
import 'package:user_app/ui/home_page.dart';
import 'package:user_app/ui/user_page.dart';


void main() async {
  runApp(MaterialApp(
    home: Home(),
    debugShowCheckedModeBanner: false,
  ));
}

