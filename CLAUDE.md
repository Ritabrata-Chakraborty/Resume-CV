# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Three standalone LaTeX documents for one person (Ritabrata Chakraborty). Two are
**comprehensive** (everything the person has done) and one is a **short selective**
extract:

- `Master___Resume.tex` — **comprehensive resume** and the content source of truth.
  Work is grouped by theme (e.g. "Experience -- Robotics & Computer Vision") with
  two detailed, impact-driven bullets per entry. New experience/projects land here
  first.
- `Research___CV.tex` — **comprehensive CV**: the same content as the Master resume
  but in brief. Roles are split by category (Research / Industry / Teaching /
  Leadership & Volunteering / Projects) and each entry is condensed to one-line
  topics rather than full bullet descriptions.
- `Research___Resume.tex` — **short, selective resume** for targeted applications.
  It is *not* comprehensive: it deliberately carries a subset of entries and some
  entries stay commented out. Do **not** auto-sync new content into this file; only
  change it when explicitly asked.

Each `.tex` file has a matching pre-built `.pdf` of the same base name checked into
the repo — regenerate and re-commit these together whenever the `.tex` source changes.

## Build

Compile any file directly with a standard TeX Live install:

```bash
pdflatex "Master___Resume.tex"
pdflatex "Research___CV.tex"
pdflatex "Research___Resume.tex"
```

No bibliography/index step is needed (no `.bib`, no cross-references requiring a
second pass beyond pdfLaTeX's own resolution). Clean up build artifacts after
compiling — `.aux`/`.log`/`.out` should not be committed:

```bash
rm -f *.aux *.log *.out
```

Required packages (all standard TeX Live): `latexsym`, `geometry`, `titlesec`,
`marvosym`, `color`, `enumitem`, `hyperref`, `fancyhdr`, `babel`, `tabularx`,
`fontawesome5`.

## Shared macro system

Both files define an **identical custom macro preamble** (lines ~45–107) that all
content is built from. When editing content, use these macros rather than raw
LaTeX markup, and if a macro needs to change, change it identically in both files:

- `\resumeSubHeadingListStart` / `\resumeSubHeadingListEnd` — wraps a block of
  entries (e.g. all Education entries, all Research Experience entries).
- `\resumeSubheading{title}{location/company}{role/description}{date}` — the
  main entry type: renders a two-column row with `title`/`location` bolded on top
  and `role`/`date` italicized underneath. Used for Education, Experience,
  Leadership, and (with the 3rd/4th args left as `{}{}`) for single-line
  Awards/Honours entries — see below.
- `\resumeSubSubheading{role}{date}` — a nested sub-entry under a `\resumeSubheading`
  (e.g. multiple courses taught under one Teaching Assistant role).
- `\resumeProjectHeading{title}{date}` — used as a bold subsection label inside
  Publications (e.g. "Journal Publications", "Poster Presentations").
- `\resumeItemListStart` / `\resumeItem{...}` / `\resumeItemListEnd` — bullet list
  under an entry.
- `\nbresumeItemListStart` / `\nbresumeItem{...}` / `\nbresumeItemListEnd` — a
  no-bullet list, used for Technical Skills lines.

**Known gotcha:** `\resumeSubheading`'s 2nd argument is wrapped in `\textbf{...}`
by the macro. When it's used to hold a *date* (e.g. single-line Awards/Honours
entries where args 3–4 are empty), the date inherits unwanted bold — prefix it with
`\mdseries` (e.g. `{\mdseries\textit{Mar '25}}`) to cancel the bold while keeping
the italic. This has already been applied throughout; keep it consistent in new
entries of this pattern.

**Known gotcha:** `\resumeSubheading`/`\resumeSubSubheading`/`\resumeProjectHeading`
render their arguments inside a `tabular*` environment, so a raw unescaped `&`
anywhere in an argument is read as a column separator and breaks compilation with
cascading `Extra alignment tab` / `Missing }` errors. Always escape ampersands as
`\&` in entry text (organization names, etc.).

## Content conventions

- Dates use an en dash with spaces on both sides: `Jan '24 – May '26` (not `--` or
  em dash). Compilation succeeds either way, but the file should stay internally
  consistent — check for stray `--` date separators after edits.
