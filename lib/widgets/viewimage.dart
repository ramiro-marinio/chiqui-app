import 'package:flutter/material.dart';

class ViewImage extends StatelessWidget {
  final String? imageUrl;
  final String tag;
  const ViewImage({super.key, required this.imageUrl, required this.tag});

  @override
  Widget build(BuildContext context) {
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
      body: Dismissible(
        key: UniqueKey(),
        movementDuration: const Duration(seconds: 1),
        resizeDuration: const Duration(milliseconds: 50),
        onDismissed: (_) => Navigator.pop(context),
        direction: DismissDirection.down,
        background: Container(),
        child: InteractiveViewer(
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
                          : const AssetImage('assets/no_image.jpg')
                              as ImageProvider,
                    ),
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
