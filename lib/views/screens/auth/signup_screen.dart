import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:intl/intl.dart';
import 'package:textfield_datepicker/textfield_datepicker.dart';
import 'package:tiktok/constants.dart';
import 'package:tiktok/controllers/auth_controller.dart';
import 'package:tiktok/controllers/face_detector_controller.dart';
import 'package:tiktok/views/screens/auth/login_screen.dart';
import 'package:tiktok/views/widgets/text_input_field.dart';

import '../../common/page_transition.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreen createState() => _RegisterScreen();
}

enum Gender { man, woman }
class _RegisterScreen extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _BODController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  ImageProvider avatarPath = const AssetImage('assets/images/default_profile.png');
  Gender? _gender = Gender.man;

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SingleChildScrollView(
        child:       Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'TikTok',
              style: TextStyle(
                fontSize: 35,
                color: buttonColor,
                fontWeight:
                FontWeight.w900
              ),
            ),
            const Text(
              'Register', 
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w700
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 64,
                  backgroundImage: avatarPath,
                ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(icon: const Icon(Icons.add_a_photo), onPressed: () => {
                    authController.pickImage().then((pickedImage) => {
                      setState(() {
                        avatarPath = FileImage(pickedImage.value!);
                      }),
                    }),
                  }),
                )
              ],
            ),
            const SizedBox(
              height: 25
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: MediaQuery.of(context).size.width,
              child: TextInputField(controller: _usernameController, labelText: 'Username', icon: Icons.person,)
            ),
            const SizedBox(
              height: 25
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: TextfieldDatePicker(
                textfieldDatePickerPadding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const InputDecoration(
                                labelStyle: TextStyle(fontSize: 20),
                                labelText: 'Birthday',
                                prefixIcon: Icon(Icons.calendar_month),
                                // border: OutlineInputBorder(
                                //   borderSide: BorderSide(color: Colors.white, width: 10)
                                // ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(
                                      color:Colors.white60,
                                      width: 1,
                                  )
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(
                                      color:Colors.white60,
                                      width: 1,
                                  )
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  borderSide: BorderSide(
                                      color:Colors.white60,
                                      width: 1,
                                  )
                                )
                            ),
                textfieldDatePickerController: _BODController,
                materialDatePickerFirstDate: DateTime.now(),
                materialDatePickerLastDate: DateTime(2099),
                materialDatePickerInitialDate: DateTime.now(),
                preferredDateFormat: DateFormat('yyyy/MM/dd') ,
                cupertinoDatePickerMaximumDate: DateTime(2099),
                cupertinoDatePickerMinimumDate: DateTime(1990),
                cupertinoDatePickerBackgroundColor: Colors.white,
                cupertinoDatePickerMaximumYear: 2099,
                cupertinoDateInitialDateTime: DateTime.now()
              ),
            ),
            const SizedBox(
              height: 25
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(controller: _emailController, labelText: 'Email', icon: Icons.email),
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInputField(controller: _passwordController, labelText: 'Password', icon: Icons.lock, isObscure: true, ),
            ),
                        const SizedBox(
              height: 25
            ),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    child:
                      ListTile(
                        title: const Text('Man'),
                        leading: Radio(
                          value: Gender.man,
                          groupValue: _gender,
                          onChanged: (Gender? value) {
                            setState(() {
                              _gender = value;
                            });
                          }),
                      ),
                  ),
                ),
                Expanded(
                  child:
                  ListTile(
                    title: const Text('Woman'),
                    leading: Radio(
                      value: Gender.woman,
                      groupValue: _gender,
                      onChanged: (Gender? value) {
                        setState(() {
                          _gender = value;
                        });
                      }),
                  )
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: const BoxDecoration(
                color: buttonColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(5)
                )
              ),
              child: InkWell(
                onTap: () => authController.registerUser(_usernameController.text, _emailController.text, _passwordController.text, authController.profilePhoto),
                child: const Center(
                  child: Text('Register', style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  )),
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Already have an account? ',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    PageTransition.createRoute(LoginScreen())
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      color: buttonColor,
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
      )
    );
  }

}