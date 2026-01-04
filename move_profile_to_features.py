import os
import re
import shutil
from pathlib import Path

# =========================
# Config
# =========================
PROJECT_ROOT = Path(__file__).resolve().parent
LIB = PROJECT_ROOT / "lib"

def norm(p: Path) -> str:
    return str(p).replace("/", "\\")

def ensure_dir(path: Path):
    path.mkdir(parents=True, exist_ok=True)

def move_file(src: Path, dst: Path):
    if not src.exists():
        return False, f"MISS: {src}"
    ensure_dir(dst.parent)
    if dst.exists():
        return False, f"SKIP (exists): {dst}"
    shutil.move(str(src), str(dst))
    return True, f"MOVED: {src} -> {dst}"

def read_text(p: Path) -> str:
    return p.read_text(encoding="utf-8")

def write_text(p: Path, s: str):
    p.write_text(s, encoding="utf-8")

# =========================
# 1) Move Map (from old -> new)
# =========================
MOVES = [
    # ========= Experience -> profile_experience
    ("modules/profile/data/models/experience_model.dart",
     "modules/profile_experience/data/models/experience_model.dart"),
    ("modules/profile/domain/entities/experience_entity.dart",
     "modules/profile_experience/domain/entities/experience_entity.dart"),
    ("modules/profile/domain/usecases/experience/add_experience_usecase.dart",
     "modules/profile_experience/domain/usecases/add_experience_usecase.dart"),
    ("modules/profile/domain/usecases/experience/delete_experience_usecase.dart",
     "modules/profile_experience/domain/usecases/delete_experience_usecase.dart"),
    ("modules/profile/domain/usecases/experience/get_experiences_stream_usecase.dart",
     "modules/profile_experience/domain/usecases/get_experiences_stream_usecase.dart"),
    ("modules/profile/domain/usecases/experience/update_experience_usecase.dart",
     "modules/profile_experience/domain/usecases/update_experience_usecase.dart"),
    ("modules/profile/presentation/providers/experience/get_experiences_stream_provider.dart",
     "modules/profile_experience/presentation/providers/experiences_stream_provider.dart"),
    ("modules/profile/presentation/viewmodels/experience/experiences_form_viewmodel.dart",
     "modules/profile_experience/presentation/viewmodels/experience_form_viewmodel.dart"),
    ("modules/profile/presentation/widgets/experience/experience_container.dart",
     "modules/profile_experience/presentation/widgets/experiences_section_container.dart"),
    ("modules/profile/presentation/widgets/experience/experience_form_widget.dart",
     "modules/profile_experience/presentation/widgets/experience_form_widget.dart"),
    ("modules/profile/presentation/widgets/experience/profile_experience_section.dart",
     "modules/profile_experience/presentation/widgets/profile_experience_section.dart"),

    # ========= Projects -> profile_projects
    ("modules/profile/data/models/project_model.dart",
     "modules/profile_projects/data/models/project_model.dart"),
    ("modules/profile/domain/entities/project_entity.dart",
     "modules/profile_projects/domain/entities/project_entity.dart"),
    ("modules/profile/domain/entities/profile_item.dart",
     "modules/profile_projects/domain/entities/profile_item.dart"),
    ("modules/profile/domain/usecases/prohect/add_project_usecase.dart",
     "modules/profile_projects/domain/usecases/add_project_usecase.dart"),
    ("modules/profile/domain/usecases/prohect/delete_project_usecase.dart",
     "modules/profile_projects/domain/usecases/delete_project_usecase.dart"),
    ("modules/profile/domain/usecases/prohect/get_projects_stream_usecase.dart",
     "modules/profile_projects/domain/usecases/get_projects_stream_usecase.dart"),
    ("modules/profile/domain/usecases/prohect/update_project_usecase.dart",
     "modules/profile_projects/domain/usecases/update_project_usecase.dart"),
    ("modules/profile/presentation/providers/project/projects_provider.dart",
     "modules/profile_projects/presentation/providers/projects_stream_provider.dart"),
    ("modules/profile/presentation/providers/project/project_image_storage_provider.dart",
     "modules/profile_projects/presentation/providers/project_image_storage_provider.dart"),
    ("modules/profile/presentation/viewmodels/project/project_form_viewmodel.dart",
     "modules/profile_projects/presentation/viewmodels/project_form_viewmodel.dart"),
    ("modules/profile/presentation/viewmodels/project/project_cover_image_viewmodel.dart",
     "modules/profile_projects/presentation/viewmodels/project_cover_image_viewmodel.dart"),
    ("modules/profile/presentation/services/project_image_helpers.dart",
     "modules/profile_projects/presentation/services/project_image_helpers.dart"),
    ("modules/profile/presentation/widgets/project/profile_projects_section.dart",
     "modules/profile_projects/presentation/widgets/profile_projects_section.dart"),
    ("modules/profile/presentation/widgets/project/project_detail_page.dart",
     "modules/profile_projects/presentation/widgets/project_details_page.dart"),
    ("modules/profile/presentation/widgets/project/project_form_widget.dart",
     "modules/profile_projects/presentation/widgets/project_form_widget.dart"),

    # ========= Skills -> profile_skills
    ("modules/profile/domain/usecases/skill/remove_skill_usecase.dart",
     "modules/profile_skills/domain/usecases/remove_skill_usecase.dart"),
    ("modules/profile/domain/usecases/skill/set_skills_usecase.dart",
     "modules/profile_skills/domain/usecases/set_skills_usecase.dart"),
    ("modules/profile/presentation/providers/skill/skills_provider.dart",
     "modules/profile_skills/presentation/providers/skills_provider.dart"),
    ("modules/profile/presentation/viewmodels/skill/skills_form_viewmodel.dart",
     "modules/profile_skills/presentation/viewmodels/skills_form_viewmodel.dart"),
    ("modules/profile/presentation/widgets/skills/profile_skill_section.dart",
     "modules/profile_skills/presentation/widgets/profile_skills_section.dart"),
    ("modules/profile/presentation/widgets/skills/skill_section_container.dart",
     "modules/profile_skills/presentation/widgets/skills_section_container.dart"),
]

