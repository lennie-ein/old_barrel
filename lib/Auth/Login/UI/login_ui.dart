import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:old_barrel/Assets/assets.dart';
import 'package:old_barrel/Components/custom_button.dart';
import 'package:old_barrel/Components/entry_field.dart';
import 'package:old_barrel/Locale/locale.dart';

import 'login_interactor.dart';

class LoginUI extends StatefulWidget {
  final LoginInteractor loginInteractor;

  LoginUI(this.loginInteractor);

  @override
  _LoginUIState createState() => _LoginUIState();
}

class _LoginUIState extends State<LoginUI> {
  final TextEditingController _numberController = TextEditingController();

  @override
  void dispose() {
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      body: FadedSlideAnimation(
        SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 40,
                    ),
                    Image.asset(
                      Assets.logo,
                      height: 130,
                    ),
                    Image.asset(
                      Assets.signIn,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 320,
                    // margin: EdgeInsets.only(top: 390),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Spacer(),
                        Text(
                          locale.signInNow!,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyText2!.copyWith(
                                    color: Theme.of(context).hintColor,
                                    fontSize: 18,
                                  ),
                        ),
                        Spacer(),
                        EntryField(
                          label: locale.phoneNumber,
                          hint: locale.enterPhoneNumber,
                        ),
                        Spacer(),
                        CustomButton(
                          onTap: () {
                            widget.loginInteractor
                                .loginWithPhone('isoCode', 'mobileNumber');
                          },
                        ),
                        Spacer(),
                        Text(
                          locale.orContinueWith!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Theme.of(context).hintColor),
                        ),
                        Spacer(),
                        Container(
                          height: 60,
                          padding: EdgeInsets.only(bottom: 10, top: 10),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                  child: socialButton(
                                      Assets.fbIcon, locale.facebook!)),
                              Container(
                                width: 1,
                                height: 20,
                                color: Theme.of(context).backgroundColor,
                              ),
                              Expanded(
                                  child: socialButton(
                                      Assets.googleIcon, locale.google!))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }

  TextButton socialButton(String icon, String text) {
    return TextButton.icon(
      icon: ImageIcon(
        AssetImage(icon),
        color: Theme.of(context).backgroundColor,
        size: 20,
      ),
      onPressed: () {},
      label: Text(text, style: Theme.of(context).textTheme.bodyText1),
    );
  }
}
