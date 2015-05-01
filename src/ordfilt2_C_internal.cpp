
#include <Rcpp.h>
#include <algorithm>

// [[Rcpp::export]]
Rcpp::NumericMatrix ordfilt2_C_internal(Rcpp::NumericMatrix data, int x, Rcpp::NumericVector weightedMatrix) {
  using namespace Rcpp;
  
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
