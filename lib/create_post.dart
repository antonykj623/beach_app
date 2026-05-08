import 'dart:convert';
import 'dart:io';

import 'package:beach_app/utilities/Utils.dart';
import 'package:beach_app/utilities/native_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() =>
      _CreatePostScreenState();
}

class _CreatePostScreenState
    extends State<CreatePostScreen> {

  /// 🔥 CONTROLLERS
  final TextEditingController captionController =
  TextEditingController();

  final TextEditingController locationController =
  TextEditingController();

  /// 🔥 POST TYPE
  String postType = "photo";

  /// 🔥 PRIVACY
  String privacy = "public";

  /// 🔥 FILES
  File? mediaFile;

  File? thumbnailFile;

  /// 🔥 LOADING
  bool loading = false;

  /// 🔥 VIDEO PLAYER
  VideoPlayerController? videoController;

  /// 🔥 TOKEN
  String token = "";

  /// 🔥 HASHTAGS
  List hashtags = [];

  bool hashtagLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getToken();

  }

  getToken()async{

    String? v=await NativeStorage.getValue(Utils.token);
    token=v.toString();
  }

  @override
  void dispose() {

    videoController?.dispose();

    captionController.dispose();

    locationController.dispose();

    super.dispose();
  }

  /// 🔥 SEARCH HASHTAG API
  Future<void> searchHashtag(
      String value) async {

    try {

      if (!value.contains("#")) {

        setState(() {

          hashtags = [];
        });

        return;
      }

      /// 🔥 GET LAST WORD
      List words = value.split(" ");

      String lastWord = words.last;

      if (!lastWord.startsWith("#")) {

        setState(() {

          hashtags = [];
        });

        return;
      }

      String query =
      lastWord.replaceAll("#", "");

      if (query.isEmpty) {

        setState(() {

          hashtags = [];
        });

        return;
      }

      setState(() {

        hashtagLoading = true;
      });

      final response = await http.get(

        Uri.parse(
          "https://beach.adpedia.in/api/hashtags/search?q=$query",
        ),
          headers: {"Authorization":"Bearer "+token!}
      );

      final data =
      jsonDecode(response.body);

      if (data["status"] == true) {

        setState(() {

          hashtags = data["data"];
        });
      }

    } catch (e) {

      print(e);
    }

    setState(() {

      hashtagLoading = false;
    });
  }

  /// 🔥 SELECT HASHTAG
  void selectHashtag(String hashtag) {

    List words =
    captionController.text.split(" ");

    words.removeLast();

    words.add(hashtag);

    captionController.text =
    "${words.join(" ")} ";

    captionController.selection =
        TextSelection.fromPosition(

          TextPosition(
            offset:
            captionController.text.length,
          ),
        );

    setState(() {

      hashtags = [];
    });
  }

  /// 🔥 PICK MEDIA
  Future<void> pickMedia() async {

    try {

      FilePickerResult? result =
      await FilePicker.pickFiles(

        type: postType == "photo"

            ? FileType.image

            : FileType.video,
      );

      if (result != null) {

        mediaFile =
            File(result.files.single.path!);

        /// 🔥 VIDEO
        if (postType != "photo") {

          videoController =
              VideoPlayerController.file(
                mediaFile!,
              );

          await videoController!
              .initialize();

          videoController!.play();

          videoController!
              .setLooping(true);
        }

        setState(() {});
      }

    } catch (e) {

      print(e);
    }
  }

  /// 🔥 PICK THUMBNAIL
  Future<void> pickThumbnail() async {

    try {

      FilePickerResult? result =
      await FilePicker.pickFiles(

        type: FileType.image,
      );

      if (result != null) {

        thumbnailFile =
            File(result.files.single.path!);

        setState(() {});
      }

    } catch (e) {

      print(e);
    }
  }

  /// 🔥 CREATE POST
  Future<void> createPost() async {

    if (mediaFile == null) {

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
          "https://beach.adpedia.in/api/posts/create",
        ),
      );

      /// 🔥 HEADERS
      request.headers.addAll({

        "Authorization":
        "Bearer $token",
      });

      /// 🔥 FIELDS
      request.fields["post_type"] =
          postType;

      request.fields["caption"] =
          captionController.text;

      request.fields["location"] =
          locationController.text;

      request.fields["privacy"] =
          privacy;

      request.fields["duration"] = "";

      /// 🔥 MEDIA
      request.files.add(

        await http.MultipartFile
            .fromPath(

          "media",

          mediaFile!.path,
        ),
      );

      /// 🔥 THUMBNAIL
      if (thumbnailFile != null) {

        request.files.add(

          await http.MultipartFile
              .fromPath(

            "thumbnail",

            thumbnailFile!.path,
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

        /// 🔥 CLEAR
        setState(() {

          mediaFile = null;

          thumbnailFile = null;

          hashtags = [];

          captionController.clear();

          locationController.clear();
        });
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

      loading = false;
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

          "Create Post",

          style: TextStyle(
            color: Colors.white,
          ),
        ),

        actions: [

          loading

              ? const Padding(

            padding:
            EdgeInsets.all(15),

            child:
            CircularProgressIndicator(),
          )

              : TextButton(

            onPressed: () {

              createPost();
            },

            child: const Text(

              "Share",

              style: TextStyle(

                color: Colors.blue,

                fontSize: 16,

                fontWeight:
                FontWeight.bold,
              ),
            ),
          )
        ],
      ),

      body: SingleChildScrollView(

        child: Padding(

          padding:
          const EdgeInsets.all(15),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

              /// 🔥 MEDIA
              GestureDetector(

                onTap: () {

                  pickMedia();
                },

                child: Container(

                  height: 300,

                  width: double.infinity,

                  decoration: BoxDecoration(

                    color:
                    Colors.grey.shade900,

                    borderRadius:
                    BorderRadius.circular(
                        15),
                  ),

                  child: mediaFile == null

                      ? Column(

                    mainAxisAlignment:
                    MainAxisAlignment
                        .center,

                    children: const [

                      Icon(

                        Icons.add,

                        color:
                        Colors.white,

                        size: 60,
                      ),

                      SizedBox(height: 10),

                      Text(

                        "Select Media",

                        style:
                        TextStyle(

                          color:
                          Colors.white,
                        ),
                      )
                    ],
                  )

                      : ClipRRect(

                    borderRadius:
                    BorderRadius
                        .circular(15),

                    child: postType ==
                        "photo"

                        ? Image.file(

                      mediaFile!,

                      fit:
                      BoxFit.cover,
                    )

                        : videoController !=
                        null &&
                        videoController!
                            .value
                            .isInitialized

                        ? AspectRatio(

                      aspectRatio:
                      videoController!
                          .value
                          .aspectRatio,

                      child:
                      VideoPlayer(
                        videoController!,
                      ),
                    )

                        : const Center(

                      child:
                      CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 🔥 TYPE
              Row(

                children: [

                  buildType("photo"),

                  const SizedBox(width: 10),

                  buildType("video"),

                  const SizedBox(width: 10),

                  buildType("reel"),
                ],
              ),

              const SizedBox(height: 20),

              /// 🔥 CAPTION
              TextField(

                controller:
                captionController,

                onChanged: (value) {

                  searchHashtag(value);
                },

                style: const TextStyle(
                  color: Colors.white,
                ),

                maxLines: 4,

                decoration: InputDecoration(

                  hintText:
                  "Write caption with hashtags",

                  hintStyle:
                  TextStyle(

                    color:
                    Colors.grey.shade500,
                  ),

                  filled: true,

                  fillColor:
                  Colors.grey.shade900,

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(
                        12),

                    borderSide:
                    BorderSide.none,
                  ),
                ),
              ),

              /// 🔥 HASHTAG SUGGESTIONS
              if (hashtags.isNotEmpty)

                Container(

                  margin:
                  const EdgeInsets.only(
                    top: 10,
                  ),

                  padding:
                  const EdgeInsets.all(10),

                  decoration: BoxDecoration(

                    color:
                    Colors.grey.shade900,

                    borderRadius:
                    BorderRadius.circular(
                        12),
                  ),

                  child: Column(

                    children: List.generate(

                      hashtags.length,

                          (index) {

                        final item =
                        hashtags[index];

                        return ListTile(

                          onTap: () {

                            selectHashtag(
                              item["hashtag"],
                            );
                          },

                          leading: const Icon(

                            Icons.tag,

                            color:
                            Colors.white,
                          ),

                          title: Text(

                            item["hashtag"],

                            style:
                            const TextStyle(
                              color:
                              Colors.white,
                            ),
                          ),

                          subtitle: Text(

                            "${item["post_count"]} posts",

                            style:
                            const TextStyle(
                              color:
                              Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              /// 🔥 LOCATION
              TextField(

                controller:
                locationController,

                style: const TextStyle(
                  color: Colors.white,
                ),

                decoration: InputDecoration(

                  hintText:
                  "Add location",

                  hintStyle:
                  TextStyle(

                    color:
                    Colors.grey.shade500,
                  ),

                  prefixIcon: const Icon(

                    Icons.location_on,

                    color: Colors.white,
                  ),

                  filled: true,

                  fillColor:
                  Colors.grey.shade900,

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(
                        12),

                    borderSide:
                    BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 🔥 PRIVACY
              Container(

                padding:
                const EdgeInsets.symmetric(
                  horizontal: 15,
                ),

                decoration: BoxDecoration(

                  color:
                  Colors.grey.shade900,

                  borderRadius:
                  BorderRadius.circular(
                      12),
                ),

                child: DropdownButton(

                  dropdownColor:
                  Colors.black,

                  value: privacy,

                  isExpanded: true,

                  underline:
                  const SizedBox(),

                  style: const TextStyle(
                    color: Colors.white,
                  ),

                  items: const [

                    DropdownMenuItem(

                      value: "public",

                      child:
                      Text("Public"),
                    ),

                    DropdownMenuItem(

                      value: "private",

                      child:
                      Text("Private"),
                    ),
                  ],

                  onChanged: (value) {

                    setState(() {

                      privacy = value!;
                    });
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// 🔥 THUMBNAIL
              if (postType != "photo")

                Column(

                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,

                  children: [

                    const Text(

                      "Thumbnail",

                      style: TextStyle(

                        color:
                        Colors.white,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(

                      onTap: () {

                        pickThumbnail();
                      },

                      child: Container(

                        height: 120,

                        width: 120,

                        decoration:
                        BoxDecoration(

                          color: Colors
                              .grey
                              .shade900,

                          borderRadius:
                          BorderRadius
                              .circular(
                              12),
                        ),

                        child:
                        thumbnailFile == null

                            ? const Icon(

                          Icons.image,

                          color:
                          Colors.white,
                        )

                            : ClipRRect(

                          borderRadius:
                          BorderRadius
                              .circular(
                              12),

                          child:
                          Image.file(

                            thumbnailFile!,

                            fit: BoxFit
                                .cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 TYPE BUTTON
  Widget buildType(String type) {

    bool selected =
        postType == type;

    return Expanded(

      child: GestureDetector(

        onTap: () {

          setState(() {

            postType = type;

            mediaFile = null;

            thumbnailFile = null;
          });
        },

        child: Container(

          height: 45,

          decoration: BoxDecoration(

            color: selected

                ? Colors.blue

                : Colors.grey.shade900,

            borderRadius:
            BorderRadius.circular(12),
          ),

          child: Center(

            child: Text(

              type.toUpperCase(),

              style: const TextStyle(

                color: Colors.white,

                fontWeight:
                FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}