import 'package:dart_backend/views/widgets/loading_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

typedef RowBuilder<T, int> = List<DataCell> Function(T item, int index);
typedef ItemCallback<T> = void Function(T item);
typedef SelectedPredicate<T> = bool Function(T item);

class DataTableView<T> extends StatelessWidget {
  /// The data items to display
  final List<T> items;

  /// Column definitions (header row)
  final List<DataColumn> columns;

  /// Builds the cells for each item (one list per row)
  final RowBuilder<T, int> rowBuilder;

  /// Whether a given item should be visually "selected"
  final SelectedPredicate<T>? isSelected;

  /// Callbacks for actions; `null` hides the button
  final ItemCallback<T>? onEdit;
  final ItemCallback<T>? onDelete;

  final bool? isLoading;
  final String? hasError;
  final List<T>? notFound;
  final String noDataMessage;

  const DataTableView({
    super.key,
    required this.items,
    required this.columns,
    required this.rowBuilder,
    this.isSelected,
    this.onEdit,
    this.onDelete,
    this.isLoading,
    this.hasError,
    this.notFound,
    this.noDataMessage = 'No data found!',
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // If loading, show a loading animation
    if (isLoading == true) {
      return Container(
        margin: EdgeInsets.only(top: .3.sh),
        child: LoadingAnimation(type: LoadingType.cupertino),
      );
    }

    // If an error is present, show the error message
    if (hasError!.isNotEmpty) {
      return Container(
        margin: EdgeInsets.only(top: .3.sh),
        child: LoadingAnimation(label: hasError!),
      );
    }

    // If no items are found and notFound is empty, show a loading animation
    if (notFound == null || notFound!.isEmpty) {
      return Container(
        margin: EdgeInsets.only(top: .3.sh),
        child: LoadingAnimation(
          label: noDataMessage,
          type: LoadingType.cupertino,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 2).w,
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              // make the table at least as wide as the viewport
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                sortAscending: false,
                columnSpacing: 24, // tweak these to suit
                horizontalMargin: 12,
                headingTextStyle: TextStyle(fontWeight: FontWeight.bold),
                columns: [
                  ...columns,
                  if (onEdit != null || onDelete != null)
                    const DataColumn(label: Text('Actions')),
                ],
                rows: List<DataRow>.generate(items.length, (idx) {
                  final item = items[idx];
                  final cells = rowBuilder(item, idx);
                  if (onEdit != null || onDelete != null) {
                    cells.add(
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (onEdit != null)
                              IconButton(
                                icon: const Icon(Icons.edit_document),
                                onPressed: () => onEdit!(item),
                                color: colors.outline,
                              ),
                            if (onDelete != null)
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () => onDelete!(item),
                                color: colors.error,
                              ),
                          ],
                        ),
                      ),
                    );
                  }

                  return DataRow(
                    selected: isSelected?.call(item) ?? false,
                    cells: cells,
                    color: WidgetStateProperty.resolveWith<Color?>((
                      Set<WidgetState> states,
                    ) {
                      // All rows will have the same selected color.
                      if (states.contains(WidgetState.selected)) {
                        return colors.primary.withAlpha(25);
                      }
                      // Even rows will have a grey color.
                      if (idx.isEven) {
                        return Colors.grey.withAlpha(30);
                      }
                      return null; // Use default value for other states and odd rows.
                    }),
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}
