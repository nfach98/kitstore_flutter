import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/core/config/globals.dart';
import 'package:store_app/layers/domain/entities/user.dart';
import 'package:store_app/layers/presentation/account/notifier/security_notifier.dart';
import 'package:store_app/layers/presentation/main/notifier/account_notifier.dart';

import '../../store_app_button.dart';
import '../../store_app_text_field.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({Key key}) : super(key: key);

  @override
  _SecurityPageState createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  TextEditingController _passwordController;
  TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<SecurityNotifier>().reset();
      context.read<SecurityNotifier>().getLoggedInUser();
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((SecurityNotifier n) => n.user);

    return WillPopScope(
      onWillPop: () async {
        if (_passwordController.text.isNotEmpty) {
          _showDialogUnsaved();
        }

        return _passwordController.text.isEmpty;
      },
      child: Scaffold(
        appBar: _buildAppBar(),
        body: GestureDetector(
          onTap: () {
            FocusScopeNode currentFocus = FocusScope.of(context);
            if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
          },
          child: Container(
            height: App.getHeight(context),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    width: App.getWidth(context),
                    padding: EdgeInsets.all(12),
                    child: Column(
                      children: [
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
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            hintText: "New password",
                            labelText: "New password",
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
                              if (!EmailValidator.validate(value)) {
                                return "Confirm password email format";
                              }
                              return null;
                            },
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            hintText: "Confirm new password",
                            labelText: "Confirm new password",
                          ),
                        ),
                        SizedBox(height: 64),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildButtonSave(user: user),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        "Security"
      ),
    );
  }

  Widget _buildButtonSave({User user}) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: StoreAppButton(
        text: "Save changes",
        color: _passwordController.text.isEmpty && _confirmPasswordController.text.isEmpty
          ? Colors.grey : colorPrimary,
        icon: Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(
            Icons.save,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          context.read<SecurityNotifier>().updateUser(
            password: _passwordController.text
          ).then((status) {
            if (status != null) {
              context.read<AccountNotifier>().reset();
              context.read<AccountNotifier>().getLoggedInUser();
              Navigator.pop(context);
            }
          });
        },
      ),
    );
  }

  _showDialogUnsaved() {
    showDialog(
        context: context,
        builder: (_) => Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: EdgeInsets.only(left: 20, top: 32, right: 20), // spacing inside the box
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "You have unsaved changes",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline5,
                ),
                SizedBox(height: 16),
                Text(
                  "Are you sure you want to leave this page? Your changes would not be saved",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                SizedBox(height: 24),

                ButtonBar(
                  buttonMinWidth: 100,
                  alignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.grey
                        ),
                      ),
                      onPressed: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Leave",
                        style: TextStyle(
                            color: Colors.red
                        ),
                      ),
                      onPressed: () {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }
}