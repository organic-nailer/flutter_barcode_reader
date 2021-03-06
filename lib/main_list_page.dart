import 'package:barcode_reader_ml/main.dart';
import 'package:barcode_reader_ml/scan_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:intl/intl.dart";

class MainListPage extends ConsumerWidget {
  const MainListPage({Key? key}) : super(key: key);

  static final formatter = DateFormat("yyyy/MM/dd hh:mm");

  @override
  Widget build(context, watch) {
    final viewModel = watch(barcodeViewModelProvider.notifier);
    final barcodes = watch(barcodeViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Barcode Memo"),
      ),
      body: ListView.builder(
        itemCount: barcodes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(barcodes[index].value),
            subtitle: Text(formatter.format(barcodes[index].createdAt)),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline),
              color: Colors.red,
              onPressed: () {
                viewModel.onRemoveClicked(barcodes[index]);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showPhotoDialog(context);
        },
      ),
    );
  }

  void showPhotoDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              children: [
                SimpleDialogOption(
                  onPressed: () async {
                    final res = await Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => ScanPage()));
                    if (res is String) {
                      await context
                          .read(barcodeViewModelProvider.notifier)
                          .addBarcode(res);
                      Navigator.pop(context);
                    }
                  },
                  child: ListTile(
                    title: Text("???????????????"),
                    trailing: Icon(Icons.photo_camera),
                  ),
                )
              ],
            ));
  }
}
