import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:transparent_image/transparent_image.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickedImage});

  final void Function(File image) onPickedImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 150,
      imageQuality: 50,
    );

    if (image == null) {
      return;
    }

    setState(() {
      _pickedImage = File(image.path);
    });

    widget.onPickedImage(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    bool haveImage = _pickedImage != null;
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: MemoryImage(kTransparentImage),
          foregroundImage: haveImage
              ? FileImage(_pickedImage!)
              : null,
          radius: 40,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add image'),
        ),
      ],
    );
  }
}
