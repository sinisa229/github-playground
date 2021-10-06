#!/bin/bash

# Given a Github username and organisation the script will output all the repositories that belong to the organisation in a out.txt file
# This file can then be used to create git clone commands

if [ -z "$1" ]; then
    echo "waiting for the following arguments: username + organisation-name"
    exit 1
else
    name=$1
fi

if [ -z "$2" ]; then
    echo "waiting for the following arguments: username + organisation-name"
    exit 1
else
    organisation=$2
fi

if [ -z "$token" ]; then
    echo "Please export the github token as a variable: 'export token=<YOUR_GITHUB_TOKEN>'"
    exit 1
else
    organisation=$2
fi

echo Username: $name
echo Organisation: $organisation
echo Start Page: $page

page=1
until [ $results -lt 1 ]
do
    echo Current Page: $page
    #curl -u $name:$token "https://api.github.com/$organisation/$name/repos?page=$page&per_page=100" | grep -e 'git_url*' | cut -d \" -f 4 | xargs -L1 git clone
    results=`curl -u $name:$token "https://api.github.com/orgs/$organisation/repos?page=$page&per_page=100" | grep -e 'git_url*' | wc -l`
    echo Current Results: $results
    curl -u $name:$token "https://api.github.com/orgs/$organisation/repos?page=$page&per_page=100" | grep -e 'git_url*' | cut -d \" -f 4 >> out.txt
    page=$((page+1))
    echo Incremented Page: $page
done

echo End Page: $page

exit 0
