import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_password_manager/api/api.dart';
import 'package:flutter_password_manager/helper/dialogs.dart';
import 'package:flutter_password_manager/models/chat_user.dart';
import 'package:flutter_password_manager/screen/login_screen.dart';
import 'package:flutter_password_manager/screen/splash_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UserProfile extends StatefulWidget {
  final ChatUser user;

  const UserProfile({super.key, required this.user});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final _formKey = GlobalKey<FormState>();
  File? _avatar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping outside
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white70.withOpacity(0.92),
        appBar: AppBar(
          toolbarHeight: mq.height * .09,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "User Profile",
            style: TextStyle(color: Colors.white),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 11.0, right: 11.0),
          child: FloatingActionButton.extended(
            onPressed: () async {
              Dialogs.showProgressBar(context);
              await APIs.auth.signOut().then((_) => {
                    Navigator.pop(context),
                    Navigator.pop(context),
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()))
                  });
            },
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
            backgroundColor: Colors.redAccent,
            label: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  width: mq.width,
                  height: mq.height * .05,
                ),
                Stack(
                  children: [
                    _avatar!=null
                        ?ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .3),
                      child: Image.file(
                        _avatar!,
                        width: mq.height * .3,
                        height: mq.height * .3,
                        fit: BoxFit.fill,
                      )
                    )
                        :ClipRRect(
                      borderRadius: BorderRadius.circular(mq.height * .3),
                      child: CachedNetworkImage(
                        width: mq.height * .3,
                        height: mq.height * .3,
                        fit: BoxFit.fill,
                        imageUrl: "http://via.placeholder.com/350x150",
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error, color: Colors.green),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: -20,
                      child: MaterialButton(
                        onPressed: () {
                          _showBottomSheet();
                        },
                        shape: const CircleBorder(),
                        child: const Icon(
                          Icons.edit,
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: mq.height * .03,
                ),
                Text(
                  widget.user.email,
                  softWrap: true,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black.withOpacity(0.7),
                  ),
                ),
                SizedBox(
                  height: mq.height * .03,
                ),
                TextFormField(
                  onSaved: (val) => {APIs.me.name = val ?? ''},
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : "Required",
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.green,
                    ),
                    hintText: "eg: John ",
                    hintStyle: TextStyle(color: Colors.black26),
                    label: Text(
                      "Name",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                TextFormField(
                  onSaved: (val) => {APIs.me.about = val ?? ''},
                  validator: (val) =>
                      val != null && val.isNotEmpty ? null : "Required",
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.info_outline,
                      color: Colors.green,
                    ),
                    hintText: "eg: John@example ",
                    hintStyle: TextStyle(color: Colors.black26),
                    label: Text(
                      "About",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
                SizedBox(
                  height: mq.height * .02,
                ),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.green,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 50),
                  ),
                  label: const Text(
                    "Update",
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      _formKey.currentState!.save();
                      APIs.updateUserInfo().then((_) =>
                          Dialogs.snackBar(context, "User profile updated"));
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding:
                EdgeInsets.only(top: mq.height * .02, bottom: mq.height * .05),
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Text(
                  "Image Picker",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () =>_pickImage(ImageSource.gallery),
                    style: ElevatedButton.styleFrom(
                        elevation: 3,
                        shadowColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 35),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: const Icon(
                      Icons.photo,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                  ElevatedButton(
                    onPressed:()=> _pickImage(ImageSource.camera),
                    style: ElevatedButton.styleFrom(
                        elevation: 3,
                        shadowColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 35),
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5))),
                    child: const Icon(
                      Icons.camera,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Future<void> _pickImage(ImageSource source) async {
    bool permissionGranted = await checkPermissions(source);
    if (permissionGranted) {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _avatar = File(image.path);
        });
      }
    } else {
      Dialogs.snackBar(context,
          "Permission denied. Cannot Access ${source == ImageSource.camera ? 'Camera' : 'Gallery'}");
    }
    Navigator.pop(context);
  }

  Future<bool> checkPermissions(ImageSource source) async {
    if (source == ImageSource.camera) {
      PermissionStatus cameraStatus = await Permission.camera.status;
      if (!cameraStatus.isGranted) {
        PermissionStatus result = await Permission.camera.request();
        return result.isGranted;
      }
      return true;
    } else {
      PermissionStatus galleryStatus = await Permission.photos.status;
      if (!galleryStatus.isGranted) {
        PermissionStatus result = await Permission.photos.request();
        return result.isGranted;
      }
      return true;
    }
  }
}