# =========================
# 2) Import rewrite rules
# =========================
IMPORT_REWRITES = [
    # Experience
    ("package:notes_tasks/modules/profile/data/models/experience_model.dart",
     "package:notes_tasks/modules/profile_experience/data/models/experience_model.dart"),
    ("package:notes_tasks/modules/profile/domain/entities/experience_entity.dart",
     "package:notes_tasks/modules/profile_experience/domain/entities/experience_entity.dart"),
    ("package:notes_tasks/modules/profile/domain/usecases/experience/",
     "package:notes_tasks/modules/profile_experience/domain/usecases/"),
    ("package:notes_tasks/modules/profile/presentation/providers/experience/get_experiences_stream_provider.dart",
     "package:notes_tasks/modules/profile_experience/presentation/providers/experiences_stream_provider.dart"),
    ("package:notes_tasks/modules/profile/presentation/viewmodels/experience/experiences_form_viewmodel.dart",
     "package:notes_tasks/modules/profile_experience/presentation/viewmodels/experience_form_viewmodel.dart"),
    ("package:notes_tasks/modules/profile/presentation/widgets/experience/experience_container.dart",
     "package:notes_tasks/modules/profile_experience/presentation/widgets/experiences_section_container.dart"),
    ("package:notes_tasks/modules/profile/presentation/widgets/experience/experience_form_widget.dart",
     "package:notes_tasks/modules/profile_experience/presentation/widgets/experience_form_widget.dart"),
    ("package:notes_tasks/modules/profile/presentation/widgets/experience/profile_experience_section.dart",
     "package:notes_tasks/modules/profile_experience/presentation/widgets/profile_experience_section.dart"),

    # Projects
    ("package:notes_tasks/modules/profile/data/models/project_model.dart",
     "package:notes_tasks/modules/profile_projects/data/models/project_model.dart"),
    ("package:notes_tasks/modules/profile/domain/entities/project_entity.dart",
     "package:notes_tasks/modules/profile_projects/domain/entities/project_entity.dart"),
    ("package:notes_tasks/modules/profile/domain/entities/profile_item.dart",
     "package:notes_tasks/modules/profile_projects/domain/entities/profile_item.dart"),
    ("package:notes_tasks/modules/profile/domain/usecases/prohect/",
     "package:notes_tasks/modules/profile_projects/domain/usecases/"),
    ("package:notes_tasks/modules/profile/presentation/providers/project/projects_provider.dart",
     "package:notes_tasks/modules/profile_projects/presentation/providers/projects_stream_provider.dart"),
    ("package:notes_tasks/modules/profile/presentation/providers/project/project_image_storage_provider.dart",
     "package:notes_tasks/modules/profile_projects/presentation/providers/project_image_storage_provider.dart"),
    ("package:notes_tasks/modules/profile/presentation/viewmodels/project/",
     "package:notes_tasks/modules/profile_projects/presentation/viewmodels/"),
    ("package:notes_tasks/modules/profile/presentation/services/project_image_helpers.dart",
     "package:notes_tasks/modules/profile_projects/presentation/services/project_image_helpers.dart"),
    ("package:notes_tasks/modules/profile/presentation/widgets/project/profile_projects_section.dart",
     "package:notes_tasks/modules/profile_projects/presentation/widgets/profile_projects_section.dart"),
    ("package:notes_tasks/modules/profile/presentation/widgets/project/project_detail_page.dart",
     "package:notes_tasks/modules/profile_projects/presentation/widgets/project_details_page.dart"),
    ("package:notes_tasks/modules/profile/presentation/widgets/project/project_form_widget.dart",
     "package:notes_tasks/modules/profile_projects/presentation/widgets/project_form_widget.dart"),

    # Skills
    ("package:notes_tasks/modules/profile/domain/usecases/skill/",
     "package:notes_tasks/modules/profile_skills/domain/usecases/"),
    ("package:notes_tasks/modules/profile/presentation/providers/skill/skills_provider.dart",
     "package:notes_tasks/modules/profile_skills/presentation/providers/skills_provider.dart"),
    ("package:notes_tasks/modules/profile/presentation/viewmodels/skill/skills_form_viewmodel.dart",
     "package:notes_tasks/modules/profile_skills/presentation/viewmodels/skills_form_viewmodel.dart"),
    ("package:notes_tasks/modules/profile/presentation/widgets/skills/profile_skill_section.dart",
     "package:notes_tasks/modules/profile_skills/presentation/widgets/profile_skills_section.dart"),
    ("package:notes_tasks/modules/profile/presentation/widgets/skills/skill_section_container.dart",
     "package:notes_tasks/modules/profile_skills/presentation/widgets/skills_section_container.dart"),
]

