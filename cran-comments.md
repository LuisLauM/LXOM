## Test environments
* ubuntu 16.04 (on travis-ci), R 3.2.5
* win-builder (devel and release)

## R CMD check results

1 errors | 1 warnings | 1 note

* This is a new release.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.

---

* There were some problems with R version 3.0.0 and higher when check algorithms tried to run examples on 64-bits architectures. This problems were not present compiling and checking the package on R v. 3.2.5 or lower. The ERROR showed above was related to this.
