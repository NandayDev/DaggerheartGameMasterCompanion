import os
import json
import re
from tkinter import Tk, filedialog


def clean_markdown(md):
    md = md.lstrip("\ufeff")
    lines = md.splitlines()
    cleaned = [line.lstrip("> ").strip() for line in lines if line.strip()]
    return "\n".join(cleaned)


def parse_md_content(content):
    content = clean_markdown(content)

    # Estrazione titolo
    title_match = re.search(r"^# (.+)", content)

    # Estrazione livello, dominio e tipo (Ability o Spell)
    type_match = re.search(
        r"\*\*Level (\d+) (\w+) (Ability|Spell|Grimoire)\*\*", content
    )
    recall_match = re.search(r"\*\*Recall Cost:\*\* (\d+)", content)
    description_match = re.split(r"\*\*Recall Cost:\*\* \d+", content, maxsplit=1)

    if not (title_match and type_match and recall_match and len(description_match) > 1):
        return None

    title = title_match.group(1).strip().title()
    level = int(type_match.group(1))
    domain = type_match.group(2).strip().title()
    type_ = type_match.group(3).strip().title()
    recall_cost = int(recall_match.group(1))
    description = description_match[1].strip()

    return {
        "title": title,
        "domain": domain,
        "level": level,
        "type": type_,
        "recallCost": recall_cost,
        "description": description,
    }


def convert_md_files_to_json(folder_path):
    for filename in os.listdir(folder_path):
        if filename.endswith(".md"):
            md_path = os.path.join(folder_path, filename)
            with open(md_path, "r", encoding="utf-8-sig") as f:
                content = f.read()

            data = parse_md_content(content)
            if data:
                json_path = os.path.splitext(md_path)[0] + ".json"
                with open(json_path, "w", encoding="utf-8") as json_file:
                    json.dump(data, json_file, indent=2)
                print(f"Creato: {json_path}")
            else:
                print(f"Formato non valido o non riconosciuto: {filename}")


if __name__ == "__main__":
    Tk().withdraw()
    selected_folder = filedialog.askdirectory(
        title="Seleziona una cartella con file MD"
    )

    if selected_folder:
        convert_md_files_to_json(selected_folder)
    else:
        print("Nessuna cartella selezionata.")
