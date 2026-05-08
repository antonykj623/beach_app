import 'dart:convert';
import 'dart:io';

import 'package:beach_app/utilities/Utils.dart';
import 'package:beach_app/utilities/native_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CreateStoryScreen extends StatefulWidget {
  const CreateStoryScreen({super.key});

  @override
  State<CreateStoryScreen> createState() =>
      _CreateStoryScreenState();
}

class _CreateStoryScreenState
    extends State<CreateStoryScreen> {

  /// 🔥 CONTROLLERS
  final TextEditingController captionController =
  TextEditingController();

  final TextEditingController
  descriptionController =
  TextEditingController();

  /// 🔥 FILE
  File? selectedFile;

  /// 🔥 TYPE
  String mediaType = "image";

  /// 🔥 LOADING
  bool loading = false;

  /// 🔥 TOKEN
  String token = "";




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();
  }

  getToken() async {
    String? v=await NativeStorage.getValue(Utils.token);
    token=v.toString();

  }

  /// 🔥 PICK MEDIA
  Future<void> pickMedia() async {

    try {

      FilePickerResult? result =
      await FilePicker.pickFiles(

        type: FileType.custom,

        allowedExtensions: [
          "jpg",
          "jpeg",
          "png",
          "mp4",
          "mov"
        ],
      );

      if (result != null) {

        selectedFile =
            File(result.files.single.path!);

        /// 🔥 CHECK FILE TYPE
        String extension =
        result.files.single.extension!
            .toLowerCase();

        if (extension == "mp4" ||
            extension == "mov") {

          mediaType = "video";

        } else {

          mediaType = "image";
        }

        setState(() {});
      }

    } catch (e) {

      print(e);
    }
  }

  /// 🔥 CREATE STORY
  Future<void> createStory() async {

    if (selectedFile == null) {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(

          content:
          Text("Please select media"),
        ),
      );

      return;
    }

    try {

      setState(() {

        loading = true;
      });

      var request =
      http.MultipartRequest(

        "POST",

        Uri.parse(
          "https://beach.adpedia.in/api/stories/create",
        ),
      );

      /// 🔥 HEADERS
      request.headers.addAll({

        "Authorization":
        "Bearer $token",
      });

      /// 🔥 BODY
      request.fields["media_type"] =
          mediaType;

      request.fields["caption"] =
          captionController.text;

      request.fields["description"] =
          descriptionController.text;

      /// 🔥 FILE
      request.files.add(

        await http.MultipartFile
            .fromPath(

          "media",

          selectedFile!.path,
        ),
      );

      /// 🔥 SEND
      var response =
      await request.send();

      var responseData =
      await response.stream.bytesToString();

      final data =
      jsonDecode(responseData);

      print(data);

      setState(() {

        loading = false;
      });

      if (data["Status"] == true) {

        ScaffoldMessenger.of(context)
            .showSnackBar(

          SnackBar(

            content:
            Text(data["Message"]),
          ),
        );

        Navigator.pop(context);
      }

    } catch (e) {

      setState(() {

        loading = false;
      });

      print(e);

      ScaffoldMessenger.of(context)
          .showSnackBar(

        SnackBar(
          content: Text("$e"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.black,

      appBar: AppBar(

        backgroundColor: Colors.black,

        elevation: 0,

        title: const Text(

          "Create Story",

          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(15),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            /// 🔥 MEDIA PICKER
            GestureDetector(

              onTap: () {

                pickMedia();
              },

              child: Container(

                width: double.infinity,

                height: 300,

                decoration: BoxDecoration(

                  color: Colors.grey.shade900,

                  borderRadius:
                  BorderRadius.circular(20),

                  border: Border.all(
                    color: Colors.grey.shade800,
                  ),
                ),

                child: selectedFile == null

                    ? Column(

                  mainAxisAlignment:
                  MainAxisAlignment.center,

                  children: const [

                    Icon(

                      Icons.add_photo_alternate,

                      color: Colors.white,

                      size: 60,
                    ),

                    SizedBox(height: 15),

                    Text(

                      "Select Image or Video",

                      style: TextStyle(

                        color: Colors.white,

                        fontSize: 16,
                      ),
                    )
                  ],
                )

                    : ClipRRect(

                  borderRadius:
                  BorderRadius.circular(20),

                  child: mediaType ==
                      "image"

                      ? Image.file(

                    selectedFile!,

                    fit: BoxFit.cover,

                    width:
                    double.infinity,

                    height:
                    double.infinity,
                  )

                      : Stack(

                    alignment:
                    Alignment.center,

                    children: [

                      Container(

                        color:
                        Colors.black,
                      ),

                      const Icon(

                        Icons
                            .play_circle_fill,

                        color:
                        Colors.white,

                        size: 70,
                      ),

                      Positioned(

                        bottom: 15,

                        child: Text(

                          selectedFile!
                              .path
                              .split("/")
                              .last,

                          style:
                          const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 MEDIA TYPE
            Container(

              padding:
              const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),

              decoration: BoxDecoration(

                color: Colors.grey.shade900,

                borderRadius:
                BorderRadius.circular(15),
              ),

              child: Row(

                children: [

                  const Text(

                    "Media Type : ",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),

                  Text(

                    mediaType.toUpperCase(),

                    style: const TextStyle(

                      color: Colors.blue,

                      fontWeight:
                      FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 CAPTION
            TextField(

              controller: captionController,

              style: const TextStyle(
                color: Colors.white,
              ),

              decoration: InputDecoration(

                hintText: "Caption",

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
                  BorderRadius.circular(15),

                  borderSide:
                  BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 DESCRIPTION
            TextField(

              controller:
              descriptionController,

              style: const TextStyle(
                color: Colors.white,
              ),

              maxLines: 5,

              decoration: InputDecoration(

                hintText: "Description",

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
                  BorderRadius.circular(15),

                  borderSide:
                  BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// 🔥 BUTTON
            SizedBox(

              width: double.infinity,

              height: 55,

              child: ElevatedButton(

                onPressed: loading

                    ? null

                    : () {

                  createStory();
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

                child: loading

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

                  "Create Story",

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
}