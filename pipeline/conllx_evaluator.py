#!/usr/bin/python

# name: conllx_evaluator.py
# usage: python conllx_evaluator.py system.conll gold.conll
# purpose: evaluating LAS and UAS of conllx-formatted pair of files.
# author: Edoardo Maria Ponti
# date of creation: 17th of September, 2015

#importing modules
from __future__ import division
import sys, os, codecs

#opening the system and gold files
system_file = str(sys.argv[1])
if os.path.exists(system_file) == False:
    print "File " + system_file + " does not exist"
    quit()
system = codecs.open(system_file, "r", encoding="utf-8")

gold_file = str(sys.argv[2])
if os.path.exists(gold_file) == False:
    print "File " + gold_file + " does not exist"
    quit()
gold = codecs.open(gold_file, "r", encoding="utf-8")

# setting counters
total = 0
correct_head = 0
correct_both = 0
delimiter = "\t"

# comparing lines
for line1, line2 in zip(system, gold):
    if line1.strip() == "":
        pass
    else:
        total += 1
        columns1 = line1.split(delimiter)
        columns2 = line2.split(delimiter)
        head1 = columns1[6]
        deprel1 = columns1[7]
        head2 = columns2[6]
        deprel2 = columns2[7]
        if head1 == head2:
            correct_head += 1
        if deprel1 == deprel2 and head1 == head2:
            correct_both +=1

# printing out results
UAS = str(correct_head / total * 100)
LAS = str(correct_both / total * 100)
print "LAS = " + LAS + "\tUAS = " + UAS
