#include "ordfilt2.C.internal.h"
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
RcppExport SEXP ordfilt2_C_internal(SEXP data, SEXP x, SEXP weightedMatrix){
  
  int nrows = data.nrow();
  int ncols = data.ncol();
  Rcpp::NumericMatrix emptyData(nrows, ncols);
  Rcpp::NumericVector miniMatrix(9);
  
  
  for(int j = 0; j < ncols; j++){
    for(int i = 0; i < nrows; i++){
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