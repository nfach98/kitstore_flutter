import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/core/config/globals.dart';
import 'package:store_app/layers/domain/entities/user.dart';
import 'package:store_app/layers/presentation/account/notifier/edit_notifier.dart';
import 'package:store_app/layers/presentation/main/notifier/account_notifier.dart';

import '../../store_app_button.dart';
import '../../store_app_text_field.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      context.read<EditNotifier>().reset();
      context.read<EditNotifier>().getLoggedInUser().then((user) {
        if (user != null) {
          _nameController.text = user.name;
          _emailController.text = user.email;
        }
      });
    });
  }


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((EditNotifier n) => n.user);
    final image = context.select((EditNotifier n) => n.image);

    return WillPopScope(
      onWillPop: () async {
        if (_nameController.text != user.name || _emailController.text != user.email || image != null) {
          _showDialogUnsaved();
        }

        return _nameController.text == user.name && _emailController.text == user.email && image == null;
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
                        Stack(
                          children: [
                            Container(
                              height: App.getWidth(context) * .5,
                              child: AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(500)),
                                  child: image == null
                                  ? Image.asset(
                                    user == null || user.avatar == null
                                      ? "assets/images/no_image.png"
                                      : user.avatar,
                                    fit: BoxFit.cover,
                                  )
                                  : Image.file(
                                    image,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              ),
                            ),
                            Positioned(
                              right: 8,
                              bottom: 8,
                              child: InkWell(
                                onTap: () {
                                  _showPicker();
                                },
                                borderRadius: BorderRadius.circular(100),
                                child: Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      color: colorPrimary
                                  ),
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              )
                            )
                          ],
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
        "About"
      ),
    );
  }

  Widget _buildButtonSave({User user}) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: StoreAppButton(
        text: "Save changes",
        icon: Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(
            Icons.save,
            color: Colors.white,
          ),
        ),
        onPressed: () {
          context.read<EditNotifier>().updateUser(
            id: user.id.toString(),
            name: _nameController.text,
            email: _emailController.text,
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

  _showPicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Container(
            child: Wrap(
              children: [
                ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Gallery'),
                  onTap: () {
                    _getImage(source: ImageSource.gallery);
                    Navigator.pop(context);
                  }
                ),
                ListTile(
                  leading: Icon(Icons.photo_camera),
                  title: Text('Camera'),
                  onTap: () {
                    _getImage(source: ImageSource.camera);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      }
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

  Future _getImage({ImageSource source}) async {
    final pickedFile = await _picker.getImage(source: source);
    if (pickedFile != null) {
      File picked = File(pickedFile.path);
      setState(() {
        context.read<EditNotifier>().setImage(picked);
      });
    }
  }
}