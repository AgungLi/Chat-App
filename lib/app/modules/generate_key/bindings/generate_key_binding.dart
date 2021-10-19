import 'package:get/get.dart';

import '../controllers/generate_key_controller.dart';

class GenerateKeyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GenerateKeyController>(
      () => GenerateKeyController(),
    );
  }
}