- The resume/CV author's own name is always bolded in publication author lists:
  `\textbf{R. Chakraborty}`.
- External links use `\color{blue}\href{URL}{\faExternalLink*}`, bolded
  (`\textbf{\faExternalLink*}`) in the Publications section, unbolded elsewhere
  (in Experience entry headings/bullets) — this distinction is intentional, not an
  inconsistency to fix.
- Publications are split into subsections by type (Journal / Conference / Poster /
  Peer Reviews) via `\resumeProjectHeading`; keep new publications filed under the
  correct subsection rather than adding a new top-level section.

## CV-is-a-brief-of-the-Master-resume rule

`Research___CV.tex` is a condensed version of **`Master___Resume.tex`** (not of the
short `Research___Resume.tex`), not an independently written document. When adding
or editing an experience/project entry, treat the Master resume as the source of
truth for content and derive the CV entry from it:

- **Granularity**: each distinct topic in the resume — a `\resumeSubheading`
  project heading or a nested `\resumeSubSubheading` sub-project — becomes exactly
  one `\resumeItem` bullet in the corresponding CV entry. Don't merge two resume
  sub-projects into a single CV bullet (e.g. KU Leuven's two `\resumeSubSubheading`
  entries in the resume map to two separate one-line bullets in the CV, not one).
- **Text**: drop the resume's full impact/metric bullets down to a single
  one-line topic/title per project (no quantified outcomes, no multi-sentence
  description).
- **Links**: every link present in the resume version of a project must still
  appear in the CV version — either as the same trailing `\faExternalLink*` icon,
  or embedded on the relevant keyword in the one-line topic text (e.g. resume
  links "PnLCalib" inline → CV keeps that as `{\color{blue}\href{...}{PnLCalib}}`
  inside its shortened bullet). Never let condensing silently drop a link.
- When multiple resume experience headings share the same institution/supervisor
  (e.g. two separate CSIR-CEERI stints), they're merged into one CV
  `\resumeSubheading` with a spanning date range and one bullet per original
  resume topic — this is why CV entry counts don't 1:1 match resume entry counts,
  but *topic* counts should.
- If an entry exists in one file but not the other, that's a gap to flag/fix, not a
  stylistic choice — the CV and Master resume should cover the same body of work.
  (`Research___Resume.tex` is exempt: it is selective by design.)

**Known outstanding gap:** the BARC research experience (railgun impact testing;
constrained drone detection/tracking) exists in `Research___CV.tex` but has no
counterpart in `Master___Resume.tex`, because no metrics/outcomes were supplied for
resume-style bullets. Ask before inventing them.

## Resume action-verb convention

Every `\resumeItem` bullet in the resumes opens with an action verb, and **no
leading verb should repeat** across a given document. Before adding a new bullet,
scan existing bullets' opening words and pick an unused verb ("Engineered" was
previously duplicated and had to be re-verbed — see git history). To check
mechanically:

```bash
grep -o '\\resumeItem{[A-Z][a-z]*' "Master___Resume.tex" | sort | uniq -c | awk '$1>1'
```

This applies to `Master___Resume.tex` and `Research___Resume.tex`;
`Research___CV.tex` bullets are noun-phrase topics, not action-verb sentences, so
it doesn't apply there.

## Adding a new project/experience (typical workflow)

The user supplies raw notes (title, dates, supervisor, rough bullets, often a "Tech
Stack:" line). Convert them as follows:

1. Write **exactly two** bullets per entry in `Master___Resume.tex`, each opening
   with an unused action verb and roughly 100–125 characters — match the visual
   length of neighbouring bullets.
2. **Drop the "Tech Stack:" line** — this format doesn't carry one; fold the one or
   two tools that matter into the bullet prose instead.
3. Keep quantified outcomes the user provided (percentages, counts, timings); never
   invent new ones.
4. Derive the condensed CV entry per the brief rule above, carrying links across.
5. Recompile both PDFs and delete the build artifacts.

Project titles may be reworded to match the existing
`Title $|$ Competition/Venue Year` pattern used in the Projects sections.
