#!/bin/bash
# http://www.imagemagick.org/Usage/masking/#two_background

set -e

pov=$1

convert ${pov}1.png ${pov}2.png -alpha off \
	\( -clone 0,1 -compose difference -composite \
		-separate -evaluate-sequence max -auto-level -negate \) \
	\( -clone 0,2 -fx "v==0?0:u/v-u.p{0,0}/v+u.p{0,0}" \) \
		-delete 0,1 +swap -compose Copy_Opacity -composite \
	${pov}.png

convert ${pov}.png -resize 96x96 ${pov}-hr.png
convert ${pov}.png -resize 48x48 ${pov}-lr.png

convert ${pov}.png -crop 464x464+24+16 -resize 32x32 ${pov}-icon.png
convert ${pov}.png -crop 464x464+24+16 -resize 144x144 ${pov}-thumb.png
convert ${pov}.png -crop 464x464+24+16 -resize 128x128 ${pov}-tech.png
