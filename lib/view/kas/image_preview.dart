import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ImagePreviewPage extends StatelessWidget {
  // Parameter URL diterima melalui Get.arguments
  final String? imageUrl;

  ImagePreviewPage({super.key}) : imageUrl = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Nota'),
      ),
      body: Center(
        child: imageUrl != null
            ? CachedNetworkImage(
                imageUrl: imageUrl ?? '',
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              )
            : const Text('Gambar Tidak temukan'),
      ),
    );
  }
}
