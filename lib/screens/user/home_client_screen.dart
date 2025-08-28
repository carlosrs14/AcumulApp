import 'package:acumulapp/models/category.dart';
import 'package:acumulapp/models/user.dart';
import 'package:acumulapp/providers/business_provider.dart';
import 'package:acumulapp/providers/category_provider.dart';
import 'package:acumulapp/screens/user/home_client/business_list.dart';
import 'package:acumulapp/screens/user/home_client/business_search_field.dart';
import 'package:acumulapp/screens/user/home_client/category_filter_dropdown.dart';
import 'package:acumulapp/widgets/pagination.dart';
import 'package:acumulapp/models/business.dart';
import 'package:flutter/material.dart';

class HomeClientScreen extends StatefulWidget {
  final User user;

  const HomeClientScreen({super.key, required this.user});

  @override
  State<HomeClientScreen> createState() => _HomeClientScreenState();
}

class _HomeClientScreenState extends State<HomeClientScreen> {
  final BusinessProvider businessProvider = BusinessProvider();
  final CategoryProvider categoryProvider = CategoryProvider();

  List<Business> businesses = [];
  String selectedCategory = 'All';
  bool _isLoadingCategories = true;
  bool _errorCategories = false;
  bool _isLoadingBusiness = true;
  bool _errorBusiness = false;

  int currentPage = 1;
  int itemsPerPage = 10;
  int totalPage = 10;

  List<Category> categoryList = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadCategories();
    await _loadBusiness();
  }

  Future<void> _loadCategories() async {
    if (!mounted) return;
    setState(() {
      _isLoadingCategories = true;
      _errorCategories = false;
    });
    try {
      final lista = await categoryProvider.all();
      lista.insert(0, Category(-1, "All", "All"));
      if (!mounted) return;
      setState(() {
        categoryList = lista;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorCategories = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingCategories = false;
        });
      }
    }
  }

  Future<void> _loadBusiness() async {
    if (!mounted) return;
    setState(() {
      _isLoadingBusiness = true;
      _errorBusiness = false;
    });
    try {
      final paginationData = await businessProvider.all(
        _searchQuery.isEmpty ? null : _searchQuery,
        selectedCategory == 'All'
            ? null
            : categoryList.firstWhere((c) => c.name == selectedCategory).id,
        currentPage,
        itemsPerPage,
      );
      if (!mounted) return;
      setState(() {
        businesses = paginationData!.list as List<Business>;
        currentPage = paginationData.currentPage;
        itemsPerPage = paginationData.pageSize;
        totalPage = paginationData.totalPages;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorBusiness = true;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingBusiness = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoadingBusiness || _isLoadingCategories) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorBusiness || _errorCategories) {
      return _buildRetryWidget();
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _buildFilters(),
          const SizedBox(height: 10),
          Expanded(child: BusinessList(businesses: businesses, user: widget.user)),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        const SizedBox(width: 10),
        BusinessSearchField(onSearch: _onSearchChanged),
        const SizedBox(width: 10),
        CategoryFilterDropdown(
          selectedCategory: selectedCategory,
          categories: categoryList,
          onChanged: _onCategoryChanged,
        ),
      ],
    );
  }

  Widget _buildPagination() {
    return PaginacionWidget(
      currentPage: currentPage,
      itemsPerPage: itemsPerPage,
      totalItems: businesses.length,
      totalPages: totalPage,
      onPageChanged: (newPage) async {
        setState(() {
          currentPage = newPage;
        });
        await _loadBusiness();
      },
      onItemsPerPageChanged: (newCount) async {
        setState(() {
          itemsPerPage = newCount;
          currentPage = 1;
        });
        await _loadBusiness();
      },
    );
  }

  Widget _buildRetryWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Error de conexión"),
          ElevatedButton(
            onPressed: _loadData,
            child: const Text("Reintentar"),
          ),
        ],
      ),
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      currentPage = 1;
    });
    _loadBusiness();
  }

  void _onCategoryChanged(String? newValue) {
    if (newValue != null) {
      setState(() {
        selectedCategory = newValue;
        currentPage = 1;
      });
      _loadBusiness();
    }
  }
}