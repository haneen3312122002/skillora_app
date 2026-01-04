abstract class ProfileSkillsApi {
  Future<void> addSkill(String skill);
  Future<void> removeSkill(String skill);
  Future<void> setSkills(List<String> skills);
}
