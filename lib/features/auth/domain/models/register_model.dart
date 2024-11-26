import 'dart:io';

class RegisterModel {
  String? email;
  String? password;
  String? fName;
  String? lName;
  String? phone;
  String? socialId;
  String? loginMedium;
  String? referCode;
  String? tradeLicense;
  String? foodLicense;
  String? GSTNumber;

  File? billImage;

  RegisterModel({
    this.email,
    this.password,
    this.fName,
    this.lName,
    this.phone,
    this.socialId,
    this.loginMedium,
    this.referCode,
    this.billImage,
    this.tradeLicense,
    this.foodLicense,
    this.GSTNumber,
  });

  // Constructor to initialize the model from JSON
  RegisterModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    fName = json['full_name'];
    lName = json['store_name'];
    phone = json['phone'];
    socialId = json['social_id'];
    loginMedium = json['login_medium'];
    referCode = json['referral_code'];
    billImage = json['billImage']; // Fixed to match your API's 'billImage' field
    tradeLicense = json['tradeLicense'];
    foodLicense = json['foodLicense'];
    GSTNumber = json['GSTNumber'];
  }

  // Convert the model data to JSON
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['password'] = password;
    data['full_name'] = fName;
    data['store_name'] = lName;
    data['phone'] = phone;
    data['social_id'] = socialId;
    data['login_medium'] = loginMedium;
    data['referral_code'] = referCode;
    data['billImage'] = billImage; // Ensure this field is serialized correctly
    data['tradeLicense'] = tradeLicense;
    data['foodLicense'] = foodLicense;
    data['GSTNumber'] = GSTNumber;
    return data;
  }
}
