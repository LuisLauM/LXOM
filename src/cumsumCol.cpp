#include <Rcpp.h>
#include <algorithm>
#include <math.h>

using namespace Rcpp;

//' @importFrom Rcpp evalCpp
//' @useDynLib oXim
// [[Rcpp::export]]
NumericMatrix cumsumCol(NumericMatrix data, NumericVector colSums){

  for(int j = 0; j < data.ncol(); ++j) {
    for(int i = 1; i < data.nrow(); ++i) {
      data(i, j) += data(i - 1, j);
    }
  }

  for(int j = 0; j < data.ncol(); ++j) {
    for(int i = 0; i < data.nrow(); ++i) {
      data(i, j) = data(i, j)/colSums(j);
    }
  }

  return data;
}
