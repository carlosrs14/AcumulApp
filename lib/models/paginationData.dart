import 'package:acumulapp/models/user_card.dart';

class PaginationData {
  List<dynamic> list;
  int totalPages;
  int totalItems;
  int currentPage;
  int pageSize;

  PaginationData(
    this.list,
    this.totalPages,
    this.totalItems,
    this.currentPage,
    this.pageSize,
  );
}
