#include <cstdlib>
#include <cstring>
#include <iostream>
#include "mpi.h"


using std::cout; 
using std::endl;
using std::flush;


bool SUPERQUEEN = false;


bool isCollisionFree(int* queens, int N, int n) {
  for (int i = 0; i < N; ++i) {
    if (queens[i] == -1) break;
    if (i == n) continue;
    int dx = i - n;
    int dy = queens[i] - queens[n];
    if (dy == 0 || dx == dy || dx == -dy) return false;
    if (SUPERQUEEN) {
      if (dx < 0) dx = -dx;
      if (dy < 0) dy = -dy;
      if ((dx == 2 && dy == 1) || (dx == 1 && dy == 2)) return false;
    }
  }

  return true;
}


void printBoard(int* queens, int N) {
  cout << "╔";
  for (int i = 0; i < N-1; ++i) cout << "═══╦";
  cout << "═══╗";

  for (int i = 0; i < N; ++i) {
    cout << endl << "║";
    for (int j = 0; j < N; ++j) cout << ((queens[i] != j) ? "   ║" : " Q ║");

    if (i+1 < N) {
      cout << endl << "╠";
      for (int j = 0; j < N-1; ++j) cout << "═══╬";      
      cout << "═══╣";
    }
  }

  cout << endl << "╚";
  for (int i = 0; i < N-1; ++i) cout << "═══╩";
  cout << "═══╝";

  cout << endl << endl;  
}


bool findSolution(int* queens, int N, int n = 0) {
  for (int i = 0; i < N; ++i) {    
    // place n-th queen at i-th column    
    queens[n] = i;
    if (!isCollisionFree(queens, N, n)) continue;

    // board valid and full -> solved!
    if (n+1 == N) return true;

    // store current state
    int* tmp = new int[N];
    for (int j = 0; j < N; ++j) tmp[j] = queens[j];
    
    // recursively place next queen        
    if (findSolution(queens, N, n+1)) {
      // success: free tmp memory and return true
      delete[] tmp;
      tmp = 0;
      return true;
    } else {
      // failed: restore previous state and try next position
      for (int j = 0; j < N; ++j) queens[j] = tmp[j];
      delete[] tmp;
      tmp = 0;
    }
  }

  return false;
}


int countSolutions(int* queens, int N, int n = 0) {
  int count = 0;
  for (int i = 0; i < N; ++i) {
    // print progress
    if (n == 0) cout << (100 * i / N) << "% done\r" << flush;

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


int main(int argc, char* argv[]) {
  // parse command line arguments
  int N = 8;
  if (argc > 1) N = atoi(argv[1]);
  if (argc > 2) SUPERQUEEN = (0 == strcmp(argv[2], "s"));

  // init MPI
  int nTasks, taskId;
  MPI_Status status;
  MPI_Init(&argc, &argv);  
  MPI_Comm_size(MPI_COMM_WORLD, &nTasks);  
  MPI_Comm_rank(MPI_COMM_WORLD, &taskId);

  if (nTasks > N) {
    if (taskId == 0) {
      cout << "The current implementation does not allow that ";
      cout << "the number of parallel threads is bigger than ";
      cout << "the size of the board!" << endl;
    }
    
    MPI_Finalize();
    exit(0);
  }  

  // count all solutions
  int chunkSize = (N % nTasks == 0) ? N / nTasks : (N/nTasks)+1;
  int localCount = 0, totalCount = 0;
  int* queens = new int[N];  

  for (int i = 0; i < chunkSize; ++i) {
    int index = i * nTasks + taskId;
    if (index > N-1) break;
    for (int i = 0; i < N; ++i) queens[i] = -1;
    queens[0] = index;
    localCount += countSolutions(queens, N, 1);
  }

  MPI_Reduce(&localCount, &totalCount, 1, MPI_INT, MPI_SUM, 0, MPI_COMM_WORLD);

  if (taskId == 0) {
    cout << endl;
    cout << "Found " << totalCount << " solutions for N = " << N;

    // if available, generate a sample solution
    if (totalCount > 0) {
      for (int i = 0; i < N; ++i) queens[i] = -1;
      findSolution(queens, N);

      cout << ". Sample solution:" << endl << endl;
      printBoard(queens, N);
    }
  }

  MPI_Finalize();
  return 0;
}
