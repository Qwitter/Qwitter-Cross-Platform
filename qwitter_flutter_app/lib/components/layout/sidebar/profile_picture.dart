import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/profile/profile_details_screen.dart';
import 'package:qwitter_flutter_app/models/app_user.dart';

class ProfilePicture extends StatelessWidget {


  const ProfilePicture(
      {super.key});
  void onTap(BuildContext context) {
    AppUser appUser = AppUser();
    print(appUser.birthDate);
    print(appUser.createdAt);
    print(appUser.followersCount);
    print(appUser.followingCount);
    Navigator.of(context).pop();
    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileDetailsScreen(username: AppUser().username!),));
  }

  @override
  Widget build(BuildContext context) {
    AppUser appUser = AppUser();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: (){onTap(context);},
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  image: (appUser.profilePicture!.path.isEmpty
                      ? const AssetImage("assets/images/def.jpg")
                      : NetworkImage(
                              appUser.profilePicture!.path.startsWith("http")
                                  ? appUser.profilePicture!.path
                                  : "http://" + appUser.profilePicture!.path)
                          as ImageProvider),
                  fit: BoxFit.cover),
            ),
          ),
        ),
        InkWell(
          onTap: (){},
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
               "${appUser.fullName}",
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "@${appUser.username}",
                style: TextStyle(
                    color: Colors.grey.shade800, fontSize: 15, height: 0.9),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            TextButton(
              onPressed: () {},
              style: const ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(Colors.transparent)),
              child: Row(
                children: [
                  Text(
                    appUser.followingCount==null?"0":"${appUser.followingCount}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5,),
                  Text(
                    ' Following',
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {},
              style: const ButtonStyle(
                  overlayColor: MaterialStatePropertyAll(Colors.transparent),
                  padding: MaterialStatePropertyAll(EdgeInsets.zero)),
              child: Row(
                children: [
                  Text(
                    appUser.followersCount==null?"0":"${appUser.followersCount}",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5,),
                  Text(
                    ' Followers',
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
