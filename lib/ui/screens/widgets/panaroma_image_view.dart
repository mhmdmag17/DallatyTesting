import 'dart:io';

import 'package:ebroker/utils/Extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:panorama/panorama.dart';

class PanaromaImageScreen extends StatelessWidget {
  const PanaromaImageScreen({
    required this.imageUrl,
    super.key,
    this.isFileImage,
  });
  final String imageUrl;
  final bool? isFileImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: context.color.tertiaryColor),
      ),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Panorama(
          sensitivity: 2,
          latitude: 4,
          child: (isFileImage ?? false)
              ? Image.file(File(imageUrl))
              : Image.network(
                  imageUrl,
                ),
        ),
      ),
    );
  }
}
