
# ============================================================ Global variables

# These can be overwritten for customization in client code.
ZSH_GIT_STATUS_GIT_ICON="%{$fg[white]%}%f"
ZSH_GIT_STATUS_PREFIX="["
ZSH_GIT_STATUS_SUFFIX="]"
ZSH_GIT_STATUS_SEPARATOR="|"
ZSH_GIT_STATUS_CLEAN_ICON="%{$fg[green]%}✔%f"
ZSH_GIT_STATUS_MODIFIED_ICON="%{$fg[yellow]%}✚%f"
ZSH_GIT_STATUS_STAGED_ICON="%{$fg[green]%}✚%f"
ZSH_GIT_STATUS_UNTRACKED_ICON="%{$fg[red]%}✚%f"
ZSH_GIT_STATUS_CONFLICT_ICON="%{$fg[red]%}✖%f"

# =========================================================== Private functions

function get_array_data(){
    local git_output=$("$1")
    local array_data=$(echo $git_output | tr "\n" " ")  # intermediate step
    array_data=($(echo $array_data| tr "\t" " "))
    echo "$array_data"
    return 0
}

function get_git_branch(){
    local branch_name=""
    local star_symbol=""
    git branch 2> /dev/null | grep "\*" | read star_symbol branch_name
    echo "$branch_name"
    return 0
}

function get_number_modified(){
    local git_output=$(git diff --name-status)
    local array_data=$(echo $git_output | tr "\n" " ")  # intermediate step
    array_data=($(echo $array_data| tr "\t" " "))
    local modified=()
    for i in $(seq 1 2 ${#array_data[@]}); do
        local val="$array_data[$i]"
        [ "$val" = "M" -o "$val" = "D" ] && modified+=("$array_data[$((i+1))]")
    done
    echo ${#modified[@]}
    return 0
}

function get_number_staged(){
    local git_output=$(git diff --staged --name-status)
    local array_data=$(echo $git_output | tr "\n" " ")  # intermediate step
    array_data=($(echo $array_data| tr "\t" " "))
    local modified=()
    local conflicts=()
    for i in $(seq 1 2 ${#array_data[@]}); do
        local val="$array_data[$i]"
        [ "$val" = "M" -o "$val" = "A" -o "$val" = "D" ] \
        && modified+=("$array_data[$((i+1))]")
        continue
        [ "$val" = "U" ]  && conflicts+=("$array_data[$((i+1))]")
    done
    local res=("${#modified[@]}" "${#conflicts[@]}")
    echo "$res"
    return 0
}

function get_number_untracked(){
    local git_output=$(git status --porcelain)
    local array_data=$(echo $git_output | tr "\n" " ")  # intermediate step
    array_data=($(echo $array_data| tr "\t" " "))
    local modified=()
    for i in $(seq 1 2 ${#array_data[@]}); do
        [ "$array_data[$i]" = "??" ] && modified+=("$array_data[$((i+1))]")
    done
    echo ${#modified[@]}
    return 0
}

# ============================================================ Public functions

function get_git_status(){
    local branch_name=$(get_git_branch)
    if [ -z "$branch_name" ]; then
        echo ""
        return 0
    fi
    local status_="$ZSH_GIT_STATUS_GIT_ICON $ZSH_GIT_STATUS_PREFIX$branch_name"
    local mod_number=$(get_number_modified)
    local staged_number=0
    local conflicts_number=0
    read staged_number conflicts_number <<< $(get_number_staged)
    local untracked_number=$(get_number_untracked)
    [ $untracked_number != 0 ] \
    && status_+="$ZSH_GIT_STATUS_SEPARATOR$ZSH_GIT_STATUS_UNTRACKED_ICON$untracked_number"
    [ $mod_number != 0 ] \
    && status_+="$ZSH_GIT_STATUS_SEPARATOR$ZSH_GIT_STATUS_MODIFIED_ICON$mod_number"
    [ $staged_number != 0 ] \
    && status_+="$ZSH_GIT_STATUS_SEPARATOR$ZSH_GIT_STATUS_STAGED_ICON$staged_number"
    [ $staged_number = 0 -a $mod_number = 0 ] \
    && status_+="$ZSH_GIT_STATUS_SEPARATOR$ZSH_GIT_STATUS_CLEAN_ICON"
    [ $conflicts_number != 0 ] \
    && status_+="$ZSH_GIT_STATUS_SEPARATOR$ZSH_GIT_STATUS_CONFLICT_ICON$conflicts_number"
    status_+="$ZSH_GIT_STATUS_SUFFIX"
    echo "$status_"
    return 0
}

