import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

class PdfService {
  String _sanitizeFileName(String fileName) {
    return fileName
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '_')
        .toLowerCase();
  }

  Future<void> generateIngredientsList(
      String title, List<dynamic> ingredients) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              title,
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Ingredients:',
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),
            ...ingredients.map((ingredient) => pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Row(
                    children: [
                      pw.Container(
                        width: 10,
                        height: 10,
                        decoration: pw.BoxDecoration(
                          shape: pw.BoxShape.circle,
                          border: pw.Border.all(),
                        ),
                      ),
                      pw.SizedBox(width: 10),
                      pw.Text(ingredient['original']),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final sanitizedTitle = _sanitizeFileName(title);
    final file = File('${output.path}/ingredientes_$sanitizedTitle.pdf');

    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }
}
