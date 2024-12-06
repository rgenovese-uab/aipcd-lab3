This is the VPU project verification repository. To run a test you need to first setup the environment.

### Temporal Set-Up guide:
-------------

Clone the repo using 

```
git clone git@repo.hca.bsc.es:EPI/verification/vpu-dv.git
cd vpu-dv/
git checkout develop
```
Next, you must clone the VPU RTL repos. To do so run the following commands:
```
make clone_rtl
cd rtl/Vector_Acclerator
git checkout new-dv-env
```  

&nbsp;  

### Compilation and simulation guide (only using the Makefile):
-------------

To compile and simulate a binary with GUI follow these steps:

```
make TEST=/path_to_file/binary_name GUI=1
```

Else, if you want to simulate a binary without GUI follow these steps:

```
make TEST=/path_to_file/binary_name GUI=0
```

To remove compiled files:

```
make clean
```

&nbsp;  

### Compilation and simulation guide:

To compile and simulate a test, run the following command:
```
python3 run.py --test path_to_binary/binary_name
```

To compile and simulate a set of regressions, run the following command:
```
python3 run.py --regress regression_name
```
In the *regress/* folder you have the yaml that configure these regressions sets. 
There are of four types, single test ones, sets and lists.

For more details on the run.py script run:
```
python3 run.py -h
```
