import 'package:flutter/material.dart';
import 'package:flutter_sixvalley_ecommerce/features/dashboard/screens/dashboard_screen.dart';
import 'package:flutter_sixvalley_ecommerce/localization/controllers/localization_controller.dart';
import 'package:flutter_sixvalley_ecommerce/localization/language_constrants.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/controllers/auth_controller.dart';
import 'package:flutter_sixvalley_ecommerce/utill/custom_themes.dart';
import 'package:flutter_sixvalley_ecommerce/utill/dimensions.dart';
import 'package:flutter_sixvalley_ecommerce/utill/images.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/widgets/sign_in_widget.dart';
import 'package:flutter_sixvalley_ecommerce/features/auth/widgets/sign_up_widget.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  final bool fromLogout;
  const AuthScreen({super.key, this.fromLogout = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    Provider.of<AuthController>(context, listen: false).updateSelectedIndex(0, notify: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthController>(
        builder: (context, authProvider, _) {
          return Column(
            children: [
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 56),
                    child: Center(
                      child: Image.asset(
                        authProvider.selectedIndex == 0
                            ? 'assets/images/Login.gif'
                            : 'assets/images/Signup.gif', // Replace with the actual path to your signup image
                        fit: BoxFit.cover,
                        height: MediaQuery.of(context).size.height * 0.4,
                      ),
                    ),
                  ),
                  Positioned(
                    top: Dimensions.paddingSizeThirtyFive,
                    left: Provider.of<LocalizationController>(context, listen: false).isLtr
                        ? Dimensions.paddingSizeLarge
                        : null,
                    right: Provider.of<LocalizationController>(context, listen: false).isLtr
                        ? null
                        : Dimensions.paddingSizeLarge,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios, size: 30, color: Colors.white),
                      onPressed: () {
                        if (widget.fromLogout) {
                          Navigator.pushAndRemoveUntil(
                              context, MaterialPageRoute(builder: (_) => const DashBoardScreen()), (route) => false);
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ),
                ],
              ),
              AnimatedContainer(
                transform: Matrix4.translationValues(0, -20, 0),
                curve: Curves.fastOutSlowIn,
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge)),
                ),
                duration: const Duration(seconds: 2),
                child: Padding(
                  padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.marginSizeLarge),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => authProvider.updateSelectedIndex(0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getTranslated('login', context)!,
                                    style: authProvider.selectedIndex == 0
                                        ? textRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge)
                                        : textRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                                  ),
                                  Container(
                                    height: 3,
                                    width: 25,
                                    margin: const EdgeInsets.only(top: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                      color: authProvider.selectedIndex == 0 ? Theme.of(context).primaryColor : Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: Dimensions.paddingSizeExtraLarge),
                            InkWell(
                              onTap: () => authProvider.updateSelectedIndex(1),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getTranslated('sign_up', context)!,
                                    style: authProvider.selectedIndex == 1
                                        ? titleRegular.copyWith(color: Theme.of(context).primaryColor, fontSize: Dimensions.fontSizeLarge)
                                        : titleRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
                                  ),
                                  Container(
                                    height: 3,
                                    width: 25,
                                    margin: const EdgeInsets.only(top: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                                      color: authProvider.selectedIndex == 1 ? Theme.of(context).primaryColor : Colors.transparent,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: authProvider.selectedIndex == 0 ? const SignInWidget() : const SignUpWidget(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
