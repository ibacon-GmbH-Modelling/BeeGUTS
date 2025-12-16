## R CMD check results

0 errors | 0 warnings | 3 note

* checking CRAN incoming feasibility ... [27s] NOTE
   Maintainer: 'Carlo Romoli <carlo.romoli@ibacon.com>'
   
   Found the following (possibly) invalid URLs:
     URL: https://efsa.onlinelibrary.wiley.com/doi/10.2903/j.efsa.2018.5377
       From: man/criteriaCheck.Rd
       Status: 403
       Message: Forbidden
     URL: https://www.efsa.europa.eu/en/efsajournal/pub/5377 (moved to https://efsa.onlinelibrary.wiley.com/doi/10.2903/j.efsa.2018.5377)
       From: man/BeeGUTS-package.Rd
       Status: 403
       Message: Forbidden
       
 _The links do work when opened manually_

* checking installed package size ... NOTE
    installed size is  8.6Mb
    sub-directories of 1Mb or more:
      data   1.7Mb
      libs   6.1Mb

* checking for future file timestamps ... NOTE
  unable to verify current time

## Reverse dependencies

There are no reverse dependencies listed for BeeGUTS


## Test environment

* local environment (Windows 10, R version 4.3.1 (2023-06-16 ucrt))

* devtools::check_win_devel()

* GitHub actions performed on 
- macos-latest (release)
- windows-latest (release)
- ubuntu-latest (devel)
- ubuntu-latest (release)
- ubuntu-latest (oldrel-1)
