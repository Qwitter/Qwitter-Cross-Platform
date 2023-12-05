import 'dart:math';

import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qwitter_flutter_app/providers/tweet_images_provider.dart';
import 'package:qwitter_flutter_app/providers/tweet_progress_provider.dart';
import 'package:qwitter_flutter_app/screens/tweets/add_tweet_circular_indicator.dart';
import 'dart:io';

class AddTweetActionBar extends ConsumerStatefulWidget {
  const AddTweetActionBar({super.key});

  @override
  ConsumerState<AddTweetActionBar> createState() => _AddTweetActionBarState();
}

class _AddTweetActionBarState extends ConsumerState<AddTweetActionBar> {
  int _selectedIndex = 0;
  final List<File> _images = [];
  final picker = ImagePicker();
  final List<File> _tweetImages = [];

  bool isVideoFile(File file) {
    // Define a list of video file extensions
    List<String> videoExtensions = ['.mp4', '.avi', '.mov', '.mkv', '.wmv'];

    // Get the file extension
    String extension = file.path.split('.').last.toLowerCase();
    print("Extension: $extension");
    // Check if the extension is in the list of video extensions
    return videoExtensions.contains('.$extension');
  }

//Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final List<XFile> images = await picker.pickMultiImage();
    if (_images.length + images.length > 4) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only upload 4 images at a time'),
        ),
      );
      return;
    }
    setState(() {
      for (int i = 0; i < images.length; i++) {
        _images.add(File(images[i].path));
        _tweetImages.add(File(images[i].path));
      }
      ref.read(tweetImagesProvider.notifier).setTweetImages(_tweetImages);
    });
  }

  Future getVideoFromGallery() async {
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
    if (_images.length + 1 > 4) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only upload 4 videos at a time'),
        ),
      );
      return;
    }
    setState(() {
      if (video != null) {
        _images.add(File(video.path));
        _tweetImages.add(File(video.path));
      }
      ref.read(tweetImagesProvider.notifier).setTweetImages(_tweetImages);
    });
  }

//Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (_images.length + 1 > 4) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only upload 4 images at a time'),
        ),
      );
      return;
    }
    setState(() {
      if (photo != null) {
        _images.add(File(photo.path));
        _tweetImages.add(File(photo.path));
      }
      ref.read(tweetImagesProvider.notifier).setTweetImages(_tweetImages);
    });
  }

//Image Picker function to get image from camera
  Future getVideoFromCamera() async {
    final XFile? photo = await picker.pickVideo(source: ImageSource.camera);
    if (_images.length + 1 > 4) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You can only upload 4 images at a time'),
        ),
      );
      return;
    }
    setState(() {
      if (photo != null) {
        _images.add(File(photo.path));
        _tweetImages.add(File(photo.path));
      }
      ref.read(tweetImagesProvider.notifier).setTweetImages(_tweetImages);
    });
  }

  void _onItemTapped(int index) {
    if (index == 0) {
      getImageFromCamera();
    } else if (index == 1) {
      getImageFromGallery();
    }
    if (index == 2) {
      getVideoFromCamera();
    } else if (index == 3) {
      getVideoFromGallery();
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (_images.isNotEmpty)
                for (int i = 0; i < _images.length; i++)
                  ImageCard(
                      imageUrl: _images[i],
                      onRemove: () {
                        setState(() {
                          _images.removeAt(i);
                        });
                      }),
            ],
          ),
        ),
        BottomNavigationBar(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.blue,
          selectedIconTheme: const IconThemeData(size: 23),
          unselectedIconTheme: const IconThemeData(size: 22),
          selectedFontSize: 0,
          iconSize: 22,
          type: BottomNavigationBarType.fixed,
          items: [
            const BottomNavigationBarItem(
              icon: Icon(BootstrapIcons.camera_fill),
              label: 'Home',
            ),
            const BottomNavigationBarItem(
              icon: Icon(BootstrapIcons.image),
              label: 'Search',
            ),
            const BottomNavigationBarItem(
              icon: Icon(BootstrapIcons.camera_video),
              label: 'Favorites',
            ),
            const BottomNavigationBarItem(
              icon: Icon(BootstrapIcons.play_btn_fill),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: SizedBox(
                height: 22,
                width: 20,
                child: Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    final progressValue = ref.watch(tweetProgressProvider);
                    return AddTweetCircularIndicator(
                      progress: progressValue,
                    );
                  },
                ),
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
      ],
    );
  }
}

class ImageCard extends StatelessWidget {
  final File imageUrl;
  final VoidCallback onRemove;

  const ImageCard({super.key, required this.imageUrl, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          // Display the image
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: FileImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Close button
          Positioned(
            top: -10,
            right: -10,
            child: IconButton(
              icon: const Icon(Icons.close),
              color: Colors.white,
              onPressed: onRemove,
            ),
          ),
        ],
      ),
    );
  }
}
