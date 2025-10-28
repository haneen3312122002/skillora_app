import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes_tasks/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/users/presentation/widgets/custom_error_view.dart';
import 'package:flutter_riverpod/legacy.dart';


final expandedSectionProvider = StateProvider<Map<String, bool>>((ref) => {});


class UserDetailSection extends ConsumerWidget {
  final String title;
  final dynamic provider;
  final VoidCallback onFetch;

  const UserDetailSection({
    super.key,
    required this.title,
    required this.provider,
    required this.onFetch,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expandedState = ref.watch(expandedSectionProvider);
    final expandedNotifier = ref.read(expandedSectionProvider.notifier);
    final isExpanded = expandedState[title] ?? false;

    final sectionState = ref.watch(provider);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            trailing: IconButton(
              icon: Icon(
                isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                size: 28,
                color: Colors.grey.shade700,
              ),
              onPressed: () {
                if (!isExpanded) onFetch();
                expandedNotifier.state = {
                  ...expandedNotifier.state,
                  title: !isExpanded,
                };
              },
            ),
          ),

          
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Builder(
                builder: (context) {
                  if (sectionState.isLoading) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  }

                  if (sectionState.hasError) {
                    return CustomErrorView(
                      error: sectionState.error!,
                      message: 'Failed to load $title info',
                    );
                  }

                  final data = sectionState.value;
                  if (data == null) {
                    return const Text(
                      'No data available',
                      style: TextStyle(color: Colors.grey),
                    );
                  }

                  return _buildEntityDetails(data);
                },
              ),
            ),
        ],
      ),
    );
  }

  
  Widget _buildEntityDetails(dynamic entity) {
    if (entity is BankEntity) {
      return _buildDetailList({
        'Card Type': entity.cardType,
        'Card Number': entity.cardNumber,
      });
    } else if (entity is CompanyEntity) {
      return _buildDetailList({
        'Company Name': entity.name,
        'Title': entity.title,
      });
    } else if (entity is AddressEntity) {
      return _buildDetailList({'City': entity.city, 'Country': entity.country});
    } else if (entity is CryptoEntity) {
      return _buildDetailList({'Coin': entity.coin, 'Network': entity.network});
    } else {
      return const Text(
        'Unknown entity type',
        style: TextStyle(color: Colors.grey),
      );
    }
  }

  
  Widget _buildDetailList(Map<String, String> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: data.entries.map((e) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            '${e.key}: ${e.value}',
            style: const TextStyle(fontSize: 14),
          ),
        );
      }).toList(),
    );
  }
}
