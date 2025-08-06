import 'package:dart_backend/utils/generic_table_source.dart';
import 'package:dart_backend/views/widgets/components/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

typedef SortField<T> = Comparable Function(T);

class PaginatedTableView<T> extends StatefulWidget {
  final List<T> items;
  final String? title;
  final List<DataColumn> columns;
  final List<DataCell> Function(T item, int index) rowBuilder;
  final bool Function(T value)? isSelected;
  final void Function(T value)? onEdit;
  final void Function(T value)? onDelete;
  final List<SortField<T>>? sorters;
  final bool? isLoading;
  final String? hasError;
  final String noDataMessage;

  const PaginatedTableView({
    super.key,
    required this.items,
    required this.columns,
    required this.rowBuilder,
    this.isSelected,
    this.onEdit,
    this.onDelete,
    this.title,
    this.sorters,
    this.isLoading,
    this.hasError,
    this.noDataMessage = 'No data found!',
  }) : assert(sorters == null || sorters.length == columns.length);

  @override
  State<PaginatedTableView<T>> createState() => _PaginatedTableViewState<T>();
}

class _PaginatedTableViewState<T> extends State<PaginatedTableView<T>> {
  static const _defaultRowsPerPage = 10;
  bool _isSearching = false;
  final _searchCtrl = TextEditingController();

  late GenericTableSource<T> _source;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;
  int _rowsPerPage = _defaultRowsPerPage;

  @override
  void initState() {
    super.initState();
    _source = GenericTableSource<T>(
      items: widget.items,
      rowBuilder: widget.rowBuilder,
      isSelected: widget.isSelected,
      onEdit: widget.onEdit,
      onDelete: widget.onDelete,
    );

    if (widget.items is RxInterface<List<T>>) {
      ever(widget.items as RxInterface, (list) {
        // updateAll expects a List<T>
        _source.updateAll(List<T>.from(list as Iterable));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // inside build, where you build DataColumn list
    final allColumns = [
      ...widget.columns,
      if (widget.onEdit != null || widget.onDelete != null)
        const DataColumn(label: Text('Actions')),
    ];

    // If loading, show a loading animation
    if (widget.isLoading == true && widget.hasError!.isNotEmpty) {
      debugPrint("${widget.hasError}");
      return Container(
        margin: EdgeInsets.only(top: .3.sh),
        child: LoadingAnimation(type: LoadingType.cupertino),
      );
    }

    // If no items are found and notFound is empty, show a loading animation
    if (widget.items.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: .3.sh),
        child: LoadingAnimation(
          label: widget.noDataMessage,
          type: LoadingType.cupertino,
        ),
      );
    }

    return PaginatedDataTable(
      header: _isSearching
          // ── Search Field ────────────────────────────────────────────────────
          ? TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search...',
              ),
              onChanged: _source.filter,
              autofocus: true,
            )
          : Text(widget.title!),
      actions: [
        if (_isSearching)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchCtrl.clear();
                _source.filter(''); // reset filter
              });
            },
          )
        else
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
      ],
      columns: List.generate(widget.columns.length, (idx) {
        final col = widget.columns[idx];
        return DataColumn(
          label: col.label,
          numeric: col.numeric,
          onSort: widget.sorters == null
              ? null
              : (colIndex, asc) {
                  setState(() {
                    _sortColumnIndex = colIndex;
                    _sortAscending = asc;
                  });
                  // now this lines up perfectly
                  _source.sort(widget.sorters![colIndex], asc);
                },
        );
      })
        // then append the Actions column if needed...
        ..addAll(allColumns.skip(widget.columns.length)),
      source: _source,
      rowsPerPage: _rowsPerPage,
      availableRowsPerPage: const [10, 15, 20, 50],
      onRowsPerPageChanged: (r) {
        setState(() {
          _rowsPerPage = r ?? _defaultRowsPerPage;
        });
      },
      sortColumnIndex: _sortColumnIndex,
      sortAscending: _sortAscending,
      showEmptyRows: false,
    );
  }
}
