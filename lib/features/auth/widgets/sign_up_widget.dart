import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/domain/models/register_model.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/widgets/condition_check_box_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/profile/controllers/profile_contrroller.dart';
import 'package:flutter_sixvalley_ecommerce/helper/velidate_check.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/main.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/features/splash/controllers/splash_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/app_constants.dart';
import 'package:flutter_sixvalley_ecommerce/utill/color_resources.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_button_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/show_custom_snakbar_widget.dart';
import 'package:flutter_sixvalley_ecommerce/common/basewidget/custom_textfield_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:provider/provider.dart';
import '../screens/otp_verification_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:http/http.dart' as http;


class SignUpWidget extends StatefulWidget {
  const SignUpWidget({super.key});

  @override
  SignUpWidgetState createState() => SignUpWidgetState();
}

class SignUpWidgetState extends State<SignUpWidget> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referController = TextEditingController();

  final FocusNode _fNameFocus = FocusNode();
  final FocusNode _lNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referFocus = FocusNode();
  final TextEditingController _tradeLicenseController = TextEditingController();
  final TextEditingController _foodLicenseController = TextEditingController();
  final TextEditingController _GSTNumberController = TextEditingController();



  RegisterModel register = RegisterModel();
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();

  FirebaseStorage storage = FirebaseStorage.instance;



  @override
  void dispose() {
    // Dispose the controller when the widget is removed from the widget tree
    _tradeLicenseController.dispose();
    _foodLicenseController.dispose();
    _GSTNumberController.dispose();
    super.dispose();
  }

  void _fetchTradeLicense() {
    // Fetch the entered text
    String tradeLicense = _tradeLicenseController.text.trim();
    if (tradeLicense.isNotEmpty) {
      // Do something with the fetched data
      print("Trade License: $tradeLicense");
    } else {
      print("Trade License field is empty.");
    }
  }


  // Future<void> pickImage() async {
  //   final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     setState(() {
  //       billImage = File(pickedFile.path);
  //     });
  //   }
  // }

  File? _pickedImage;
  final ImagePicker _picker = ImagePicker();


  File? image;
  final picker = ImagePicker();
  bool showSpinner = false;
  File? billImage;

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        billImage = File(pickedFile.path);
        _pickedImage = File(pickedFile.path);
      });
    } else {
      showCustomSnackBar('No image selected', context);
    }
  }




  Future<void> uploadImage() async {
    if (_pickedImage == null) {
      showCustomSnackBar('Please select an image to upload', context);
      return;
    }

    setState(() {
      showSpinner = true;
    });

    try {
      var stream = http.ByteStream(_pickedImage!.openRead());
      var length = await _pickedImage!.length();
      var uri = Uri.parse(AppConstants.registrationUri);
      var request = http.MultipartRequest('POST', uri);
      var multiport = http.MultipartFile('billImage', stream, length);

      request.files.add(multiport);
      var response = await request.send();

      if (response.statusCode == 200) {
        print('Image uploaded successfully');
      } else {
        print('Image upload failed');
      }
    } catch (e) {
      print('Error uploading image: $e');
    } finally {
      setState(() {
        showSpinner = false;
      });
    }
  }

  //
  //
  // Future<void>uploadImage() async{
  //
  //  setState(() {
  //
  //  });
  //
  //  var stream = new http.ByteStream(image!.openRead());
  //  stream.cast();
  //
  //  var length =await image!.length();
  //
  //  var uri = Uri.parse( AppConstants.registrationUri);
  //
  //  var request = new http.MultipartRequest('POST', uri);
  //
  //  // request.fields['title']="name";
  //
  //  var multiport =new http.MultipartFile('billImage', stream, length);
  //
  //  request.files.add(multiport);
  //
  //  var response = await request.send();
  //  if(response.statusCode==200){
  //    print('Image uploaded');
  //
  //  } else{
  //    print('Image failed');
  //  }
  //
  // }


