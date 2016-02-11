#!/usr/bin/env bash
cleanup() { # This has been trapped to the EXIT, INT, and ABRT signals
	([ ! -z "$TMPDIR" ] && [ -d "$TMPDIR" ]) && rm -rf "$TMPDIR"
}
displayHelp() {
	echo -e "Usage: $(basename "$0") [OPTIONS] --file [FILE] --output-dir [OUTPUT DIR]"
	echo -e "Creates SpringBoard icons of all sizes, and outputs to the given directory"
	echo -e "Note that an input image cannot be in Apple's mutilated PNG format, otherwise ImageMagick will balk at it"
	echo -e
	echo -e "Mandatory parameters:"
	echo -e "  -f,  --file        Specify the base image"
	echo -e "  -o,  --output-dir  Specify an output directory"
	echo -e
	echo -e "Optional parameters:"
	echo -e "  -h,  --help        Display this usage message"
	echo -e "  -q,  --quiet       Display only error messages"
	echo -e "  -v,  --version     Display version information"
	echo -e
	echo -e "       --crop        Crop the image"
	echo -e "       --crush       Compress the image"
	echo -e "       --resize      Resize the image"
	echo -e
	echo -e "       --mask        Use icon masks"
	echo -e "       --outline     Use icon outline"
	echo -e "       --overlay     Use icon gloss"
	echo -e "       --shadow      Use icon shadows"
	echo -e "       --shape       Use cookie-cutters"
}
displayVersion() {
	echo -e "$__title__ $__version__"
	echo -e "$__author__"
}
vecho() { # If quiet mode is on, only errors from ImageMagick will be shown
	([ "$opt_quiet" == 0 ] || [ -z "$opt_quiet" ]) && echo "$@"
}

# Docstrings in bash
__author__="dxs <dxs444@gmail.com>"
__title__="MakeIcon.sh"
__version__="0.1"

LIBRARY="/var/mobile/Library/MakeIcon.sh"
ORIG_DIR="$PWD"
RESOURCES="$LIBRARY/Base"
TMPDIR="$(mktemp -d /tmp/$(basename "$0" .sh)-XXXXXXXX)"

baseIcon="$TMPDIR/Base.png"
tmpIcon="$TMPDIR/Temporary.png"

trap "cleanup; exit" EXIT INT ABRT

# Options
opt_mask=0
opt_outline=0
opt_overlay=0
opt_shadow=0
opt_shape=0

opt_crop=0
opt_quiet=0
opt_resize=0
opt_pincrush=0

while [ "$#" -gt 0 ]; do
	case "$1" in
		-f | --file )			INPUT_FILE="$2"; shift;;
		-o | --output-dir )		OUTPUT_DIR="$2"; shift;;
		
		-h | --h | -help | --help | --usage ) displayHelp; exit 0;;
		-q | --quiet )			opt_quiet=1;;
		-v | --version )		displayVersion; exit 0;;
		
		--crop )			opt_crop=1;;
		--pincrush )		opt_pincrush=1;;
		--resize )			opt_resize=1;;
		
		--mask )			opt_mask=1;;
		--outline )			opt_outline=1;;
		--overlay )			opt_overlay=1;;
		--shadow )			opt_shadow=1;;
		--shape )			opt_shape=1;;
		
		--resource | --resources )	RESOURCES="$2"; shift;; # For debugging purposes
		
		* ) echo -e "Unrecognized parameter \"$1\"\nUse the --help parameter for usage instructions"; exit 1;;
	esac
	shift
done

# Check arguments
if [ -z "$INPUT_FILE" ]; then
	echo "Input file not specified"
	exit 1
elif [ -z "$OUTPUT_DIR" ]; then
	echo "Output directory not specified"
	exit 1
elif [ ! -d "$RESOURCES" ]; then
	echo "Resources directory does not exist!?"
	exit 1
fi

# Dependency checks
for dependency in basename convert dirname identify mktemp djpeg; do
	if [ ! "$(which "$dependency" 2>/dev/null)" ]; then
		echo "Command \"$dependency\" not found"
		exit 1
	fi
done

# Get absolute pathnames, helps in some cases
cd "$ORIG_DIR"; mkdir -p "$OUTPUT_DIR"; cd "$OUTPUT_DIR"
OUTPUT_DIR="$PWD"
cd "$ORIG_DIR"; cd "$(dirname "$INPUT_FILE")"
INPUT_FILE="$PWD/$(basename "$INPUT_FILE")"

# Safety checks
if [ ! -r "$INPUT_FILE" ]; then
	echo "Input file does not exist" >&2
	exit 1
fi

# Make things easier by converting into PNG first
convert "$INPUT_FILE" "$baseIcon" &>/dev/null

