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
> ### Name: getOxyrange
> ### Title: Takes a matrix of echogram and calculate Oxycline.
> ### Aliases: getOxyrange
>
> ### ** Examples
>
> fileMode <- list(fish38_file   = system.file("extdata", "fish38.mat", package = "oXim"),
> +                  fluid120_file = system.file("extdata", "fluid120.mat", package = "oXim"),
> +                  blue38_file   = system.file("extdata", "blue38.mat", package = "oXim"))
> echoData <- readEchograms(fileMode = fileMode)
> oxyclineRange <- getOxyrange(echoData)
> Message:
> No filter-setting object or file detected. OXim will use default filter configuration.
> 
> And here the output stops (crash?).

I have made some corrections and the functions are working well again. Nevertheless, when I check, I am still observing the error with x64 arch.
