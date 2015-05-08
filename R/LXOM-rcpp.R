
# ordfilt2.C.internal <- function(data, x, weightedMatrix) {
#   .Call("ordfilt2_C_internal", data, x, weightedMatrix, PACKAGE = 'LXOM')
# }

.ordfilt2_C_int <- function(data, x, weightedMatrix){
  # Defining text (in C++) of filter function
  sourceCpp <- '#include <Rcpp.h>
  #include <algorithm>
  
  using namespace Rcpp;
  
  // [[Rcpp::export]]
  NumericMatrix ordfilt2_C_internal2(NumericMatrix data, int x, NumericVector weightedMatrix) {
  
  int nrows = data.nrow();
  int ncols = data.ncol();
  NumericMatrix emptyData(nrows, ncols);
  NumericVector miniMatrix(9);
  
  
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
  }'
  
  # Compiling function and converting to R-version
  # It is inside a loop because sometimes, at first, it causes error
  for(i in 1:2)
    suppressWarnings(cppFunction(code = sourceCpp))
  
  # Applying funtion
  output <- ordfilt2_C_internal2(data, x, weightedMatrix)
  
  return(output)
}