import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';

class AuthController extends GetxController {
  static AuthController get instance => Get.find();
  var verificationid = ''.obs;

  //update this code.
  void login(String username, String password) async{
       await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: username,
          verificationCompleted: (PhoneAuthCredential credential) async {
            var usercred=await FirebaseAuth.instance.signInWithCredential(credential);
            print("aryaniscool$usercred");
            Get.toNamed(AppRoutes.HOME);
          },
          verificationFailed: (FirebaseAuthException e) {
            print(e.message);
          },
          codeSent: (verificationId, resendtk) {
            this.verificationid.value = verificationId;
          },
          codeAutoRetrievalTimeout: (verificationId) {
            this.verificationid.value = verificationId;
          });
  }

  void verifyOTP(otp) async {
    var credential = await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(verificationId: this.verificationid.value, smsCode: otp));
    credential.user != null ? Get.toNamed(AppRoutes.HOME) : false;
  }

  void googlelogin()async{
    GoogleAuthProvider _googleauthpoviider =  GoogleAuthProvider();
    var userCredentials= await FirebaseAuth.instance.signInWithProvider(_googleauthpoviider);
    bool? isNewUser = userCredentials.additionalUserInfo?.isNewUser;
    if (isNewUser==true){
      Get.toNamed(AppRoutes.REGISTER);
    }
    else {
      Get.toNamed(AppRoutes.HOME);
    }
  }
}
