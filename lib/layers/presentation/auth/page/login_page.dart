import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/core/config/globals.dart';
import 'package:store_app/layers/presentation/auth/notifier/login_notifier.dart';
import 'package:store_app/layers/presentation/auth/page/register_page.dart';
import 'package:store_app/layers/presentation/main/page/main_page.dart';
import 'package:store_app/layers/presentation/kit_store_button.dart';
import 'package:store_app/layers/presentation/kit_store_text_field.dart';
import 'package:toast/toast.dart';

import '../../kit_store_loading_dialog.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  KitStoreLoadingDialog loadingDialog;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<LoginNotifier>().reset();
    });

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    loadingDialog = KitStoreLoadingDialog(context: context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isHidePassword = context.select((LoginNotifier n) => n.isHidePassword);

    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        },
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Container(
              height: App.getHeight(context),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Image.asset(
                      "assets/images/logo_long_color.png",
                      height: 120,
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: KitStoreTextField(
                      controller: _emailController,
                      maxLines: 1,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Email could not be empty";
                        }
                        if (!EmailValidator.validate(value)) {
                          return "Wrong email format";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      hintText: "Email",
                      labelText: "Email",
                    ),
                  ),
                  SizedBox(height: 12),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: KitStoreTextField(
                      controller: _passwordController,
                      maxLines: 1,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Password could not be empty";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      hintText: "Password",
                      labelText: "Password",
                      suffixIcon: IconButton(
                        splashRadius: 16,
                        icon: Icon(
                          isHidePassword ? Icons.visibility : Icons.visibility_off,
                          size: 20,
                          color: isHidePassword ? Colors.grey : colorPrimary,
                        ),
                        onPressed: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();

                          context.read<LoginNotifier>().setHidePassword(!isHidePassword);
                        },
                      ),
                      obscureText: isHidePassword,
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: KitStoreButton(
                        text: "Login",
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
                            loadingDialog.showLoading();

                            context.read<LoginNotifier>().login(
                              email: _emailController.text,
                              password: _passwordController.text
                            ).then((user) {
                              if (user != null) {
                                Navigator.pop(context);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => MainPage(
                                    isDialog: true,
                                  ))
                                );
                              }

                              else {
                                Toast.show(
                                  "Failed to login",
                                  context,
                                  duration: Toast.LENGTH_LONG,
                                  gravity: Toast.BOTTOM,
                                  backgroundRadius: 32,
                                  backgroundColor: Colors.red
                                );
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 12),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Don't have account?"),
                        SizedBox(width: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => RegisterPage())
                            );
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorPrimary
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}