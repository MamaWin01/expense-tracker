import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:http/http.dart';
import 'package:expense_app/widget/main_page.dart';
import 'package:expense_app/Helper/constant.dart';
import 'package:expense_app/Helper/function.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  _EditProfileState createState() => _EditProfileState();
}

TextEditingController FullnameController = TextEditingController();
TextEditingController EmailController = TextEditingController();
TextEditingController PasswordController = TextEditingController();
TextEditingController NewPasswordController = TextEditingController();

class _EditProfileState extends State<EditProfile> {
  bool _obscureText = true;
  XFile? _image;
  bool _isloading = false;
  bool _pickingImage = false;
  dynamic AccPic;
  late SharedPreferences prefs;

  Future<void> _pickImage() async {
    if (_pickingImage) {
      return;
    }

    _pickingImage = true;
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }

    _pickingImage = false;
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    var prefs = await SharedPreferences.getInstance();
    var test = prefs?.getString('token');
    var jwtDecodedToken = JwtDecoder.decode(test.toString());
    var userPic = await getAccountInfo(jwtDecodedToken);
    if (mounted) {
      setState(() {
        AccPic = userPic['profile_image'];
        FullnameController.text = jwtDecodedToken['name'].toString();
        EmailController.text = jwtDecodedToken['email'].toString();
        NewPasswordController.text = '';
        PasswordController.text = '';
      });
    }
  }

  _showValidation(context, type) {
    if (type == 'update') {
      showDialog(
          context: context,
          builder: (context) => CustomDialog(
                handleUpdate: _updateAccount,
              ));
    }
  }

  _updateAccount() async {
    var prefs = await SharedPreferences.getInstance();
    var test = prefs?.getString('token');
    var userData = JwtDecoder.decode(test.toString());
    var new_name = FullnameController.text.toString();
    var new_email = EmailController.text.toString();
    var new_password = NewPasswordController.text.toString();
    var password = PasswordController.text.toString();
    Uint8List? originalImage;
    Uint8List? compressedImage;
    XFile? image = _image;

    if (image != null) {
      originalImage = await image.readAsBytes();
      compressedImage = await FlutterImageCompress.compressWithList(
        originalImage,
        quality: 20, // Adjust the quality as needed
      );
    }

    setState(() {
      _isloading = true;
    });
    var data = {
      'email': userData['email'],
      'new_name': new_name,
      'new_email': new_email,
      'new_password': new_password,
      'password': password,
    };
    if (compressedImage != null) {
      data['profile_image'] = base64Encode(compressedImage);
    }
    try {
      Response response = await post(Uri.parse('$API_URL/editAccount'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data));

      if (response.statusCode == 200) {
        if (mounted) {
          showDialog(
              // barrierDismissible: false,
              context: context,
              builder: (context) {
                return const AlertDialog(
                  title: Text("Edit Account Info"),
                  backgroundColor: Colors.white,
                  content: Text("Account successfully edited"),
                );
              });
        }
        Timer(const Duration(seconds: 1), () {
          Navigator.pushNamed(context, '/edit_profile');
        });
      } else {
        if (mounted) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text("Edit Account Info"),
                    content: Text(
                        "Edit Account Failed, ${jsonDecode(response.body)['error'].toString()}"),
                    backgroundColor: const Color(0xFFFAFAFA),
                    actions: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        enableFeedback: false,
                        child: const Text('Go back'),
                      )
                    ],
                  ));
        }

        setState(() {
          _isloading = false;
        });
      }
    } catch (exp) {
      debugPrint(exp.toString());
    }
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    var mainImage;
    if (_image != null) {
      mainImage = ClipOval(
        child: Image.file(
          File(_image!.path),
          width: 140,
          height: 140,
          fit: BoxFit.cover,
        ),
      );
    } else if (AccPic != null) {
      mainImage = ClipOval(
        child: Image.memory(
          base64.decode(AccPic),
          width: 140,
          height: 140,
          fit: BoxFit.cover,
        ),
      );
    } else {
      mainImage = Image.asset(
        'assets/images/Default_Image.png',
        fit: BoxFit.cover,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Account',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w500,
            height: 0,
          ),
        ),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Main_page(
                  initialIndex: 2,
                ),
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: CircleAvatar(
                    radius: 70,
                    backgroundColor: Colors.transparent,
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.grey.shade800.withOpacity(0.5),
                        BlendMode.srcATop,
                      ),
                      child: Stack(
                        children: [
                          mainImage,
                          Center(
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                                size: 40,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              const SizedBox(height: 30.0),
              TextField(
                textAlign: TextAlign.justify,
                controller: FullnameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: UnderlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.50, color: Color(0xFF828282)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        const BorderSide(width: 2.5, color: Color(0xFF31A062)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "New Full name",
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                textAlign: TextAlign.justify,
                controller: EmailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: UnderlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.50, color: Color(0xFF828282)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        const BorderSide(width: 2.5, color: Color(0xFF31A062)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "New Email",
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                textAlign: TextAlign.justify,
                controller: NewPasswordController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: UnderlineInputBorder(
                    borderSide:
                        const BorderSide(width: 0.50, color: Color(0xFF828282)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        const BorderSide(width: 2.5, color: Color(0xFF31A062)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: "New Password",
                  suffixIcon: IconButton(
                    enableFeedback: false,
                    icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: () {
                      _toggle();
                    },
                  ),
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: 'DM Sans',
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                obscureText: _obscureText,
              ),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton(
                onPressed: _isloading
                    ? null
                    : () {
                        _showValidation(context, 'update');
                      },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF31A062),
                    fixedSize: const Size(300, 30),
                    enableFeedback: false),
                child: const Text(
                  'Update Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: _isloading
                    ? null
                    : () {
                        _showValidation(context, 'delete');
                      },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    fixedSize: const Size(300, 30),
                    enableFeedback: false),
                child: const Text(
                  'Delete Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w700,
                    height: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomDialog extends StatefulWidget {
  CustomDialog({super.key, this.handleUpdate});
  dynamic handleUpdate;

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  bool _obscureText2 = true;

  void _toggle2() {
    setState(() {
      _obscureText2 = !_obscureText2;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Please enter your password!"),
      content: Stack(fit: StackFit.loose, children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              textAlign: TextAlign.justify,
              controller: PasswordController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 0.50, color: Color(0xFF828282)),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(width: 2.5, color: Color(0xFF31A062)),
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: "Password",
                suffixIcon: IconButton(
                  enableFeedback: false,
                  icon: Icon(
                      _obscureText2 ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    _toggle2();
                  },
                ),
              ),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'DM Sans',
                fontWeight: FontWeight.w400,
                height: 1,
              ),
              obscureText: _obscureText2,
            ),
          ],
        )
      ]),
      backgroundColor: Colors.white,
      actions: <Widget>[
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          enableFeedback: false,
          child: const Text('Cancel'),
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: () {
            widget.handleUpdate();
          },
          enableFeedback: false,
          child: const Text('Enter'),
        ),
      ],
    );
  }
}
