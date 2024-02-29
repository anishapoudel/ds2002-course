#!/bin/bash

set -e

/usr/bin/tr '\t' ',' < $1 > $2
