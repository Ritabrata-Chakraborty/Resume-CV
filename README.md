# Research Resume & CV LaTeX Templates

This repository contains two LaTeX templates for researchers and technical
students: a compact, one-page-style **resume** (`resume.tex`) and a fuller,
academic-style **CV** (`cv.tex`). Both are built on the same custom LaTeX
macros, so entries look consistent across the two documents.

## resume.tex

A concise, achievement-driven resume that groups work by theme and keeps each
entry to a couple of high-impact bullets.

1. Header — name, links (GitHub, Scholar, ResearchGate, Scopus, Portfolio,
   LinkedIn), email, and phone.
2. Education — degree, institute, location, dates, GPA.
3. Publications & Peer Reviews — Journal / Conference / Poster / Peer Review
   subsections, each with authors, title, venue, and links.
4. Experience — grouped by theme (e.g. Robotics & Computer Vision,
   Generative AI & Predictive Maintenance), with detailed bullets per role.
5. Projects — selected project work with measurable outcomes.
6. Leadership & Teaching — roles, contributions, and teaching impact.
7. Awards & Achievements — competition outcomes and recognitions.
8. Technical Skills — courses, languages, robotics/ML tools, engineering
   software.

## cv.tex

A longer-form CV that separates roles by category and keeps most entries to
a title/one-line topic rather than full bullet descriptions.

1. Header — name and contact/profile links.
2. Education
3. Honours & Scholarships
4. Publications & Peer Reviews — same Journal / Conference / Poster / Peer
   Review breakdown as the resume.
5. Research Experience — position, institution, supervisor, one-line topic.
6. Industry Experience — same condensed format, for industry roles.
7. Teaching Experience
8. Leadership & Volunteering Experience
9. Awards & Achievements
10. Professional Activities — society memberships, etc.
11. Technical Skills

## Building

Both files are self-contained; compile either with:

```bash
pdflatex resume.tex
pdflatex cv.tex
```

Requires a standard TeX Live installation (`fontawesome5`, `titlesec`,
`enumitem`, `tabularx`, `fancyhdr`, and `hyperref` are used by both files).

## License

MIT License.
You can reuse and adapt these templates for your own resume or CV.

---

<p align="center">
  <strong>⭐ IF THIS HELPS, PLEASE STAR THE REPO! ⭐</strong>
</p>
