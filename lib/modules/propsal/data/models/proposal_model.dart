import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_entity.dart';
import 'package:notes_tasks/modules/propsal/domain/entities/proposal_status.dart';

class ProposalModel extends ProposalEntity {
  const ProposalModel({
    // ProfileItem
    required super.id,
    required super.title,
    super.description = '',
    super.tags = const [],
    super.imageUrl,
    super.linkUrl,

    // Relations
    required super.jobId,
    required super.clientId,
    required super.freelancerId,

    // Snapshot fields
    super.jobTitle = '',
    super.jobCategory = '',
    super.jobBudget,
    super.jobDeadline,
    super.clientName = '',
    super.clientPhotoUrl,

    // Content
    required super.coverLetter,
    super.price,
    super.durationDays,

    // Status & dates
    super.status = ProposalStatus.pending,
    required super.createdAt,
    super.updatedAt,
  });

  /// ✅ Firestore -> Model
  factory ProposalModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return ProposalModel(
      id: doc.id,

      // ProfileItem fields (اختياري)
      title: (data['title'] as String?) ?? 'Proposal',
      description: (data['description'] as String?) ?? '',
      tags: (data['tags'] as List?)?.map((e) => e.toString()).toList() ??
          const [],
      imageUrl: data['imageUrl'] as String?,
      linkUrl: data['linkUrl'] as String?,

      // Relations
      jobId: (data['jobId'] as String?) ?? '',
      clientId: (data['clientId'] as String?) ?? '',
      freelancerId: (data['freelancerId'] as String?) ?? '',

      // Snapshot fields (defaults if missing)
      jobTitle: (data['jobTitle'] as String?) ?? '',
      jobCategory: (data['jobCategory'] as String?) ?? '',
      jobBudget: _toDouble(data['jobBudget']),
      jobDeadline: _toNullableDateTime(data['jobDeadline']),
      clientName: (data['clientName'] as String?) ?? '',
      clientPhotoUrl: data['clientPhotoUrl'] as String?,

      // Content
      coverLetter: (data['coverLetter'] as String?) ?? '',
      price: _toDouble(data['price']),
      durationDays: (data['durationDays'] as num?)?.toInt(),

      // Status
      status: _statusFromString(data['status'] as String?),

      // Timestamps (serverTimestamp ممكن يرجع null أول لحظة)
      createdAt: _toDateTimeOrNow(data['createdAt']),
      updatedAt: _toNullableDateTime(data['updatedAt']),
    );
  }

  /// ✅ Model -> Firestore map
  /// ملاحظة: احنا هون بنرجّع DateTime كسيرفر Timestamp طبيعي
  Map<String, dynamic> toFirestore() {
    return {
      // ProfileItem (اختياري)
      'title': title,
      'description': description,
      'tags': tags,
      'imageUrl': imageUrl,
      'linkUrl': linkUrl,

      // Relations
      'jobId': jobId,
      'clientId': clientId,
      'freelancerId': freelancerId,

      // Snapshot fields
      'jobTitle': jobTitle,
      'jobCategory': jobCategory,
      'jobBudget': jobBudget,
      'jobDeadline':
          jobDeadline != null ? Timestamp.fromDate(jobDeadline!) : null,
      'clientName': clientName,
      'clientPhotoUrl': clientPhotoUrl,

      // Content
      'coverLetter': coverLetter,
      'price': price,
      'durationDays': durationDays,
      'status': _statusToString(status),

      // timestamps
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
    };
  }

  /// ✅ Entity -> Model
  factory ProposalModel.fromEntity(ProposalEntity e) {
    return ProposalModel(
      id: e.id,
      title: e.title,
      description: e.description,
      tags: e.tags,
      imageUrl: e.imageUrl,
      linkUrl: e.linkUrl,
      jobId: e.jobId,
      clientId: e.clientId,
      freelancerId: e.freelancerId,
      jobTitle: e.jobTitle,
      jobCategory: e.jobCategory,
      jobBudget: e.jobBudget,
      jobDeadline: e.jobDeadline,
      clientName: e.clientName,
      clientPhotoUrl: e.clientPhotoUrl,
      coverLetter: e.coverLetter,
      price: e.price,
      durationDays: e.durationDays,
      status: e.status,
      createdAt: e.createdAt,
      updatedAt: e.updatedAt,
    );
  }

  // ===== Helpers =====

  static ProposalStatus _statusFromString(String? v) {
    switch ((v ?? '').toLowerCase()) {
      case 'accepted':
        return ProposalStatus.accepted;
      case 'rejected':
        return ProposalStatus.rejected;
      case 'pending':
      default:
        return ProposalStatus.pending;
    }
  }

  static String _statusToString(ProposalStatus s) {
    switch (s) {
      case ProposalStatus.accepted:
        return 'accepted';
      case ProposalStatus.rejected:
        return 'rejected';
      case ProposalStatus.pending:
      default:
        return 'pending';
    }
  }

  static DateTime _toDateTimeOrNow(dynamic v) {
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    return DateTime.now();
  }

  static DateTime? _toNullableDateTime(dynamic v) {
    if (v == null) return null;
    if (v is Timestamp) return v.toDate();
    if (v is DateTime) return v;
    return null;
  }

  static double? _toDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
}
