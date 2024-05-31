import 'package:flutter/material.dart';
import 'package:food_delivery_app/registration_page/sign_up_page.dart';
import 'package:provider/provider.dart';
import '../const/billing_const.dart';
import '../const/login_const.dart';
import '../home_page/home_screen.dart';
import '../provider/meal_details_provider.dart';
import '../sqlite/helper.dart';
import '../sqlite/user_model.dart';

class LoginPage extends StatelessWidget {
   const LoginPage({Key? key}) : super(key: key);


  Future<void> _loginUser(
      String email, String password, BuildContext context) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    User? user = await databaseHelper.getUserByEmail(email, password);

    if (user == null || user.password != password) {
      /// Show an error dialog if the email and password do not match.
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 20,
            title: const Text(errorLogin),
            content: const Text(invalidMessage),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                    elevation: 7,
                  backgroundColor: Colors.red[400]
                ),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      /// Navigate to the home screen if the login is successful.
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (context, animation, secondaryAnimation) {
            const begin = Offset(-1.0, 0.0); // Animation starts from left
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: FirstHomeScreen(user: user),
            );
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    Color primaryColor = Theme.of(context).primaryColor;
    Color accentColor = Theme.of(context).accentColor;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(children: [
          Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                  'assets/login_image.jpg') //Image.asset('assets/background.png'),
              ),
          Padding(
            padding: const EdgeInsets.only(
                top: 60.0, bottom: 40.0, left: 26.0, right: 25.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    login,
                    style: TextStyle(fontSize: 45.0),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        loginWelcome,
                        style: TextStyle(fontSize: 24.0),
                      ),
                      Text(
                        loginText,
                        style: TextStyle(fontSize: 24.0),
                      ),
                      Text(
                        loginText1,
                        style: TextStyle(fontSize: 24.0),
                      ),
                    ],
                  ),
                  Consumer<MealProvider>(
                      builder: (context, mealProvider, child) {
                    return Column(
                      children: [
                        TextField(
                          controller: emailController,
                          cursorColor: Colors.redAccent,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            labelStyle: TextStyle(color: Colors.pink),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .pink), // Set the baseline color here
                            ),
                            hintText: email,
                            labelText: email,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 10),
                          child: TextField(
                            controller: passwordController,
                            cursorColor: Colors.redAccent,
                           // obscureText: true,
                            obscureText: !mealProvider.passwordVisible,
                            keyboardType: TextInputType.visiblePassword,
                            onChanged: (value) {},
                            decoration: InputDecoration(
                              hintText: password,
                              labelText: password,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  mealProvider.passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {

                                  print('Eye icon pressed');
                                  mealProvider.togglePasswordVisibility();
                                },

                              ),
                              labelStyle: const TextStyle(color: Colors.pink),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.pink),
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {},
                            child: Text(
                              loginForgotMessage,
                              style:
                                  TextStyle(fontSize: 20.0, color: accentColor),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  ElevatedButton(
                    onPressed: () async {
                      String email = '';
                      String password = '';

                      email = emailController.text;
                      password = passwordController.text;

                      await _loginUser(email, password, context);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: primaryColor,
                      elevation: 7
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        login,
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        loginAlertMessage,
                        style: TextStyle(fontSize: 20.0),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration:
                                  const Duration(milliseconds: 500),
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(1, 0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: SignupPage(),
                                );
                              },
                            ),
                          );
                        },
                        child: Text(
                          signUp,
                          style: TextStyle(fontSize: 25.0, color: accentColor),
                        ),
                      ),
                    ],
                  ),
                ]),
          )
        ]));
  }
}
