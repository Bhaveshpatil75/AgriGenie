import 'dart:io';
import 'package:cosine/pages/bot_chat_page.dart';
import 'package:cosine/pages/botchat.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickPagedemo extends StatefulWidget {
  const ImagePickPagedemo({super.key});

  @override
  State<ImagePickPagedemo> createState() => _ImagePickPagedemoState();
}

class _ImagePickPagedemoState extends State<ImagePickPagedemo> {
  XFile? _mediaFileList;
  final ImagePicker _picker = ImagePicker();
  String? _retrieveDataError;
  dynamic _pickImageError;

  void _setImageFileListFromFile(XFile? value) {
    _mediaFileList = value;
  }
  Future<void> _onImageButtonPressed(ImageSource source, {
    required BuildContext context,
  }) async {
    if (context.mounted) {
        try {
          final XFile? pickedFile = await _picker.pickImage(
            source: source,
          );
          setState(() {
            _setImageFileListFromFile(pickedFile);
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      }
    }

  Widget _previewImages() {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_mediaFileList != null) {
      return
          Image.file(
            File(_mediaFileList!.path),
            errorBuilder: (BuildContext context, Object error,
                StackTrace? stackTrace) {
              return const Center(
                  child:
                  Text('This image type is not supported'));
            },
          );
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _setImageFileListFromFile(response.file);
      });
    }
    else {
      _retrieveDataError = response.exception!.code;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("picking Image"),
      ),
      body: Center(
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
          future: retrieveLostData(),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return const Text(
                  'You have not yet picked an image.',
                  textAlign: TextAlign.center,
                );
              case ConnectionState.done:
                return _previewImages();
              case ConnectionState.active:
                if (snapshot.hasError) {
                  return Text(
                    'Pick image/video error: ${snapshot.error}}',
                    textAlign: TextAlign.center,
                  );
                } else {
                  return const Text(
                    'You have not yet picked an image.',
                    textAlign: TextAlign.center,
                  );
                }
            }
          },
        )
            : _previewImages(),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          ElevatedButton(onPressed: (){
            Navigator.push(context, (MaterialPageRoute(builder: (_)=>Botchat2(path: _mediaFileList?.path,))));
          }, child: Text("AI2")),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_)=>BotChat(img:_mediaFileList!.path,)));
          },
            child: Text("AI"),
          ),
          ElevatedButton(
            onPressed: () {
              _onImageButtonPressed(ImageSource.gallery, context: context);
            },
            child: const Icon(Icons.photo),
          ),
          if (_picker.supportsImageSource(ImageSource.camera))
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  _onImageButtonPressed(ImageSource.camera, context: context);
                },
                child: const Icon(Icons.camera_alt),
              ),
            ),
        ],
      ),
    );
  }

}

typedef OnPickImageCallback =void Function(
    double? maxWidth, double? maxHeight, int? quality, int? limit);