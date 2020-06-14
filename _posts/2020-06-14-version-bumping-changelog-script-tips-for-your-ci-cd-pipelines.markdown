---
layout:     post
title:      "Versions/Bumping/Changelog script tips for your CI/CD pipelines"
author:     "eridem"
main-img:   img/featured/2017-11-19-multistage-builds-for-nodejs.jpg
permalink:  multistage-builds-for-nodejs
comments: true
---

## Getting the last tag

Play with tags means, in most of the cases, play with releases (production or beta ones). 

Some reasons:

- Tag and bump your current branch with a newer version when merge to your default branch (usually `master`).
- Create a cron job to release the latest tag at some specific day.

```sh
git fetch --tags &> /dev/null
LATEST_TAG=$(git tag | sort --version-sort | tail -n1)

echo "Latest tag: [$LATEST_TAG]"
# E.g. output:
# Latest tag: [1.2.3]
```

## Split major, minor and patch versions

When working with [Semantic Versioning](https://semver.org/) or other version strategies, we may want to understand which is our current major, minor and patch numbers.

Some reasons:

- When bumping based on your own strategy, you can decide which number to increment.

```sh
# Get the latest tag we have (it can work with our without 'v')
git fetch --tags &> /dev/null
VERSION_TAG=$(git tag | sort --version-sort | tail -n1)

MAJOR=$(tr '.' '\n' <<< "$VERSION_TAG" | head -n1 | tail -n1)
MAJOR=${MAJOR/v/}
MINOR=$(tr '.' '\n' <<< "$VERSION_TAG" | head -n1 | tail -n2)
PATCH=$(tr '.' '\n' <<< "$VERSION_TAG" | head -n1 | tail -n2)

echo "Major: [$MAJOR], Minor: [$MINOR], Patch: [$PATCH]"
# E.g. output:
# Major: [1], Minor: [2], Patch: [3]
```

## Obtain the logs between two tags or branches

We can obtain the logs between two tags with GIT, in a pretty format.

Some reasons:

- Create documentation based on the difference between two releases.
- Use it as changelog on your beta system.
- Inform your testers or stakeholders about changes.
- Use it to filter comments and triggers other procedures. 

```sh
FROM="1.0.0"
TO="master"  # Or "2.0.0"

CHANGELOG=$(git log --pretty=format:"%s" "$FROM".."$TO")

echo "$CHANGELOG"
# E.g. output:
# [BUGFIX] JIRA-148: Fix toolbar color which was displayed wrongly
# [PATCH] JIRA-145: Add more retries when connection problems
# [MINOR] JIRA-143: Add section to change the username
# [BUGFIX] JIRA-142: Fix animation not displayed when login
```

## Do replacements on the log for better documentation

We may want to do changes on the logs, for documenting proposes.

Some reasons:

- Human readable logs.
- Replace log words with other ones:
  - Use emojis on the log and words on the changelog.
  - Use keywords on the log and words on the changelog.
- Remove unnecesary logs from the documentation:
  - Merge with other branches
  - Bump logs
  - CI bot logs
  - Fix conflicts logs

```sh
CHANGELOG=$(git log --pretty=format:"%s" "1.0.0".."2.0.0")

# Example for string substitution based on emojis
LOG=$(echo "$LOG" | sed -e $'s/💥/\[BREAKING_CHANGE\] /g')
LOG=$(echo "$LOG" | sed -e $'s/🎉/\[FEATURE\] /g')
LOG=$(echo "$LOG" | sed -e $'s/🐛/\[BUGFIX\] /g')
LOG=$(echo "$LOG" | sed -e $'s/🐞/\[BUGFIX\] /g')
LOG=$(echo "$LOG" | sed -e $'s/🔥/\[IMPROVEMENT\] /g')

# Remove logs that we do not want to report:
for FIND in "^Merge branch.*" "^Merge pull.*" ".*Bump to.*" ".*Bump version.*" ".*Bump build.*" ".*Fix conflicts.*"; do
  LOG=$(echo "$LOG" | sed -e $"s/$FIND//g")
done
```

## Getting current branch

Usually our CI will let us know, with an environment variable, in which branch, tag and hash we are. Although, if we get lost on the way, we can use the following commands:

```sh
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "Current branch: [$CURRENT_BRANCH]"
# E.g. output:
# Current branch: [master]

CURRENT_HASH=$(git log -1 --pretty=format:%h)
echo "Current hash: [$CURRENT_BRANCH]"
# E.g. output:
# Current branch: [a4f2e19d]

# This command will ONLY work if you know you are in a tag
CURRENT_TAG=$(git describe --tags --abbrev=0)
echo "Current tag: [$CURRENT_TAG]"
# E.g. output:
# Current branch: [1.2.3]
```
