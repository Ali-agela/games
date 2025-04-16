import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class DarkModeController extends GetxController {
  // Reactive variable for dark mode
  var isDark = false.obs;

  // Toggles the dark mode and stores the value
  void switchMode() async {
    isDark.value = !isDark.value;
    await storeMode();
  }

  // Stores the dark mode value in shared preferences
  Future<void> storeMode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setBool("isDark", isDark.value);
    update();
  }

  // Retrieves the dark mode value from shared preferences
  Future<void> getMode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    isDark.value = pref.getBool("isDark") ?? false;
  }

  // Initialize the controller by fetching the stored mode
  @override
  void onInit() {
    super.onInit();
    getMode();
  }
}
