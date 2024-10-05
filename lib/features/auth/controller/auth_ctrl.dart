import 'package:seller_management/main.export.dart';

import '../repository/auth_repo.dart';

final authCtrlProvider =
    NotifierProvider<AuthCtrlNotifier, bool>(AuthCtrlNotifier.new);

class AuthCtrlNotifier extends Notifier<bool> {
  final _repo = locate<AuthRepo>();
  String? _token;

  Future<void> login(String name, String pass) async {
    final data = await _repo.loginUser(name, pass);
    data.fold(
      (l) => Toaster.showError(l),
      (r) {
        _repo.saveToken(r.data);
        Toaster.showSuccess('Login Successful');
      },
    );
    ref.invalidateSelf();
  }

  Future<void> register(QMap formData) async {
    final data = await _repo.registerUser(formData);
    data.fold(
      (l) => Toaster.showError(l),
      (r) {
        _repo.saveToken(r.data);
        Toaster.showSuccess('Register Successful');
      },
    );
    ref.invalidateSelf();
  }

  Future<void> updatePassword(QMap formData) async {
    final data = await _repo.updatePassword(formData);
    data.fold(
      (l) => Toaster.showError(l),
      (r) => Toaster.showSuccess(r.data),
    );
    ref.invalidateSelf();
  }

  Future<bool> emailVerify(String email) async {
    final data = await _repo.emailVerify(email);
    return data.fold(
      (l) {
        Toaster.showError(l);
        return false;
      },
      (r) {
        Toaster.showSuccess(r.data);
        return true;
      },
    );
  }

  Future<bool> verifyOTP(QMap formData) async {
    final data = await _repo.verifyOTP(formData);

    return data.fold(
      (l) {
        Toaster.showError(l);
        return false;
      },
      (r) {
        Toaster.showSuccess(r.data);
        return true;
      },
    );
  }

  Future<bool> resetPassword(QMap formData) async {
    final data = await _repo.resetPassword(formData);
    return data.fold(
      (l) {
        Toaster.showError(l);
        return false;
      },
      (r) {
        Toaster.showSuccess(r.data);
        return true;
      },
    );
  }

  Future<void> logout([bool callApi = true]) async {
    if (callApi) {
      final data = await _repo.logOut();
      data.fold(
        (l) => Toaster.showError(l),
        (r) => Toaster.showSuccess(r.data),
      );
    } else {
      await _repo.deleteToken();
    }
    ref.invalidateSelf();
  }

  Future<void> _setupFireMsg(bool isLoggedIn) async {
    final fcm = FireMessage.instance;
    await fcm.updateServerToken(isLoggedIn);
  }

  Future<String?> getToken() async {
    final loggedIn = _repo.getToken();

    if (loggedIn != null) {
      _token = loggedIn; // Cache it in memory for future use
      return loggedIn;
    }

    return _token;
  }



  @override
  bool build() {
    Logger('auth init', 'AuthCtrl');
    final loggedIn = _repo.getToken();
    final isLoggedIn = loggedIn != null;
    _setupFireMsg(isLoggedIn);
    return isLoggedIn;
  }
}
