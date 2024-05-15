
# =========================================================== Private functions

function get_git_branch(){
    local branch_name=""
    local star_symbol=""
    git branch 2> /dev/null | grep "\*" | read star_symbol branch_name
    echo "$branch_name"
    return 0
}


# ============================================================ Public functions

function get_git_status(){
    local branch_name=$(get_git_branch)
    local status_=""
    [ -z $branch_name ] || status_=" $branch_name"
    echo "$status_"
    return 0
}

