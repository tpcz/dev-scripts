# Generator of project copies - copy original files and replace a
# set of patters in files and file names.


# SETUP
FROM_DIR=/home/tomaspop/workspaces/drivers/ms5805
TO_DIR=/home/tomaspop/workspaces/drivers/ms5xxx
TEXT_REPLACEMENT_PATTERNS="MS5805:MS5XXX ms5805:ms5xxx competitor:Measurement-Specialities"
# applied to complete path!
FILENAME_REPLACEMENT_PATTERNS="ms5805:xxx"
REMOVE_TARGET_IF_EXISTS="NO"


replace_program=""
for p in $TEXT_REPLACEMENT_PATTERNS; do
    from=`echo $p | cut -f1 -d:`
    to=`echo $p | cut -f2 -d:`
    replace_program="${replace_program}s/$from/$to/g;"
done

echo "Going to create project copy:"
echo " * FROM " $FROM_DIR
echo " * TO " $TO_DIR
echo " * TEXT REPLACE: " $replace_program
echo " * REMOVE TARGET IF EXISTS: " $REMOVE_TARGET_IF_EXISTS
echo ""
echo "This process will run [make clean] in $FROM_DIR directory"
echo "Are you sure you want to continue? (y/n)"
read  answer
if ! [ $answer == 'y' ]; then
        echo "Aborted by user..."
        exit 1
fi

if [ $REMOVE_TARGET_IF_EXISTS == "YES" ]; then
      rm -rf $TO_DIR
fi

if [ ! -d $FROM_DIR ]; then
      echo "FROM is not a directory. Aborting..."
      exit 1
fi;

here=`pwd`
cd $FROM_DIR;
make clean > /dev/null
cd $here

dirs=`find $FROM_DIR -type d | grep -v '/\.' | sed 's@'$FROM_DIR'@'$TO_DIR'@g'`
for dirr in $dirs; do
  if ! mkdir -p $dirr; then
      echo "mkdir " $dirr "... [FAIL]"
      exit 1;
  fi
done

files=`find $FROM_DIR -type f | grep -v '/\.'`
for f in $files; do
  src="$f"
  dst="`echo $f | sed 's@'$FROM_DIR'@'$TO_DIR'@g'`"
  for fnrp in $FILENAME_REPLACEMENT_PATTERNS; do
      from=`echo $fnrp | cut -f1 -d:`
      to=`echo $fnrp | cut -f2 -d:`
      dst="`echo $dst | sed 's@'$from'@'$to'@g'`"
  done;
  if ! cp "$src" "$dst"; then
      echo "cp " "$src" "$dst" "... [FAIL]"
      exit 1;
  fi
  sed -i "$replace_program" "$dst"
done;

echo "[ DONE ] (see $TO_DIR)"

