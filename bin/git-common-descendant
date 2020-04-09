#!/usr/bin/env bash

commit_1="$1"
commit_2="$2"
branch="$(git rev-parse --abbrev-ref HEAD)"

if git merge-base --is-ancestor "$commit_1" "$commit_2"; then
    echo "$commit_2"
    exit 0
fi

if git merge-base --is-ancestor "$commit_2" "$commit_1"; then
    echo "$commit_1"
    exit 0
fi

while read -r merge_commit; do
    if
        git merge-base --is-ancestor "$commit_1" "$merge_commit" \
        && \
        git merge-base --is-ancestor "$commit_2" "$merge_commit";
    then
        echo "$merge_commit"
        exit 0
    fi
done < <(
    git rev-list \
        --topo-order \
        --reverse \
        --merges \
        --ancestry-path \
        "^$commit_1" \
        "^$commit_2" \
        "$branch"
)

exit 1