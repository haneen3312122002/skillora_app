class UserSectionDetailsArgs<T> {
  final String title;
  final dynamic provider;
  final Map<String, dynamic> Function(T data) mapper;

  UserSectionDetailsArgs({
    required this.title,
    required this.provider,
    required this.mapper,
  });
}
