import 'package:flutter/material.dart';

class TweetScrolUpButton extends StatelessWidget {
  final scrollController;
  final scrollPressedFunc;

  const TweetScrolUpButton({Key? key, required ScrollController this.scrollController, required this.scrollPressedFunc}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Container(
            width: 160,
            child: FilledButton(
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateColor.resolveWith((states) => Colors.blue),
                padding:
                    MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(0)),
              ),
              onPressed: () {
                scrollPressedFunc();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.arrow_upward,
                    color: Colors.white,
                    size: 15,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 70,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 40 * 1,
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(20)),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/user.jpg'),
                              radius: 12,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 20 * 1,
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(20)),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/user.jpg'),
                              radius: 12,
                            ),
                          ),
                        ),
                        Positioned(
                          child: Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 2),
                                borderRadius: BorderRadius.circular(20)),
                            child: CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/user.jpg'),
                              radius: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "posted",
                    style: TextStyle(fontWeight: FontWeight.w400),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
