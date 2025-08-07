import 'package:flutter/material.dart';
import 'app.dart';
import 'core/di/di.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

