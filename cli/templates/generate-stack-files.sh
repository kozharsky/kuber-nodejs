#!/bin/bash




################################################################
## PARAMS PARSE
################################################################

FORCE=0
SKIP_VOLUME_CREATION=0
for i in "$@"
do
case $i in
    --volume-wp=*)
    VOLUME_ID_WP=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
    ;;
    --stack-name=*)
    STACK_NAME=`echo $i | sed 's/[-a-zA-Z0-9]*=//'`
    ;;
    -f)
    FORCE=1
    ;;
    --skip-volume-creation)
    SKIP_VOLUME_CREATION=1
    ;;
    *)
    echo "Unknown option ${i}"
    ;;
esac
done

################################################################
## INTIALIZAITION
################################################################

SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
pushd . > /dev/null
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null


if [ -d "$STACK_NAME" ]; then
   if [ $FORCE == 0 ]; then
      echo "Directory $STACK_NAME already exists"
      exit 1
   else
      echo "Removing $STACK_NAME directory as long -f parameter present"
      mkdir -p ./backup
      NOW=$(date +"%Y-%m-%d-%H-%M")
      mv $STACK_NAME ./backup/$NOW-$STACK_NAME
   fi
fi

mkdir $STACK_NAME

arr_files=( $(ls $SCRIPT_PATH/kubernates) )
for i in ${arr_files[@]}
do 
    echo "Generating ./$STACK_NAME/$i"
    sed -e 's/%ECR_REPO%/'${ECR_REPO}'/g' -e 's/%STACK_NAME%/'${STACK_NAME}'/g' $SCRIPT_PATH/kubernates/$i > ./$STACK_NAME/$i
done




