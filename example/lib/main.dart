import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cross_file_image/cross_file_image.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  XFile? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: file == null
            ? const Text('Click floating button to pick some image')
            : Image(image: XFileImage(file!)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final file =
              await ImagePicker().pickImage(source: ImageSource.gallery);
          setState(() => this.file = file);
        },
        tooltip: 'Pick Image',
        child: const Icon(Icons.add),
      ),
    );
  }
}
