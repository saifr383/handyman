import 'package:booking_system_flutter/model/LoginResponse.dart';
import 'package:booking_system_flutter/model/UserData.dart';
import 'package:booking_system_flutter/network/RestApis.dart';
import 'package:booking_system_flutter/screens/DashboardScreen.dart';
import 'package:booking_system_flutter/utils/Constant.dart';
import 'package:booking_system_flutter/utils/ModelKeys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class AuthServices {
  Future<void> updateUserData(UserData user) async {
    userService.updateDocument({
      'player_id': getStringAsync(PLAYERID),
      'updatedAt': Timestamp.now(),
    }, user.uid);
  }

  Future<User> signInWithGoogle() async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult = await _auth.signInWithCredential(credential);
      final User user = authResult.user!;

      assert(!user.isAnonymous);

      final User currentUser = _auth.currentUser!;
      assert(user.uid == currentUser.uid);
      signOutGoogle();

      String firstName = '';
      String lastName = '';

      if (currentUser.displayName.validate().split(' ').length >= 1) firstName = currentUser.displayName.splitBefore(' ');
      if (currentUser.displayName.validate().split(' ').length >= 2) lastName = currentUser.displayName.splitAfter(' ');

      await setValue(LOGIN_TYPE, LoginTypeGoogle);
      await appStore.setUserProfile(currentUser.photoURL!);

      Map req = {
        "email": currentUser.email,
        "first_name": firstName,
        "last_name": lastName,
        "username": currentUser.displayName,
        "profile_image": currentUser.photoURL,
        "accessToken": googleSignInAuthentication.accessToken,
        "login_type": LoginTypeGoogle,
        "user_type": LoginTypeUser,
      };

      return await loginUser(req, isSocialLogin: true).then((value) async {
        await loginFromFirebaseUser(currentUser, loginDetail: value, fName: firstName, lName: lastName);
        return currentUser;
      }).catchError((e) {
        throw e;
      });
    } else {
      throw errorSomethingWentWrong;
    }
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
  }

  Future<void> signUpWithEmailPassword(context, {String? name, String? email, String? password, String? mobileNumber, String? lName, String? userName}) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email!, password: password!);
    if (userCredential != null && userCredential.user != null) {
      User currentUser = userCredential.user!;

      UserData userModel = UserData();
      var displayName = name! + lName!;

      /// Create user
      userModel.uid = currentUser.uid;
      userModel.email = currentUser.email;
      userModel.contact_number = mobileNumber;
      userModel.first_name = name;
      userModel.last_name = lName;
      userModel.username = userName;
      userModel.display_name = displayName;
      userModel.user_type = LoginTypeUser;
      userModel.created_at = Timestamp.now().toDate().toString();
      userModel.updated_at = Timestamp.now().toDate().toString();
      userModel.player_id = getStringAsync(PLAYERID);

      await userService.addDocumentWithCustomId(currentUser.uid, userModel.toJson()).then((value) async {
        var request = {
          UserKeys.firstName: name,
          UserKeys.lastName: lName,
          UserKeys.userName: userName,
          UserKeys.userType: LoginTypeUser,
          UserKeys.contactNumber: mobileNumber,
          UserKeys.email: email,
          UserKeys.password: password,
          UserKeys.uid: userModel.uid,
        };
        await createUser(request).then((res) async {
          await loginUser(request).then((res) async {
            DashboardScreen(index: 0).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Slide);
          }).catchError((e) {
            toast(e.toString());
          });
        }).catchError((e) {
          toast(e.toString());
          return;
        });
        appStore.setLoading(false);

        /*await signInWithEmailPassword(context, email: email, password: password).then((value) {
          //
        }).catchError((e) {
          toast(e.toString());
          return;
        });*/
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    } else {
      throw errorSomethingWentWrong;
    }
  }

  Future<void> signIn(context, {String? email, String? password, LoginResponse? res}) async {
    UserCredential? userCredential = await _auth.createUserWithEmailAndPassword(email: email!, password: password!);
    if (userCredential != null && userCredential.user != null) {
      User currentUser = userCredential.user!;

      UserData userModel = UserData();

      /// Create user
      userModel.uid = currentUser.uid;
      userModel.email = currentUser.email;
      userModel.contact_number = res!.data!.contact_number;
      userModel.first_name = res.data!.first_name;
      userModel.last_name = res.data!.last_name;
      userModel.username = res.data!.username;
      userModel.display_name = res.data!.display_name;
      userModel.country_id = res.data!.country_id;
      userModel.address = res.data!.address;
      userModel.city_id = res.data!.city_id;
      userModel.state_id = res.data!.state_id;
      userModel.user_type = LoginTypeUser;
      userModel.created_at = Timestamp.now().toDate().toString();
      userModel.updated_at = Timestamp.now().toDate().toString();
      userModel.player_id = getStringAsync(PLAYERID);

      await userService.addDocumentWithCustomId(currentUser.uid, userModel.toJson()).then((value) async {
        appStore.setUId(currentUser.uid);

        await signInWithEmailPassword(context, email: email, password: password).then((value) {
          //
        });
      });
    } else {
      throw errorSomethingWentWrong;
    }
  }

  Future<void> signInWithEmailPassword(context, {required String email, required String password}) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) async {
      appStore.setLoading(true);
      final User user = value.user!;
      UserData userModel = await userService.getUser(email: user.email);
      await updateUserData(userModel);

      appStore.setLoading(true);
      //Login Details to SharedPreferences
      setValue(UID, userModel.uid.validate());
      setValue(USER_EMAIL, userModel.email.validate());
      setValue(IS_LOGGED_IN, true);

      //Login Details to AppStore
      appStore.setUserEmail(userModel.email.validate());
      appStore.setUId(userModel.uid.validate());
      //
    }).catchError((e) {
      log(e.toString());
    });
  }

  Future<void> loginFromFirebaseUser(User currentUser, {LoginResponse? loginDetail, String? fullName, String? fName, String? lName}) async {
    UserData userModel = UserData();

    if (await userService.isUserExist(loginDetail!.data!.email)) {
      ///Return user data
      await userService.userByEmail(loginDetail.data!.email).then((user) async {
        userModel = user;
        appStore.setUserEmail(userModel.email.validate());
        appStore.setUId(userModel.uid.validate());

        await updateUserData(user);
      }).catchError((e) {
        log(e);
        throw e;
      });
    } else {
      /// Create user
      userModel.uid = currentUser.uid.validate();
      userModel.id = loginDetail.data!.id.validate();
      userModel.email = loginDetail.data!.email.validate();
      userModel.first_name = loginDetail.data!.first_name.validate();
      userModel.last_name = loginDetail.data!.last_name.validate();
      userModel.contact_number = loginDetail.data!.contact_number.validate();
      userModel.display_name = loginDetail.data!.display_name.validate();
      userModel.username = loginDetail.data!.display_name.validate();
      userModel.email = loginDetail.data!.email.validate();
      userModel.user_type = LoginTypeUser;

      if (isIos) {
        userModel.display_name = fullName;
      } else {
        userModel.display_name = loginDetail.data!.display_name.validate();
      }

      userModel.contact_number = loginDetail.data!.contact_number.validate();
      userModel.profile_image = loginDetail.data!.profile_image.validate();
      userModel.player_id = getStringAsync(PLAYERID);

      setValue(UID, currentUser.uid.validate());
      log(getStringAsync(UID));
      setValue(USER_EMAIL, userModel.email.validate());
      setValue(IS_LOGGED_IN, true);

      log(userModel.toJson());

      await userService.addDocumentWithCustomId(currentUser.uid, userModel.toJson()).then((value) {
        //
      }).catchError((e) {
        throw e;
      });
    }
  }
}
