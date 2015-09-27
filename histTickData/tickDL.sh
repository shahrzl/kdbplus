#!/bin/bash

symbols=(GE.N)

dates=(0924 0925)

element_count=${#symbols[@]}
dates_count=${#dates[@]}

echo "No of Symbols: $element_count"

echo "No of Dates: $dates_count"

for i in "${symbols[@]}"
do
        for j in "${dates[@]}"
        do
                echo "$i $j"
                _file="taq/trade$i$j.csv"
                echo $_file
                java TickDL trade 2015 $j $i > "$_file"
        done
done
