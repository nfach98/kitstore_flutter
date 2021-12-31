import 'package:flutter/material.dart';

class StoreAppTextField extends StatelessWidget {
  final TextEditingController controller;
  final int maxLines;
  final String hintText;
  final TextInputType keyboardType;
  final Function(String) validator;
  final bool obscureText;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final Function(String) onChanged;

  const StoreAppTextField({Key key, this.controller, this.hintText, this.keyboardType, this.validator, this.maxLines, this.obscureText, this.prefixIcon, this.suffixIcon, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      autofocus: false,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText ?? false,
      decoration: InputDecoration(
        // border: UnderlineInputBorder(
        //   borderSide: BorderSide(
        //     color: kPrimaryColor,
        //   ),
        // ),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: EdgeInsets.all(12.0),
        hintText: hintText,
        isDense: true,
      ),
    );
  }
}
