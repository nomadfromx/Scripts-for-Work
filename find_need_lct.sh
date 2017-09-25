for FILE in `find $APPL_TOP -name "*.lct"`
do
grep -l MTL_INTERORG_PARAMETERS $FILE
done
