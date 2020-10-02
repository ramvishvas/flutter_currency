import 'package:flutter/material.dart';

class CryptoWidget extends StatelessWidget {
  final List<MaterialColor> colors;
  final List currencies;

  const CryptoWidget(
      {Key key, @required this.currencies, @required this.colors})
      : super(key: key);

  Widget _getSubtitleText(double priceUSD, double percentageChange) {
    var priceTextWidget = TextSpan(
      text: "\$$priceUSD\n",
      style: TextStyle(
        color: Colors.black87,
      ),
    );

    var perChangeWidget;

    if (percentageChange > 0) {
      perChangeWidget = TextSpan(
        text: "$percentageChange% - 1 hour ago ",
        style: TextStyle(
          color: Colors.green,
        ),
      );
    } else {
      perChangeWidget = TextSpan(
        text: "$percentageChange% - 1 hour ago ",
        style: TextStyle(
          color: Colors.red,
        ),
      );
    }

    return RichText(
      text: TextSpan(children: [priceTextWidget, perChangeWidget]),
    );
  }

  Widget _getCurrencyItem(Map currency, MaterialColor color) {
    var priceUSD = double.parse("${currency["quote"]["USD"]["price"]}");
    var percentageChange =
        double.parse("${currency["quote"]["USD"]["percent_change_1h"]}");

    return ListTile(
      leading: CircleAvatar(
        radius: 32,
        backgroundColor: color,
        child: Text(
          currency["symbol"],
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
            color: Colors.white,
          ),
        ),
      ),
      title: Text(currency["name"]),
      subtitle: _getSubtitleText(priceUSD, percentageChange),
      isThreeLine: true,
    );
  }

  Widget _cryptoWidget() {
    return currencies == null
        ? Center(child: CircularProgressIndicator())
        : currencies.length == 0
            ? Center(
                child: Text('No Data Found.'),
              )
            : ListView.builder(
                itemCount: currencies.length,
                itemBuilder: (BuildContext context, int index) {
                  var currency = currencies[index];
                  var color = colors[index % colors.length];
                  return _getCurrencyItem(currency, color);
                },
              );
  }

  @override
  Widget build(BuildContext context) {
    return _cryptoWidget();
  }
}
