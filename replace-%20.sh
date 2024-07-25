#recursively, buggy
#for x in `find . -type f -name "*.docx" -o -name "*.doc" -o -name "*.pdf"`; do 

#nonrecursive
#for x in *; do
for x in *.docx *.doc *.pdf *.pps *.pptx; do
    echo "$x"
    mv -- "$x" "${x//%20/ }"
done

