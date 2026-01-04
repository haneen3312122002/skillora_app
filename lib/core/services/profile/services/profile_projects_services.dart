import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ProfileProjectsApi {
  Stream<QuerySnapshot<Map<String, dynamic>>> watchProjects();

  Future<String> addProject({
    required String title,
    required String description,
    List<String> tools,
    String? imageUrl,
    String? projectUrl,
  });

  Future<void> updateProject({
    required String id,
    required String title,
    required String description,
    List<String> tools,
    String? imageUrl,
    String? projectUrl,
  });

  Future<void> deleteProject(String id);
}
