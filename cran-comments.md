## Test environments
* ubuntu 16.04 (on travis-ci), R 3.2.5
* win-builder (devel and release)

## R CMD check results

1 errors | 1 warnings | 1 note

* This is a new release.

## Reverse dependencies

This is a new release, so there are no reverse dependencies.

---

## First submission

* There were some problems with R version 3.0.0 and higher when check algorithms tried to run examples on 64-bits architectures. This problems were not present compiling and checking the package on R v. 3.2.5 or lower. The ERROR showed above was related to this.


## Second submission

> Thanks, we see:
> 
> Possibly mis-spelled words in DESCRIPTION:
>   madian (8:84)
>
> median?

Yes, it was my mistake, I corrected this.


> Package has a FOSS license but eventually depends on the following
> package which restricts use:
>   akima
> 
> Please explain how that can work or change license or remove dependencies on akima.

In order to avoid this license problem on the future with akima package, I decided to change code and replace akima methods by gstat methods (IDW interpolation).


> ** running examples for arch 'i386' ... ERROR
> Running examples in 'oXim-Ex.R' failed
> The error most likely occurred in:
>
> base::assign(".ptime", proc.time(), pos = "CheckExEnv")
>
> \### Name: getOxyrange
>
> \### Title: Takes a matrix of echogram and calculate Oxycline.
>
> \### Aliases: getOxyrange
>
> \### ** Examples
>
> fileMode <- list(fish38_file   = system.file("extdata", "fish38.mat", package = "oXim"),
>                  fluid120_file = system.file("extdata", "fluid120.mat", package = "oXim"),
>                  blue38_file   = system.file("extdata", "blue38.mat", package = "oXim"))
>
> echoData <- readEchograms(fileMode = fileMode)
>
> oxyclineRange <- getOxyrange(echoData)
>
> Message:
> No filter-setting object or file detected. OXim will use default filter configuration.
> 
> And here the output stops (crash?).

I have made some corrections and the functions are working well again (I have used demos and made some calculations with external data). Nevertheless, when I check (ONLY IN R >= 3.0.0), I am still observing the error with x64 arch examples. In short, this problem is only observable in example's environment. Moreover, there is little information about this issue, most forums suggest some problem with DLL source in R 3.0.x.


## Third submission

> Pls remove the redundant "Package oriented to" from DESCRIPTION file.

Done

## Fourth submission
> The installation errors are covered at https://cran.r-project.org/doc/manuals/r-patched/R-exts.html#Portable-C-and-C_002b_002b-code : it seems you do not understand C/C++ integer arithmtic so need to review your code thoroughly.

I have checked C++ code, avoiding to use functions like sqrt and changing class for number variables (now, I am using double instead int in order to solve ambiguity problems).

> For OS X, traceback() shows
> 
> 8: pretty_dates(xAxis, nIntervals)
>
> 9: seq.POSIXt(start, end, paste(binlength, binunits))
> 
> Selection: 8
>
> Called from: top level
>
> Browse[1]> start
>
> [1] "POSIXct of length 0"
>
> so I guess there is yet another bug in the lubridate package you use (it is notorious for leaving them unfixed): use base R facilities instead.

Now, 'oXim' does not need lubridate package, I have remove it from depends.

> Packages almost never need to depend on Rcpp and can just have it in LinkingTo.

Done

#### Extra
Problems with devtools check in Windows were still present, so I decided to use 'dontrun' sentence with 'getOxyrange' examples. I have searching and asking about the problem with dll but there is not a certain answer. I have test 'oXim' in Ubuntu (R 3.2.3) and it is working perfectly (testing --as-cran). I am still with no explaination for this problem, but I think that is not a C++ code issue but in the dll files managing (at least in Windows).
