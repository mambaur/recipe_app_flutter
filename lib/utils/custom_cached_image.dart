import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomCachedImage {
  static Widget build(BuildContext context,
      {String? imgUrl, BorderRadiusGeometry? borderRadius, BoxFit? fit}) {
    return CachedNetworkImage(
      imageUrl: imgUrl ??
          'https://i.pinimg.com/236x/4f/5d/23/4f5d23170a65869ff7c210342516ad2c.jpg',
      fit: BoxFit.cover,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: borderRadius ?? BorderRadius.circular(0),
          image: DecorationImage(
            image: imageProvider,
            fit: fit ?? BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey.shade300,
          highlightColor: Colors.grey.shade100,
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: borderRadius ?? BorderRadius.circular(0)),
              width: double.infinity,
              height: double.infinity,
              child: Container()
              // child: const Icon(Icons.image, size: 70)

              )),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey.shade100,
        width: double.infinity,
        height: double.infinity,
        child: Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade100,
            child: Container()
            // child: const Icon(Icons.image, size: 70)
            ),
      ),
    );
  }
}
