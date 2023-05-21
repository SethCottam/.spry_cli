  ##############################################################################################
 ########  Mini-README - START                                                         ########
##############################################################################################
#
# This is an example for how to build of a family of functions as an individual python plugin
#
# Alternatively, you can also add a mew .py file with a single command
#	(ex. `print("Hello World");`) and call it by the typing the file's name from the command
#	line
#
# It really can be that simple
#
# Enjoy!!!
#
# Working:
# python example_python.py this that
#
# TODO: Need to fix this in the master controller
# Broken (Does not pass the args! Passes the name of the file):
# example_python this that
#
##############################################################################################
 ########  Mini-README - END                                                           ########
  ##############################################################################################



#!/usr/bin/env python
  ##############################################################################################
 ########  Example Python Functions - START                                            ########
##############################################################################################
#
# Example Title
# Shortcut - @example
# Description - Example description of the thing and purpose
# Author - Seth Cottam
# Dependencies - colors, format, finder
# Status - Operational

# It's possible just run raw classless python
print('Running the Example Python script');

# Imports (Standard)
import sys
# Imports (3rd Party)

# Imports (Local)


# For a simple Class
def main(args):
    """
    Quick and dirty runner for fast development. Zoom Zoom!
    """
    # TODO: Non of these exist. We should add Click...
    print('Running the main function!')
    print('args: %s' % args)
    # api_calls = ApiCalls()
    # api_calls.example_request_basic()


if __name__ == '__main__':
    print('sys.argv: %s' % sys.argv)
    main(sys.argv[1:])


##############################################################################################
####  Helper Child Functions (For Independent Shells)
##############################################################################################
# These should be included as helper functions with MOST independent shell scripts


##############################################################################################
####  Child Functions (Non-Standard)
##############################################################################################
# The unique functions that makes your parent function worth having


##############################################################################################
 ########  Example Python Functions - END                                              ########
  ##############################################################################################