import 'package:get/get.dart';

abstract class ControlProvider<T> extends GetxController {
  /// Loading & error state
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<T> items = <T>[].obs;
}
