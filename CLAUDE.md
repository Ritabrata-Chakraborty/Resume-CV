# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Three LaTeX documents for one person (Ritabrata Chakraborty), all sharing an identical custom macro preamble:

- `Master___Resume.tex` — comprehensive resume, the content source of truth. Grouped by theme, two impact bullets per entry.
- `Master___CV.tex` — comprehensive CV: same body of work as the Master resume, condensed to one-line topics.
- `Research___Resume.tex` — short, selective resume. Deliberately not comprehensive; don't auto-sync new content into it, only edit when explicitly asked.

Each `.tex` has a matching `.pdf` of the same base name — regenerate and commit together whenever source changes.

## Build

```bash
pdflatex Master___Resume.tex
pdflatex Master___CV.tex
pdflatex Research___Resume.tex
rm -f *.aux *.log *.out   # never commit these
```

## Shared macro system

- `\resumeSubheading{title}{location/company}{role/description}{date}` — two-column entry, `title`/`location` bold on top, `role`/`date` italic below.
- `\resumeSubSubheading{role}{date}` — nested sub-entry under a `\resumeSubheading`.
- `\resumeProjectHeading{title}{date}` — bold subsection label (e.g. inside Publications).
- `\resumeItemListStart` / `\resumeItem{...}` / `\resumeItemListEnd` — bullet list under an entry.
- `\nbresumeItemListStart` / `\nbresumeItem{...}` / `\nbresumeItemListEnd` — no-bullet list (Technical Skills).

**Gotcha — bold dates:** `\resumeSubheading`'s 2nd argument is wrapped in `\textbf{}`. For single-line entries (Awards, Honours, Competitive Exams) that put a date there with args 3–4 empty, prefix it with `\mdseries` (`{\mdseries\textit{Mar '25}}`) to cancel the inherited bold.

**Gotcha — literal `&`:** entries render inside a `tabular*`; an unescaped `&` in any argument is read as a column separator and cascades into fatal compile errors. Always escape as `\&`.

## Content conventions

- Dates: en dash with spaces, `Jan '24 – May '26` (not `--`).
- Author's own name always bolded in publication lists: `\textbf{R. Chakraborty}`.
- Link icons (`\faExternalLink*`) are bold in Publications, unbold elsewhere — intentional, not an inconsistency.
- Publications are split by type (Journal / Conference / Poster / Peer Reviews) via `\resumeProjectHeading`.
- Every `\resumeItem` bullet in `Master___Resume.tex` / `Research___Resume.tex` opens with a distinct action verb — no repeats in a given file. Check before adding:
  ```bash
  grep -o '\\resumeItem{[A-Z][a-z]*' Master___Resume.tex | sed 's/\\resumeItem{//' | sort | uniq -c | awk '$1>1'
  ```
  `Master___CV.tex` bullets are noun-phrase topics, not sentences — this rule doesn't apply there.

## CV-is-a-brief-of-the-Master-resume rule

`Master___CV.tex` is derived from `Master___Resume.tex`, not written independently:

- One resume topic (a `\resumeSubheading` or nested `\resumeSubSubheading`) → exactly one condensed `\resumeItem` bullet in the CV. Don't merge two resume sub-projects into one CV bullet.
- Drop full impact bullets to a single one-line topic; no quantified outcomes.
- Every link in the resume version must survive in the CV version — as the same icon or embedded on a keyword. Never let condensing drop a link.
- Resume headings sharing an institution/supervisor merge into one CV entry with a spanning date range and one bullet per original topic.
- A gap between the two files (entry in one but not the other) should be flagged, not left — except `Research___Resume.tex`, which is exempt by design.

## Publishing a redacted public copy

Remote `resume-cv` → `https://github.com/Ritabrata-Chakraborty/Resume-CV.git` (public). There is no `origin` remote — this repo pushes nowhere else.

Real contact info must never reach that repo: email/phone are replaced with placeholders (`rc@gmail.com`, `+91 00000 00000`), and `CLAUDE.md` is excluded entirely.

Run `scripts/publish.sh` to do the whole thing safely:
1. Requires `*.tex` and `CLAUDE.md` already committed on `main` (fails otherwise).
2. Redacts contact info in all three `.tex` files, removes `CLAUDE.md`, recompiles PDFs.
3. Commits that redacted snapshot and force-pushes it to `resume-cv`'s `main`.
4. Always restores real contact info afterward (`git reset --hard` the publish commit away), recompiles real PDFs, and copies them to `/home/rc/Documents/Personal/Resume/` — this restore runs even if the push fails.
