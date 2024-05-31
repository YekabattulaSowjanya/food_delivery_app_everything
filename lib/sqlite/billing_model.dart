class UserInfo {
   int? id;
   String fullName;
   String email;
   String address;
   String city;
   String state;
   String country;
   String pinCode;
   //String phoneNumber;

  UserInfo({
     this.id,
    required this.fullName,
    required this.email,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.pinCode, //required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'pinCode': pinCode,
      //'phoneNumber': phoneNumber,
    };
  }
   factory UserInfo.fromMap(Map<String, dynamic> map) {
     return UserInfo(
       id: map['id'],
       fullName: map['fullName'],
       email: map['email'],
       address: map['address'],
       city: map['city'],
       state: map['state'],
       country: map['country'],
       pinCode: map['pinCode'],
       //phoneNumber: map['phoneNumber']
     );
   }
}
