#!/usr/bin/env bash
# Publish a contact-info-redacted snapshot of the resume/CV to the public
# `resume-cv` remote, then restore real contact info locally.
#
# Preconditions: all real content (including CLAUDE.md) already committed on
# `main`. Only *.tex/CLAUDE.md are checked for cleanliness — PDFs are expected
# to differ run-to-run because pdflatex embeds a compile timestamp.
#
# Usage: scripts/publish.sh

set -euo pipefail
cd "$(git rev-parse --show-toplevel)"

RESUME_DIR="/home/rc/Documents/Personal/Resume"
TEX_FILES=(Master___Resume.tex Research___CV.tex Research___Resume.tex)
PDF_FILES=(Master___Resume.pdf Research___CV.pdf Research___Resume.pdf)

REAL_EMAIL="ritabratabits@gmail.com"
REAL_TEL_HREF="tel:+918910783548"
REAL_TEL_TEXT="+91 89107 83548"
FAKE_EMAIL="rc@gmail.com"
FAKE_TEL_HREF="tel:+910000000000"
FAKE_TEL_TEXT="+91 00000 00000"

if [[ -n "$(git status --porcelain -- "${TEX_FILES[@]}" CLAUDE.md)" ]]; then
  echo "Uncommitted changes in .tex files or CLAUDE.md — commit real content first." >&2
  exit 1
fi

PUBLISHED=0
restore() {
  echo "Restoring real contact info..."
  if [[ "$PUBLISHED" == "1" ]]; then
    git reset --hard HEAD~1 >/dev/null
  else
    git checkout -- "${TEX_FILES[@]}" 2>/dev/null || true
  fi
  rm -f ./*.aux ./*.log ./*.out
  for f in "${TEX_FILES[@]}"; do
    pdflatex -interaction=nonstopmode "$f" >/dev/null 2>&1
  done
  rm -f ./*.aux ./*.log ./*.out
  cp "${PDF_FILES[@]}" "$RESUME_DIR/"
  echo "Restored real content and PDFs (repo + $RESUME_DIR)."
}
trap restore EXIT

echo "Redacting contact info..."
for f in "${TEX_FILES[@]}"; do
  perl -pi -e "s/\\\\href\\{mailto:${REAL_EMAIL}\\}\\{${REAL_EMAIL}\\}/\\\\href{mailto:${FAKE_EMAIL}}{${FAKE_EMAIL}}/" "$f"
  perl -pi -e "s/\\\\href\\{${REAL_TEL_HREF}\\}\\{${REAL_TEL_TEXT}\\}/\\\\href{${FAKE_TEL_HREF}}{${FAKE_TEL_TEXT}}/" "$f"
done
git rm -q CLAUDE.md

echo "Compiling redacted PDFs..."
for f in "${TEX_FILES[@]}"; do
  pdflatex -interaction=nonstopmode "$f" >/dev/null 2>&1
done
rm -f ./*.aux ./*.log ./*.out

git add -A
git commit -q -m "Publish: redact contact info for public release"
PUBLISHED=1

echo "Force-pushing to resume-cv/main..."
git push resume-cv HEAD:main --force
