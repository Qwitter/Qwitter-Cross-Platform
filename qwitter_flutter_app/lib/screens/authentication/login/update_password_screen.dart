import 'package:flutter/material.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/primary_button.dart';
import 'package:qwitter_flutter_app/components/basic_widgets/underlined_text_field.dart';
import 'package:qwitter_flutter_app/components/layout/qwitter_back_app_bar.dart';

class UpdatePasswordScreen extends StatefulWidget {
  const UpdatePasswordScreen({super.key});

  @override
  State<UpdatePasswordScreen> createState() => _UpdatePasswordScreenState();
}

class _UpdatePasswordScreenState extends State<UpdatePasswordScreen> {
  late TextEditingController currentPassController;
  late TextEditingController firstNewPassController;
  late TextEditingController secondNewPassController;

  bool isActive = false;
  void hello() {
    setState(() {
      isActive = false;
    });
    currentPassController.clear();
    firstNewPassController.clear();
    secondNewPassController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    currentPassController.dispose();
    firstNewPassController.dispose();
    secondNewPassController.dispose();
  }

  @override
  void initState() {
    super.initState();
    currentPassController = TextEditingController();
    firstNewPassController = TextEditingController();
    secondNewPassController = TextEditingController();
    currentPassController.addListener(updateIsState);
    firstNewPassController.addListener(updateIsState);
    secondNewPassController.addListener(updateIsState);
  }

  void updateIsState() {
    setState(() {
      isActive = currentPassController.text.isNotEmpty &&
          firstNewPassController.text.isNotEmpty &&
          secondNewPassController.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(75),
        child: QwitterBackAppBar(
          title: "Update password",
          extraTitle: "@AlyMF",
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          child: Column(
            children: [
              UnderlineTextField(
                keyboardType: TextInputType.emailAddress,
                placeholder: "",
                controller: currentPassController,
              ),
              UnderlineTextField(
                keyboardType: TextInputType.emailAddress,
                placeholder: "",
                controller: firstNewPassController,
              ),
              UnderlineTextField(
                keyboardType: TextInputType.emailAddress,
                placeholder: "",
                controller: secondNewPassController,
              ),
              PrimaryButton(
                  text: "Update password", on_pressed: isActive ? hello : null),
              TextButton(
                onPressed: () {},
                child: Text("Forgotten your password?",
                    style: TextStyle(
                      color: Colors.grey[500],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
