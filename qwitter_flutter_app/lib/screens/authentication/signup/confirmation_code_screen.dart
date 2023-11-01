import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/decorated_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_app_bar.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_next_bar.dart';

class ConfirmationCodeScreen extends StatelessWidget {
  const ConfirmationCodeScreen(
      {super.key, this.email = 'omarmahmoud@gmail.com'});

  final String email;

  @override
  Widget build(BuildContext context) {
    final TextEditingController codeController = TextEditingController();
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: QwitterAppBar(),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'We sent you a code',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 28,
                color: Color.fromARGB(255, 222, 222, 222),
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Enter it below to verify $email.',
              textAlign: TextAlign.start,
              style: const TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 132, 132, 132),
              ),
            ),
            const SizedBox(height: 15),
            Form(
              child: Column(
                children: [
                  DecoratedTextField(
                    keyboardType: TextInputType.name,
                    placeholder: 'Verification code',
                    padding_value: const EdgeInsets.all(0),
                    controller: codeController,
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          _showOverlay(context);
                        },
                        child: const Text(
                          'Didn\'t receive an email?',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: const QwitterNextBar(
        buttonFunction: null,
      ),
    );
  }

  void _showOverlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 15, 25, 2),
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 38, 38, 38),
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            height: 170,
            width: 300,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                        child: Text(
                          "Didn't receive an email?",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 222, 222, 222),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          // Add your action here for the first option.
                          Navigator.of(context).pop(); // Close the overlay
                        },
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 222, 222, 222),
                              fontWeight: FontWeight.w400,
                            ), // Set an empty TextStyle
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 222, 222, 222),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors
                                .transparent, // Set transparent background color
                          ),
                        ),
                        child: const Text(
                          "Resend Email",
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Add your action here for the second option.
                          Navigator.of(context).pop(); // Close the overlay
                        },
                        style: ButtonStyle(
                          textStyle: MaterialStateProperty.all<TextStyle>(
                            const TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 222, 222, 222),
                              fontWeight: FontWeight.w400,
                            ), // Set an empty TextStyle
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 222, 222, 222),
                          ),
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Colors
                                .transparent, // Set transparent background color
                          ),
                        ),
                        child: const Text(
                          "Use phone instead",
                          style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 222, 222, 222),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ]),
          ),
        );
      },
    );
  }
}
// child: AlertDialog(
//   backgroundColor: const Color.fromARGB(255, 0, 0, 0),
//   title: const Text(
//     "Didn't receive an email?",
//     style: TextStyle(
//       fontSize: 16,
//       color: Color.fromARGB(255, 222, 222, 222),
//       fontWeight: FontWeight.w500,
//     ),
//   ),
//   actions: [
//     Row(
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextButton(
//               onPressed: () {
//                 // Add your action here for the first option.
//                 Navigator.of(context).pop(); // Close the overlay
//               },
//               child: const Text(
//                 "Resend Email",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Color.fromARGB(255, 222, 222, 222),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             TextButton(
//               onPressed: () {
//                 // Add your action here for the second option.
//                 Navigator.of(context).pop(); // Close the overlay
//               },
//               child: const Text(
//                 "Cancel",
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Color.fromARGB(255, 222, 222, 222),
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     )
//   ],
// ),