set -ex

env="$1"

if [ "$env" != "mirror" ]; then
  env="product"
fi

echo "change app rawfile by env $env"

WORK_DIR=$(
  cd $(dirname $0)
  pwd
)

echo "WORK_DIR: $WORK_DIR"

cp -rf ../appFlavorConfig/$env/resources ../AppScope/
