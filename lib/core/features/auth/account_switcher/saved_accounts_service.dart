import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SavedAccount {
  final String uid;
  final String email;
  final String name;
  final String role;
  final int lastUsedAt;

  const SavedAccount({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.lastUsedAt,
  });

  SavedAccount copyWith({int? lastUsedAt}) => SavedAccount(
        uid: uid,
        email: email,
        name: name,
        role: role,
        lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      );

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'email': email,
        'name': name,
        'role': role,
        'lastUsedAt': lastUsedAt,
      };

  factory SavedAccount.fromJson(Map<String, dynamic> j) => SavedAccount(
        uid: (j['uid'] ?? '').toString(),
        email: (j['email'] ?? '').toString(),
        name: (j['name'] ?? '').toString(),
        role: (j['role'] ?? '').toString(),
        lastUsedAt: (j['lastUsedAt'] ?? 0) as int,
      );
}

class SavedAccountsService {
  static const _kKey = 'saved_accounts_v1';

  Future<List<SavedAccount>> getAll() async {
    final sp = await SharedPreferences.getInstance();
    final raw = sp.getString(_kKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final list = (jsonDecode(raw) as List).cast<dynamic>();
      final accounts = list
          .map((e) => SavedAccount.fromJson(Map<String, dynamic>.from(e)))
          .where((a) => a.email.isNotEmpty)
          .toList();

      accounts.sort((a, b) => b.lastUsedAt.compareTo(a.lastUsedAt));
      return accounts;
    } catch (_) {
      return [];
    }
  }

  Future<void> upsert(SavedAccount account) async {
    final sp = await SharedPreferences.getInstance();
    final list = await getAll();

    final updated = <SavedAccount>[];
    bool found = false;

    for (final a in list) {
      if (a.email.toLowerCase() == account.email.toLowerCase()) {
        updated.add(account);
        found = true;
      } else {
        updated.add(a);
      }
    }
    if (!found) updated.add(account);

    updated.sort((a, b) => b.lastUsedAt.compareTo(a.lastUsedAt));

    await sp.setString(
      _kKey,
      jsonEncode(updated.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> removeByEmail(String email) async {
    final sp = await SharedPreferences.getInstance();
    final list = await getAll();
    final updated = list
        .where((a) => a.email.toLowerCase() != email.toLowerCase())
        .toList();

    await sp.setString(
      _kKey,
      jsonEncode(updated.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> clearAll() async {
    final sp = await SharedPreferences.getInstance();
    await sp.remove(_kKey);
  }
}
