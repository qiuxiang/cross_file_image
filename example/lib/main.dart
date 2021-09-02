import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cross_file_image/cross_file_image.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  XFile? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: file == null
            ? Text('Click floating button to pick some image')
            : Image(image: XFileImage(file!)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final file =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          setState(() => this.file = file);
        },
        tooltip: 'Pick Image',
        child: Icon(Icons.add),
      ),
    );
  }
}
