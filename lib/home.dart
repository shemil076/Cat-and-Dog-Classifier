import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final  picker = ImagePicker();
    late File _image;
    bool _loading = false;

  pickImage() async {
    var image = await picker.getImage(source: ImageSource.camera);

     if (image == null) return null;

     setState(() {
       _image = File(image.path);
     });
  }


  pickGalleryImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);

    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
  }


  void initState() {
    super.initState();
    _loading = true;
    loadModel().then((value){

    });
  }

  void dispose() {
    Tflite.close();
    _loading = false;
  }

  loadModel() async {
    await Tflite.loadModel(model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(path: image.path, numResults: 2, threshold: 0.5, imageMean: 127.5, imageStd: 127.5);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF101010),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 100),
              Text(
                'Teachable machine CNN',
                style: TextStyle(
                  color: Color(0xFFEEDA28),
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 6),
              Text('Detect Dogs and Cats', style: TextStyle(color: Color(0xFFE99600),
              fontWeight: FontWeight.w500, fontSize:28
              )),
              SizedBox(height: 50),
              Center(
                child: Container(
                  width: 300,
                    child: Column(
                      children: [
                        Image.asset('assets/cat.png'),
                        SizedBox(height: 50),
                      ],
                    ),
                ),
              ),
              Container(
                width : MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(onTap: pickImage,
                    child: Container(
                      width : MediaQuery.of(context).size.width -260,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 24, vertical: 17),
                      decoration:  BoxDecoration(
                        color: Color(0xFFE99600),
                        borderRadius: BorderRadius.circular(6),
                      ),
                        child: Text('Take a photo',
                        style: TextStyle(color: Colors.white,)),
                    ),
                    ),
                    SizedBox(
                      width:20
                    ),
                    GestureDetector(onTap: pickGalleryImage,
                      child: Container(
                        width : MediaQuery.of(context).size.width -260,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            horizontal: 24, vertical: 17),
                        decoration:  BoxDecoration(
                          color: Color(0xFFE99600),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text('Camera Roll',
                            style: TextStyle(color: Colors.white,)),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
