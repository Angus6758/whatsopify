import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:seller_management/main.export.dart';

extension PDFEx on pw.Context {
  pw.ThemeData get pdfTheme => pw.Theme.of(this);
}

class PDFPages {
  static pw.Widget orderPDFPage(
    pw.Context context,
    pw.Image? stamp,
    OrderModel order,
  ) {
    final carts = [...order.details];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      mainAxisAlignment: pw.MainAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.RichText(
              textAlign: pw.TextAlign.right,
              text: pw.TextSpan(
                text: 'INVOICE',
                style: context.pdfTheme.header2,
                children: [
                  pw.TextSpan(
                    text: '\n${order.orderId}',
                    style: context.pdfTheme.defaultTextStyle,
                  ),
                ],
              ),
            )
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.start,
          children: [
            pw.Expanded(
              flex: 2,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(height: 15),
                  _name(order.billing?.fullName ?? '',
                      order.billing?.phone ?? ''),
                  if (order.billing != null) ...[
                    pw.SizedBox(height: 10),
                    _address(order.billing!.address),
                  ],
                ],
              ),
            ),
            pw.SizedBox(width: 10),
            pw.Expanded(
              flex: 1,
              child: _summery(
                order.date,
                order.paymentStatus,
                order.shipping?.name,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 15),
        pw.Table(
          columnWidths: {
            0: const pw.FlexColumnWidth(2.5),
            1: const pw.FlexColumnWidth(1),
            2: const pw.FlexColumnWidth(1),
            3: const pw.FlexColumnWidth(1),
          },
          border: pw.TableBorder.all(),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey300),
              children: [
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  child: pw.Text('Item'),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(3),
                  child: pw.Center(
                    child: pw.Text('Quantity'),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(3),
                  child: pw.Center(
                    child: pw.Text('Rate'),
                  ),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.all(3),
                  child: pw.Center(
                    child: pw.Text('Amount'),
                  ),
                ),
              ],
            ),
            ...List.generate(
              carts.length,
              (index) {
                final item = carts[index];
                return _table(item.productName, item.quantity, item.price);
              },
            ),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.SizedBox(
          width: 200,
          child: pw.Table(
            columnWidths: const {
              0: pw.FlexColumnWidth(2.0),
              1: pw.FlexColumnWidth(1.0)
            },
            border: pw.TableBorder.all(),
            children: [
              _paymentSummeryRow(
                  'Subtotal:', order.orderAmount.formate(useSymbol: false)),
              _paymentSummeryRow(
                'Delivery charge:',
                '+ ${order.shippingCharge.formate(useSymbol: false)}',
              ),
              _paymentSummeryRow(
                  'Total:', order.finalAmount.formate(useSymbol: false)),
            ],
          ),
        ),
        if (stamp != null) _fullPaidStamp(stamp),
      ],
    );
  }
}

//!============================ Methods ===============================================

pw.Align _fullPaidStamp(pw.Image stamp) {
  return pw.Align(
    alignment: pw.Alignment.topLeft,
    child: pw.Container(
      margin: const pw.EdgeInsets.all(10),
      child: stamp,
    ),
  );
}

pw.TableRow _paymentSummeryRow(String left, String right) {
  return pw.TableRow(
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Text(left),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Text(
          right,
          textAlign: pw.TextAlign.right,
        ),
      ),
    ],
  );
}

pw.TableRow _table(String name, num quantity, num price) {
  return pw.TableRow(
    verticalAlignment: pw.TableCellVerticalAlignment.middle,
    children: [
      pw.Padding(
        padding: const pw.EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 3,
        ),
        child: pw.Text(name),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(5),
        child: pw.Text(
          quantity.toString(),
          textAlign: pw.TextAlign.right,
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Center(
          child: pw.Text(price.formate(useSymbol: false)),
        ),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(3),
        child: pw.Center(
          child: pw.Text((price * quantity).formate(useSymbol: false)),
        ),
      ),
    ],
  );
}

pw.Column _summery(String orderDate, String payStatus, String? ship) {
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.end,
    children: [
      _date(orderDate),
      pw.SizedBox(height: 5),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Payment status:'),
          pw.Text(payStatus),
        ],
      ),
      pw.SizedBox(height: 5),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Shipping:'),
          if (ship != null) pw.Text(ship),
        ],
      ),
      pw.SizedBox(height: 5),
    ],
  );
}

pw.Row _date(String orderDate) {
  return pw.Row(
    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
    children: [
      pw.Text('Date:', textAlign: pw.TextAlign.right),
      pw.Text(orderDate),
    ],
  );
}

pw.SizedBox _address(String address) {
  return pw.SizedBox(
    // width: 140,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Address:'),
        pw.SizedBox(height: 5),
        pw.Text('$address,'),
      ],
    ),
  );
}

pw.SizedBox _name(String name, String phone) {
  return pw.SizedBox(
    // width: 100,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      mainAxisAlignment: pw.MainAxisAlignment.center,
      children: [
        pw.Text(
          'Name & Contact:',
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 5),
        pw.Text(name),
        pw.SizedBox(height: 3),
        pw.Text(phone),
      ],
    ),
  );
}
