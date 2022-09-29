# update version

VERSION="1"

SCRIPT_URL='https://github.com/anuja-mohalkar/AudIT/blob/main/audit1.sh'



# No need to update version

SCRIPT_LOCATION="${BASH_SOURCE}"

ABS_SCRIPT_PATH=$(readlink -f "$SCRIPT_LOCATION")

TMP_FILE=$(mktemp -p "" "XXXXX.sh")



curl -s -L "$SCRIPT_URL" > "$TMP_FILE"

NEW_VER=$(grep "^VERSION" "$TMP_FILE" | awk -F'[="]' '{print $3}')

if [[ "$VERSION" < "$NEW_VER" ]]; then

    printf "Updating script \e[31;1m%s\e[0m -> \e[32;1m%s\e[0m\n" "$VERSION" "$NEW_VER"

    cp -f "$TMP_FILE" "$ABS_SCRIPT_PATH" || printf "Unable to update the script"

else

     printf "Already the latest version."

fi

echo curl -s -L "$SCRIPT_URL" > "$TMP_FILE"

