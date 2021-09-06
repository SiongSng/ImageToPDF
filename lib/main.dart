// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, unnecessary_null_comparison, avoid_function_literals_in_foreach_calls, sized_box_for_whitespace, non_constant_identifier_names, dead_code

import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '圖片轉PDF',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<bool> ImageToPDF() async {
    final pdf = pw.Document();

    await Future.delayed(Duration(seconds: 1));

    await Future.forEach(files, (XFile file) async {});

    for (XFile file in files) {
      final image = pw.MemoryImage(
        await file.readAsBytes(),
      );

      pdf.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image),
            );
          }));
    }

    XFile pdfFile =
        XFile.fromData(await pdf.save(), name: 'ImagePDF.pdf', mimeType: 'pdf');
    pdfFile.saveTo("");
    return true;
  }

  List<XFile> files = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("圖片轉PDF"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () async {
                  if (files.isEmpty) {
                    showCupertinoDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                              title: Text("您尚未新增圖片檔，因此無法轉換"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("確定"),
                                )
                              ]);
                        });
                  } else {
                    showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return FutureBuilder(
                              future: ImageToPDF(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return AlertDialog(
                                      title: Text("轉檔完成"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("確定"),
                                        )
                                      ]);
                                } else {
                                  return AlertDialog(
                                    title: Text("轉檔中，請稍後..."),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        CircularProgressIndicator(),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              });
                        });
                  }
                },
                child: Text(
                  "轉檔為PDF",
                  style: TextStyle(fontSize: 35),
                )),
            Container(
              height: MediaQuery.of(context).size.height / 1.3,
              child: GridView.builder(
                  controller: ScrollController(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 1.35, crossAxisCount: 5),
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    late var setGridState;
                    bool onHover = false;
                    XFile file = files[index];
                    Size size = MediaQuery.of(context).size;

                    return Card(
                        child: InkWell(
                      onHover: (value) {
                        if (value) {
                          setGridState(() {
                            onHover = true;
                          });
                        } else {
                          setGridState(() {
                            onHover = false;
                          });
                        }
                      },
                      onTap: () {
                        showCupertinoDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "圖片預覽",
                                      ),
                                      Flexible(
                                        child: Align(
                                          alignment: Alignment.topRight,
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(Icons.close),
                                            tooltip: "關閉",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      FutureBuilder(
                                          future: file.readAsBytes(),
                                          builder: (context,
                                              AsyncSnapshot imageSnapshot) {
                                            if (imageSnapshot.hasData) {
                                              return Image.memory(
                                                imageSnapshot.data,
                                                width: size.width / 2,
                                                height: size.height / 2,
                                              );
                                            } else {
                                              return CircularProgressIndicator();
                                            }
                                          }),
                                      Text(file.name),
                                    ],
                                  ),
                                ));
                      },
                      child: GridTile(
                        child: Column(
                          children: [
                            FutureBuilder(
                                future: file.readAsBytes(),
                                builder:
                                    (context, AsyncSnapshot imageSnapshot) {
                                  if (imageSnapshot.hasData) {
                                    return Expanded(
                                      child: Image.memory(
                                        imageSnapshot.data,
                                        fit: BoxFit.contain,
                                      ),
                                    );
                                  } else {
                                    return CircularProgressIndicator();
                                  }
                                }),
                            Text(file.name),
                            StatefulBuilder(builder: (context, setGridState_) {
                              setGridState = setGridState_;
                              if (onHover) {
                                return IconButton(
                                  onPressed: () {
                                    files.removeAt(index);
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.delete),
                                  iconSize: 25,
                                  tooltip: "移除",
                                );
                              } else {
                                return Container();
                              }
                            })
                          ],
                        ),
                      ),
                    ));
                  }),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            files.addAll(await FileSelectorPlatform.instance.openFiles(
              acceptedTypeGroups: [
                XTypeGroup(label: "圖片", extensions: ["jpg", "png"])
              ],
            ));
            setState(() {});
          },
          tooltip: "新增圖片",
          child: Icon(Icons.add),
        ),
        persistentFooterButtons: [
          Center(
              child: Text(
            "Copyright © SiongSng 2021  All Right Reserved.\n版權所有 菘菘 2021 保留所有權利。",
            textAlign: TextAlign.center,
          ))
        ]);
  }
}
