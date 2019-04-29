= Readme

== Introduction

AsciiMint is a wrapper enviroment around Asciidoctor and Latex ecosystems that helps to more easily and elegantly publish texts in HTML (web), HTML (presentation), PDF (through (Xe)Latex), PDF (directly), Docbook, ePub (not complete yet), DocX (not complete yet). The idea is to use one pure document in text (Asciidoc) alongside figures in many flavors to create quality publications for Web, Paper, Presentation at the same time.

Features include:
- One-click (actually one command!) solution to produce HTML, PDF (through (Xe)Latex), PDF (directly), Docbook, ePub (not complete yet), DocX (not complete yet)
- Being able to use Persian keywords for Asciidoctor macro names and attributes (translation to English version)
- An extra set of roles in Asciidoctor that is being translated to (Xe)Latex and HTML at the same time
- Automatic compilation of figures in Tikz(tex) and R and including them in the document
- Automatic conversion of figures in Tikz(tex), R, SVG, PDF, PNG, to their corresponding PDF, PNG and including them in the document
- Asciimint (Xe)Latex package includes a series of macros and styles
- Asciimint HTML CSS includes a seris of styles
- Same solution for citation and bibliography for both HTML and (Xe)Latex
- Same solution for accronyms for both HTML and (Xe)Latex
- Updates (copies) the needed source files from different locations

== Instructions
- Copy AsciiMint file somewhere (let's call it "app folder")
- Create a folder for your project (let's call it "base folder")
- Put your `something.adoc.txt` file in the base folder
- Copy and paste `config_sample.yaml` from app folder to base folder,rename it to `config.yaml` and the edit as appropriate
- You can ask AsciiMint through the config file to copy other files from some sources to the base folder, or you may just copy it manually. Things that normally can be copied are your source text `something.adoc.txt`, bibliography file, figures (in the figures folder), xmp data file
- run the `node some/folder/a` from the base folder, note that `some/folder `is the app folder. Also note to use `\` instead of `/` in Windows
- If things succeed output files would be in `output` folder (you can change in config file)
-Otherwise, look at `asciimint.log` to find error. For latex/xelatex compilation errors you should go inside `build` folder and look for `latexmd.log` (or other logs)

== Tips
- AsciiMint copies pdf output from latex/xetex output even if there is some error. So check `latexmd.log` sometimes to make sure every thing was fine.
- For latex things sometime it is good to clear build folder and rebuild if an error persists even after fixing. This can happen specially for bibliography things.

== Extended Language
- You should define acronyms like this to enable AsciiMint to expand the first one correctly:
	-:HTML: pass:q[[.acro]#indexterm2:[HTML]#]
	-:HTML-abbrev: pass:q[HyperText Markup Language ([.acro]#indexterm2:[HTML]#)]



