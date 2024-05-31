import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../const/billing_const.dart';
import '../const/login_const.dart';
import '../const/titles.dart';
import '../provider/meal_details_provider.dart';
import '../sqlite/billing_model.dart';
import '../sqlite/helper.dart';

class OrderConfirmationPage extends StatelessWidget {
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  final pinCodeController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  OrderConfirmationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children:  [

                Padding(
                    padding: const EdgeInsets.only(left: 8,right: 40.0),
                    child: IconButton(onPressed: (){
                      Navigator.pop(context);
                    }, icon: const Icon(Icons.arrow_back))
                ),
                const Text(billingTitle,style: TextStyle(
                    fontSize: 26
                ),),
              ],),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, right: 25, top: 15),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    TextFormField(
                      controller: fullNameController,
                      cursorColor: Colors.redAccent,
                      decoration: const InputDecoration(
                        labelText: fullName,
                        labelStyle: TextStyle(color: Colors.pink),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.pink),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return alertErrorName;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: emailController,
                      cursorColor: Colors.redAccent,
                      decoration: const InputDecoration(
                        labelText: email,
                        labelStyle: TextStyle(color: Colors.pink),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.pink),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return alertErrorEmail;
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: addressController,
                      cursorColor: Colors.redAccent,
                      decoration: const InputDecoration(
                        labelText: address,
                        labelStyle: TextStyle(color: Colors.pink),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.pink),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return alertErrorAddress;
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: cityController,
                            cursorColor: Colors.redAccent,
                            decoration: const InputDecoration(
                              labelText: city,
                              labelStyle: TextStyle(color: Colors.pink),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.pink),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return alertErrorCity;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: stateController,
                            cursorColor: Colors.redAccent,
                            decoration: const InputDecoration(
                              labelText: state,
                              labelStyle: TextStyle(color: Colors.pink),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.pink),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return alertErrorState;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: countryController,
                            cursorColor: Colors.redAccent,
                            decoration: const InputDecoration(
                              labelText: country,
                              labelStyle: TextStyle(color: Colors.pink),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.pink),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return alertErrorCountry;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: pinCodeController,
                            cursorColor: Colors.redAccent,
                            decoration: const InputDecoration(
                              labelText: pincode,
                              labelStyle: TextStyle(color: Colors.pink),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color:
                                        Colors.pink),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return alertErrorPincode;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      width: double.infinity,
                      height: 100,
                      margin: const EdgeInsets.only(top: 40, bottom: 20),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState?.validate() == true) {
                            String fullName = fullNameController.text;
                            String email = emailController.text;
                            String address = addressController.text;
                            String city = cityController.text;
                            String state = stateController.text;
                            String country = countryController.text;
                            String pinCode = pinCodeController.text;

                            final userInfo = UserInfo(
                              fullName: fullName,
                              email: email,
                              address: address,
                              city: city,
                              state: state,
                              country: country,
                              pinCode: pinCode,
                            );
                            DatabaseHelper databaseHelper = DatabaseHelper();
                            int? id = await databaseHelper.insertUserInfo(userInfo);
                            debugPrint(
                                'User inserted with ID: $id, Name: $fullName');

                            ///update the userInfo data
                            Provider.of<MealProvider>(context, listen: false)
                                .getUserInfo(userInfo.email);

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  elevation: 20,
                                  title: const Center(
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 80,
                                    ),
                                  ),
                                  content: Text(
                                    successMessage,
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red[400]),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // Close the dialog
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.all(15),
                                          decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(blurRadius: 3)
                                            ],
                                            color: Colors.red[400],
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            ok,
                                            style: TextStyle(color: Colors.white),
                                          )),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                               const SnackBar(
                                content:
                                    Text(ErrorMessage),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: primaryColor,
                          elevation: 6,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28), // Adjust the corner radius as needed
                          ),
                        ),

                        child: const Text(submit),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
