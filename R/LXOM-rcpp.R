
ordfilt2.C.internal <- function(data, x, weightedMatrix) {
  .Call("ordfilt2_C_internal", data, x, weightedMatrix, PACKAGE = 'LXOM')
}
