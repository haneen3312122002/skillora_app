import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ProfileExperiencesApi {
  Stream<QuerySnapshot<Map<String, dynamic>>> watchExperiences();

  Future<String> addExperience({
    required String title,
    required String company,
    DateTime? startDate,
    DateTime? endDate,
    required String location,
    required String description,
  });

  Future<void> updateExperience({
    required String id,
    required String title,
    required String company,
    DateTime? startDate,
    DateTime? endDate,
    required String location,
    required String description,
  });

  Future<void> deleteExperience(String id);
}
