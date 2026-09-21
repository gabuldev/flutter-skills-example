import '../../domain/entities/paginated.dart';

/// Builds a [Paginated] from a page envelope plus already-parsed [items].
///
/// Generic so one envelope parser serves every entity.
class PaginatedModel<T> {
  const PaginatedModel({
    required this.items,
    required this.total,
    required this.page,
    required this.limit,
  });

  final List<T> items;
  final int total;
  final int page;
  final int limit;

  factory PaginatedModel.fromJson({
    required Map<String, dynamic> json,
    required List<T> items,
  }) {
    return PaginatedModel<T>(
      items: items,
      total: (json['total'] as num?)?.toInt() ?? items.length,
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? items.length,
    );
  }

  Paginated<T> toEntity() =>
      Paginated<T>(items: items, total: total, page: page, limit: limit);
}
