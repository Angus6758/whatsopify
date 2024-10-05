import 'package:seller_management/features/auth/controller/auth_ctrl.dart';
import 'package:seller_management/main.export.dart';

final passwordResetCtrlProvider =
    NotifierProvider<PasswordResetCtrlNotifier, ResetPasswordState>(
        PasswordResetCtrlNotifier.new);

class PasswordResetCtrlNotifier extends Notifier<ResetPasswordState> {
  @Deprecated('Use setters')
  void copyWith(ResetPasswordState Function(ResetPasswordState current) copy) {
    state = copy(state);
    Logger.json(state.toMap().removeNullAndEmpty());
  }

  void setEmail(String email) => state = state.copyWith(email: email);

  void setOtp(String otp) => state = state.copyWith(otp: otp);

  void setPassword(QMap formData) => state = state.copyWith(
        password: formData['password'],
        confirmPassword: formData['password_confirmation'],
      );

  Future<bool> verifyEmail() async {
    return await authCtrl().emailVerify(state.email);
  }

  Future<bool> verifyOtp() async {
    return await authCtrl().verifyOTP(state.toMap());
  }

  Future<bool> resetPass() async {
    return await authCtrl().resetPassword(state.toMap());
  }

  AuthCtrlNotifier authCtrl() => ref.read(authCtrlProvider.notifier);

  @override
  build() {
    return ResetPasswordState.empty;
  }
}

class ResetPasswordState {
  const ResetPasswordState({
    required this.email,
    required this.otp,
    required this.password,
    required this.confirmPassword,
  });

  factory ResetPasswordState.fromMap(Map<String, dynamic> map) {
    return ResetPasswordState(
      email: map['email'] ?? '',
      otp: map['code'] ?? '',
      password: map['password'] ?? '',
      confirmPassword: map['password_confirmation'] ?? '',
    );
  }

  static ResetPasswordState empty = const ResetPasswordState(
    email: '',
    otp: '',
    password: '',
    confirmPassword: '',
  );

  final String confirmPassword;
  final String email;
  final String otp;
  final String password;

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'email': email});
    result.addAll({'code': otp});
    result.addAll({'password': password});
    result.addAll({'password_confirmation': confirmPassword});

    return result;
  }

  ResetPasswordState copyWith({
    String? email,
    String? otp,
    String? password,
    String? confirmPassword,
  }) {
    return ResetPasswordState(
      email: email ?? this.email,
      otp: otp ?? this.otp,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}
