#!/bin/bash
# ensure we are in the right dir
cd $(dirname $0)/..;
# check for a git dir
if [[ ! -e .git ]]; then
    echo "No .git directory here, exiting" >&2;
    exit 1;
fi
s
# be on master and get the updates
git checkout master;
git reset --hard origin/master
git fetch origin;
# inspect what has changed
flist=$(git diff --name-only origin/master);
if [[ -z "${flist}" ]]; then
    # no changes, we are done
    exit 0;
fi
# there are updates, do them
git pull;

# now, run SQL files
for sql_file in ./sql/**/*.sql; do
    echo "executing: ${sql_file}"
    sudo -u postgres psql -Xd $DB_NAME -f "${sql_file}"
done
exit $?;
