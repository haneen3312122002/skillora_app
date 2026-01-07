import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:notes_tasks/core/app/theme/text_styles.dart';
import 'package:notes_tasks/core/shared/constants/colors.dart';
import 'package:notes_tasks/core/shared/constants/spacing.dart';
import 'package:notes_tasks/core/shared/widgets/buttons/app_icon_button.dart';
import 'package:notes_tasks/core/shared/widgets/fields/custom_text_field.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.title = 'Let’s find best talent for you',
    this.subtitle,
    this.showSearch = false,
    this.searchController,
    this.searchHint = 'Search',
    this.onNotificationTap,

    // ✅ جديد
    this.onSettingsTap,
    this.onLogoutTap,
    this.height,
    this.width,
    this.backgroundColor,
  });

  final String title;
  final String? subtitle;

  final bool showSearch;
  final TextEditingController? searchController;
  final String searchHint;

  final VoidCallback? onNotificationTap;

  // ✅ جديد
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;

  final double? height;
  final double? width;

  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final headerHeight = height ?? AppSpacing.homeContainerH;
    final headerWidth = width ?? double.infinity;

    final shouldShowSearch = showSearch && searchController != null;
    final totalHeight = shouldShowSearch ? headerHeight + 50.h : headerHeight;

    return SizedBox(
      height: totalHeight,
      width: headerWidth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _HeaderBody(
            height: headerHeight,
            width: headerWidth,
            title: title,
            subtitle: subtitle,
            backgroundColor: backgroundColor,
            onNotificationTap: onNotificationTap,
            onSettingsTap: onSettingsTap,
            onLogoutTap: onLogoutTap,
          ),
          if (shouldShowSearch)
            Positioned(
              left: 16.w,
              right: 16.w,
              top: headerHeight - 70.h,
              child: _SearchBox(
                controller: searchController!,
                hint: searchHint,
              ),
            ),
        ],
      ),
    );
  }
}

class _HeaderBody extends StatelessWidget {
  const _HeaderBody({
    required this.height,
    required this.width,
    required this.title,
    this.subtitle,
    this.backgroundColor,
    this.onNotificationTap,
    this.onSettingsTap,
    this.onLogoutTap,
  });

  final double height;
  final double width;
  final String title;
  final String? subtitle;
  final Color? backgroundColor;

  final VoidCallback? onNotificationTap;
  final VoidCallback? onSettingsTap;
  final VoidCallback? onLogoutTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.primary,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 48.h),

          // ======================
          // Top Row (subtitle + actions)
          // ======================
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 30.h),
                  child: Text(
                    subtitle ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w400,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ),

              // ✅ SETTINGS
              if (onSettingsTap != null)
                InkWell(
                  onTap: onSettingsTap,
                  borderRadius: BorderRadius.circular(22.r),
                  child: Container(
                    height: 44.r,
                    width: 44.r,
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.7),
                        width: 1.2,
                      ),
                    ),
                    child: const Icon(
                      Icons.settings_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),

              // ✅ LOGOUT
              if (onLogoutTap != null)
                InkWell(
                  onTap: onLogoutTap,
                  borderRadius: BorderRadius.circular(22.r),
                  child: Container(
                    height: 44.r,
                    width: 44.r,
                    margin: EdgeInsets.only(right: 8.w),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.7),
                        width: 1.2,
                      ),
                    ),
                    child: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ),

              // 🔔 Notification (اختياري)
              if (onNotificationTap != null)
                InkWell(
                  onTap: onNotificationTap,
                  borderRadius: BorderRadius.circular(22.r),
                  child: Container(
                    height: 44.r,
                    width: 44.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.7),
                        width: 1.2,
                      ),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),

          SizedBox(height: 9.h),

          // ======================
          // Title
          // ======================
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Text(
                  title,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: AppTextStyles.title.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: constraints.maxWidth < 320 ? 25.sp : 35.sp,
                    height: 1.1,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({
    required this.controller,
    required this.hint,
  });

  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return AppCustomTextField(
      controller: controller,
      prefix: AppIconButton(icon: Icons.search, onTap: () {}),
      hint: hint,
      animate: false,
    );
  }
}
