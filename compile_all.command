#!/bin/bash
# Finder double-click entry: five submission PDFs + editable Highlights Word.
# Requires MacTeX (pdfLaTeX/BibTeX) and Python 3; no third-party Python packages.
set -euo pipefail

# Accept the former automation flag for compatibility; all runs are non-pausing.
if [[ $# -gt 0 && ! ( $# -eq 1 && "$1" == "--no-pause" ) ]]; then
  echo "Usage: $0" >&2
  exit 2
fi
finish() {
  local status=$?
  if [[ $status -ne 0 ]]; then
    echo "[ERROR] Build stopped. Logs are preserved in the project directory." >&2
  fi
  exit "$status"
}
trap finish EXIT

cd -- "$(dirname -- "$0")"
# Finder's Terminal environment may omit the MacTeX directory from PATH.
if [[ -d /Library/TeX/texbin ]]; then
  export PATH="/Library/TeX/texbin:$PATH"
fi
for tool in pdflatex bibtex python3; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    echo "[ERROR] $tool not found. Install MacTeX and Python 3, then try again." >&2
    exit 1
  fi
done
if ! python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 8) else 1)'; then
  echo '[ERROR] Python 3.8 or newer is required for Highlights Word.' >&2
  exit 1
fi
shopt -s nullglob
main_files=( *-main.tex )
if [[ ${#main_files[@]} -ne 1 ]]; then
  echo "[ERROR] Keep exactly one *-main.tex file in this directory." >&2
  exit 1
fi
MAIN_TEX=${main_files[0]}
BASE_NAME=${MAIN_TEX%.tex}
HIGHLIGHTS_DOCX="$BASE_NAME-highlights.docx"
[[ -f 0.Highlights.tex ]] || { echo "[ERROR] Missing 0.Highlights.tex" >&2; exit 1; }
# Local convenience only: never create configuration from the manuscript itself.
mkdir -p texfiles
# noclobber also protects an existing file if two launchers start concurrently.
if [[ ! -e texfiles/els-local.tex && ! -L texfiles/els-local.tex ]]; then
  (set -o noclobber
   printf '%s\n' '% Local preview options; never upload this file.' '\ORCIDicontrue' > texfiles/els-local.tex)
  echo 'Created texfiles/els-local.tex: ORCID icons preferred; review mode is set in the main file.'
fi
echo "Main file: $MAIN_TEX"
echo "Working directory: $PWD"

run_logged() {
  local log=$1
  shift
  if ! "$@" >"$log" 2>&1; then
    echo "[ERROR] Command failed; see $log" >&2
    tail -n 15 "$log" >&2
    return 1
  fi
}
build_pdf() {
  local job=$1 defs=$2 with_bib=$3
  local tex_command="\\def\\ELSCleanMetadata{1}${defs}\\input{${MAIN_TEX}}"
  run_logged "$job-run.log" pdflatex -interaction=nonstopmode -halt-on-error -jobname="$job" "$tex_command"
  if [[ $with_bib -eq 1 ]]; then
    run_logged "$job-bibtex.log" bibtex "$job"
    run_logged "$job-run.log" pdflatex -interaction=nonstopmode -halt-on-error -jobname="$job" "$tex_command"
  fi
  run_logged "$job-run.log" pdflatex -interaction=nonstopmode -halt-on-error -jobname="$job" "$tex_command"
}
echo '[1/6] Full manuscript...'
build_pdf "$BASE_NAME-full" "\\def\\ELSAuthorsOutput{${BASE_NAME}-authors.txt}\\def\\ELSExportAuthors{1}\\def\\ELSShowAuthors{1}\\def\\FULL{1}" 1
echo '[2/6] Main text with authors...'
build_pdf "$BASE_NAME-without-abstract" '\def\ELSShowAuthors{1}\def\WITHOUTABSTRACT{1}' 1
echo '[3/6] Double-blind manuscript...'
build_pdf "$BASE_NAME-blind" '\def\BLIND{1}\def\WITHOUTABSTRACT{1}' 1
echo '[4/6] Graphical abstract...'
build_pdf "$BASE_NAME-graphical-abstract" '\def\ELSShowAuthors{1}\def\GRAPHICALONLY{1}' 0
echo '[5/6] Highlights PDF...'
build_pdf "$BASE_NAME-highlights" '\def\ELSShowAuthors{1}\def\HIGHLIGHTSONLY{1}' 0
echo '[6/6] Editable Highlights Word...'
python3 - '0.Highlights.tex' "$HIGHLIGHTS_DOCX" "$MAIN_TEX" <<'ELS_HIGHLIGHTS_PYTHON'
# Same simple-text conversion and OOXML layout as the embedded Windows code.
import os
from pathlib import Path
import re
import sys
import tempfile
from xml.sax.saxutils import escape
from zipfile import ZipFile, ZipInfo, ZIP_DEFLATED


def convert(text):
    text = text.strip()
    for escaped in ['&', '%', '_', '#']:
        text = text.replace('\\' + escaped, escaped)
    for command in ['textbf', 'emph', 'textit']:
        text = re.sub(r'\\' + command + r'\{([^{}]*)\}', r'\1', text)
    return re.sub(r'\$([^$]*)\$', r'\1', text).strip()


source, output, main = map(Path, sys.argv[1:])
items = [convert(m.group(1)) for line in source.read_text(encoding='utf-8-sig').splitlines()
         if (m := re.match(r'^\s*\\item\s*(.+?)\s*$', line))]
if not items:
    raise ValueError(f'No \\item lines found in {source}')
def paper_title(tex):
    # Strip TeX comments, then read balanced braces (simple formatting is supported).
    tex = re.sub(r'(?<!\\)%[^\n]*', '', tex)
    patterns = [r'\\newcommand\s*\{\\PaperTitle\}\s*\{',
                r'\\title\s*(?:\[[^\]]*\])?\s*\{']
    for pattern in patterns:
        match = re.search(pattern, tex)
        if not match:
            continue
        start, depth = match.end(), 1
        for pos in range(start, len(tex)):
            if tex[pos] in '{}':
                backslashes = len(tex[:pos]) - len(tex[:pos].rstrip('\\'))
                if backslashes % 2:
                    continue
                depth += 1 if tex[pos] == '{' else -1
                if depth == 0:
                    return convert(re.sub(r'\s+', ' ', tex[start:pos]))
        raise ValueError('Unclosed paper title in main file')
    return 'Paper Title'


title = paper_title(main.read_text(encoding='utf-8-sig'))
paragraphs = ['<w:p><w:pPr><w:pStyle w:val="Title"/></w:pPr><w:r><w:t>'
              + escape(title) + '</w:t></w:r></w:p>',
              '<w:p><w:r><w:rPr><w:b/></w:rPr><w:t>Highlights</w:t></w:r></w:p>']
paragraphs += ['<w:p><w:r><w:t>- ' + escape(item) + '</w:t></w:r></w:p>' for item in items]
xml_header = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'
parts = {
    '[Content_Types].xml': '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
        '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
        '<Default Extension="xml" ContentType="application/xml"/>'
        '<Override PartName="/word/document.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>'
        '<Override PartName="/word/styles.xml" ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.styles+xml"/></Types>',
    '_rels/.rels': '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
        '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="word/document.xml"/></Relationships>',
    'word/styles.xml': '<w:styles xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">'
        '<w:style w:type="paragraph" w:default="1" w:styleId="Normal"><w:name w:val="Normal"/></w:style>'
        '<w:style w:type="paragraph" w:styleId="Title"><w:name w:val="Title"/><w:basedOn w:val="Normal"/>'
        '<w:qFormat/><w:rPr><w:b/><w:sz w:val="32"/></w:rPr></w:style></w:styles>',
    'word/_rels/document.xml.rels': '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
        '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles" Target="styles.xml"/></Relationships>',
    'word/document.xml': '<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"><w:body>'
        + '\n'.join(paragraphs) + '<w:sectPr><w:pgSz w:w="11906" w:h="16838"/>'
        '<w:pgMar w:top="1440" w:right="1440" w:bottom="1440" w:left="1440" w:header="720" w:footer="720" w:gutter="0"/>'
        '</w:sectPr></w:body></w:document>',
}
output.parent.mkdir(parents=True, exist_ok=True)
# Replace only after a complete archive has been written; keep an old Word on failure.
fd, temporary = tempfile.mkstemp(prefix='.highlights-', suffix='.docx', dir=output.parent)
os.close(fd)
try:
    with ZipFile(temporary, 'w', ZIP_DEFLATED) as archive:
        for name, text in parts.items():
            info = ZipInfo(name, date_time=(1980, 1, 1, 0, 0, 0))
            info.create_system = 0
            info.external_attr = 32
            info.compress_type = ZIP_DEFLATED
            archive.writestr(info, (xml_header + text).encode('utf-8'))
    os.replace(temporary, output)
finally:
    if os.path.exists(temporary):
        os.unlink(temporary)
print(f'Word generated: {output}')
ELS_HIGHLIGHTS_PYTHON

# Successful builds only: clean the five generated jobs, preserve manuscript files.
for variant in full without-abstract blind graphical-abstract highlights; do
  job="$BASE_NAME-$variant"
  for ext in aux bbl blg log out toc lof lot fls fdb_latexmk synctex.gz abs bcf run.xml; do
    rm -f -- "$job.$ext"
  done
  rm -f -- "$job-run.log" "$job-bibtex.log"
done
echo 'Done. Generated:'
for variant in full without-abstract blind graphical-abstract highlights; do
  echo "  $BASE_NAME-$variant.pdf"
done
echo "  $HIGHLIGHTS_DOCX"
echo "  $BASE_NAME-authors.txt"
