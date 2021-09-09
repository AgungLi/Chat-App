import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  final authC = Get.find<AuthController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Get.back(),
          ),
          actions: [
            IconButton(
              onPressed: () => authC.logout(),
              icon: Icon(
                Icons.logout,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Container(
              child: Column(
                children: [
                  AvatarGlow(
                    endRadius: 110,
                    glowColor: Colors.black,
                    duration: Duration(seconds: 2),
                    child: Container(
                      margin: EdgeInsets.all(15),
                      width: 175,
                      height: 175,
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: AssetImage("assets/logo/noimage.png"),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Text(
                    "Lorem Ipsum",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "loremipsum@gmail.com",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    ListTile(
                      onTap: () => Get.toNamed(Routes.UPDATE_STATUS),
                      leading: Icon(Icons.note_add_outlined),
                      title: Text(
                        "Update Status",
                        style: TextStyle(fontSize: 22),
                      ),
                      trailing: Icon(Icons.arrow_right),
                    ),
                    ListTile(
                      onTap: () => Get.toNamed(Routes.CHANGE_PROFILE),
                      leading: Icon(Icons.person),
                      title: Text(
                        "Change Profile",
                        style: TextStyle(fontSize: 22),
                      ),
                      trailing: Icon(Icons.arrow_right),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: Icon(Icons.color_lens),
                      title: Text(
                        "Change Theme",
                        style: TextStyle(fontSize: 22),
                      ),
                      trailing: Text("Light"),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: context.mediaQueryPadding.bottom + 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Chat App", style: TextStyle(color: Colors.black54)),
                  Text("v1.0", style: TextStyle(color: Colors.black54)),
                ],
              ),
            ),
          ],
        ));
  }
}
