import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class GlobalOutlineEditText extends StatefulWidget {
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double prefixIconSize;
  final double suffixIconSize;
  final bool editable;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged; // ✅ Add this line



  const GlobalOutlineEditText({
    super.key,
    required this.hintText,
    this.controller,
    this.editable = true,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.prefixIconSize = 10.0,
    this.suffixIconSize = 20.0,
    this.onTap,
    this.onChanged,
  });

  @override
  State<GlobalOutlineEditText> createState() => _GlobalOutlineEditTextState();
}

class _GlobalOutlineEditTextState extends State<GlobalOutlineEditText> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.editable ? null : widget.onTap,
      child: AbsorbPointer(
        absorbing: !widget.editable, // disables interaction if not editable
        child: TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: _obscureText,
          readOnly: !widget.editable,
          onChanged: widget.onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.backgroundGray01,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.borderGray01),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            errorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            focusedErrorBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red, width: 2),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            hintText: widget.hintText,
            hintMaxLines: 1,
            hintStyle: TextStyle(
              fontSize: 14,
              color: AppColors.hintGray,
              fontWeight: FontWeight.w400,
            ),
            prefixIcon: widget.prefixIcon != null
                ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: widget.prefixIconSize,
                width: widget.prefixIconSize,
                child: widget.prefixIcon,
              ),
            )
                : null,
            suffixIcon: widget.keyboardType == TextInputType.visiblePassword && widget.editable
                ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                size: widget.suffixIconSize,
                color: AppColors.iconGray01,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )
                : widget.suffixIcon != null
                ? Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: widget.suffixIconSize,
                width: widget.suffixIconSize,
                child: widget.suffixIcon,
              ),
            )
                : null,
          ),
          validator: widget.validator,
          onTap: widget.editable ? widget.onTap : null,
        ),
      ),
    );
  }
}
