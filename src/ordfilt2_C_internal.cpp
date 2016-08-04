#include <Rcpp.h>
#include <algorithm>
#include <math.h>

using namespace Rcpp;

//' @importFrom Rcpp evalCpp
//' @useDynLib oXim
// [[Rcpp::export]]
NumericMatrix ordfiltInC(NumericMatrix data, double x, NumericMatrix weightedMatrix){
  int nrows = data.nrow();
  int ncols = data.ncol();

  int wmrows = weightedMatrix.nrow();
  int wmcols = weightedMatrix.ncol();

  NumericMatrix emptyData(nrows, ncols);
  NumericVector miniMatrix(wmrows*wmcols);

  for(int j = 1; j < ncols - std::abs(floor(wmcols/2)); j++){
    for(int i = 1; i < nrows - std::abs(floor(wmrows/2)); i++){
      for(int n = 0; n < wmcols; n++){
        for(int m = 0; m < wmrows; m++){
          int index = m*3 + n;
          int a = i + m - 1;
          int b = j + n - 1;
          miniMatrix[index] = data(a, b)*weightedMatrix(m, n);
        }
      }

      std::sort(miniMatrix.begin(), miniMatrix.end());

      emptyData(i, j) = miniMatrix[std::abs(x) - 1];
    }
  }

  return emptyData;
}
