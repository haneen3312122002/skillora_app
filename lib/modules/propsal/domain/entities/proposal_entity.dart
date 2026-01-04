import 'package:notes_tasks/modules/profile_projects/domain/entities/profile_item.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_status.dart';

class ProposalEntity implements ProfileItem {
  // ===== ProfileItem fields =====
  @override
  final String id;

  @override
  final String title;

  @override
  final String description;

  @override
  final List<String> tags;

  @override
  final String? imageUrl;

  @override
  final String? linkUrl;

  // ===== Proposal fields =====
  final String jobId;
  final String clientId;
  final String freelancerId;

  // ===== Snapshot fields (for freelancer list UI) =====
  final String jobTitle;
  final String jobCategory;
  final double? jobBudget;
  final DateTime? jobDeadline;

  final String clientName;
  final String? clientPhotoUrl;

  // ===== Proposal content =====
  final String coverLetter;
  final double? price;
  final int? durationDays;

  // ===== Status & dates =====
  final ProposalStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ProposalEntity({
    // ProfileItem
    required this.id,
    required this.title,
    this.description = '',
    this.tags = const [],
    this.imageUrl,
    this.linkUrl,

    // Relations
    required this.jobId,
    required this.clientId,
    required this.freelancerId,

    // Snapshot (defaults so old docs won't crash)
    this.jobTitle = '',
    this.jobCategory = '',
    this.jobBudget,
    this.jobDeadline,
    this.clientName = '',
    this.clientPhotoUrl,

    // Content
    required this.coverLetter,
    this.price,
    this.durationDays,

    // Status & dates
    this.status = ProposalStatus.pending,
    required this.createdAt,
    this.updatedAt,
  });

  // ✅ Helpers
  bool get isPending => status == ProposalStatus.pending;
  bool get isAccepted => status == ProposalStatus.accepted;
  bool get isRejected => status == ProposalStatus.rejected;

  ProposalEntity copyWith({
    // ProfileItem
    String? id,
    String? title,
    String? description,
    List<String>? tags,
    String? imageUrl,
    String? linkUrl,

    // Relations
    String? jobId,
    String? clientId,
    String? freelancerId,

    // Snapshot
    String? jobTitle,
    String? jobCategory,
    double? jobBudget,
    DateTime? jobDeadline,
    String? clientName,
    String? clientPhotoUrl,

    // Content
    String? coverLetter,
    double? price,
    int? durationDays,

    // Status & dates
    ProposalStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProposalEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      linkUrl: linkUrl ?? this.linkUrl,
      jobId: jobId ?? this.jobId,
      clientId: clientId ?? this.clientId,
      freelancerId: freelancerId ?? this.freelancerId,
      jobTitle: jobTitle ?? this.jobTitle,
      jobCategory: jobCategory ?? this.jobCategory,
      jobBudget: jobBudget ?? this.jobBudget,
      jobDeadline: jobDeadline ?? this.jobDeadline,
      clientName: clientName ?? this.clientName,
      clientPhotoUrl: clientPhotoUrl ?? this.clientPhotoUrl,
      coverLetter: coverLetter ?? this.coverLetter,
      price: price ?? this.price,
      durationDays: durationDays ?? this.durationDays,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
