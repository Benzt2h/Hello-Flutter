import 'package:flutteronline/redux/appReducer.dart';
import 'package:flutteronline/redux/product/productReducer.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

@immutable
class GetProductAction {
  final ProductState productState;

  GetProductAction(this.productState);
}

getProductAction(Store<AppState> store) async {
  try {
    store.dispatch(GetProductAction(ProductState(isLoading: true)));
    var url = 'https://api.codingthailand.com/api/course';
    var res = await http.get(url);
    if (res.statusCode == 200) {
      final Map<String, dynamic> product = convert.jsonDecode(res.body);
      /*setState(() {
          course = product['data'];
          isLoading = false;
        });*/
      store.dispatch(GetProductAction(
          ProductState(course: product['data'], isLoading: false)));
    } else {
      store.dispatch(
          GetProductAction(ProductState(course: [], isLoading: false)));
      print('error from backend ${res.statusCode}');
    }
  } catch (e) {
    store
        .dispatch(GetProductAction(ProductState(course: [], isLoading: false)));
  }
}
