#ifndef ORDFILT2_C_INTERNAL_H
#define ORDFILT2_C_INTERNAL_H

#include <Rcpp.h>

using namespace Rcpp;

RcppExport NumericMatrix ordfilt2_C_internal(NumericMatrix data, int x, NumericVector weightedMatrix);

#endif