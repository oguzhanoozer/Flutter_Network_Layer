import 'package:flutter/material.dart';

import 'json_place_holder/json_place_holder.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Material App', home: jsonPlaceHolder());
  }
}
