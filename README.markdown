# stroop



## Usage

Run SBCL or your Common Lisp implementation of choice in the main project directory
with the command line flag to load app.lisp. If your common lisp implementation 
does not provide this flag you can type:

    sbcl --load app.lisp

Which will load the application, it may take a minute or two because it has to 
load the word frequency table into memory.

## Installation

Unpack the dictionary.xz in the data directory to the main project directory.

## How To Run The Test Suite

Start by loading the app.lisp as in the 'usage' section. Then from the main 
project directory load the test suite:

    (load "t/stroop.lisp")

## Author

* John David Pressman

## Copyright

Copyright (c) 2015 John David Pressman

