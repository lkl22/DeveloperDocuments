func="$1"
versionName="$2"

echo "versionName: $versionName"

# 字符串按指定字符转为数组
if [ "$func" == "1" ]; then
  IFS="."
  arr=($versionName)
elif [ "$func" == "2" ]; then
  arr=($(echo $versionName | awk 'BEGIN{FS=".";OFS=" "} {print $1,$2,$3,$4}'))
elif [ "$func" == "3" ]; then
  arr=(${versionName//\./ })
elif [ "$func" == "4" ]; then
  arr=($(echo "$versionName" | tr "\." " "))
fi
echo "${arr[@]}" "${arr[0]}" "${arr[1]}"

versionCode=$((${arr[0]} * 10000000 + ${arr[1]} * 100000 + ${arr[2]} * 1000 + ${arr[3]}))
echo "versionCode: $versionCode"
