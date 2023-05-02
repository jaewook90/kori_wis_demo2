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
        style: TextButton.styleFrom(
            backgroundColor: widget.buttonColor,
            fixedSize: Size(widget.buttonWidth!, widget.buttonHeight!),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40))),
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
                color: const Color(0xffB7B7B7),
              )
                  :Icon(
                widget.appIcon,
                color: const Color(0xffB7B7B7),
                size: widget.buttonIconSize,
              ),
            ),
            Text(
              widget.buttonText!,
              style: widget.buttonFont,
            ),
          ],
        ));
  }
}
