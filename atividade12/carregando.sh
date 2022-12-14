#!/bin/bash
# tm=$(bc; echo "scale=2"; echo $1 / 100)
max_width=$(tput cols);

function progress () {
local percent=${1}
local max_bar=$(( ${max_width} - 8))
local width=$(( ${max_bar} * ${percent} / 100 ))
if [ ${width} -gt ${max_bar} ] ; then
width=${max_bar}
fi

local bar=""
while [ ${#bar} -lt ${width} ] ; do bar="${bar}>"; done;
while [ ${#bar} -lt ${max_bar} ] ; do bar="${bar} "; done;
while [ ${#percent} -lt 3 ] ; do percent=" ${percent}"; done;

echo -ne "[${bar} ${percent}%]\r"
}

value=0;
while [[ ${value} -lt 101 ]] ; do
progress ${value}
sleep 0.6
(( value++ ))
done;

echo
