import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/primary_button.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/secondary_button.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        contentPadding: EdgeInsets.zero,
        minLeadingWidth: 0,
        minVerticalPadding: 0,
        leading: const CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
              'https://ih1.redbubble.net/image.2967438346.0043/bg,f8f8f8-flat,750x,075,f-pad,750x1000,f8f8f8.jpg'),
        ),
        title: const Text(
          'Abdallah',
          style: TextStyle(
            fontSize: 16,
            color: Color.fromARGB(255, 222, 222, 222),
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Transform.translate(
          offset: const Offset(0, -5),
          child: const Text(
            '@abdallah_aali',
            style: TextStyle(
              fontSize: 15,
              color: Color.fromARGB(255, 132, 132, 132),
            ),
          ),
        ),
        trailing: Transform.translate(
          offset: const Offset(0, -5),
          child: SecondaryButton(
              text: 'Follow',
              on_pressed: () {},
              paddingValue:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 35),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              )),
        ),
      ),
      Transform.translate(
        offset: const Offset(0, -15),
        child: Row(
          children: [
            const SizedBox(width: 57),
            Expanded(
              child: Text(
                'lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'
                    .substring(0, 90),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color.fromARGB(255, 222, 222, 222),
                ),
              ),
            ),
          ],
        ),
      )
    ]);
  }
}
