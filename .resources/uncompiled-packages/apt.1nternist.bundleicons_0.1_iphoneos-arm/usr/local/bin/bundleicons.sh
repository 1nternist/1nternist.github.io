#!/bin/bash

target=$1
outdir=$PWD/$(echo "$target" | cut -d '.' -f1)

mkdir -p "$outdir"
makeicon --crop --resize --shape --file "$1" --output-dir "$outdir" 2>/dev/null

echo "Your bundle icons have been created successfully. You can find your icons at `echo "$outdir"`."
exit 0
