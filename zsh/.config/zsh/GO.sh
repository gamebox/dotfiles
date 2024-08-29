if [ ! -z "$GO_VERSION"];
then
    export GO_VERSION="1.22.0"
fi

export GO_HOME="$HOME/sdk/go$GO_VERSION/bin"
ls "$GO_HOME" > /dev/null 2>&1
if [ "$#" -ne 0 ];
then
    ERROR="$ERROR:GO home not found"
fi
export GO_BIN="$HOME/go/bin"
ls "$GO_BIN" > /dev/null 2>&1
if [ "$#" -ne 0 ];
then
    ERROR="$ERROR:GO Bin not found"
fi
export PATH="$GO_BIN:$GO_HOME:$PATH"

