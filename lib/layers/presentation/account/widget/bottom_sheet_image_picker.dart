import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/config/constants.dart';
import 'package:store_app/core/config/globals.dart';
import 'package:store_app/layers/presentation/account/notifier/profile_notifier.dart';

class BottomSheetImagePicker extends StatefulWidget {
  final ImagePicker picker;

  const BottomSheetImagePicker({Key key, this.picker}) : super(key: key);

  @override
  _BottomSheetImagePickerState createState() => _BottomSheetImagePickerState();
}

class _BottomSheetImagePickerState extends State<BottomSheetImagePicker> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }

  Future _getImage({ImageSource source}) async {
    final pickedFile = await widget.picker.getImage(source: source);
    if (pickedFile != null) {
      File picked = File(pickedFile.path);
      context.read<ProfileNotifier>().setImage(picked);
    }
  }
}