// Pick image from gallery
//   Future<File?> pickImage() async {
//     final ImagePicker _picker = ImagePicker();
//
//     // Pick an image from the gallery
//     final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
//
//     // Check if an image was picked
//     if (image != null) {
//       // Convert XFile to File
//       File file = File(image.path);
//       print('Image picked successfully');
//       return file;
//     } else {
//       print('No image selected');
//       return null; // Return null if no image was selected
//     }}
//
//
//
//   // Upload image to Firebase and return the image URL
//   Future<String?> _uploadImage(File image) async {
//     try {
//       final storageRef = FirebaseStorage.instance.ref().child('uploads/${DateTime.now().toString()}.jpg');
//       final uploadTask = await storageRef.putFile(image);
//       return await uploadTask.ref.getDownloadURL();
//     } catch (e) {
//       print('Error uploading image: $e');
//       return null;
//     }
//   }
//
//


  route(bool isRoute, String? token, String? tempToken, String? errorMessage) async {
    var splashController = Provider.of<SplashController>(context,listen: false);
    var authController = Provider.of<AuthController>(context, listen: false);
    var profileController = Provider.of<ProfileController>(context, listen: false);
    String phone = authController.countryDialCode +_phoneController.text.trim();
    if (isRoute) {
      if(splashController.configModel!.emailVerification!){
        authController.sendOtpToEmail(_emailController.text.toString(), tempToken!).then((value) async {
          if (value.response?.statusCode == 200) {
            authController.updateEmail(_emailController.text.toString());
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>
                VerificationScreen(tempToken,'',_emailController.text.toString())), (route) => false);

          }
        });
      }else if(splashController.configModel!.phoneVerification!){
        authController.sendOtpToPhone(phone,tempToken!).then((value) async {
          if (value.isSuccess) {
            authController.updatePhone(phone);
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) =>
                VerificationScreen(tempToken,phone,'')), (route) => false);

          }
        });
      }else{
        await profileController.getUserInfo(context);
        Navigator.pushAndRemoveUntil(Get.context!, MaterialPageRoute(builder: (_) =>
        const DashBoardScreen()), (route) => false);
        _emailController.clear();
        _passwordController.clear();
        _firstNameController.clear();
        _lastNameController.clear();
        _phoneController.clear();
        _confirmPasswordController.clear();
        _referController.clear();
      }


    }
    else {
      showCustomSnackBar(errorMessage, context);
    }
  }


  @override
  void initState() {
    super.initState();
   Provider.of<AuthController>(context, listen: false).setCountryCode(CountryCode.fromCountryCode(Provider.of<SplashController>(context, listen: false).configModel!.countryCode!).dialCode!, notify: false);

  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        Consumer<AuthController>(
          builder: (context, authProvider, _) {
            return Consumer<SplashController>(
              builder: (context, splashProvider,_) {
                return Form(
                  key: signUpFormKey,
                  child: Column(children: [
                    const SizedBox(height: Dimensions.paddingSizeExtraSmall,),
                    Container(
                        margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault, right: Dimensions.marginSizeDefault),
                      child: CustomTextFieldWidget(
                        hintText: getTranslated('Your name', context),
                        labelText: getTranslated('Your name', context),
                        inputType: TextInputType.name,
                        required: true,
                        focusNode: _fNameFocus,
                        nextFocus: _lNameFocus,
                        prefixIcon: Images.username,
                        capitalization: TextCapitalization.words,
                        controller: _firstNameController,
                        validator: (value)  => ValidateCheck.validateEmptyText(value, "first_name_field_is_required"))),


                    Container(margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault, right: Dimensions.marginSizeDefault,
                        top: Dimensions.marginSizeSmall),
                      child: CustomTextFieldWidget(
                        hintText: getTranslated('Your shop name', context),
                        labelText: getTranslated('Your shop name', context),
                        focusNode: _lNameFocus,
                        prefixIcon:   Images.shopu,
                        nextFocus: _emailFocus,
                        required: true,
                        capitalization: TextCapitalization.words,
                        controller: _lastNameController,
                        validator: (value)  => ValidateCheck.validateEmptyText(value, "last_name_field_is_required"))),

                      Container(margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault, right: Dimensions.marginSizeDefault,
                          top: Dimensions.marginSizeSmall),
                        child: CustomTextFieldWidget(
                          hintText: getTranslated('enter_your_email', context),
                          labelText: getTranslated('enter_your_email', context),
                          focusNode: _emailFocus,
                          nextFocus: _phoneFocus,
                          required: true,
                          inputType: TextInputType.emailAddress,
                          controller: _emailController,
                          prefixIcon: Images.email,
                          validator: (value) => ValidateCheck.validateEmail(value))),



                      Container(margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault,
                          right: Dimensions.marginSizeDefault, top: Dimensions.marginSizeSmall),
                        child: CustomTextFieldWidget(
                          hintText: getTranslated('enter_mobile_number', context),
                          labelText: getTranslated('enter_mobile_number', context),
                          controller: _phoneController,
                          focusNode: _phoneFocus,
                          nextFocus: _passwordFocus,
                          required: true,
                          showCodePicker: true,
                          countryDialCode: authProvider.countryDialCode,
                          onCountryChanged: (CountryCode countryCode) {
                            _phoneFocus.requestFocus();
                            authProvider.countryDialCode = countryCode.dialCode!;
                            authProvider.setCountryCode(countryCode.dialCode!);
                          },
                          isAmount: true,
                          validator: (value)=> ValidateCheck.validateEmptyText(value, "phone_must_be_required"),
                          inputAction: TextInputAction.next,
                          inputType: TextInputType.phone)),




                      Container(margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault,
                          right: Dimensions.marginSizeDefault, top: Dimensions.marginSizeSmall),
                        child: CustomTextFieldWidget(
                          hintText: getTranslated('minimum_password_length', context),
                          labelText: getTranslated('password', context),
                          controller: _passwordController,
                          focusNode: _passwordFocus,
                          isPassword: true,required: true,
                          nextFocus: _confirmPasswordFocus,
                          inputAction: TextInputAction.next,
                          validator: (value)=> ValidateCheck.validatePassword(value, "password_must_be_required"),
                          prefixIcon: Images.pass)),



                      Hero(tag: 'user',
                        child: Container(margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault,
                            right: Dimensions.marginSizeDefault, top: Dimensions.marginSizeSmall),
                          child: CustomTextFieldWidget(
                            isPassword: true,required: true,
                            hintText: getTranslated('re_enter_password', context),
                            labelText: getTranslated('re_enter_password', context),
                            controller: _confirmPasswordController,
                            focusNode: _confirmPasswordFocus,
                            inputAction: TextInputAction.done,
                              validator: (value)=> ValidateCheck.validateConfirmPassword(value, _passwordController.text.trim()),
                              prefixIcon: Images.pass))),

                    SizedBox(height: 8,),

                    //tradeLicense
                    Container(
                      margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault,
                          right: Dimensions.marginSizeDefault, top: Dimensions.marginSizeSmall),
                         height: 50,

                      child: TextField(
                        controller:  _tradeLicenseController,
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFBFBFBF),
                                width:  .75,)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor,//widget.borderColor,
                                width: .75,)),

                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFBFBFBF),
                                width: .75,)),
                          filled: true,
                          prefixIcon: Icon(Icons.add_business_rounded,color:  Theme.of(context).primaryColor.withOpacity(.6),),
                          //fillColor: Colors.white,
                          focusColor: Colors.white,
                          labelStyle : textRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context).hintColor),

                          label: Text.rich(TextSpan(children: [
                            TextSpan(text: 'Email your TradeLicense', style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor.withOpacity(.75))),
                              TextSpan(text : ' *', style: textRegular.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeLarge))
                          ])),
                          // focusedBorder: OutlineInputBorder(
                          //   borderSide: const BorderSide(color: Colors.white, width: 2.0),
                          //   borderRadius: BorderRadius.circular(30),
                          // ),
                          // border: OutlineInputBorder(
                          //   borderSide: const BorderSide(color: Colors.white, width: 2.0),
                          //   borderRadius: BorderRadius.circular(30),
                          // ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: const BorderSide(color: Colors.white, width: 2.0),
                          //   borderRadius: BorderRadius.circular(30),
                          // ),
                          hintText: 'Email your TradeLicense',
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                      ),

                      ),

                    SizedBox(height: 8,),

                    //tradeLicense
                    Container(
                      margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault,
                          right: Dimensions.marginSizeDefault, top: Dimensions.marginSizeSmall),
                      height: 50,

                      child: TextField(
                        controller:  _foodLicenseController,
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFBFBFBF),
                                width:  .75,)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor,//widget.borderColor,
                                width: .75,)),

                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFBFBFBF),
                                width: .75,)),
                          filled: true,
                          prefixIcon: Icon(Icons.library_books_rounded,color:  Theme.of(context).primaryColor.withOpacity(.6),),
                          //fillColor: Colors.white,
                          focusColor: Colors.white,
                          labelStyle : textRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context).hintColor),

                          label: Text.rich(TextSpan(children: [
                            TextSpan(text: 'Email your FoodLicense', style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor.withOpacity(.75))),
                            TextSpan(text : ' *', style: textRegular.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeLarge))
                          ])),
                          // focusedBorder: OutlineInputBorder(
                          //   borderSide: const BorderSide(color: Colors.white, width: 2.0),
                          //   borderRadius: BorderRadius.circular(30),
                          // ),
                          // border: OutlineInputBorder(
                          //   borderSide: const BorderSide(color: Colors.white, width: 2.0),
                          //   borderRadius: BorderRadius.circular(30),
                          // ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: const BorderSide(color: Colors.white, width: 2.0),
                          //   borderRadius: BorderRadius.circular(30),
                          // ),
                          hintText: 'Email your FoodLicense',
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                      ),

                    ),

                    SizedBox(height: 8,),

                    //tradeLicense
                    Container(
                      margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault,
                          right: Dimensions.marginSizeDefault, top: Dimensions.marginSizeSmall),
                      height: 50,

                      child: TextField(
                        controller:  _GSTNumberController,
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).cardColor,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFBFBFBF),
                                width:  .75,)),
                          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Theme.of(context).primaryColor,//widget.borderColor,
                                width: .75,)),

                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Color(0xFFBFBFBF),
                                width: .75,)),
                          filled: true,
                          prefixIcon: Icon(Icons.text_snippet_sharp,color:  Theme.of(context).primaryColor.withOpacity(.6),),
                          //fillColor: Colors.white,
                          focusColor: Colors.white,
                          labelStyle : textRegular.copyWith(
                              fontSize: Dimensions.fontSizeDefault,
                              color: Theme.of(context).hintColor),

                          label: Text.rich(TextSpan(children: [
                            TextSpan(text: 'Email your GSTNumber', style: textRegular.copyWith(fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor.withOpacity(.75))),
                            TextSpan(text : ' *', style: textRegular.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeLarge))
                          ])),
                          // focusedBorder: OutlineInputBorder(
                          //   borderSide: const BorderSide(color: Colors.white, width: 2.0),
                          //   borderRadius: BorderRadius.circular(30),
                          // ),
                          // border: OutlineInputBorder(
                          //   borderSide: const BorderSide(color: Colors.white, width: 2.0),
                          //   borderRadius: BorderRadius.circular(30),
                          // ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: const BorderSide(color: Colors.white, width: 2.0),
                          //   borderRadius: BorderRadius.circular(30),
                          // ),
                          hintText: 'Email your GSTNumber',
                          hintStyle: const TextStyle(color: Colors.grey),
                        ),
                      ),

                    ),

                    SizedBox(height: 8,),

                    Text('Upload your bill'),
                    // Image display section
                    if (_pickedImage != null)
                GestureDetector(
                  onTap: pickImage,
                  child: Container(
                    margin: const EdgeInsets.all(Dimensions.marginSizeDefault),
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: FileImage(_pickedImage!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
                else
                GestureDetector(
                onTap: pickImage,
                child: Container(
                margin: const EdgeInsets.all(Dimensions.marginSizeDefault),
                width: MediaQuery.of(context).size.width,
                height: 200,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
                ),
                child: Icon(Icons.text_snippet_rounded, size: 32, color: Colors.grey[400]),
                ),),


                // Button to pick image
                    // ElevatedButton.icon(
                    //   onPressed: _pickImage,
                    //   icon: const Icon(Icons.image),
                    //   label: const Text('Pick Image'),
                    // ),


                      if(splashProvider.configModel!.refEarningStatus != null && splashProvider.configModel!.refEarningStatus == "1")
                      Padding(padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault, left: Dimensions.paddingSizeDefault),
                        child: Row(children: [Text(getTranslated('refer_code', context)??'')])),
                      if(splashProvider.configModel!.refEarningStatus != null && splashProvider.configModel!.refEarningStatus == "1")
                      Container(margin: const EdgeInsets.only(left: Dimensions.marginSizeDefault,
                          right: Dimensions.marginSizeDefault, top: Dimensions.marginSizeSmall),
                        child: CustomTextFieldWidget(
                          hintText: getTranslated('enter_refer_code', context),
                          labelText: getTranslated('enter_refer_code', context),
                          controller: _referController,
                          focusNode: _referFocus,
                          inputAction: TextInputAction.done)),

                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    const ConditionCheckBox(),

                    Container(margin: const EdgeInsets.all(Dimensions.marginSizeLarge), child: Hero(
                      tag: 'onTap',
                        child: CustomButton(
                          isLoading: authProvider.isLoading,
                          onTap: authProvider.isAcceptTerms ? () async {
                            String firstName = _firstNameController.text.trim();
                            String lastName = _lastNameController.text.trim();
                            String email = _emailController.text.trim();
                            String phoneNumber = authProvider.countryDialCode + _phoneController.text.trim();
                            String password = _passwordController.text.trim();

                            if (signUpFormKey.currentState?.validate() ?? false) {
                              if (billImage == null) {
                                showCustomSnackBar('Bill image is required', context);
                                return;
                              }

                              register.fName = firstName;
                              register.lName = lastName;
                              register.email = email;
                              register.phone = phoneNumber;
                              register.password = password;
                              register.referCode = _referController.text.trim();
                              register.billImage = billImage;
                              register.tradeLicense=_tradeLicenseController.text.trim();
                              register.foodLicense=_foodLicenseController.text.trim();
                              register.GSTNumber=_GSTNumberController.text.trim();

                              authProvider.registration(register, billImage!, route);
                            }
                          } : null,
                          buttonText: getTranslated('sign_up', context),
                        ),


                    )),


                    authProvider.isLoading ? const SizedBox() :
                    Center(child: Padding(padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraLarge),
                      child: InkWell(onTap: () {authProvider.getGuestIdUrl();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashBoardScreen()));},
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center, children: [
                            Text(getTranslated('skip_for_now', context)!,
                              style: titilliumRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                                  color: ColorResources.getPrimary(context))),
                            Icon(Icons.arrow_forward, size: 15,color: Theme.of(context).primaryColor,)
                          ],
                        ),
                      ),
                    )),
                    ],
                  ),
                );
              }
            );
          }
        ),
      ],
    );
  }
}
