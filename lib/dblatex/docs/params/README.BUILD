XSL Parameter Documentation Principle
-------------------------------------
- Each parameter is documented through an individual refentry file, like
  the DocBook Project does. These refentries stored unders params/ are the
  sources to maintain.

  There were built from the original parameter table (../custom/param.xml) with
  the command:

  xsltproc --xinclude ../../tools/param2ref.xsl ../custom/param.xml

  Each refentries XIncludes its related synopsis file. The reason of this
  structure (and not putting the synopsis directly in the refentries) is to be
  able to automatically update/sync the synopsis from the XSL stylesheets
  without modifying the refentries.

- The parameter synopsis are stored under the ./syn directory. They are 
  automatically produced from the dblatex XSL stylesheets with the following
  command:

  ../../tools/parambuild ./syn

- params/param.xml is the appendix that groups the whole refentries by
  XIncluding them. This file is currently maintained by hand, but it could be
  possible to build it through scripts.

- the params/param.xml file is XIncluded in the main documentation (manual.xml).

