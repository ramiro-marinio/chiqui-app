// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class VideoPickField extends StatefulWidget {
//   final Function(String? path) chooseVideo;
//   const VideoPickField({super.key, required this.chooseVideo});

//   @override
//   State<VideoPickField> createState() => _VideoPickFieldState();
// }

// class _VideoPickFieldState extends State<VideoPickField> {
//   // String? videoPath;

//   @override
//   Widget build(BuildContext context) {
//     // final controller = VideoPlayerController.file(File(videoPath!));
//     return Column(
//       children: [
//         const Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.video_call),
//             Text(
//               "Demonstration Video",
//               style: TextStyle(fontSize: 20),
//             ),
//           ],
//         ),
//         ElevatedButton(
//           onPressed: () async {
//             // ImagePicker imagePicker = ImagePicker();
//             // ImageSource? imageSource;
//             await showDialog(
//               context: context,
//               builder: (context) => AlertDialog(
//                 title: const Text('Pick a Source'),
//                 actions: [
//                   TextButton(
//                       onPressed: () {
//                         // imageSource = ImageSource.camera;
//                       },
//                       child: const Text('Camera')),
//                   TextButton(
//                     onPressed: () {
//                       // imageSource = ImageSource.gallery;
//                     },
//                     child: const Text('Gallery'),
//                   )
//                 ],
//               ),
//             );
//             // if (imageSource == null) {
//               return;
//             }
//             // XFile? xfile = await imagePicker.pickVideo(source: imageSource!);
//             // videoPath = xfile?.path;
//             // widget.chooseVideo(videoPath);
//           },
//           child: const Text("Pick a Video"),
//         )
//       ],
//     );
//   }
// }
