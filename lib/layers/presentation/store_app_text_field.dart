import 'package:flutter/material.dart';

class StoreAppTextField extends StatelessWidget {
  final TextEditingController controller;
  final int maxLines;
  final String hintText;
  final String labelText;
  final TextInputType keyboardType;
  final Function(String) validator;
  final bool obscureText;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final EdgeInsets contentPadding;
  final Color fillColor;
  final TextStyle style;
  final InputBorder border;
  final InputBorder enabledBorder;
  final InputBorder focusedBorder;
  final Function(String) onChanged;

  const StoreAppTextField({Key key, this.controller, this.hintText, this.keyboardType, this.validator, this.maxLines, this.obscureText, this.prefixIcon, this.suffixIcon, this.onChanged, this.contentPadding, this.fillColor, this.style, this.border, this.enabledBorder, this.focusedBorder, this.labelText}) : super(key: key);

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
      style: style,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
        ),
        enabledBorder: enabledBorder ?? OutlineInputBorder(
          borderRadius: BorderRadius.circular(32),
          borderSide: BorderSide(
            color: Colors.grey[400],
          )
        ),
        focusedBorder: focusedBorder,
        hintStyle: TextStyle(
          color: Colors.grey[400]
        ),
        filled: fillColor != null,
        fillColor: fillColor,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        contentPadding: contentPadding ?? EdgeInsets.all(12.0),
        hintText: hintText,
        labelText: labelText,
        isDense: true,
      ),
    );
  }
}
