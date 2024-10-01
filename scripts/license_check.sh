touch files.cnt
(
    find . -type f -name "*.dart" ! -name "*.g.dart" ! -name "*.freezed.dart" ! -name "*.gen.dart" -path "./test/*" -path "./lib/*" ! -path "./lib/generated/*" &&
    find . -type f -name "*.dart" \( -path "./packages/*/test/**" -o -path "./packages/*/lib/**" \)
) | xargs -0 $(dirname -- "$0")/license_add.sh
CNT_VALUE="$(wc -l < files.cnt |  tr -d ' \t\n\r' )"
if [ $((CNT_VALUE)) -gt 0 ]
then
echo "There were $CNT_VALUE files without license"
rm -rf files.cnt
exit 1
fi
rm -rf files.cnt
