import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/globals.dart';
import 'package:store_app/layers/presentation/auth/notifier/auth_notifier.dart';
import 'package:store_app/layers/presentation/main/page/main_page.dart';
import 'package:toast/toast.dart';

import '../../store_app_button.dart';
import '../../store_app_text_field.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var appBarHeight = _buildAppBar().preferredSize.height;

    return Scaffold(
      appBar: _buildAppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Container(
                  height: App.getHeight(context) - appBarHeight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Image.asset(
                        "assets/images/icon_black.png",
                        height: 120,
                      ),
                      SizedBox(height: 20),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: StoreAppTextField(
                          controller: _nameController,
                          maxLines: 1,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Name could not be empty";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          hintText: "Name",
                        ),
                      ),
                      SizedBox(height: 8),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: StoreAppTextField(
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
                        ),
                      ),
                      SizedBox(height: 8),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: StoreAppTextField(
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
                          obscureText: true,
                        ),
                      ),
                      SizedBox(height: 8),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: StoreAppTextField(
                          controller: _confirmPasswordController,
                          maxLines: 1,
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Password confirmation could not be empty";
                            }
                            if (value != _passwordController.text) {
                              return "Password confirmation is wrong";
                            }
                            return null;
                          },
                          keyboardType: TextInputType.text,
                          hintText: "Confirm password",
                          obscureText: true,
                        ),
                      ),
                      SizedBox(height: 20),

                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 12),
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          child: StoreAppButton(
                            text: "Register",
                            onPressed: () {
                              context.read<AuthNotifier>().register(
                                name: _nameController.text,
                                email: _emailController.text,
                                password: _passwordController.text
                              ).then((status) {
                                if (status != null) {
                                  Navigator.pop(context);
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => MainPage())
                                  );
                                }

                                else {
                                  Toast.show(
                                    "Failed to register",
                                    context,
                                    duration: Toast.LENGTH_LONG,
                                    gravity: Toast.BOTTOM,
                                    backgroundColor: Colors.red
                                  );
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        "Register"
      ),
    );
  }
}
