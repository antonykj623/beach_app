import 'dart:convert';
import 'dart:io';

import 'package:beach_app/utilities/Utils.dart';
import 'package:beach_app/utilities/native_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UpdateProfileScreen
    extends StatefulWidget {

  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() =>
      _UpdateProfileScreenState();
}

class _UpdateProfileScreenState
    extends State<UpdateProfileScreen> {

  /// 🔥 CONTROLLERS
  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController
  usernameController =
  TextEditingController();

  final TextEditingController
  emailController =
  TextEditingController();

  final TextEditingController
  dobController =
  TextEditingController();

  final TextEditingController
  websiteController =
  TextEditingController();

  final TextEditingController bioController =
  TextEditingController();

  final TextEditingController
  countryController =
  TextEditingController();

  final TextEditingController
  stateController =
  TextEditingController();

  /// 🔥 PROFILE DATA
  dynamic profileData;

  bool isLoading = true;

  /// 🔥 IMAGE
  File? profileImage;

  String networkImage = "";

  /// 🔥 BUTTON LOADING
  bool buttonLoading = false;

  /// 🔥 TOKEN
  String token = "";

  @override
  void initState() {

    super.initState();

    getProfile();
  }

  /// 🔥 GET PROFILE API
  Future<void> getProfile() async {

    try {
      String? v=await NativeStorage.getValue(Utils.token);

      token=v.toString();
      final response = await http.get(

        Uri.parse(
          "https://beach.adpedia.in/api/profile",
        ),

        headers: {

          "Authorization":
          "Bearer $token",
        },
      );

      if (response.statusCode == 200) {

        final jsonData =
        json.decode(response.body);

        print(jsonData);

        if (jsonData["status"] == true) {

          profileData =
          jsonData["data"];

          /// 🔥 SET VALUES
          nameController.text =
              profileData["name"] ?? "";

          usernameController.text =
              profileData["username"] ?? "";

          emailController.text =
              profileData["email"] ?? "";

          bioController.text =
              profileData["bio"] ?? "";

          countryController.text =
              profileData["country_id"]
                  .toString();

          stateController.text =
              profileData["state_id"]
                  .toString();

          /// 🔥 IMAGE
          if (profileData["profile_image"] !=
              null) {

            networkImage =
            "https://beach.adpedia.in/uploads/profile_images/${profileData["profile_image"]}";
          }

          setState(() {

            isLoading = false;
          });
        }
      }

    } catch (e) {

      print("Error: $e");

      setState(() {

        isLoading = false;
      });
    }
  }

  /// 🔥 PICK IMAGE
  Future<void> pickImage() async {

    try {

      FilePickerResult? result =
      await FilePicker.pickFiles(

        type: FileType.image,
      );

      if (result != null) {

        setState(() {

          profileImage =
              File(result.files.single.path!);
        });
      }

    } catch (e) {

      print(e);
    }
  }

  /// 🔥 DATE PICKER
  Future<void> selectDate() async {

    DateTime? pickedDate =
    await showDatePicker(

      context: context,

      initialDate: DateTime.now(),

      firstDate: DateTime(1950),

      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {

      dobController.text =
      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    }
  }

  /// 🔥 UPDATE PROFILE
  Future<void> updateProfile() async {

    try {
      String? v=await NativeStorage.getValue(Utils.token);

      token=v.toString();
      setState(() {

        buttonLoading = true;
      });

      var request =
      http.MultipartRequest(

        "POST",

        Uri.parse(
          "https://beach.adpedia.in/api/update-profile",
        ),
      );

      /// 🔥 HEADERS
      request.headers.addAll({

        "Authorization":
        "Bearer $token",
      });

      /// 🔥 FIELDS
      request.fields["name"] =
          nameController.text;

      request.fields["username"] =
          usernameController.text;

      request.fields["date_of_birth"] =
          dobController.text;

      request.fields["country_id"] =
          countryController.text;

      request.fields["state_id"] =
          stateController.text;

      request.fields["website"] =
          websiteController.text;

      request.fields["bio"] =
          bioController.text;

      /// 🔥 IMAGE
      if (profileImage != null) {

        request.files.add(

          await http.MultipartFile
              .fromPath(

            "profile_image",

            profileImage!.path,
          ),
        );
      }

      /// 🔥 RESPONSE
      var response =
      await request.send();

      var responseData =
      await response.stream.bytesToString();

      final data =
      jsonDecode(responseData);

      print(data);

      if (data["status"] == true) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(

            content:
            Text(data["message"]),
          ),
        );

        getProfile();
      }

    } catch (e) {

      print(e);

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text("$e"),
        ),
      );
    }

    setState(() {

      buttonLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        elevation: 0,

        title: const Text(

          "Edit Profile",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: isLoading

          ? const Center(

        child:
        CircularProgressIndicator(),
      )

          : SingleChildScrollView(

        padding:
        const EdgeInsets.all(15),

        child: Column(

          children: [

            /// 🔥 PROFILE IMAGE
            GestureDetector(

              onTap: () {

                pickImage();
              },

              child: Stack(

                children: [

                  CircleAvatar(

                    radius: 55,

                    backgroundColor:
                    Colors.grey.shade900,

                    backgroundImage:

                    profileImage != null

                        ? FileImage(
                        profileImage!)

                        : networkImage
                        .isNotEmpty

                        ? NetworkImage(
                        networkImage)

                        : null
                    as ImageProvider?,

                    child:
                    profileImage == null &&
                        networkImage
                            .isEmpty

                        ? const Icon(

                      Icons.person,

                      color:
                      Colors.white,

                      size: 50,
                    )

                        : null,
                  ),

                  Positioned(

                    bottom: 0,

                    right: 0,

                    child: Container(

                      padding:
                      const EdgeInsets.all(
                          7),

                      decoration:
                      const BoxDecoration(

                        color:
                        Colors.blue,

                        shape:
                        BoxShape.circle,
                      ),

                      child: const Icon(

                        Icons.edit,

                        color:
                        Colors.white,

                        size: 18,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 FOLLOWERS FOLLOWING
            Row(

              mainAxisAlignment:
              MainAxisAlignment.center,

              children: [

                buildCountCard(

                  title: "Followers",

                  count:
                  profileData["followers"]
                      .toString(),
                ),

                const SizedBox(width: 20),

                buildCountCard(

                  title: "Following",

                  count:
                  profileData["following"]
                      .toString(),
                ),
              ],
            ),

            const SizedBox(height: 30),

            /// 🔥 NAME
            buildTextField(

              controller:
              nameController,

              hint: "Name",
            ),

            const SizedBox(height: 15),

            /// 🔥 USERNAME
            buildTextField(

              controller:
              usernameController,

              hint: "Username",
            ),

            const SizedBox(height: 15),

            /// 🔥 EMAIL
            buildTextField(

              controller:
              emailController,

              hint: "Email",

              keyboardType:
              TextInputType.emailAddress,
            ),

            const SizedBox(height: 15),

            /// 🔥 DATE OF BIRTH
            GestureDetector(

              onTap: () {

                selectDate();
              },

              child: AbsorbPointer(

                child: buildTextField(

                  controller:
                  dobController,

                  hint:
                  "Date of Birth",

                  icon:
                  Icons.calendar_month,
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// 🔥 COUNTRY ID
            buildTextField(

              controller:
              countryController,

              hint: "Country ID",

              keyboardType:
              TextInputType.number,
            ),

            const SizedBox(height: 15),

            /// 🔥 STATE ID
            buildTextField(

              controller:
              stateController,

              hint: "State ID",

              keyboardType:
              TextInputType.number,
            ),

            const SizedBox(height: 15),

            /// 🔥 WEBSITE
            buildTextField(

              controller:
              websiteController,

              hint: "Website",

              icon: Icons.language,
            ),

            const SizedBox(height: 15),

            /// 🔥 BIO
            TextField(

              controller: bioController,

              style: const TextStyle(
                color: Colors.white,
              ),

              maxLines: 4,

              decoration: InputDecoration(

                hintText: "Bio",

                hintStyle:
                const TextStyle(
                  color: Colors.grey,
                ),

                filled: true,

                fillColor:
                Colors.grey.shade900,

                border:
                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(
                      15),

                  borderSide:
                  BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// 🔥 UPDATE BUTTON
            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton(

                onPressed: () {

                  updateProfile();
                },

                style:
                ElevatedButton.styleFrom(

                  backgroundColor:
                  Colors.blue,

                  shape:
                  RoundedRectangleBorder(

                    borderRadius:
                    BorderRadius.circular(
                        15),
                  ),
                ),

                child: buttonLoading

                    ? const SizedBox(

                  width: 20,

                  height: 20,

                  child:
                  CircularProgressIndicator(

                    color:
                    Colors.white,

                    strokeWidth: 2,
                  ),
                )

                    : const Text(

                  "Update Profile",

                  style: TextStyle(

                    color:
                    Colors.white,

                    fontSize: 16,

                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 🔥 COUNT CARD
  Widget buildCountCard({

    required String title,

    required String count,
  }) {

    return Column(

      children: [

        Text(

          count,

          style: const TextStyle(

            color: Colors.white,

            fontSize: 20,

            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 5),

        Text(

          title,

          style: const TextStyle(
            color: Colors.grey,
          ),
        )
      ],
    );
  }

  /// 🔥 TEXTFIELD
  Widget buildTextField({

    required TextEditingController
    controller,

    required String hint,

    TextInputType keyboardType =
        TextInputType.text,

    IconData? icon,
  }) {

    return TextField(

      controller: controller,

      keyboardType: keyboardType,

      style: const TextStyle(
        color: Colors.white,
      ),

      decoration: InputDecoration(

        hintText: hint,

        hintStyle: const TextStyle(
          color: Colors.grey,
        ),

        prefixIcon: icon != null

            ? Icon(
          icon,
          color: Colors.grey,
        )

            : null,

        filled: true,

        fillColor:
        Colors.grey.shade900,

        border: OutlineInputBorder(

          borderRadius:
          BorderRadius.circular(15),

          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}