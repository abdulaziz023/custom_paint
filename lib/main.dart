import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frosh/test.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(
    MaterialApp(
      home: FormDataSendingPage(),
    ),
  );
}

class FormDataSendingPage extends StatefulWidget {
  @override
  _FormDataSendingPageState createState() => _FormDataSendingPageState();
}

class _FormDataSendingPageState extends State<FormDataSendingPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  List<File> _imageFiles = [];

  Future<void> _getImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultipleMedia(
      maxWidth: 800,
      maxHeight: 600,
      imageQuality: 80,
    );

    setState(() {
      _imageFiles =
          pickedFiles.map((pickedFile) => File(pickedFile.path)).toList();
    });
  }

  Future<void> _sendFormData() async {
    try {
      var dio = Dio();
      var formData = FormData();
      formData.fields.addAll([
        MapEntry('name', _nameController.text),
        MapEntry('email', _emailController.text),
      ]);
      for (int i = 0; i < _imageFiles.length; i++) {
        formData.files.add(MapEntry(
          'image$i',
          await MultipartFile.fromFile(_imageFiles[i].path,
              filename: 'image$i.jpg'),
        ));
        print(_imageFiles[i]);
      }

      var response =
          await dio.post('https://example.com/submit-form', data: formData);
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: SizedBox(
                  height: 600,
                  width: double.infinity,
                  child: ColoredBox(
                    color: const Color(0xffF5F5F5),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: CustomScrollView(
                        shrinkWrap: true,
                        slivers: [
                          const SliverToBoxAdapter(
                            child: SizedBox(height: 20),
                          ),
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 1,
                                    crossAxisSpacing: 9,
                                    mainAxisSpacing: 20,
                                    childAspectRatio: 1.7),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                print(_imageFiles);
                                return Material(
                                  elevation: 10,
                                  borderRadius: BorderRadius.circular(15),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: GestureDetector(
                                      onTap: () async {
                                        _getImages();
                                      },
                                      child: SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: ColoredBox(
                                          color: const Color(0xffF5F5F5),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 20),
                                              SvgPicture.asset(
                                                  "assets/icon/Vector.svg"),
                                              const Text(
                                                "Rasm joylash",
                                                style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              const Text(
                                                "10ta rasm gacha / 10mb dan katta bo’lmasligi kerak",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(fontSize: 14),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: 1,
                            ),
                          ),
                          const SliverToBoxAdapter(
                            child: SizedBox(
                                height: 20), // Add your desired spacing here
                          ),
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 20,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: SizedBox(
                                        height: 200,
                                        width: 200,
                                        child: Image.file(
                                          _imageFiles[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        setState(() {
                                          _imageFiles
                                              .remove(_imageFiles[index]);
                                        });
                                      },
                                      child: Align(
                                        alignment: Alignment.topRight,
                                        child: SvgPicture.asset(
                                            "assets/icon/ic_close.svg",
                                            height: 25),
                                      ),
                                    ),
                                    Align(
                                      alignment: const Alignment(-0.9, -1),
                                      child: Text("${index + 1}",
                                          style: const TextStyle(
                                              color: Colors.red, fontSize: 18)),
                                    )
                                  ],
                                );
                              },
                              childCount: _imageFiles.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: LoadingWidget(10, _imageFiles.length)),
                ),
              ),
            ),

            //MANA SHETDAN KODNI TAWEN
          ],
        ),
      ),
    );
  }
}
