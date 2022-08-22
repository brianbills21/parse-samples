#!/usr/bin/env bash

samps=""
chans=""
total=false

while getopts ':c:s:t' opt; do
    case $opt in
        s) samps="$OPTARG" ;;
        c) chans="$OPTARG" ;;
        t) total=true ;;
        *) printf 'Unrecognized option "%s"\n' "$opt" >&2
    esac
done
shift $(( OPTIND - 1 ))

# if input_file is not specified, print usage and exit
if (( $# == 0 )); then
  echo "usage: $0 ([-s samples] [-c channels] | -t) file"
  exit 1
fi

infile=$1
read -r size _ < <(wc -c "$infile")
lines=$(( (size - 1) / 8 ))             # last line number

if [[ $total == true ]]; then
  printf "Total Samples: "$(hexdump -v -e '8/1 "%02x " "\n"' "$infile" | wc -l)"\n"
else {
hexdump -v -e '8/1 "%02x " "\n"' samples.bin |
awk -v samps="${samps}" -v chans="${chans}" '

function fill_array(var,arr) {                             # NOTE: arrays are passed by reference so changes made here are maintained in parent

    m=split(var,_a,",")                                    # split variables on comma
    for (i=1;i<=m;i++) {
        n=split(_a[i],_b,"-")                              # further split each field on hyphen
        for (j=_b[1];j<=(n==1 ? _b[1] : _b[2]);j++)        # if no hyphen => n==1 so just re-use _b[1]
            arr[j]                                         # store value as array index
    }
}

BEGIN { OFS="\t"

        fill_array(samps,samps_arr)                        # parse variable "samps" and store as indices of samps_arr[] array
        fill_array(chans,chans_arr)                        # parse variable "chans" and store as indices of chans_arr[] array

        printf "%s", OFS                                   # print header ...
        for (i=0;i<=3;i++)                                 # loop through possible channel numbers and ...
            if (i in chans_arr)                            # if an index in the chans_arr[] array then ...
               printf "%sCh%d", OFS, i                     # print the associated header
        print ""                                           # terminate printf line
      }

      { if ((FNR-1) in samps_arr) {                        # if current line number (minus 1) is in samps_arr[] array then ...
           printf "Sample %d:", (FNR-1)                    # print our "Sample #:" line ...
           for (i=1;i<=NF;i=i+2) {                         # loop through odd-numbered fields and ...
               if ( (i-1)/2 in chans_arr) {                # if the associated group # is in the chans_arr[] array then ...
                  printf "%s0x%s%s", OFS, $(i), $(i+1)     # add to our output line
               }
           }
           print ""                                        # terminate printf line
        }
      }
'
}
fi