import 'package:acumulapp/models/business.dart';
import 'package:acumulapp/models/user.dart';

class BusinessDetailsArguments {
  final Business business;
  final User user;

  BusinessDetailsArguments({required this.business, required this.user});
}
