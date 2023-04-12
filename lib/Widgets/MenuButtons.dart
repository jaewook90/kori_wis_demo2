import 'package:flutter/material.dart';

class MenuButtons extends StatefulWidget {
  const MenuButtons({
    Key? key,
    this.buttonText,
    this.buttonFont,
    required this.assetsBool,
    this.iconAsset,
    this.appIcon,
    this.buttonIconSize,
    this.buttonWidth,
    this.buttonHeight,
    this.buttonColor,
    this.onPressed,
  }) : super(key: key);

  final String? buttonText;
  final TextStyle? buttonFont;
  final bool assetsBool;
  final String? iconAsset;
  final IconData? appIcon;
  final double? buttonIconSize;
  final double? buttonWidth;
  final double? buttonHeight;
  final Color? buttonColor;
  final VoidCallback? onPressed;

  @override
  State<MenuButtons> createState() => _MenuButtonsState();
}

class _MenuButtonsState extends State<MenuButtons> {

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed:widget.onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: widget.buttonWidth! * 0.035,
            ),
            SizedBox(
              width: widget.buttonWidth! * 0.33,
              child: widget.assetsBool==true ? ImageIcon(
                AssetImage(widget.iconAsset!),
                size: widget.buttonIconSize,
                color: Color(0xffB7B7B7),
              )
                  :Icon(
                widget.appIcon,
                color: Color(0xffB7B7B7),
                size: widget.buttonIconSize,
              ),
            ),
            Text(
              widget.buttonText!,
              style: widget.buttonFont,
            ),
          ],
        ),
        style: TextButton.styleFrom(
            backgroundColor: widget.buttonColor,
            // backgroundColor: Color(0xFF2D2D2D),
            fixedSize: Size(widget.buttonWidth!, widget.buttonHeight!),
            shape: RoundedRectangleBorder(
              // side: BorderSide(
              //     color: Color(0xFFB7B7B7),
              //     style: BorderStyle.solid,
              //     width: 1),
                borderRadius: BorderRadius.circular(40))));
  }
}
