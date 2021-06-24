import 'package:flutter/material.dart';
import '../constant.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ExtraVenueDetail extends StatefulWidget {
  static const String extraVenueDetail = '/extra_venue_detail';

  @override
  _ExtraVenueDetailState createState() => _ExtraVenueDetailState();
}

class _ExtraVenueDetailState extends State<ExtraVenueDetail> {
  bool _isUploadingStarted = false;

  FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  late String _charges24;
  late String _cateringCharge;
  late String _rooms;

  File? _pickedVenueImage;

  late String _venueOwnerName;
  late String _venueOwnerContact;
  late String _venueLocation;
  late String _venueName;
  late String _venueDescription;
  late List<String> _selectedEvents;
  late File _venueProviderImage;

  void onSave() async {
    // ignore: unnecessary_null_comparison
    if (_pickedVenueImage == null) {
      await showDialog(
        context: context,
        builder: (ctx) {
          return GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: AlertDialog(
              backgroundColor: Color(0xFF033249),
              title: Text(
                'Please Pick a venue image',
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
      print('Hello');
      print(_venueOwnerName);
      print(_venueOwnerContact);
      print(_venueName);
      print(_venueLocation);
      print(_venueDescription);
      print(_selectedEvents);
      print(_venueProviderImage);
      print(_charges24);
      print(_cateringCharge);
      print(_rooms);
      print(_pickedVenueImage);
      String _venueProviderImageUrl = '';
      String _venueImageUrl = '';
      setState(() {
        _isUploadingStarted = true;
      });
      try {
        final providerRef = _firebaseStorage
            .ref()
            .child('venue_provider_images')
            .child('${_auth.currentUser.uid}.jpg');

        await providerRef.putFile(_venueProviderImage).whenComplete(
          () async {
            _venueProviderImageUrl = await providerRef.getDownloadURL();

            final venueRef = _firebaseStorage
                .ref()
                .child('venue_images')
                .child('${_auth.currentUser.uid}.jpg');

            await venueRef.putFile(_pickedVenueImage).whenComplete(
              () async {
                _venueImageUrl = await venueRef.getDownloadURL();

                await _firestore
                    .collection('venues')
                    .doc(_auth.currentUser.uid)
                    .set(
                  {
                    'address': _venueLocation,
                    'image': _venueImageUrl,
                    'name': _venueName,
                    'rooms': _rooms,
                    'rating': '0',
                    'description': _venueDescription,
                    'cateringCharge': _cateringCharge,
                    'charges24': _charges24,
                    'providerName': _venueOwnerName,
                    'providerContact': _venueOwnerContact,
                    'providerImage': _venueProviderImageUrl,
                  },
                );
                _selectedEvents.forEach((event) async {
                  await _firestore.collection('events').doc(event).update({
                    'venueArray': FieldValue.arrayUnion([_auth.currentUser.uid])
                  });
                });

                setState(() {
                  _isUploadingStarted = false;
                });
              },
            );
          },
        );
      } catch (e) {
        print(e.toString());
      }
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
      imageQuality: 100,
      maxHeight: 150,
    );

    if (image == null) return;
    setState(() {
      _pickedVenueImage = File(image.path);
    });
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> _routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _venueOwnerName = _routeArgs['venueOwnerName'];
    _venueOwnerContact = _routeArgs['venueOwnerContact'];
    _venueName = _routeArgs['venueName'];
    _venueLocation = _routeArgs['venueLocation'];
    _venueDescription = _routeArgs['venueDescription'];
    _selectedEvents = _routeArgs['selectedEvents'];
    _venueProviderImage = _routeArgs['venueProviderImage'];
    print('${_auth.currentUser.uid} Hello');
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isUploadingStarted,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    key: ValueKey('charges'),
                    keyboardType: TextInputType.number,
                    decoration: klogininput.copyWith(
                      labelText: 'Charges per 24 hrs',
                      prefixIcon: Container(
                        width: 10,
                        alignment: Alignment.center,
                        child: Text(
                          '₹',
                          style: TextStyle(
                            color: const Color(0xFFFF8038),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'please fill info';
                      }
                      if (value.length == 0) {
                        return 'Please provide info';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _charges24 = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    key: ValueKey('catering'),
                    keyboardType: TextInputType.number,
                    decoration: klogininput.copyWith(
                      labelText: 'Catering charges per person',
                      prefixIcon: Container(
                        width: 10,
                        alignment: Alignment.center,
                        child: Text(
                          '₹',
                          style: TextStyle(
                            color: const Color(0xFFFF8038),
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'please fill info';
                      }
                      if (value.length == 0) {
                        return 'Please provide info';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _cateringCharge = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    key: ValueKey('rooms'),
                    keyboardType: TextInputType.number,
                    decoration: klogininput.copyWith(
                      labelText: 'Total rooms',
                      prefixIcon: Icon(
                        Icons.room_service,
                        color: Color(0xFFFF8038),
                      ),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return 'Provide name';
                      }
                      if (value.length == 0) {
                        return 'Please provide info';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _rooms = value!;
                    },
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: _pickedVenueImage == null
                        ? TextButton.icon(
                            style: TextButton.styleFrom(
                              primary: Color(0xFFFF8038),
                            ),
                            onPressed: () {
                              pickImage();
                            },
                            icon: Icon(Icons.add),
                            label: Text('Add Image of venue'),
                          )
                        : null,
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(width: 0.8, color: Colors.black),
                      image: _pickedVenueImage == null
                          ? null
                          : DecorationImage(
                              fit: BoxFit.fill,
                              image: FileImage(_pickedVenueImage!),
                            ),
                    ),
                  ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      onSave();
                    },
                    child: Text(
                      'Done',
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
      ),
    );
  }
}
