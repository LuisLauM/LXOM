// This file was generated by Rcpp::compileAttributes
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

// ordfilt2_C_internal
RcppExport NumericMatrix ordfilt2_C_internal(NumericMatrix data, int x, NumericVector weightedMatrix);
RcppExport SEXP LXOM_ordfilt2_C_internal(SEXP dataSEXP, SEXP xSEXP, SEXP weightedMatrixSEXP) {
BEGIN_RCPP
    Rcpp::RObject __result;
    Rcpp::RNGScope __rngScope;
    Rcpp::traits::input_parameter< NumericMatrix >::type data(dataSEXP);
    Rcpp::traits::input_parameter< int >::type x(xSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type weightedMatrix(weightedMatrixSEXP);
    __result = Rcpp::wrap(ordfilt2_C_internal(data, x, weightedMatrix));
    return __result;
END_RCPP
}