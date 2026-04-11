import 'package:flutter/material.dart';

/// An image widget that automatically resolves network URLs vs asset paths.
///
/// Pass any image path — if it starts with `http://` or `https://` it is
/// loaded from the network, otherwise it is treated as an asset.
class AdaptiveImage extends StatelessWidget {
  const AdaptiveImage({
    super.key,
    required this.path,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  final String path;
  final BoxFit fit;
  final double? width;
  final double? height;

  static bool isNetwork(String path) =>
      path.startsWith('http://') || path.startsWith('https://');

  static ImageProvider provider(String path) =>
      isNetwork(path) ? NetworkImage(path) : AssetImage(path);

  @override
  Widget build(BuildContext context) {
    return Image(
      image: provider(path),
      fit: fit,
      width: width,
      height: height,
    );
  }
}
