#!/bin/bash

# please replace the following with your org name
ORGANIZATION='1qlabs'

# name of the temporary repository
TEMP_REPO='temp-repo-for-labels'

# authenticate with GitHub (assumption is that you have already logged in using `gh auth login`)

# create a new temporary repository
gh repo create ${ORGANIZATION}/${TEMP_REPO} --private

# get a list of all repositories in the organization (excludes forks)
repos=$(gh repo list ${ORGANIZATION} --json name --jq '.[].name' -L 200 | tr -d '"')

# clone the labels from the temporary repository to all other repositories
for repo in $repos
do
    if [ "${repo}" != "${TEMP_REPO}" ]; then
        gh label clone ${ORGANIZATION}/${TEMP_REPO} --repo "${ORGANIZATION}/${repo}"
    fi
done

# delete the temporary repository
gh repo delete ${ORGANIZATION}/${TEMP_REPO} --yes
