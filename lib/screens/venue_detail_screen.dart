import 'package:event_planner_buisness/screens/extra_details_of_venue.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:event_planner_buisness/constant.dart';

class VenueDetailForm extends StatefulWidget {
  static const String venueDetailFrom = '/venue_detail_form';

  @override
  _VenueDetailFormState createState() => _VenueDetailFormState();
}

class _VenueDetailFormState extends State<VenueDetailForm> {
  bool _isUploadingStarted = false;

  File? _venueProviderImage;
  late String _venueOwnerName;
  late String _venueOwnerContact;
  late String _venueLocation;
  late String _venueName;
  late String _venueDescription;
  late List<String> _selectedEvents;

  final _formKey = GlobalKey<FormState>()!;

  void onSave() async {
    // ignore: unnecessary_null_comparison
    if (_venueProviderImage == null) {
      await showDialog(
        context: context,
        builder: (ctx) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: AlertDialog(
              backgroundColor: Color(0xFF033249),
              title: Text(
                'Please Pick an image',
                style: TextStyle(
                  color: Color(0xFFFF8038),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'OK',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF8038),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
      return;
    }
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      Navigator.of(context).pushReplacementNamed(
        ExtraVenueDetail.extraVenueDetail,
        arguments: {
          'venueOwnerName': _venueOwnerName,
          'venueOwnerContact': _venueOwnerContact,
          'venueLocation': _venueLocation,
          'venueName': _venueName,
          'venueDescription': _venueDescription,
          'selectedEvents': _selectedEvents,
          'venueProviderImage': _venueProviderImage,
        },
      );
    }
  }

  void pickImage() {
    showDialog(
      context: context,
      builder: (ctx) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: SimpleDialog(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                onWantToTakePic(ImageSource.camera);
              },
              child: Text(
                'Open Camera',
              ),
            ),
            SizedBox(height: 10),
            SimpleDialogOption(
              onPressed: () {
                onWantToTakePic(ImageSource.gallery);
              },
              child: Text(
                'Pick From Gallery',
              ),
            ),
            SizedBox(height: 10),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                FocusScope.of(context).unfocus();
              },
              child: Text(
                'Cancel',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onWantToTakePic(ImageSource imageSource) async {
    final picker = ImagePicker();
    final PickedFile? image = await picker.getImage(
      source: imageSource,
      imageQuality: 50,
      maxWidth: 150,
    );

    if (image == null) return;
    setState(() {
      _venueProviderImage = File(image.path);
    });
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    _selectedEvents =
        ModalRoute.of(context)!.settings.arguments as List<String>;
    return Scaffold(
      appBar: AppBar(
        title: Text('Please fill your details'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Color(0xFF033249),
                  backgroundImage: _venueProviderImage != null
                      ? FileImage(_venueProviderImage!)
                      : AssetImage('assets/images/user_avatar.PNG')
                          as ImageProvider<Object>?,
                ),
                TextButton.icon(
                  onPressed: pickImage,
                  icon: Icon(
                    Icons.add_a_photo,
                    color: Color(0xFFFF8038),
                  ),
                  label: Text(
                    'Add photo',
                    style: TextStyle(color: Color(0xFFFF8038)),
                  ),
                ),
                TextFormField(
                  key: ValueKey('name'),
                  keyboardType: TextInputType.name,
                  decoration: klogininput.copyWith(
                    labelText: 'Name',
                    prefixIcon: Icon(
                      Icons.person,
                      color: Color(0xFFFF8038),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Provide name';
                    }
                    if (value!.length < 4) {
                      return 'Atleast 4 char long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _venueOwnerName = value!;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  key: ValueKey(
                    'Contact',
                  ),
                  keyboardType: TextInputType.phone,
                  decoration: klogininput.copyWith(
                    labelText: 'Contact',
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Color(0xFFFF8038),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Provide number';
                    }
                    if (value!.length < 10) {
                      return 'Provide right number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _venueOwnerContact = value!;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  key: ValueKey('shop'),
                  keyboardType: TextInputType.name,
                  decoration: klogininput.copyWith(
                    labelText: 'Venue name',
                    prefixIcon: Icon(
                      Icons.shopping_bag,
                      color: Color(0xFFFF8038),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) return 'Provide shop name';
                    if (value.length < 4) {
                      return 'Atleast 4 char long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _venueName = value!;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  key: ValueKey('address'),
                  maxLines: 2,
                  keyboardType: TextInputType.multiline,
                  decoration: klogininput.copyWith(
                    labelText: 'Venue location',
                    prefixIcon: Icon(
                      Icons.home,
                      color: Color(0xFFFF8038),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Provide address';
                    }
                    if (value!.length < 10) {
                      return 'Provide full address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _venueLocation = value!;
                  },
                ),
                SizedBox(height: 15),
                TextFormField(
                  key: ValueKey('description'),
                  maxLines: 2,
                  keyboardType: TextInputType.multiline,
                  decoration: klogininput.copyWith(
                    labelText: 'Add some description of venue',
                    prefixIcon: Icon(
                      Icons.add,
                      color: Color(0xFFFF8038),
                    ),
                  ),
                  validator: (value) {
                    if (value == null) {
                      return 'Provide description';
                    }
                    if (value!.length < 10) {
                      return 'Atleast 10 char long';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _venueDescription = value!;
                  },
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    onSave();
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
