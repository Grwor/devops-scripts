#!/bin/bash

create_group() {
    local group_name=$1
    if getent group "$group_name" > /dev/null 2>&1; then
        echo "Error: Group '$group_name' already exists"
    else
        groupadd "$group_name"
        echo "Group '$group_name' created"
    fi
}

create_user() {
    local username=$1
    local group_name=$2
    if id "$username" > /dev/null 2>&1; then
        echo "Error: User '$username' already exists"
    else
        useradd -m -G "$group_name" "$username"
        echo "User '$username' created in group '$group_name'"
    fi
}

create_group "Dev"
create_group "Ops"
create_user "devuser1" "Dev"
create_user "opuser1" "Ops"
create_user "opuser2" "Ops"
