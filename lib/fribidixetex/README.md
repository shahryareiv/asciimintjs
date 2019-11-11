FriBidiXeTeX
========

FriBidiXeTeX is a pre-processor for XeTeX files to support unicode bidirectional algorithm.

Usage
-----

To use FriBidiXeTeX, run the `fribidixetex` command on the XeTeX file, the resulting file
can then be processed by the XeTeX engine to produce the final output.

FriBidiXeTeX understands some special comments to control its behavior:

* `%BIDION`: activate FriBidiXeTeX special handling.
* `%BIDIOFF`: stop it
* `%BIDILTR`: the paragraph is mainly left-to-right with some right-to-left text.

Example
-------

Here is a sample `xepersian` document:

````latex
\documentclass{article}
\usepackage{xepersian}
\settextfont{Yas}
\setdigitfont{Yas}
\let\fribidixetexLRE\lr
\let\fribidixetexRLE\rl
\let\fribidixetexlatinnumbers\lr
\let\fribidixetexnonlatinnumbers\rl
%BIDION
\begin{document}    
این یک پاراگراف «پارسی» است به نام Simple text و این یک عدد 0887 به لاتین است.
%BIDIOFF
\begin{equation}
1+2=3\label{eq:1}
\end{equation}
%BIDION
این فرمول شماره
\ref{eq:1}
است.
%BIDILTR
\begin{latin}
Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.
\end{latin}
%BIDION
و ادامه متن که بعد از متن Lorem Imsum قرار می‌گیرد.
\end{document}
%BIDIOFF
````

This can be processed with FriBidiXeTeX, then by XeTeX to produce the final pdf:

    fribidixetex -n test.tex -o test.ltx
    xelatex test.ltx
    
    
Reporting bugs
-------
Please use [the issue tracker][1] to report bugs.


  [1]: https://github.com/vafa/fribidixetex/issues