import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:stock_app/features/stock/model/stock_model.dart';
import 'package:stock_app/data/stocks_data.dart';
import 'package:stock_app/features/stock/ui/screens/buy_sell.dart';

class StocksScreen extends ConsumerWidget {
  const StocksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    StocksData stocksData = StocksData();
    List<StockModel> stocks = [];

    void onClick(StockModel stock) {
      Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
        return BuySell(
          stock: stock,
        );
      }));
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Stocks',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
      body: FutureBuilder(
        future: stocksData.fetchStocks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SpinKitCircle(
                size: 50,
                color: Colors.black,
              ),
            );
          } else {
            return ListView.separated(
              itemCount: snapshot.data!.finance!.result![0].quotes!.length,
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  color: Colors.grey.shade400,
                );
              },
              itemBuilder: (context, index) {
                String? shortName =
                    snapshot.data?.finance?.result?[0].quotes?[index].shortName;
                if (shortName == null) shortName = 'Null';
                String? longName =
                    snapshot.data?.finance?.result?[0].quotes?[index].longName;
                if (longName == null) longName = 'Null';
                double? price = snapshot.data?.finance?.result![0]
                    .quotes?[index].regularMarketPrice;
                if (price == null) price = 0.0;
                double? changeInPrice = snapshot.data?.finance?.result?[0]
                    .quotes?[index].regularMarketChangePercent;
                if (changeInPrice == null) changeInPrice = 0.0;
                String? symbol =
                    snapshot.data?.finance?.result?[0].quotes?[index].symbol;
                if (symbol == null) symbol = 'Null';
                stocks.add(
                  StockModel(
                    shortName: shortName,
                    longName: longName,
                    price: price,
                    changeInPrice: changeInPrice,
                    symbol: symbol,
                  ),
                );
                return ListTile(
                  onTap: () {
                    return onClick(stocks[index]);
                  },
                  contentPadding: const EdgeInsets.all(10),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        child: Text(
                          longName.characters.first,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              shortName,
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              longName,
                              softWrap: true,
                              maxLines: 1,
                              overflow: TextOverflow.fade,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price.toStringAsFixed(2),
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (changeInPrice >= 0)
                        Text(
                          '+${changeInPrice.toStringAsFixed(2)}%',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 15,
                          ),
                        )
                      else
                        Text(
                          '${changeInPrice.toStringAsFixed(2)}%',
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 15,
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}