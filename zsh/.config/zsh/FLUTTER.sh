if [ ! -z "$FLUTTER_PATH" ];
then
    export PATH="$PATH:$FLUTTER_PATH"
else
    echo "Flutter not installed"
    ERROR="$ERROR:Flutter path not set\n"
fi
