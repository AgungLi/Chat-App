import 'package:chatapp/app/controllers/auth_controller.dart';
import 'package:chatapp/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  final authC = Get.find<AuthController>();

  List dataTemp = List.generate(
      10,
      (index) => ListTile(
            onTap: () => Get.toNamed(Routes.CHAT_ROOM),
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: Colors.black26,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image.asset(
                    "assets/logo/noimage.png",
                    fit: BoxFit.cover,
                  )),
            ),
            title: Text(
              "Orang ke - ${index + 1}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              "Status orang ke - ${index + 1}",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            trailing: Chip(
              label: Text("3"),
            ),
          )).reversed.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Material(
            elevation: 5,
            child: Container(
              margin: EdgeInsets.only(top: context.mediaQueryPadding.top),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black38,
                  ),
                ),
              ),
              padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Chats",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.red[900],
                    child: InkWell(
                      onTap: () => Get.toNamed(Routes.PROFILE),
                      child: Padding(
                        padding: const EdgeInsets.all(5),
                        child: Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: dataTemp.length,
              itemBuilder: (context, index) => dataTemp[index],
            ),
          ),
          // Expanded(
          //   child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          //     stream: controller.chatsStream(authC.user.value.email!),
          //     builder: (context, snapshot) {
          //       if (snapshot.connectionState == ConnectionState.active) {
          //         var allChats = (snapshot.data!.data()
          //             as Map<String, dynamic>)["chats"] as List;
          //         return ListView.builder(
          //           padding: EdgeInsets.zero,
          //           itemCount: allChats.length,
          //           itemBuilder: (context, index) =>
          //               StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          //             stream: controller
          //                 .friendStream(allChats[index]["connection"]),
          //             builder: (context, snapshot2) {
          //               if (snapshot2.connectionState ==
          //                   ConnectionState.active) {
          //                 var data = snapshot2.data!.data();

          //                 return data!["status"] == ""
          //                     ? ListTile(
          //                         onTap: () => Get.toNamed(Routes.CHAT_ROOM),
          //                         leading: CircleAvatar(
          //                           radius: 30,
          //                           backgroundColor: Colors.black26,
          //                           child: ClipRRect(
          //                             borderRadius: BorderRadius.circular(100),
          //                             child: data["photoUrl"] == "noimage"
          //                                 ? Image.asset(
          //                                     "assets/logo/noimage.png",
          //                                     fit: BoxFit.cover,
          //                                   )
          //                                 : Image.network(
          //                                     "${data["photoUrl"]}",
          //                                     fit: BoxFit.cover,
          //                                   ),
          //                           ),
          //                         ),
          //                         title: Text(
          //                           "${data["name"]}",
          //                           style: TextStyle(
          //                               fontSize: 20,
          //                               fontWeight: FontWeight.w600),
          //                         ),
          //                         trailing: allChats[index]["total_unread"] == 0
          //                             ? SizedBox()
          //                             : Chip(
          //                                 label: Text(
          //                                     "${allChats[index]["total_unread"]}"),
          //                               ),
          //                       )
          //                     : ListTile(
          //                         onTap: () => Get.toNamed(Routes.CHAT_ROOM),
          //                         leading: CircleAvatar(
          //                           radius: 30,
          //                           backgroundColor: Colors.black26,
          //                           child: ClipRRect(
          //                             borderRadius: BorderRadius.circular(100),
          //                             child: data["photoUrl"] == "noimage"
          //                                 ? Image.asset(
          //                                     "assets/logo/noimage.png",
          //                                     fit: BoxFit.cover,
          //                                   )
          //                                 : Image.network(
          //                                     "${data["photoUrl"]}",
          //                                     fit: BoxFit.cover,
          //                                   ),
          //                           ),
          //                         ),
          //                         title: Text(
          //                           "${data["name"]}",
          //                           style: TextStyle(
          //                               fontSize: 20,
          //                               fontWeight: FontWeight.w600),
          //                         ),
          //                         subtitle: Text(
          //                           "${data["status"]}",
          //                           style: TextStyle(
          //                               fontSize: 20,
          //                               fontWeight: FontWeight.w600),
          //                         ),
          //                         trailing: allChats[index]["total_unread"] == 0
          //                             ? SizedBox()
          //                             : Chip(
          //                                 label: Text(
          //                                     "${allChats[index]["total_unread"]}"),
          //                               ),
          //                       );
          //               }
          //               return Center(
          //                 child: CircularProgressIndicator(),
          //               );
          //             },
          //           ),
          //         );
          //       }
          //       return Center(
          //         child: CircularProgressIndicator(),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(Routes.SEARCH),
        child: Icon(
          Icons.search_rounded,
          size: 30,
        ),
        backgroundColor: Colors.red[900],
      ),
    );
  }
}
