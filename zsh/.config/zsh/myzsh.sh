local ERROR=""

function __in_array() {
    local needle="$1"
    shift 1
    local haystack=("$@")

    local value
    for value in "${haystack[@]}"; do
        [ "$value" = "$needle" ] && return 0
    done
    return 1
}

source "$HOME/.config/zsh/HOMEBREW.sh"
source "$HOME/.config/zsh/INIT.sh"

local -a ALL_MODS=(`ls "$HOME"/.config/zsh/*.sh | sed "s_.*/.config/zsh/\([a-zA-Z]*\).sh_\1_" | grep -vE "(HOMEBREW|INIT|myzsh)"`)

local MOD
for MOD in ${ZSH_MODULES[@]}; do
    if __in_array "$MOD" "${ALL_MODS[@]}"; 
    then
            source "$HOME/.config/zsh/$MOD.sh"
    else
            echo "This module is not recognized: '$MOD'"
    fi
done

if [ ! -z "$ERROR" ];
then
    echo "Did not start up correctly, there were the following errors:\n$ERROR"
fi
