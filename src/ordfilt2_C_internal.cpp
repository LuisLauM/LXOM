#include "ordfilt2_C_internal.h"
#include <algorithm>

NumericMatrix ordfilt2_C_internal(NumericMatrix data, int x, NumericVector weightedMatrix){
  using namespace Rcpp;
  
  int nrows = data.nrow();
  int ncols = data.ncol();
  Rcpp::NumericMatrix emptyData(nrows, ncols);
  Rcpp::NumericVector miniMatrix(9);  
  
  for(int j = 1; j < ncols-1; j++){
    for(int i = 1; i < nrows-1; i++){
      for(int n = 0; n < 3; n++){
        for(int m = 0; m < 3; m++){
          int index = 3*m + n;
          int a = i + m - 1;
          int b = j + n - 1;
          miniMatrix[index] = data(a, b)*weightedMatrix[index];
        }
      }
      
      std::sort(miniMatrix.begin(), miniMatrix.end());
      
      emptyData(i, j) = miniMatrix[x - 1];
    }
  }
  
  return emptyData;
}