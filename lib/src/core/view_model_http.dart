import 'package:flutter_boot/http.dart';
import 'view_model.dart';
import 'view_model_action.dart';


class HttpViewModel extends ViewModel with ActionVmMixin, AnHttpMixin {
  HttpViewModel({super.key});
}
