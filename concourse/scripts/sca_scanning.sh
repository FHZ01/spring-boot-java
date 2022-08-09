#!/bin/bash

# Install the binaries we need to use the security scripts.
echo "Installing prerequisites..."
export DEBIAN_FRONTEND=noninteractive # Allows us to install tzdata with no interactive prompts
apt-get -qq update > /dev/null
apt-get install -y tzdata > /dev/null
apt-get install -qq wget curl openssl openjdk-8-jdk maven git > /dev/null
echo -e "Done \n"

# CD into the directory that contains the .git database and checkout our branch
cd ./$git_resource

# If we are in a pull request then get branch name. Otherwise check out our main branch
if [[ $git_resource = "pull-request" ]]; then
    branch_name=$(cat .git/resource/head_name)
    git fetch --all --quiet # Fetch the remote branch so we can pass the correct branch to the SCA scan
    git checkout $branch_name
    git pull --force
else
    branch_name=$main_branch_name
    git checkout $branch_name
fi

echo "Branch name: $branch_name"
echo "Main branch bame: $main_branch_name"

# Download the 'sca-runner' script from S3 and invoke it.
# Variables are mapped through from the Pipeline and Task
echo "Downloding sca-runner script"
bash <(curl -s -L https://sac-dev-artifacts-devsecops-main.s3.eu-west-1.amazonaws.com/sca-runner) \
    --bd-api-token="$blackduck_token" \
    --bd-search-depth="5" \
    --bd-force-success="false" \
    --scm-system="GITHUB-UK" \
    --aws-access-key="$access_key_id" \
    --aws-secret="$secret_access_key" \
    --bd-source-path="../" \
    --scm-main-branch=$main_branch_name
