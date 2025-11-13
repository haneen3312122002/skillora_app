import 'package:flutter/material.dart';
import 'package:notes_tasks/core/constants/colors.dart';

class CoverImage extends StatelessWidget {
  final String? coverUrl;
  final bool isLoading;
  final VoidCallback onChangeCover;

  const CoverImage({
    super.key,
    required this.coverUrl,
    required this.isLoading,
    required this.onChangeCover,
  });

  @override
  Widget build(BuildContext context) {
    final placeholder = Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.border.withOpacity(0.3),
      ),
      child: const Center(
        child: Icon(Icons.image, size: 40, color: AppColors.border),
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        children: [
          SizedBox(
            height: 140,
            width: double.infinity,
            child: coverUrl != null
                ? Image.network(coverUrl!, fit: BoxFit.cover)
                : placeholder,
          ),
          Positioned(
            right: 8,
            bottom: 8,
            child: ElevatedButton.icon(
              onPressed: isLoading ? null : onChangeCover,
              icon: isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.edit),
              label: const Text('Edit cover', style: TextStyle(fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }
}
