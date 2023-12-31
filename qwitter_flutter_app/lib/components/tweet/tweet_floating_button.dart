import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/screens/tweets/add_tweet_screen.dart';

class TweetFloatingButton extends StatelessWidget {
  final bool isVisible;
  final Function closeFloatingButton;
  final Function toggleVisibility;
  const TweetFloatingButton(
      {Key? key,
      required this.isVisible,
      required this.closeFloatingButton,
      required this.toggleVisibility})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        isVisible
            ? GestureDetector(
                child: Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.8),
                ),
                onTap: () => closeFloatingButton(),
              )
            : Container(),
        Positioned(
          bottom: 210,
          right: 30,
          child: Row(
            children: [
              AnimatedScale(
                scale: isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Text("Spaces",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                        color: Colors.white)),
              ),
              const SizedBox(
                width: 15,
              ),
              AnimatedScale(
                scale: isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: FilledButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(5)),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        CircleBorder()), // Set the shape to CircleBorder()
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                  ),
                  child: const Icon(
                    Icons.mic,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    // //print("Floating button pressed");
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 155,
          right: 30,
          child: Row(
            children: [
              AnimatedScale(
                scale: isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Text("GIF",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                        color: Colors.white)),
              ),
              const SizedBox(
                width: 15,
              ),
              AnimatedScale(
                scale: isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: FilledButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(5)),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        const CircleBorder()), // Set the shape to CircleBorder()
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                  ),
                  child: const Icon(
                    Icons.gif_box_outlined,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    // //print("Floating button pressed");
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 100,
          right: 30,
          child: Row(
            children: [
              AnimatedScale(
                scale: isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Text("Photos",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                        color: Colors.white)),
              ),
              const SizedBox(
                width: 15,
              ),
              AnimatedScale(
                scale: isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: FilledButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.all(5)),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        const CircleBorder()), // Set the shape to CircleBorder()
                    backgroundColor: MaterialStateColor.resolveWith(
                        (states) => Colors.white),
                  ),
                  child: const Icon(
                    Icons.image_outlined,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    // //print("Floating button pressed");
                  },
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 30,
          right: 30,
          child: Row(
            children: [
              AnimatedScale(
                scale: isVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: const Text("Post",
                    style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 18,
                        color: Colors.white)),
              ),
              const SizedBox(
                width: 15,
              ),
              FilledButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.all(17),
                  ),
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      const CircleBorder()), // Set the shape to CircleBorder()
                  backgroundColor:
                      MaterialStateColor.resolveWith((states) => Colors.blue),
                ),
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: isVisible ? 1 : 0,
                  child: isVisible
                      ? const Icon(Icons.post_add,
                          color: Colors.white) // Icon when button is visible
                      : const Icon(Icons.add, color: Colors.white),
                ),
                onPressed: () {
                  if (isVisible) {
                    // Make post
                    toggleVisibility();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return const AddTweetScreen();
                        },
                      ),
                    );
                    // // Temp Behaviour
                    // SharedPreferences.getInstance().then((prefs) {
                    //   prefs.clear().then((value) {
                    //     //print('SharedPreferences cleared!');
                    //   });
                    // });

                    // Navigator.popUntil(context, (route) => false);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (BuildContext context) {
                    //       return const SignupChooseMethodScreen();
                    //     },
                    //   ),
                    // );
                  } else {
                    // open buttons list
                    toggleVisibility();
                  }
                },
              ),
            ],
          ),
        )
      ],
    );
  }
}
