import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/auth_service.dart';
import '../screens/login/login_screen.dart';
import '../screens/main/main_screen.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final Rx<User?> user = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize current user
    user.value = _authService.currentUser;

    // Listen to auth state changes
    _authService.authStateChanges.listen((data) {
      user.value = data.session?.user;
      _handleAuthRedirect(data.event);
    });
  }

  @override
  void onReady() {
    super.onReady();
    // If user is already logged in on start, go to main
    if (_authService.currentUser != null) {
      Get.offAll(() => const MainScreen());
    }
  }

  void _handleAuthRedirect(AuthChangeEvent event) {
    if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.initialSession) {
      Get.offAll(() => const MainScreen());
    } else if (event == AuthChangeEvent.signedOut) {
      Get.offAll(() => const LoginScreen());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _authService.signIn(email: email, password: password);
    } catch (e) {
      Get.snackbar(
        'Lỗi đăng nhập',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(String email, String password, String name) async {
    try {
      isLoading.value = true;
      await _authService.signUp(email: email, password: password, name: name);
      Get.snackbar(
        'Thành công',
        'Vui lòng kiểm tra email để xác nhận tài khoản.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print(e);
      Get.snackbar(
        'Lỗi đăng ký',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}
