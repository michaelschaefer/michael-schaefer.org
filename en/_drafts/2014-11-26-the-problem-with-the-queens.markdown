---
layout: post
title: The problem with the queens
date: 2014-11-26 16:27:00
tags: [c++, chess]
---

For the last two weeks the chess world championships were held. I did not take a very great interest in it but in that context I stumbled over an old riddle, the so called [eight queens puzzle][queenspuzzle]. The original idea behind this is to take a usual chess board of 8 x 8 fields and place eight queens on it in such a way that none of them can capture another one (as a reminder: a queen can move horizontally, vertically and diagonally). The question for the total number of such solutions was posed first in 1848 and answered in 1850: There are exactly 92.

## Generalization and solution ansatz

Of course this problem can be and was generalized in order to ask for the number of possibilities to place `$n$` queens on a chess board of size `$n$` x `$n$` without conflicts. For small boards this can be done systematically by hand, but with `$n$` growing, this technique quickly goes to the limits of its capacity. It is therefore a natural idea to write a computer program to do that task. As a first step one obviously needs a proper solution strategy.

The most basic idea would be to let the computer systematically test all distributions of the queens on the chess board and decide if they are valid. But it comes clear that this if by far to inefficient, because most of the distributions already become invalid after a few of the `$n$` queens. Apart from this even for the moderately sized original problem there are no less than `$\frac{64!}{56!} \approx 1.8 \cdot 10^{14}$`, that is about 180 trillion, combinations to test.

A much more efficient and at the same time not much more complicated algorithm is the so called [backtracking][backtracking]. Loosely speaking, the idea of this technique is to place queen after queen to the board until a conflict arises, meaning that one of the queens can capture another. Once this happens we step back to the last state that was free of conlicts. Starting from there we then construct another solution. To get a better feeling of it, we want to perform the method exemplary on a board of size 4.

<object data="/media/images/chess-backtrace.svg"><img src="/media/images/chess-backtrace.png" /></object>

*Figure (a)*: We start by placing a queen in the upper left field. The fields guarded by this queen are marked in gray, they are unavailable for the further placing. *Figure (b)*: The first valid field for the second queen in the third in the second row. If the figure is placed there, all but one fields are guarded. So this cannot lead to a valid solution, since we have to put two more queens to the board. *Figure (c)*: We have to start again with the last conflict free state from figure (a). The field marked red is the one that previously led to a problem. *Figure (d)*: We have to place the second queen on the last field of the second row. If we again mark the guarded fields in gray we see that this cannot result in a valid solution, too: The remaining two queens can only be placed in such a way that they can capture each other. *Figure (e)*: We have seen that placing the first queen in the upper left field will not give a valid solution. We thus move on and instead place it on the second field of the first row. *Figures (f) - (h)*: Marking guarded fields in gray and placing a queen on the first field that remains free now leads to a valid solution of the problem. If we continue this way until the first queen reaches the last field of the first row, we will ultimately find all the solutions.

## Programming

For small programs of this kind I usually like to use [Python][python]. However, for performance reasons I decided to use C++ this time. If you want to have a look at the code you can do this: [nqueens.cc][nqueens.cc]. Because the computational time rapidly increases with the size of the board it is a good idea to allow for parallel computations, meaning to distribute the calculations over more than one processor. This way we can get the desired result more quickly. To make this work we have to have installed a library implementing the [MPI][mpi] interface like [Open MPI][openmpi]. If you use Linux, the following commands (executed on the command line) allow you to compile and execute the program:

{% highlight bash linenos %}
mpic++ -O3 -o nqueens nqueens.cc
mpirun -n p ./nqueens n
{% endhighlight %}

Here, p is to be replaced by the number of processors to use for parallelization and n by the desired size of the board.

## Results

The number of solutions are known for boards up to size 26 x 26 and can be checked in the Wikipedia article I already linked. Instead, I want to show that parallelization indeed pays off for this problem. Therefore I ran the program on a multi-processor computer for board sizes 14 to 17 on up to 17 processors. To get a feeling of the complexity please note that on a single core the calculation on the board of size 17 took about 64 minutes on a recent computer.

<object data="/media/images/chess-speedup.svg"><img src="/media/images/chess-speedup.png" /></object>

The diagram shows the speed-up factor `$s_n$` that is calculated as follows: If we denote by `$t_n$` the runtime of the program using `$n$` processors, then `$s_n$`is defined as `$s_n := \frac{t_1}{t_n}$`. In a perfect world we would have `$s_n = n$` meaning that for example the runtime halves itself when the program runs on two instead of one processor. However, the world is not perfect and thus these ratios are not obtained in practice. But in our case we see that the speed-up for 17 processors is at least 14, which is not bad. Furthermore we see that the parallelization works better with increasing complexity of the problem since the curves grow faster for bigger `$n$`.


[backtracking]: http://en.wikipedia.org/wiki/Backtracking
[queenspuzzle]: http://en.wikipedia.org/wiki/Eight_queens_puzzle
[example]: /media/images/chess.svg
[mpi]: http://de.wikipedia.org/wiki/Message_Passing_Interface
[nqueens.cc]: /media/code/nqueens.cc
[openmpi]: http://www.open-mpi.org/
[python]: http://www.python.org