import 'package:flutter/material.dart';

class GenericTableSource<T> extends DataTableSource {
  List<T> _allItems;
  List<T> _filteredItems;
  final List<DataCell> Function(T item, int index) rowBuilder;
  final bool Function(T value)? isSelected;
  final void Function(T value)? onEdit, onDelete;

  GenericTableSource({
    required List<T> items,
    required this.rowBuilder,
    this.isSelected,
    this.onEdit,
    this.onDelete,
  }) : _allItems = List.from(items),
       _filteredItems = List.from(items);

  /// call this when the search query changes
  void filter(String query) {
    if (query.isEmpty) {
      _filteredItems = List.from(_allItems);
    } else {
      _filteredItems = _allItems
          .where(
            (item) =>
                // you decide how to search; here we stringify row cells:
                rowBuilder(item, 0)
                    .map(
                      (c) => c.child is Text
                          ? (c.child as Text).data!.toLowerCase()
                          : '',
                    )
                    .join(' ')
                    .contains(query.toLowerCase()),
          )
          .toList();
    }
    notifyListeners();
  }

  /// REPLACES the entire data set
  void updateAll(List<T> items) {
    _allItems = List.from(items);
    _filteredItems = List.from(items);
    notifyListeners();
  }

  /// ADD one item
  void add(T item) {
    _allItems.add(item);
    _filteredItems.add(item);
    notifyListeners();
  }

  /// UPDATE one item (match by == or by index)
  void update(T item, bool Function(T) predicate) {
    final idxAll = _allItems.indexWhere(predicate);
    final idxFilt = _filteredItems.indexWhere(predicate);
    if (idxAll >= 0) _allItems[idxAll] = item;
    if (idxFilt >= 0) _filteredItems[idxFilt] = item;
    notifyListeners();
  }

  /// REMOVE one item
  void removeWhere(bool Function(T) predicate) {
    _allItems.removeWhere(predicate);
    _filteredItems.removeWhere(predicate);
    notifyListeners();
  }

  /// call this to sort
  void sort(Comparable Function(T d) getField, bool ascending) {
    _filteredItems.sort((a, b) {
      final aVal = getField(a);
      final bVal = getField(b);

      // Both aVal and bVal are Comparable, so we can do:
      final result = aVal.compareTo(bVal);
      return ascending ? result : -result;
    });
    notifyListeners();
  }

  @override
  DataRow? getRow(int index) {
    final item = _filteredItems[index];
    // build your “data” cells:
    final cells = rowBuilder(item, index);

    // then append the action cell only if you added the Actions column above:
    if (onEdit != null || onDelete != null) {
      cells.add(
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onEdit != null)
                IconButton(
                  icon: Icon(Icons.edit_document),
                  onPressed: () => onEdit!(item),
                ),
              if (onDelete != null)
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => onDelete!(item),
                ),
            ],
          ),
        ),
      );
    }

    return DataRow.byIndex(
      index: index,
      selected: isSelected?.call(item) ?? false,
      cells: cells,
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _filteredItems.length;

  @override
  int get selectedRowCount => 0;
}
