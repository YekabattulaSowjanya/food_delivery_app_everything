import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/const/billing_const.dart';
import 'package:food_delivery_app/provider/meal_details_provider.dart';
import 'package:food_delivery_app/sqlite/billing_model.dart';
import 'package:food_delivery_app/sqlite/user_model.dart';
import 'package:provider/provider.dart';
import '../const/titles.dart';
import '../sqlite/helper.dart';

class ProfilePage extends StatelessWidget {
  final User user;
  final UserInfo? userInfo;
  ProfilePage({
    Key? key,
    required this.user,
    this.userInfo,
  }) : super(key: key);

  DatabaseHelper databaseHelper = DatabaseHelper();

  UserInfo? userData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<MealProvider>(builder: (context, provider, _) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 8, right: 70.0),
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back))),
                  const Text(
                    'Person Details',
                    style: TextStyle(fontSize: 26),
                  ),
                ],
              ),
              const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: CircleAvatar(
                    backgroundColor: Colors.pink,
                    radius: 50,
                    backgroundImage: NetworkImage(
                        'https://i.pinimg.com/550x/8d/52/c5/8d52c5c35382908832ffedb21c1e63b0.jpg'),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16, bottom: 10),
                  child: Text(
                    provider.userInfo?.fullName ?? '',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    provider.userInfo?.email ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20, top: 10),
                child: Text(
                  address1,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                padding: const EdgeInsets.only(
                    left: 20.0, right: 30, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 3,
                        color: Colors.grey,
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: const Color(0xFFC5CAE9), width: 3)),
                child: Row(
                  children: [
                    Text(
                      provider.userInfo?.address ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      provider.userInfo?.city ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20, top: 10),
                child: Text(
                  stateCountry,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 3,
                        color: Colors.grey,
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: const Color(0xFFC5CAE9), width: 3)),
                child: Row(
                  children: [
                    Text(
                      provider.userInfo?.state ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      provider.userInfo?.country ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20, top: 10),
                child: Text(
                  pincode,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 2,
                        color: Colors.grey,
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: const Color(0xFFC5CAE9), width: 3)),
                child: Text(
                  provider.userInfo?.pinCode ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
