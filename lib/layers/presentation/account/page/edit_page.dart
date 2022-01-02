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
import 'package:toast/toast.dart';

import '../../kit_store_button.dart';
import '../../kit_store_loading_dialog.dart';
import '../../kit_store_text_field.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key key}) : super(key: key);

  @override
  _EditPageState createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  ImagePicker _picker = ImagePicker();
  KitStoreLoadingDialog loadingDialog;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    loadingDialog = KitStoreLoadingDialog(context: context);

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

        return user == null || (user != null && _nameController.text == user.name && _emailController.text == user.email && image == null);
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
                        _buildImage(
                          user: user,
                          image: image
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
                        SizedBox(height: 8),

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
                        SizedBox(height: 64),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildButtonSave(
                    user: user,
                    image: image
                  ),
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
        "Profile"
      ),
    );
  }

  Widget _buildImage({File image, User user}) {
    return Stack(
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
    );
  }

  Widget _buildButtonSave({User user, File image}) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: KitStoreButton(
        text: "Save changes",
        color: user == null || (user != null && _nameController.text == user.name && _emailController.text == user.email && image == null)
         ? Colors.grey : colorPrimary,
        icon: Padding(
          padding: EdgeInsets.only(right: 8),
          child: Icon(
            Icons.save,
            color: user == null || (user != null && _nameController.text == user.name && _emailController.text == user.email && image == null)
              ? Colors.white : colorAccent,
          ),
        ),
        onPressed: () {
          loadingDialog.showLoading();

          context.read<EditNotifier>().updateUser(
            name: _nameController.text,
            email: _emailController.text,
            oldAvatar: user.avatar
          ).then((status) {
            if (status != null) {
              context.read<AccountNotifier>().reset();
              context.read<AccountNotifier>().getLoggedInUser();
              Navigator.pop(context);
              Navigator.pop(context);
              Toast.show(
                "Profile is updated successfully",
                context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.BOTTOM,
                backgroundRadius: 32,
                textColor: colorPrimary,
                backgroundColor: colorAccent
              );
            }

            else {
              Navigator.pop(context);
              Toast.show(
                "Failed to update profile",
                context,
                duration: Toast.LENGTH_LONG,
                gravity: Toast.BOTTOM,
                backgroundRadius: 32,
                backgroundColor: Colors.red
              );
            }
          });
        },
      ),
    );
  }

  _showPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20)
                ),
              ),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(
                    children: [
                      Container(
                        height: 8,
                        alignment: Alignment.center,
                        width: App.getWidth(context) * .5,
                        decoration: BoxDecoration(
                          color: colorPrimary,
                          borderRadius: BorderRadius.circular(32)
                        ),
                      ),
                      SizedBox(height: 20),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Choose image from",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 20),

                          Wrap(
                            children: [
                              ListTile(
                                  leading: Icon(
                                    Icons.photo_library,
                                    color: colorPrimary,
                                  ),
                                  title: Text('Gallery'),
                                  onTap: () {
                                    _getImage(source: ImageSource.gallery);
                                    Navigator.pop(context);
                                  }
                              ),
                              ListTile(
                                leading: Icon(
                                  Icons.photo_camera,
                                  color: colorPrimary,
                                ),
                                title: Text('Camera'),
                                onTap: () {
                                  _getImage(source: ImageSource.camera);
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            )
          ],
        );
      },
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
      context.read<EditNotifier>().setImage(picked);
    }
  }
}