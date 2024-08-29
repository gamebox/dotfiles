if [ ! -z "$RUBY_VERSION"];
then
    export RUBY_VERSION="2.6.0"
fi
export GEM_HOME=$HOME/.gem
local GEM_BIN=$GEM_HOME/bin
ls "$GEM_BIN" >> /dev/null 2>&1
if [ "$#" -ne 0 ];
then
    ERROR="$ERROR:Ruby Gem Bin directory not found\n"
fi
export PATH=$GEM_BIN:$PATH
local RUBY_BIN=$GEM_HOME/ruby/$RUBY_VERSION/bin
ls "$RUBY_BIN" >> /dev/null 2>&1
if [ "$#" -ne 0 ];
then
    ERROR="$ERROR:Ruby Bin directory not found\n"
fi
export PATH=$RUBY_BIN:$PATH

