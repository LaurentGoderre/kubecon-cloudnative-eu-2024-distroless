#!/usr/bin/env bash
set -Eeo pipefail

currentAlpine="v$(grep '^VERSION' /etc/os-release | grep -o -E '=([0-9]*\.[0-9]*)' | cut -c2-)"
packages=( $(jq -r 'keys_unsorted[]' $1) )
sbom="[]"

for package in "${packages[@]}"; do
    packageVersion=$(jq -r ".[\"$package\"].version" $1)
    alpineVersion=$(jq -r ".[\"$package\"].alpine | select( . != null )" $1)
    alpineVersion="${alpineVersion:-$currentAlpine}"

    if [ -z "$(cat /etc/apk/repositories | grep \/alpine\/$alpineVersion\/)" ]; then
        echo -e "https://dl-cdn.alpinelinux.org/alpine/$alpineVersion/main\nhttps://dl-cdn.alpinelinux.org/alpine/$alpineVersion/community" > /etc/apk/repositories
        apk update > /dev/null
    fi

    # Validates version exists
    apk add -s "$package=$packageVersion" > /dev/null

    echo "Fetching $package version $packageVersion"
    tar="$(apk fetch "$package" | awk '{print $2}')"

    echo "Extracting"
    tar -xf "$tar.apk" -C /build
done
