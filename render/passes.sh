#!/bin/bash
# http://www.imagemagick.org/Usage/masking/#two_background

set -e
pov=$1

povray -D0 +A0.0 +AM2 +J -H512 -W512 DECLARE=Pass=1 +Fn +O${pov}1.png -I${pov}.pov
povray -D0 +A0.0 +AM2 +J -H512 -W512 DECLARE=Pass=2 +Fn +O${pov}2.png -I${pov}.pov
