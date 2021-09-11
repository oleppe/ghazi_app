// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  CachedImage({
    Key? key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.height,
    this.width,
    this.placeholder,
    this.errorWidget,
  }) : super(key: key);

  final String imageUrl;
  final BoxFit fit;
  final double? height;
  final double? width;
  final Widget? placeholder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
