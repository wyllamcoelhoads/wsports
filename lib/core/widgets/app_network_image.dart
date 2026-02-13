import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double size;

  const AppNetworkImage({super.key, required this.imageUrl, this.size = 50});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: size,
      height: size,
      placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
      errorWidget: (context, url, error) => const Icon(Icons.person, color: Colors.grey),
    );
  }
}