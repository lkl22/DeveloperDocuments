set -ex

WORK_DIR=$(
  cd $(dirname $0)
  pwd
)

echo "WORK_DIR: $WORK_DIR"

var1=$1
var2=$2

if [ "$(echo "$var1" | tr '[:upper:]' '[:lower:]')" == "$(echo "$var2" | tr '[:upper:]' '[:lower:]')" ]; then
  echo "eq"
else
  echo "neq"
fi
