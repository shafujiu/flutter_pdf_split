# flutter_pdf_split

A flutter plugin to split a multipage PDF file into multiple PDF files.


"splitToMerge" split some multipage PDF's some pages to meger a new PDF file;
| android not support, my android skill is very poor, help pull request.


## Usage

```dart
import 'package:flutter_pdf_split/flutter_pdf_split.dart';

FlutterPdfSplitResult splitResult = await FlutterPdfSplit.split(
    FlutterPdfSplitArgs(filePath, _outDirectory),
);

 String? result = await FlutterPdfSplit.splitToMerge(
                filePath: newFile.path,
                outpath: outPath,
                pageNumbers: [1, 2],
);

```

The multiple page pdf from 'filePath' will be split into multiple pdf (one for each page) into the directory '_outDirectory'.

