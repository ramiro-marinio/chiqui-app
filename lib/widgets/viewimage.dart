import 'package:flutter/material.dart';

class ViewImage extends StatelessWidget {
  final String? imageUrl;
  final String tag;
  final bool gymImage;
  const ViewImage(
      {super.key,
      required this.imageUrl,
      required this.tag,
      required this.gymImage});

  @override
  Widget build(BuildContext context) {
    TransformationController transformationController =
        TransformationController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black,
      body: InteractiveViewer(
        onInteractionEnd: (details) {},
        transformationController: transformationController,
        maxScale: 5,
        child: Center(
          child: Hero(
            tag: tag,
            transitionOnUserGestures: true,
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: FractionalOffset.center,
                    image: imageUrl != null
                        ? NetworkImage(
                            imageUrl!,
                          )
                        : AssetImage(gymImage
                            ? 'assets/no_image_gym.jpg'
                            : 'assets/no_image.jpg') as ImageProvider,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
