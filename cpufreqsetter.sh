#!/bin/bash

helpFunction()
{
    echo ""
    echo "Usage: $0 -a lowestCpuFreq -b highestCpuFreq"
    echo -e "\t-a Lowest cpu frequency you want it to run (in MHz)"
    echo -e "\t-b Highest cpu frequency you want it to run (in MHz)"
    exit 1
}

while getopts "a:b:c" opt
do
    case "$opt" in
        a ) parameterA="$OPTARG" ;;
        b ) parameterB="$OPTARG" ;;
        ? ) helpFunction ;;
    esac
done

if [ -z "$parameterA" ] || [ -z "$parameterB" ]
then
    echo "Some or all of the parameters are empty";
    helpFunction
fi

echo "$parameterA"
echo "$parameterB"

a="${parameterA}MHz"
b="${parameterB}MHz"

sudo cpupower frequency-set --min $a
sudo cpupower frequency-set --max $b
