import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:notes_tasks/core/widgets/app_card.dart';
import 'package:notes_tasks/core/widgets/app_list_tile.dart';
import 'package:notes_tasks/core/widgets/app_scaffold.dart';
import 'package:notes_tasks/modules/users/domain/entities/user_entity.dart';
import 'package:notes_tasks/modules/users/presentation/features/user_details/screens/user_section_details_view.dart';
import 'package:notes_tasks/modules/users/presentation/features/user_details/user_section_details_args.dart';
import 'package:notes_tasks/modules/users/presentation/features/user_details/viewmodels/get_user_address_viewmodel.dart';
import 'package:notes_tasks/modules/users/presentation/features/user_details/viewmodels/get_user_bank_viewmodel.dart';
import 'package:notes_tasks/modules/users/presentation/features/user_details/viewmodels/get_user_company_viewmodel.dart';

class UserDetailsScreen extends ConsumerStatefulWidget {
  final int userId;

  const UserDetailsScreen({super.key, required this.userId});

  @override
  ConsumerState<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends ConsumerState<UserDetailsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(getUserAddressViewModelProvider.notifier)
          .getUserAddress(widget.userId);
      ref
          .read(getUserBankViewModelProvider.notifier)
          .getUserBank(widget.userId);
      ref
          .read(getUserCompanyViewModelProvider.notifier)
          .getUserCompany(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'user_details'.tr(),
      scrollable: true,
      usePadding: false,
      body: Column(
        children: [
          const SizedBox(height: 12),

          // 🏠 Address
          AppCard(
            child: AppListTile(
              leading: const Icon(Icons.home_outlined),
              title: 'address_info'.tr(),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                context.push(
                  '/user-section-details',
                  extra: UserSectionDetailsArgs<AddressEntity>(
                    title: 'address_details'.tr(),
                    provider: getUserAddressViewModelProvider,
                    mapper: (data) => {
                      'country'.tr(): data.country,
                      'city'.tr(): data.city,
                    },
                  ),
                );
              },
            ),
          ),

          // 💳 Bank
          AppCard(
            child: AppListTile(
              leading: const Icon(Icons.credit_card_outlined),
              title: 'bank_info'.tr(),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserSectionDetailsView<BankEntity>(
                      title: 'bank_details'.tr(),
                      provider: getUserBankViewModelProvider,
                      mapper: (data) => {
                        'card_type'.tr(): data.cardType,
                        'card_number'.tr(): data.cardNumber,
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // 🏢 Company
          AppCard(
            child: AppListTile(
              leading: const Icon(Icons.business_outlined),
              title: 'company_info'.tr(),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserSectionDetailsView<CompanyEntity>(
                      title: 'company_details'.tr(),
                      provider: getUserCompanyViewModelProvider,
                      mapper: (data) => {
                        'company_name'.tr(): data.name,
                        'title'.tr(): data.title,
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
      actions: [],
    );
  }
}
