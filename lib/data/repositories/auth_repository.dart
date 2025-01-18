import 'package:ebroker/exports/main_export.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum LoginType {
  google('0'),
  phone('1'),
  apple('2');

  const LoginType(this.value);

  final String value;
}

class AuthRepository {
  final _auth = FirebaseAuth.instance;
  static int? forceResendingToken;
  Future<Map<String, dynamic>> loginWithApi({
    required LoginType type,
    required String? phone,
    required String uid,
    String? email,
    String? name,
  }) async {
    final parameters = <String, String>{
      Api.mobile: phone?.replaceAll(' ', '').replaceAll('+', '') ?? '',
      Api.authId: uid,
      if (email != null) 'email': email,
      if (name != null) 'name': name,
      Api.type: type.value,
    };

    if (type == LoginType.phone) {
      parameters.remove('email');
    } else {
      parameters.remove('mobile');
    }

    final response = await Api.post(
      url: Api.apiLogin,
      parameter: parameters,
      useAuthToken: false,
    );

    return {
      'token': response['token'],
      'data': response['data'],
    };
  }

  Future<void> sendOTP({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    Function(dynamic e)? onError,
  }) async {
    if (AppSettings.otpServiceProvider == 'twilio') {
      await Api.get(
        url: Api.apiGetOtp,
        queryParameters: {
          'number': phoneNumber,
        },
      );
      onCodeSent.call(phoneNumber);
    } else if (AppSettings.otpServiceProvider == 'firebase') {
      await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: Duration(
          seconds: Constant.otpTimeOutSecond,
        ),
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          onError?.call(ApiException(e.code));
        },
        codeSent: (String verificationId, int? resendToken) {
          forceResendingToken = resendToken;
          onCodeSent.call(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
        forceResendingToken: forceResendingToken,
      );
    }
  }

  Future<UserCredential> verifyFirebaseOTP({
    required String otpVerificationId,
    required String otp,
  }) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: otpVerificationId,
        smsCode: otp,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential;
    } catch (e) {
      throw ApiException(e);
    }
  }

  Future<dynamic> verifyTwilioOTP({
    required String otp,
    required String number,
  }) async {
    try {
      String? authId;
      final credential = await Api.get(
        url: Api.apiVerifyOtp,
        queryParameters: {
          'auth_id': authId,
          'number': number,
          'otp': otp,
        },
      );
      return credential;
    } catch (e) {
      throw ApiException(e);
    }
  }

  Future<void> beforeLogout() async {
    final token = await FirebaseMessaging.instance.getToken();
    await Api.post(
      url: Api.apiBeforeLogout,
      parameter: {
        Api.fcmId: token,
      },
    );
  }
}
