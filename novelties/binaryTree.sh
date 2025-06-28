#!/bin/bash

declare -A tree

insert() {
    local node_name=$1
    local value=$2

    if [[ -z "${tree[$node_name]}" ]]; then
        tree[$node_name]=$value
        return
    fi

    local curr_value=${tree[$node_name]}

    if (( value >= curr_value )); then
        local right="${node_name}r"
        if [[ -z "${tree[$right]}" ]]; then
            tree[$right]=$value
        else
            insert "$right" "$value"
        fi
    elif (( value < curr_value )); then
        local left="${node_name}l"
        if [[ -z "${tree[$left]}" ]]; then
            tree[$left]=$value
        else
            insert "$left" "$value"
        fi
    fi
}

find() {
    local node_name=$1
    local value=$2

    local curr_value=${tree[$node_name]}

    if [[ -z "$curr_value" ]]; then
        return 1
    fi

    if (( value == curr_value )); then
        echo "Found in node: $node_name"
        return 0
    elif (( value > curr_value )); then
        find "${node_name}r" "$value"
        return $?
    elif (( value < curr_value )); then
        find "${node_name}l" "$value"
        return $?
    fi
}

print_tree() {
    echo "Tree contents:"
    for k in "${!tree[@]}"; do
        echo "$k => ${tree[$k]}"
    done
}

# ======== Test Code =========
insert test_tree6 1
insert test_tree6 5
insert test_tree6 8
insert test_tree6 1283
insert test_tree6 9999

echo
echo "Searching for value 8"
if find test_tree6 8; then
    echo "Result: Found."
else
    echo "Result: Not found."
fi

echo
echo "Searching for value 123"
if find test_tree6 123; then
    echo "Result: Found"
else
    echo "Result: Not found"
fi

echo
print_tree
