import 'package:flutter/material.dart';
import 'package:food_delivery_app/provider/meal_details_provider.dart';
import 'package:provider/provider.dart';
import '../const/billing_const.dart';
import '../const/login_const.dart';
import '../sqlite/helper.dart';
import '../sqlite/user_model.dart';

class SignupPage extends StatelessWidget {
  SignupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final TextEditingController fullNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();


    final _formKey = GlobalKey<FormState>();

    Color primaryColor = Theme.of(context).primaryColor;

    bool isValidEmail(String value) {
      String pattern = r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b';
      RegExp regExp = RegExp(pattern);
      return regExp.hasMatch(value);
    }

    bool _isValidPassword(String password) {
      RegExp passwordRegExp = RegExp(
          r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$');
      return passwordRegExp.hasMatch(password);
    }

    return Scaffold(

        // resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(children: [
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
                'assets/login_image.jpg')
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 60.0, bottom: 60.0, left: 25.0, right: 25.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    registerTitle,
                    style: TextStyle(fontSize: 45.0),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        registerSubTitle,
                        style: TextStyle(fontSize: 28.0),
                      ),
                      Text(
                        registerSubTitle1,
                        style: TextStyle(fontSize: 28.0),
                      ),
                    ],
                  ),
                  Flexible(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: fullNameController,
                              keyboardType: TextInputType.name,
                              cursorColor: Colors.redAccent,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return alertMessage;
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                hintText: fullName,
                                labelText: fullName,
                                labelStyle: TextStyle(color: Colors.pink),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .pink),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 20, bottom: 20),
                              child: TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: Colors.redAccent,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return errorEmail;
                                  } else if (!isValidEmail(value)) {
                                    return alertEmail;
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: email,
                                  labelText: email,
                                  labelStyle: TextStyle(color: Colors.pink),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .pink), // Set the baseline color here
                                  ),
                                ),
                              ),
                            ),

                              Consumer<MealProvider>(builder: (context, passwordVisibleProvider, _) {
                              return TextFormField(
                                controller: passwordController,
                                cursorColor: Colors.redAccent,
                                obscureText: !passwordVisibleProvider.passwordVisible,
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return alertPassword;
                                  } else if (!passwordVisibleProvider.passwordVisible && !_isValidPassword(value)) {
                                    return validPassword;
                                  } else if (value.length < 8) {
                                    return alertPasswordEight;
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: password,
                                  labelText: password,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      passwordVisibleProvider.passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {

                                      print('Eye icon pressed');
                                      passwordVisibleProvider.togglePasswordVisibility();
                                    },

                                  ),
                                  labelStyle: TextStyle(color: Colors.pink),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.pink,
                                    ),
                                  ),
                                ),
                              );})


                          ],
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState?.validate() == true) {
                        String fullName = fullNameController.text;
                        String email = emailController.text;
                        String password = passwordController.text;

                        User user = User(
                          fullName: fullName,
                          email: email,
                          password: password,
                        );

                        DatabaseHelper databaseHelper = DatabaseHelper();
                        int? id = await databaseHelper.insertUser(user);

                        User? newUser = await databaseHelper.getUserByEmail(
                            email, password);

                        debugPrint(
                            'User inserted with ID: $id $fullName $email');

                        if (newUser != null) {
                          debugPrint(
                              'User retrieved: $id ${newUser.fullName} ${newUser.email}');

                          // Show success alert dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                elevation: 20,
                                title: const Text(success),
                                content: const Text(alertSuccess),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          boxShadow: const [
                                            BoxShadow(blurRadius: 3)
                                          ],
                                          color: Colors.red[400],
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Text(
                                          done,
                                          style: TextStyle(color: Colors.white),
                                        )),
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          debugPrint(errorSuccess);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      elevation: 7,
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        registerTitle,
                        style: TextStyle(fontSize: 25.0, color: Colors.white),
                      ),
                    ),
                  ),
                ]),
          )
        ]));
  }
}
