import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:notes_tasks/core/app/routes/app_routes.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/enums/page_mode.dart';
import 'package:notes_tasks/core/shared/enums/role.dart';
import 'package:notes_tasks/core/shared/widgets/common/app_scaffold.dart';
import 'package:notes_tasks/core/shared/widgets/common/empty_view.dart';
import 'package:notes_tasks/core/shared/widgets/common/error_view.dart';
import 'package:notes_tasks/core/shared/widgets/common/loading_indicator.dart';

import 'package:notes_tasks/core/session/providers/current_user_provider.dart';

import 'package:notes_tasks/modules/home/presentation/widgets/freelancer_home.dart';
import 'package:notes_tasks/modules/home/presentation/widgets/homeshell.dart';
import 'package:notes_tasks/modules/profile/presentation/providers/profile/get_profile_stream_provider.dart';

import 'package:notes_tasks/modules/home/presentation/viewmodels/home_bootstrap_viewmodel.dart';
import 'package:notes_tasks/modules/propsal/presentation/screens/proposal_details_page.dart';
import 'package:notes_tasks/modules/users/presentation/screens/users_admin_screen.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late final TextEditingController _search;

  @override
  void initState() {
    super.initState();
    _search = TextEditingController();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _goToChat(String chatId) {
    if (!mounted) return;
    context.push('${AppRoutes.chatDetails}/$chatId');
  }

  void _goToProposal(String proposalId) {
    if (!mounted) return;
    context.push(
      AppRoutes.proposalDetails,
      extra: ProposalDetailsArgs(
        proposalId: proposalId,
        mode: PageMode.view,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myUid = ref.watch(currentUserIdProvider);

    // ✅ Listen for bootstrap (based on my uid)
    if (myUid != null) {
      ref.listen(profileStreamProvider(myUid), (prev, next) {
        next.when(
          data: (profile) {
            final vm = ref.read(homeBootstrapViewModelProvider.notifier);

            if (profile == null) {
              vm.reset();
              return;
            }

            vm.bootstrap(
              profile: profile,
              onChat: _goToChat,
              onProposal: _goToProposal,
            );
          },
          loading: () {},
          error: (_, __) {},
        );
      });
    }

    final profileAsync = myUid == null
        ? const AsyncValue.data(null)
        : ref.watch(profileStreamProvider(myUid));

    return AppScaffold(
      showSettingsButton: true,
      showLogout: true,
      extendBodyBehindAppBar: false,
      useSafearea: false,
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return Padding(
              padding: EdgeInsets.all(AppSpacing.spaceMD),
              child: const EmptyView(),
            );
          }

          final subtitle = 'hello_name'.tr(namedArgs: {'name': profile.name});

          switch (profile.role) {
            case UserRole.client:
              return HomeShell(
                title: 'home_client_title'.tr(),
                subtitle: subtitle,
                showSearch: true,
                searchController: _search,
                searchHint: 'search'.tr(),
                padChild: true,
                child: Text(
                  'profile_client_ok'.tr(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              );

            case UserRole.admin:
              return HomeShell(
                title: 'home_admin_title'.tr(),
                subtitle: subtitle,
                showSearch: false,
                searchController: null,
                padChild: false,
                child: const UsersAdminScreen(),
              );

            case UserRole.freelancer:
              return HomeShell(
                title: 'home_freelancer_title'.tr(),
                subtitle: subtitle,
                showSearch: true,
                searchController: _search,
                searchHint: 'search'.tr(),
                padChild: false,
                child: const FreelancerHome(),
              );
          }
        },
        loading: () => HomeShell(
          title: 'home_title'.tr(),
          subtitle: 'hello'.tr(),
          showSearch: false,
          searchController: null,
          padChild: true,
          child: const LoadingIndicator(withBackground: false),
        ),
        error: (_, __) => HomeShell(
          title: 'home_title'.tr(),
          subtitle: 'hello'.tr(),
          showSearch: false,
          searchController: null,
          padChild: true,
          child: ErrorView(
            message: 'something_went_wrong'.tr(),
            fullScreen: false,
            onRetry: () {
              final uid = ref.read(currentUserIdProvider);
              if (uid != null) ref.refresh(profileStreamProvider(uid));
            },
          ),
        ),
      ),
    );
  }
}
