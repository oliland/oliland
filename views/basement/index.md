# Oli's Puzzle Basement
### Or every technical question I've ever been asked in an interview.
### Last updated 13<sup>th</sup> December 2011

## Fibonnacci Sequence
Write a program which outputs the nth element of the fibonacci sequence.

## Pushdown Automata
Write a program that returns true if a string is valid. In this case the language consists of:

* The empty set
* "(U)" - where U is another valid term
* "VW" - where V, W are other valid terms

Assume that you will be given a string which only contains the characters ( and ). It should run in O(n) and use O(1) storage space.

## Complementary Pairs
Write an algorithm which, given an array of integers A and another integer K, returns the number of complementary pairs in A. A complementary pair looks like:

A[i] + A[j] == K

So if your A = [0,1,1,3,5,5,6] and K = 6 - your pair indexes would be (0,6), (6,0), (1,5), (5,1), (1,4), (4,1), (2,5), (5,2), (2,4), (4,2) and (3,3) - 11 pairs.

You should be able to do this in O(n) using O(n) storage.

## Hard mode
