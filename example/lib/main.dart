import 'dart:io';
import 'package:flutter/services.dart' show rootBundle, ByteData;

import 'package:flutter/material.dart';
import 'package:flutter_pdf_split/flutter_pdf_split.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Plugin example app')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              // 1. 读取 assets 文件内容
              ByteData data = await rootBundle.load('assets/files/pdftestfile.pdf');

              // 2. 获取沙盒目录
              Directory directory = await getApplicationDocumentsDirectory();
              String newPath = '${directory.path}/pdfinput.pdf';

              // 3. 写入沙盒目录
              File newFile = File(newPath);
              await newFile.writeAsBytes(data.buffer.asUint8List());

              // 4. 现在 newFile 就是一个真实的文件，可以用 File 相关 API 处理
              String outPath = '${directory.path}/test_out.pdf';
              String? result = await FlutterPdfSplit.splitToMerge(
                filePath: newFile.path,
                outpath: outPath,
                pageNumbers: [1, 2],
              );
              print(result);
            },
            child: Text('Split to merge'),
          ),
        ),
      ),
    );
  }
}

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   String? _platformVersion = 'Unknown';
//   FlutterPdfSplitResult? _splitResult;
//   String? _outDirectory;

//   static final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//   AndroidDeviceInfo? androidInfo;
//   Future<void> androidDeviceInfo() async {
//     androidInfo = await deviceInfo.androidInfo;
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (Platform.isAndroid) {
//       androidDeviceInfo().whenComplete(() {
//         initPlatformState();
//         askPermission();
//         return null;
//       });
//     }
//   }

//   /// Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     String? platformVersion;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     try {
//       platformVersion = await FlutterPdfSplit.platformVersion;
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (mounted) setState(() => _platformVersion = platformVersion);
//   }

//   Future<void> askPermission() async {
//     if (androidInfo != null) {
//       if (androidInfo!.version.sdkInt! >= 30 && Platform.isAndroid) {
//         await Permission.manageExternalStorage.request();
//       } else if (androidInfo!.version.sdkInt! < 30 && Platform.isAndroid) {
//         await Permission.storage.request();
//       }
//     }
//   }

//   void _openFileExplorer() async {
//     // the output directory must be chosen first
//     if (_outDirectory == null) {
//       return;
//     }

//     FilePickerResult? result = await FilePicker.platform.pickFiles();

//     if (result != null) {
//       PlatformFile file = result.files.first;

//       debugPrint(file.name);
//       debugPrint(file.bytes.toString());
//       debugPrint(file.size.toString());
//       debugPrint(file.extension);
//       debugPrint(file.path);

//       FlutterPdfSplitResult splitResult = await FlutterPdfSplit.split(
//         FlutterPdfSplitArgs(file.path!, _outDirectory!, outFilePrefix: "Test"),
//       );

//       debugPrint(splitResult.toString());

//       if (mounted) setState(() => _splitResult = splitResult);
//     } else {
//       // User canceled the picker
//     }
//   }

//   void _openDirectoryExplorer() async {
//     String? directory = await FilePicker.platform.getDirectoryPath();

//     if (directory != null) {
//       debugPrint(directory);
//       setState(() => _outDirectory = directory);
//     } else {
//       // User canceled the picker
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Plugin example app')),
//         body: SafeArea(
//           child: SingleChildScrollView(
//             child: Container(
//               width: double.maxFinite,
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(14),
//                     child: Text('Running on: $_platformVersion'),
//                   ),
//                   ElevatedButton(
//                     onPressed: _openDirectoryExplorer,
//                     child: Text("Choose output directory"),
//                   ),
//                   ElevatedButton(
//                     onPressed: _outDirectory == null ? null : _openFileExplorer,
//                     child: Text("Choose input PDF file"),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(14),
//                     child: Text(_outDirectory == null
//                         ? "Select directory"
//                         : (_splitResult?.pageCount == null
//                             ? "Select a file"
//                             : 'Splitted pdf: ${_splitResult?.pageCount ?? 0} pages')),
//                   ),
//                   for (String path in _splitResult?.pagePaths ?? []) Text(path)
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
