#!/usr/bin/env bash

usage() {
    echo "Usage: $(basename "$0") -r repository -p passfile [-d days] [-w weeks] [-m months] [source...]"
    exit 1
}

days=7
weeks=4
months=6

while getopts ':d:m:p:r:w:' OPTION; do
    case "$OPTION" in
        d)
            days="$OPTARG"
            ;;
        m)
            months="$OPTARG"
            ;;
        p)
            password="$(< "$OPTARG")"
            ;;
        r)
            repo="$OPTARG"
            ;;
        w)
            weeks="$OPTARG"
            ;;
        ?)
            usage
            ;;
    esac
done

shift "$((OPTIND - 1))"

sources=("$@")

[[ -n $repo ]] || usage
[[ -n $password ]] || usage
[[ -n ${sources[*]} ]] || usage

export RESTIC_REPOSITORY="$repo"
export RESTIC_PASSWORD="$password"

echo 'Configuration:'
echo "  Repository: $repo"
echo "  Retention policy: "
echo "    Days: $days"
echo "    Weeks: $weeks"
echo "    Months: $months"
echo '  Sources: '
for source in "${sources[@]}"; do echo "    - $source"; done

echo
echo '---------------'
echo 'Creating backup'
echo '---------------'

restic backup --verbose "${sources[@]}"

echo
echo '-------------------'
echo 'Checking repository'
echo '-------------------'

restic check --verbose

echo
echo '------------------'
echo 'Pruning repository'
echo '------------------'

restic forget --prune --verbose \
    --keep-daily "$days" \
    --keep-weekly "$weeks" \
    --keep-monthly "$months"

echo
echo 'Done!'
