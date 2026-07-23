import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CertificateService {
  Future<void> generateAndShowCertificate(String userName, String courseName, String dateStr) async {
    final pdf = pw.Document();

    // Load custom fonts or use default
    final font = await PdfGoogleFonts.openSansRegular();
    final fontBold = await PdfGoogleFonts.openSansBold();
    
    // We can also load an image logo here if we had one in assets
    // final ByteData bytes = await rootBundle.load('assets/images/logo.png');
    // final Uint8List logoData = bytes.buffer.asUint8List();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(40),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.green800, width: 10),
            ),
            child: pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'CERTIFICATE OF COMPLETION',
                    style: pw.TextStyle(
                      font: fontBold,
                      fontSize: 40,
                      color: PdfColors.green800,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'This is to certify that',
                    style: pw.TextStyle(font: font, fontSize: 20, color: PdfColors.grey700),
                  ),
                  pw.SizedBox(height: 15),
                  pw.Text(
                    userName,
                    style: pw.TextStyle(font: fontBold, fontSize: 32, color: PdfColors.black),
                  ),
                  pw.SizedBox(height: 15),
                  pw.Text(
                    'has successfully completed the cybersecurity course',
                    style: pw.TextStyle(font: font, fontSize: 20, color: PdfColors.grey700),
                  ),
                  pw.SizedBox(height: 15),
                  pw.Text(
                    courseName,
                    style: pw.TextStyle(font: fontBold, fontSize: 28, color: PdfColors.green900),
                  ),
                  pw.SizedBox(height: 40),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        children: [
                          pw.Text(dateStr, style: pw.TextStyle(font: font, fontSize: 18)),
                          pw.Container(width: 150, height: 1, color: PdfColors.black),
                          pw.Text('Date', style: pw.TextStyle(font: font, fontSize: 14)),
                        ],
                      ),
                      pw.Column(
                        children: [
                          pw.Text('CyberGuardian Platform', style: pw.TextStyle(font: font, fontSize: 18)),
                          pw.Container(width: 200, height: 1, color: PdfColors.black),
                          pw.Text('Authorized Signature', style: pw.TextStyle(font: font, fontSize: 14)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: '${courseName}_Certificate.pdf',
    );
  }
}


