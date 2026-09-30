import re
import os
import json
import sys
from pathlib import Path

try:
    import pandas as pd
except ImportError:
    print("Missing pandas. Please run: python -m pip install pandas openpyxl")
    sys.exit(2)

IN_PATH = Path("admin_panel/tmp/Sanatan_Scroll_Isha_Upanishad_DEVELOPER_FINAL_v2.xlsx")
OUT_CSV = Path("admin_panel/tmp/upanishads_import.csv")
OUT_REPORT_JSON = Path("admin_panel/tmp/upanishads_report.json")
OUT_REPORT_MD = Path("admin_panel/tmp/upanishads_report.md")

if not IN_PATH.exists():
    print(f"Input file not found: {IN_PATH}")
    sys.exit(1)

sheets = pd.read_excel(IN_PATH, sheet_name=None)
rows_out = []
stats = {
    "file": str(IN_PATH),
    "sheets": {},
    "total_rows": 0,
    "valid_rows": 0,
    "invalid_rows": 0,
}

# common header name mapping
CANDIDATE_HEADERS = {
    'id': ['id', 'rawid', 'raw_id', 'verseid', 'verse_id'],
    'canonical': ['canonical', 'canonicalref', 'canonical_ref', 'canonical_ref_id'],
    'verse': ['verse', 'verse_text', 'sanskrit', 'sanskrit_text', 'shloka'],
    'english': ['english', 'translation', 'translation_en', 'english_translation'],
    'hindi': ['hindi', 'translation_hi', 'hindi_translation'],
    'gujarati': ['gujarati', 'translation_gu', 'gujarati_translation'],
    'notes': ['notes', 'comment'],
    'source': ['source', 'source_url', 'url'],
}

# helper to find a column name

def find_col(cols, candidates):
    low = {c.lower(): c for c in cols}
    for cand in candidates:
        if cand.lower() in low:
            return low[cand.lower()]
    # fuzzy: check substrings
    for c in cols:
        cl = c.lower()
        for cand in candidates:
            if cand.lower() in cl:
                return c
    return None

id_trailing_re = re.compile(r"(\d+)$")

for sheet_name, df in sheets.items():
    if df is None or df.shape[0] == 0:
        continue
    cols = list(df.columns.astype(str))
    stats['sheets'][sheet_name] = {'rows': int(df.shape[0])}
    # map columns
    col_map = {}
    for k, candidates in CANDIDATE_HEADERS.items():
        col = find_col(cols, candidates)
        col_map[k] = col
    # iterate rows
    sheet_valid = 0
    for idx, row in df.iterrows():
        stats['total_rows'] += 1
        raw = {c: row.get(c) for c in cols}
        # extract fields
        raw_id = None
        if col_map['id']:
            raw_id = raw.get(col_map['id'])
        canonical = None
        if col_map['canonical']:
            canonical = raw.get(col_map['canonical'])
        sanskrit = None
        if col_map['verse']:
            sanskrit = raw.get(col_map['verse'])
        english = None
        if col_map['english']:
            english = raw.get(col_map['english'])
        hindi = None
        if col_map['hindi']:
            hindi = raw.get(col_map['hindi'])
        gujarati = None
        if col_map['gujarati']:
            gujarati = raw.get(col_map['gujarati'])
        notes = None
        if col_map['notes']:
            notes = raw.get(col_map['notes'])
        source = None
        if col_map['source']:
            source = raw.get(col_map['source'])

        # canonical id resolution
        resolved_id = None
        if pd.notna(raw_id):
            resolved_id = str(raw_id).strip()
        elif pd.notna(canonical):
            resolved_id = str(canonical).strip()
        else:
            # try trailing number
            for v in [sanskrit, english, notes, source]:
                if pd.isna(v) or v is None:
                    continue
                m = id_trailing_re.search(str(v))
                if m:
                    resolved_id = m.group(1)
                    break
        if resolved_id is None or resolved_id == '' or pd.isna(resolved_id):
            # fallback to sheet + idx
            resolved_id = f"{sheet_name}-{int(idx)+1}"

        # basic validity: at least one of sanskrit/english present
        valid = False
        if (sanskrit is not None and str(sanskrit).strip()!='' and not pd.isna(sanskrit)) or (english is not None and str(english).strip()!='' and not pd.isna(english)):
            valid = True

        if valid:
            stats['valid_rows'] += 1
            sheet_valid += 1
        else:
            stats['invalid_rows'] += 1

        out_row = {
            'id': resolved_id,
            'sheet': sheet_name,
            'row_index': int(idx)+1,
            'sanskrit': '' if pd.isna(sanskrit) else str(sanskrit).strip(),
            'english': '' if pd.isna(english) else str(english).strip(),
            'hindi': '' if pd.isna(hindi) else str(hindi).strip(),
            'gujarati': '' if pd.isna(gujarati) else str(gujarati).strip(),
            'source': '' if pd.isna(source) else str(source).strip(),
            'notes': '' if pd.isna(notes) else str(notes).strip(),
            'valid': valid,
        }
        rows_out.append(out_row)
    stats['sheets'][sheet_name]['valid_rows'] = sheet_valid

# write CSV
import csv
OUT_CSV.parent.mkdir(parents=True, exist_ok=True)
with OUT_CSV.open('w', encoding='utf-8', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=['id','sheet','row_index','sanskrit','english','hindi','gujarati','source','notes','valid'])
    writer.writeheader()
    for r in rows_out:
        writer.writerow(r)

# write report
OUT_REPORT_JSON.parent.mkdir(parents=True, exist_ok=True)
with OUT_REPORT_JSON.open('w', encoding='utf-8') as f:
    json.dump(stats, f, indent=2, ensure_ascii=False)

with OUT_REPORT_MD.open('w', encoding='utf-8') as f:
    f.write(f"# Upanishads Parse Report\n\n")
    f.write(f"Input: {stats['file']}\n\n")
    f.write(f"- Total rows scanned: {stats['total_rows']}\n")
    f.write(f"- Valid rows: {stats['valid_rows']}\n")
    f.write(f"- Invalid rows (missing text): {stats['invalid_rows']}\n\n")
    f.write(f"## Sheets\n")
    for s,info in stats['sheets'].items():
        f.write(f"- {s}: {info['rows']} rows, {info.get('valid_rows',0)} valid\n")

print('Wrote:', OUT_CSV, OUT_REPORT_JSON, OUT_REPORT_MD)
print('Summary:', json.dumps(stats, ensure_ascii=False))
