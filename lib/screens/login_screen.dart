import 'package:event_planner_buisness/constant.dart';
import 'package:event_planner_buisness/screens/home_page.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_signin_button/flutter_signin_button.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:google_sign_in/google_sign_in.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:modal_progress_hud/modal_progress_hud.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:shimmer/shimmer.dart';

//import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String loginScreen = '/login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isStartRegister = false;

  Future<void> onTapSignInWithGoogle() async {
    setState(() {
      _isStartRegister = true;
    });
    try {
      await signInWithGoogle();
      setState(() {
        _isStartRegister = false;
      });
      Navigator.pushReplacementNamed(context, HomePage.homePage);
    } on NoSuchMethodError catch (e) {
      print('in Catch.....');
      setState(() {
        _isStartRegister = false;
      });
      print(e.toString());
    } catch (e) {
      print(e.toString());
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await _auth.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(color: Color(0xFFFF8038)),
        inAsyncCall: _isStartRegister,
        child: SafeArea(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Color(0xFF033249),
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/bgImage.PNG'),
                    colorFilter: ColorFilter.mode(
                        Color(0xFF033249).withOpacity(0.25), BlendMode.dstATop),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 70),
                  Shimmer.fromColors(
                    baseColor: Color(0xFFFF8038),
                    highlightColor: Colors.amber.shade300,
                    child: Text(
                      '  Event\nPlanner',
                      style: kloginText.copyWith(
                        fontSize: 50,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  // RaisedButton.icon(
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(10),
                  //   ),
                  //   padding: const EdgeInsets.only(
                  //     right: 70,
                  //     left: 20,
                  //     top: 7,
                  //     bottom: 7,
                  //   ),
                  //   textColor: Color(0xFF033249),
                  //   color: Colors.white,
                  //   onPressed: () {},
                  //   icon: Icon(
                  //     Icons.phone,
                  //     color: Color(0xFF033249),
                  //   ),
                  //   label: Text(
                  //     'Sign in using phone',
                  //     style: TextStyle(fontWeight: FontWeight.w600),
                  //   ),
                  //   highlightElevation: 15,
                  // ),
                  // SizedBox(height: 20),
                  // Shimmer.fromColors(
                  //   baseColor: Color(0xFFFF8038),
                  //   highlightColor: Colors.amber.shade300,
                  //   child: Text(
                  //     'Or',
                  //     style: TextStyle(
                  //         color: Color(0xFFFF8038),
                  //         fontWeight: FontWeight.w600,
                  //         fontSize: 17),
                  //   ),
                  // ),
                  // SizedBox(height: 20),
                  SignInButton(
                    Buttons.Google,
                    onPressed: onTapSignInWithGoogle,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                  ),
                  SizedBox(height: 70),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Shimmer.fromColors(
                      baseColor: Color(0xFFFF8038),
                      highlightColor: Colors.amber.shade300,
                      child: Text(
                        'Your Choices Our Plan!',
                        style: TextStyle(
                          color: Color(0xFFFF8038),
                          letterSpacing: 2,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
