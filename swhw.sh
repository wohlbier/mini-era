#!/bin/bash
for ((i=0;i<=$1;i++)); do
    make sw_hw_area_$i
done
