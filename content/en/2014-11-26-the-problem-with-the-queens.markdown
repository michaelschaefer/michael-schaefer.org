title: The problem with the queens
date: 2014-11-26
lang: en
tags: c++, chess

For the last two weeks the chess world championships were held. I did not take a very great interest in it but in that context I stumbled over an old riddle, the so called [eight queens puzzle][queenspuzzle]. With this article I want to introduce that problem together with a solution stategy. The original idea behind the eight queens puzzle is to take a usual chess board of 8 x 8 fields and place eight queens on it in such a way that none of them can capture another one (as a reminder: a queen can move horizontally, vertically and diagonally). The question for the total number of such solutions was posed first in 1848 and answered in 1850: There are exactly 92.

## Generalization and solution ansatz

Of course this problem can be and was generalized in order to ask for the number of possibilities to place `$n$` queens on a chess board of size `$n$` x `$n$` without conflicts. For small boards this can be done systematically by hand, but with `$n$` growing, this technique quickly goes to the limits of its capacity. It is therefore a natural idea to write a computer program to do that task. As a first step one obviously needs a proper solution strategy.

The most basic idea would be to let the computer systematically test all distributions of the queens on the chess board and decide if they are valid. But it comes clear that this if by far to inefficient, because most of the distributions already become invalid after a few of the `$n$` queens. Apart from this even for the moderately sized original problem there are no less than `$\frac{64!}{56!} \approx 1.8 \cdot 10^{14}$`, that is about 180 trillion, combinations to test.

A much more efficient and at the same time not much more complicated algorithm is the so called [backtracking][backtracking]. Loosely speaking, the idea of this technique is to place queen after queen to the board until a conflict arises, meaning that one of the queens can capture another. Once this happens we step back to the last state that was free of conlicts. Starting from there we then construct another solution. To get a better feeling of it, we want to perform the method exemplary on a board of size 4.

<object data="/files/images/chess-backtracking.svg"><img src="/files/images/chess-backtracking.png" /></object>

*Figure (a)*: We start by placing a queen in the upper left field. The fields guarded by this queen are marked in gray, they are unavailable for the further placing. *Figure (b)*: The first valid field for the second queen in the third in the second row. If the figure is placed there, all but one fields are guarded. So this cannot lead to a valid solution, since we have to put two more queens to the board. *Figure (c)*: We have to start again with the last conflict free state from figure (a). The field marked red is the one that previously led to a problem. *Figure (d)*: We have to place the second queen on the last field of the second row. If we again mark the guarded fields in gray we see that this cannot result in a valid solution, too: The remaining two queens can only be placed in such a way that they can capture each other. *Figure (e)*: We have seen that placing the first queen in the upper left field will not give a valid solution. We thus move on and instead place it on the second field of the first row. *Figures (f) - (h)*: Marking guarded fields in gray and placing a queen on the first field that remains free now leads to a valid solution of the problem. If we continue this way until the first queen reaches the last field of the first row, we will ultimately find all the solutions.

## Programming

For small programs of this kind I usually like to use [Python][python]. However, for performance reasons I decided to use C++ this time. If you want to have a look at the code you can do this: [nqueens.cc][nqueens.cc]. I do not want to present the entire program but just to explain the most important function, namely the backtracking algorithm itself.

    #!c++
    int countSolutions(int* queens, int N, int n = 0) {
      int count = 0;
      for (int i = 0; i < N; ++i) {
        if (n == 0) 
          // print progress
          cout << (100 * i / N) << "% done\r" << flush;
        else {
          // check for direct collision with upper row
          int dx = queens[n-1] - i;
          if (dx > -2 && dx < 2)
            continue;
        }

        queens[n] = i;

        if (!isCollisionFree(queens, N, n)) continue;
        if (n+1 == N) {
          count++;
        } else {
          int* tmp = new int[N];
          for (int j = 0; j < N; ++j) tmp[j] = queens[j];
          count += countSolutions(queens, N, n+1);
          for (int j = 0; j < N; ++j) queens[j] = tmp[j];
          delete[] tmp;
          tmp = 0;
        }
      }

      if (n == 0) cout << "100% done";
      return count;
    }

*Line 1*: Let's first explain the function's parameters: queens is an array storing the positions of the queens in their respective row (it is easy to see that for a valid solution each row has to contain exactly one queen), where not yet places queens are represented by -1. The value N denotes the number of dimensions of the chess board and n is the number of the queen to be placed next (starting with 0!). *Line 8-11*: There is already at least one queens on the board. Thus we can check if the field i in row n which is to be filled next is already guarded by a queen in row n-1. That particular case will then not lead to a valid solution and we can directly proceed with the next field. *Line 14*: The n-th queen is placed in the n-th row to the i-th field. *Line 16*: If the queen being of that position causes a collision we can reject the current configuration. *Line 18*: A valid solution was found since the N-th queen could be placed on the board without conflicts. *Line 20-25*: The current configuration is free of conflicts but not yet complete. Thus we save the current state in the array tmp and let the solution function call itself recursively, where the third parameter n+1 denotes that the (n+1)-th queen is to be placed on the board next. *Line 30*: Once the for-loop ran over all fields in the current row, the number of solutions found on the current level n can be returned.

Because the computational time rapidly increases with the size of the board I implemented the program to support parallel computing, meaning that it is able to distribute the calculations over more than one processor. This way we can get the desired result more quickly. To make this work we have to have installed a library implementing the [MPI][mpi] interface like [Open MPI][openmpi]. If you use Linux, the following commands (executed on the command line) allow you to compile and execute the program:

    #!bash
    mpic++ -O3 -o nqueens nqueens.cc
    mpirun -n p ./nqueens n

Here, p is to be replaced by the number of processors to use for parallelization and n by the desired size of the board.

## Results

The number of solutions are known for boards up to size 26 x 26 and can be checked in the Wikipedia article I already linked. Instead, I want to show that parallelization indeed pays off for this problem. Therefore I ran the program on a multi-processor computer for board sizes 14 to 17 on up to 17 processors. To get a feeling of the complexity please note that on a single core the calculation on the board of size 17 took about 64 minutes on a recent computer.

<object data="/files/images/chess-speedup.svg"><img src="/files/images/chess-speedup.png" /></object>

The diagram shows the speed-up factor `$s_n$` that is calculated as follows: If we denote by `$t_n$` the runtime of the program using `$n$` processors, then `$s_n$`is defined as `$s_n := \frac{t_1}{t_n}$`. In a perfect world we would have `$s_n = n$` meaning that for example the runtime halves itself when the program runs on two instead of one processor. However, the world is not perfect and thus these ratios are not obtained in practice. But in our case we see that the speed-up for 17 processors is at least 14, which is not bad. Furthermore we see that the parallelization works better with increasing complexity of the problem since the curves grow faster for bigger `$n$`. This effect is not by coincidental but comes from the computational overhead that has to be done in order to synchronize the computations over the involved processors. If the computational complexity grows this overhead becomes more and more negligible with respect to the overall computational time.


[backtracking]: http://en.wikipedia.org/wiki/Backtracking
[queenspuzzle]: http://en.wikipedia.org/wiki/Eight_queens_puzzle
[example]: /files/images/chess.svg
[mpi]: http://de.wikipedia.org/wiki/Message_Passing_Interface
[nqueens.cc]: /files/code/nqueens.cc
[openmpi]: http://www.open-mpi.org/
[python]: http://www.python.org