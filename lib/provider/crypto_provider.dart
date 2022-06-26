import 'package:crypto_simulator_app/api/crypto_service.dart';
import 'package:crypto_simulator_app/model/quote.dart';
import 'package:crypto_simulator_app/model/quote_detail.dart';
import 'package:flutter/material.dart';

class CryptoProvider extends ChangeNotifier {
  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  void setCurrentIndex(int index) {
    _currentIndex = index;

    notifyListeners();
  }

  PortfolioModel _portfolioModel = PortfolioModel();
  PortfolioModel get portfolioModel => _portfolioModel;

  List<Quote> _watchlistQuotes = [];
  List<Quote> get watchlistQuotes => _watchlistQuotes;

  List<Quote> _portfolioQuotes = [];
  List<Quote> get portfolioQuotes => _portfolioQuotes;

  List<Quote> _marketQuotes = [];
  List<Quote> get marketQuotes => _marketQuotes;

  Quote _currentQuote = Quote();
  Quote get currentQuote => _currentQuote;

  QuoteDetail _quoteDetail = QuoteDetail();
  QuoteDetail get quoteDetail => _quoteDetail;

  void fetchWatchlist() async {
    List<String> symbols = _portfolioModel.watchlist.map((e) => e).toList();
    _watchlistQuotes =
        await CryptoService.fetchQuotesBySymbol(symbols.join(','));

    notifyListeners();
  }

  void fetchPortfolioQuotes() async {
    List<String> symbols = _portfolioModel.coins.map((e) => e.symbol!).toList();
    _portfolioQuotes =
        await CryptoService.fetchQuotesBySymbol(symbols.join(','));

    notifyListeners();
  }

  void fetchQuotes(int count) async {
    _marketQuotes = await CryptoService.fetchQuotes(count);

    notifyListeners();
  }

  void fetchDetail(String symbol, String range, String interval) async {
    _quoteDetail = await CryptoService.fetchDetail(symbol, range, interval);
    _currentQuote = await CryptoService.fetchQuote(symbol);

    notifyListeners();
  }

  bool isHolding(String symbol) {
    List<String> list = _portfolioModel.coins.map((e) => e.symbol!).toList();
    return list.contains(symbol);
  }

  Coin _currentCoin = Coin();
  Coin getCurrentCoin(String symbol, double regularMarketPrice) {
    List<String> list = _portfolioModel.coins.map((e) => e.symbol!).toList();
    if (list.contains(symbol)) {
      _currentCoin = _portfolioModel.coins
          .where((element) => element.symbol == symbol)
          .first;
      _currentCoin.numberOfCoin = _currentCoin.amount! / _currentCoin.price!;
      _currentCoin.change = (_currentCoin.numberOfCoin! * regularMarketPrice);
      double a = _currentCoin.change! - _currentCoin.amount!;
      double b = (_currentCoin.change! + _currentCoin.amount!) / 2;
      double c = a / b;
      _currentCoin.changePercent = c * 100;
    }

    return _currentCoin;
  }

  void init() async {
    double amounts = _portfolioModel.coins
        .map((e) => e.amount!)
        .toList()
        .reduce((value, element) => value + element);
    _portfolioModel.totalBalance = 0.0;
    _portfolioModel.totalChangePercent = 0.0;
    List<String> symbols = _portfolioModel.coins.map((e) => e.symbol!).toList();
    List<Quote> quotes =
        await CryptoService.fetchQuotesBySymbol(symbols.join(','));
    for (var i = 0; i < quotes.length; i++) {
      Coin coin = _portfolioModel.coins[i];
      if (coin.symbol == quotes[i].symbol) {
        double price = quotes[i].regularMarketPrice!;
        double nrOfCoin = (coin.amount! / coin.price!);
        double change = (nrOfCoin * price);

        _portfolioModel.totalBalance = _portfolioModel.totalBalance + change;
        coin.marketPrice = price;
        coin.numberOfCoin = nrOfCoin;
        coin.coinImageUrl = quotes[i].coinImageUrl!;
        coin.shortName = quotes[i].shortName!;
        coin.marketChange = quotes[i].regularMarketChangePercent!;
        coin.change = change;
      }
    }
    double a = _portfolioModel.totalBalance - amounts;
    double b = (_portfolioModel.totalBalance + amounts) / 2;
    double c = a / b;
    _portfolioModel.totalChangePercent = c * 100; // change percent

    notifyListeners();
  }

  void sellQuote(String symbol) {
    List<Coin> coins = _portfolioModel.coins;
    Coin coin = _portfolioModel.coins
        .where((element) => element.symbol == symbol)
        .first;
    coins.remove(coin);
    _portfolioModel.coins = coins;

    notifyListeners();
  }

  void buyQuote(String symbol, int amount) async {
    Quote quote = await CryptoService.fetchQuote(symbol);
    Coin coin = Coin();
    coin.amount = amount.toDouble();
    coin.symbol = quote.symbol;
    coin.price = quote.regularMarketPrice!;
    coin.numberOfCoin = amount * quote.regularMarketPrice!;
    coin.shortName = quote.shortName;
    coin.marketPrice = quote.regularMarketPrice;
    coin.coinImageUrl = quote.coinImageUrl;
    _portfolioModel.coins.add(coin);

    notifyListeners();
  }
}

class PortfolioModel {
  List<Coin> coins = [
    Coin(
      symbol: 'BTC-USD',
      amount: 100,
      price: 22206.79296875,
    ),
    Coin(
      symbol: 'ETH-USD',
      amount: 100,
      price: 1222.662841796875,
    ),
    Coin(
      symbol: 'USDT-USD',
      amount: 100,
      price: 0.99895321345,
    )
  ];
  List<String> watchlist = [
    'NEAR-USD',
    'ETC-USD',
    'ATOM-USD',
    'VET-USD',
    'HBAR-USD',
  ];
  double totalBalance = 0.0;
  double totalChangePercent = 0.0;
}

class Coin {
  String? symbol;
  String? shortName;
  double? amount;
  double? price;
  double? change;
  double? changePercent;
  double? numberOfCoin;
  String? coinImageUrl;
  double? marketPrice;
  double? marketChange;

  Coin({
    this.symbol,
    this.amount,
    this.price,
  });
}
