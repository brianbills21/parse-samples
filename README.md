# parse-samples
Bash script that runs awk and parses binary samples. The script reads from an input file and returns useful data in the form of samples and channels.
```
The included binary file "samples.bin" contains a series of unsigned 16-bit values. 
These values make up a series of "Samples" where each sample 
is comprised of 4 channels and each channel is comprised of one 16-bit value.

The data is structured like so:

          ch0 ch1 ch3 ch3
Sample 0: u16 u16 u16 u16 
Sample 1: u16 u16 u16 u16
...
Sample N: u16 u16 u16 u16
```

That is, the data for sample 0 contained in the first 8 bytes of the file. 
The data for sample 1 is made up of the next 8 bytes and so on.

## Total Samples
Run the script sample.sh and return the total number of samples. Use the provided input file samples.bin for this example.
```
./sample18.sh -t samples.bin
Total Samples: 374371
```
## Range of values for samples and channels
Pass a set of ranges to the script for samples and channels
```
./sample.sh -s 0-9 -c 0-3 samples.bin
                Ch0     Ch1     Ch2     Ch3
Sample 0:       0x1a03  0x1a03  0x4a03  0x5703
Sample 1:       0x4b03  0x4403  0x1e03  0x0904
Sample 2:       0x1003  0x1903  0x4003  0xae03
Sample 3:       0x1e03  0x2603  0x3303  0xad03
Sample 4:       0x1003  0x8403  0x4303  0x6203
Sample 5:       0xe003  0x1603  0x3403  0xc403
Sample 6:       0xf802  0x3b03  0x5303  0x6103
Sample 7:       0x1003  0x1503  0x4203  0x5803
Sample 8:       0x2303  0x1f03  0x5703  0x6203
Sample 9:       0x1703  0x7303  0x3103  0x3303
```
## Nonconsecutive values for samples and channels
```
./sample.sh -s 3,5,9,12 -c 0,3 samples.bin
                Ch0     Ch3
Sample 3:       0x1e03  0xad03
Sample 5:       0xe003  0xc403
Sample 9:       0x1703  0x3303
Sample 12:      0xba03  0xa003
```
## Mixed ranges and consecutive values
```
./sample.sh -s 1,3,5,7-9 -c 0,2-3 samples.bin
                Ch0     Ch2     Ch3
Sample 1:       0x4b03  0x1e03  0x0904
Sample 3:       0x1e03  0x3303  0xad03
Sample 5:       0xe003  0x3403  0xc403
Sample 7:       0x1003  0x4203  0x5803
Sample 8:       0x2303  0x5703  0x6203
Sample 9:       0x1703  0x3103  0x3303
```
## Ignore invalid values 
The script will ignore invalid and out of order values, and return valid results without exiting
```
./sample.sh -s 3,6-8,5-7,2 -c 2-3,3-6,9 samples.bin
                Ch2     Ch3
Sample 2:       0x4003  0xae03
Sample 3:       0x3303  0xad03
Sample 5:       0x3403  0xc403
Sample 6:       0x5303  0x6103
Sample 7:       0x4203  0x5803
Sample 8:       0x5703  0x6203
```
## Force user to include input file
The user must include the input file. (This is desired as hard coding input files is not a good practice)
```
./sample18.sh -s 3,5,9,12 -c 0,3
usage: ./sample18.sh ([-s samples] [-c channels] | -t) file
```
