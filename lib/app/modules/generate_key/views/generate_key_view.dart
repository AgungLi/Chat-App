import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/modules/generate_key/controllers/business_logic/app_init_bloc/app_init_bloc.dart';
import 'package:chatapp/app/modules/generate_key/controllers/presentation/screen/encryption_screen.dart';
import 'package:chatapp/app/modules/generate_key/controllers/presentation/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:get/get.dart';

import '../controllers/generate_key_controller.dart';

class GenerateKeyView extends GetView<GenerateKeyController> {
  final AppInitBloc _appInitBloc = AppInitBloc();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppInitBloc>(
      create: (BuildContext context) => _appInitBloc,
      child: MaterialApp(
        title: 'RSAEncrypt Demot',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: BlocBuilder<AppInitBloc, AppInitState>(
          builder: (context, state) {
            if (state is InitialState) {
              return HomeScreen();
            }
            if (state is KeyGeneration) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (state is KeysGenerated) {
              return EncryptionScreen(asymmetricKeyPair: state.keyPair);
            }
            return HomeScreen();
          },
        ),
      ),
    );
  }
}
