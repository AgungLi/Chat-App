import 'package:chatapp/app/modules/generate_key/controllers/business_logic/app_init_bloc/app_init_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("RSA Encrypt"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            BlocProvider.of<AppInitBloc>(context).add(GenerateKeys());
          },
          child: Text("Generate Keys"),
        ),
      ),
    );
  }
}
