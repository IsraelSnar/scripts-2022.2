#!/bin/bash
# Nota: 1,0
# A

ls html/*.html | sed -e 's/^.*$/\U&/' -e 's/L$//'

