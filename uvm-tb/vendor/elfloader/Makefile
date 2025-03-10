QUESTAHOME ?= /tools/Siemens_EDA/questasim/2021.3/questasim/include

all: elfloader.so

elfloader.so:
	g++ -fPIC -shared -O3 -g3 -std=c++11 -I$(QUESTAHOME) elfloader.cc -o elfloader.so

clean:
	rm -f elfloader.so
