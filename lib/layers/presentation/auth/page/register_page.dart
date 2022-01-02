import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/core/config/globals.dart';
import 'package:store_app/layers/presentation/auth/notifier/register_notifier.dart';
import 'package:store_app/layers/presentation/main/page/main_page.dart';
import 'package:toast/toast.dart';

import '../../kit_store_button.dart';
import '../../kit_store_loading_dialog.dart';
import '../../kit_store_text_field.dart';

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
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  KitStoreLoadingDialog loadingDialog;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<RegisterNotifier>().reset();
    });

    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    loadingDialog = KitStoreLoadingDialog(context: context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appBarHeight = _buildAppBar().preferredSize.height;
    final isHidePassword = context.select((RegisterNotifier n) => n.isHidePassword);
    final isHideConfirmPassword = context.select((RegisterNotifier n) => n.isHideConfirmPassword);

    return Scaffold(
      appBar: _buildAppBar(),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        },
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Container(
              height: App.getHeight(context) - appBarHeight,
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
                      labelText: "Name",
                    ),
                  ),
                  SizedBox(height: 12),

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

                          context.read<RegisterNotifier>().setHidePassword(!isHidePassword);
                        },
                      ),
                      obscureText: isHidePassword,
                    ),
                  ),
                  SizedBox(height: 12),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: KitStoreTextField(
                      controller: _confirmPasswordController,
                      maxLines: 1,
                      validator: (value) {
                        if (value.isEmpty) {
                          return "Password confirmation could not be empty";
                        }
                        if (value != _passwordController.text) {
                          return "Password confirmation is not match";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      hintText: "Confirm password",
                      labelText: "Confirm password",
                      suffixIcon: IconButton(
                        splashRadius: 16,
                        icon: Icon(
                          isHideConfirmPassword ? Icons.visibility : Icons.visibility_off,
                          size: 20,
                          color: isHideConfirmPassword ? Colors.grey : colorPrimary,
                        ),
                        onPressed: () {
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();

                          context.read<RegisterNotifier>().setHideConfirmPassword(!isHideConfirmPassword);
                        },
                      ),
                      obscureText: isHideConfirmPassword,
                    ),
                  ),
                  SizedBox(height: 20),

                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: FractionallySizedBox(
                      widthFactor: 1,
                      child: KitStoreButton(
                        text: "Register",
                        onPressed: () {
                          if (formKey.currentState.validate()) {
                            FocusScopeNode currentFocus = FocusScope.of(context);
                            if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
                            loadingDialog.showLoading();

                            context.read<RegisterNotifier>().register(
                              name: _nameController.text,
                              email: _emailController.text,
                              password: _passwordController.text
                            ).then((status) {
                              if (status != null) {
                                Navigator.popUntil(context, (Route<dynamic> route) => route.isFirst);
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => MainPage(
                                    isDialog: true,
                                  ))
                                );
                              }

                              else {
                                Navigator.pop(context);
                                Toast.show(
                                  "Failed to register",
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
                ],
              ),
            ),
          ),
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