# Is this a compressed JPEG?
if [ ! -s "$baseIcon" ]; then
	djpeg -outfile "$TMPDIR/PBMPLUS.tmp" "$INPUT_FILE" &>/dev/null
	convert "$TMPDIR/PBMPLUS.tmp" "$baseIcon" &>/dev/null
	rm -f "$TMPDIR/"*.tmp
fi

# Unsupported by ImageMagick
if [ ! -s "$baseIcon" ]; then
	echo "Image format unsupported" >&2
	exit 1
fi

# Crop the image
if [ "$opt_crop" == 1 ]; then
	vecho "Cropping image"
	size="$(identify -quiet -ping -format "%w %h" "$baseIcon" 2>/dev/null)"
	size_x="${size% *}"; size_y="${size#* }"
	[ "$size_x" -le "$size_y" ] && size_new="${size_x}x${size_x}"
	[ "$size_x" -gt "$size_y" ] && size_new="${size_y}x${size_y}"
	convert "$baseIcon" -quiet -crop "$size_new" "$TMPDIR/Crop-TMP.png"
	mv -f "$TMPDIR/Crop-TMP-0.png" "$baseIcon"
	rm -f "$TMPDIR/Crop-TMP"*".png"
fi

IFS=$'\n' # It's generally more of an annoyance to leave it as default anyways

for type_raw in $(ls -x -1 "$RESOURCES"); do
	type_base="${type_raw% *}"
	for def_raw in $(ls -x -1 "$RESOURCES/$type_raw"); do
		def_base="${def_raw% *}"
		
		# Preparations
		vecho -n "$type_base [$def_base]: "
		cd "$RESOURCES/$type_raw/$def_raw"
		cp "$baseIcon" "$tmpIcon"
		
		# Decide on the final image name
		target="$OUTPUT_DIR/$type_base"
		if [ "${def_base#${def_base%?}}" == "x" ] || [ "${def_base#${def_base%?}}" == "X" ]; then
			target+="@$def_base"
		elif [ "$def_base" != "$def_raw" ]; then
			target+="-$def_base"
		fi
		target+=".png"
		
		# Resize image
		if [ "$opt_resize" == 1 ]; then
			vecho -n "Resize "
			size="$(identify -quiet -ping -format "%w %h" "$(ls -x -1 2>/dev/null | head -n 1)" 2>/dev/null)"
			size_x="${size% *}"; size_y="${size#* }"
			[ "$size_x" -le "$size_y" ] && size_new="${size_x}x${size_x}"
			[ "$size_x" -gt "$size_y" ] && size_new="${size_y}x${size_y}"
			convert "$tmpIcon" -quiet -resize "$size_new" "$tmpIcon"
		fi
		
		# Overlay
		if [ -f "$PWD/Overlay.png" ] && [ "$opt_overlay" == 1 ]; then
			vecho -n "Overlay "
			convert "$tmpIcon" "$PWD/Overlay.png" -quiet -composite "$tmpIcon"
		fi
		
		# Outline
		if [ -f "$PWD/Outline.png" ] && [ "$opt_outline" == 1 ]; then
			vecho -n "Outline "
			convert "$PWD/Outline.png" "$tmpIcon" -quiet -composite "$tmpIcon"
		fi
		
		# Cookie-cutter shapes
		if [ -f "$PWD/Shape.png" ] && [ "$opt_shape" == 1 ]; then
			vecho -n "Shape "
			convert "$PWD/Shape.png" "$tmpIcon" -quiet -compose SrcIn -composite "$tmpIcon"
		fi
		
		# Mask
		if [ -f "$PWD/Mask.png" ] && [ "$opt_mask" == 1 ]; then
			vecho -n "Mask "
			# alpha="$(convert "$PWD/Mask.png" -quiet -crop 1x1+0+0 txt:- | sed -n 's/.* \(#.*\)/\1/p' | cut -d " " -f 1)"
			convert "$tmpIcon" "$PWD/Mask.png" -quiet -alpha off -compose copy_opacity -composite "$tmpIcon"
		fi
		
		# Drop shadow
		if [ -f "$PWD/Shadow.png" ] && [ "$opt_shadow" == 1 ]; then
			vecho -n "Shadow "
			convert "$PWD/Shadow.png" "$tmpIcon" -quiet -composite "$tmpIcon"
		fi
		
		# Compress the PNG (pincrush)
		if [ "$opt_pincrush" == 1 ]; then
			vecho -n "Crush"
			if [ "$(pincrush "$tmpIcon" "$target" &>/dev/null)$?" != 0 ]; then
				vecho -n "!"
				cp "$tmpIcon" "$target"
			fi
			vecho -n " "
		else
			cp "$tmpIcon" "$target"
		fi
		
		rm -f "$tmpIcon"
		vecho
	done
done