def rewrite_imports_in_file(path: Path) -> bool:
    s = read_text(path)
    original = s
    for old, new in IMPORT_REWRITES:
        s = s.replace(old, new)

    # Fix typo folder name in old imports: "prohect" => "project" OR our new path already handled
    s = s.replace("/prohect/", "/project/")  # in case some relative paths existed
    changed = (s != original)
    if changed:
        write_text(path, s)
    return changed

def main():
    print(f"📁 Project root: {PROJECT_ROOT}")
    print(f"🔎 pubspec.yaml exists: {(PROJECT_ROOT / 'pubspec.yaml').exists()}")
    print(f"🔎 lib exists: {LIB.exists()}")
    if not LIB.exists():
        raise SystemExit("lib folder not found")

    print("\n==============================")
    print("1) Moving files ...")
    print("==============================")

    moved = 0
    skipped = 0
    missed = 0

    for src_rel, dst_rel in MOVES:
        src = LIB / Path(src_rel)
        dst = LIB / Path(dst_rel)
        ok, msg = move_file(src, dst)
        print(("✅ " if ok else "⚠️ ") + msg)
        if ok:
            moved += 1
        else:
            if msg.startswith("MISS"):
                missed += 1
            else:
                skipped += 1

    print("\n==============================")
    print("2) Rewriting imports ...")
    print("==============================")
    dart_files = list(LIB.rglob("*.dart"))
    changed_files = 0
    for f in dart_files:
        try:
            if rewrite_imports_in_file(f):
                changed_files += 1
        except Exception as e:
            print(f"❌ Failed to rewrite {f}: {e}")

    print("\n==============================")
    print("✅ Done.")
    print(f"Moved: {moved}")
    print(f"Skipped: {skipped}")
    print(f"Missed: {missed}")
    print(f"Imports updated in: {changed_files} files")
    print("==============================\n")

if __name__ == "__main__":
    main()
