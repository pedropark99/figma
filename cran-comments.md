## Resubmission
This is a resubmission. To meet the changes requested by CRAN,
I made the following adjustments in this version:

* Surround every package name, software name and API name by single quotes in
  title and description fields of DESCRIPTION;

* Added the URL to Figma's API in the Description field of DESCRIPTION;

* Added the missing 'Value' section in the documentation of `get_figma_page()`;

* Removed all code examples in the documentation of non-exported functions, to avoid
  the use of `:::` operator;
  
Besides these requested changes, I added to DESCRIPTION:

* URLs to the repository and website of the package;

* URL to Bug Report;


## R CMD check results

The package passed on R CMD check with no ERRORs or WARNINGs on all platforms. 
On Windows, the package was built using Rtools 4.2 (4.2.0.1).

The package was tested on these platforms:
  - Debian Linux (R-devel);
  - Windows 10 (using R 4.2.2 and R-devel);
  - macOS 10.13.6 (R-release);
  - Ubuntu Linux 20.04.1 LTS (R-devel);
  
This is my first submission. Because of this, I got the following note on Windows 10 (using R 4.2.2), when running `R CMD check --as-cran figma_0.1.0.tar.gz` directly on the terminal:

```
* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Pedro Duarte Faria <pedropark99@gmail.com>'

New submission
```



### In R-hub (Debian Linux, R-devel, GCC)

0 errors | 0 warnings | 0 note

* This is a new release.

### In Windows 10 (using R 4.2.2)

0 errors | 0 warnings | 1 note

* This is a new release.

### In Windows 10 (using R devel)

── R CMD check results ────────────────────────────────────────────────────────────────────────────── figma 0.1.0 ────
Duration: 1m 1.1s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔


### In R-hub (macOS 10.13.6 High Sierra, R-release, CRAN's setup)

0 errors | 0 warnings | 0 note

* This is a new release.


### In R-hub (Ubuntu Linux 20.04.1 LTS, R-devel, GCC)

0 errors | 0 warnings | 0 note

* This is a new release.







## Full logs of R CMD check

### In R-hub (Debian Linux, R-devel, GCC)

* using log directory ‘/home/docker/figma.Rcheck’
* using R Under development (unstable) (2022-07-31 r82648)
* using platform: x86_64-pc-linux-gnu (64-bit)
* using session charset: UTF-8
* checking for file ‘figma/DESCRIPTION’ ... OK
* checking extension type ... Package
* this is package ‘figma’ version ‘0.1.0’
* package encoding: UTF-8
* checking package namespace information ... OK
* checking package dependencies ... OK
* checking if this is a source package ... OK
* checking if there is a namespace ... OK
* checking for executable files ... OK
* checking for hidden files and directories ... OK
* checking for portable file names ... OK
* checking for sufficient/correct file permissions ... OK
* checking whether package ‘figma’ can be installed ... OK
* checking installed package size ... OK
* checking package directory ... OK
* checking ‘build’ directory ... OK
* checking DESCRIPTION meta-information ... OK
* checking top-level files ... OK
* checking for left-over files ... OK
* checking index information ... OK
* checking package subdirectories ... OK
* checking R files for non-ASCII characters ... OK
* checking R files for syntax errors ... OK
* checking whether the package can be loaded ... OK
* checking whether the package can be loaded with stated dependencies ... OK
* checking whether the package can be unloaded cleanly ... OK
* checking whether the namespace can be loaded with stated dependencies ... OK
* checking whether the namespace can be unloaded cleanly ... OK
* checking loading without being on the library search path ... OK
* checking dependencies in R code ... OK
* checking S3 generic/method consistency ... OK
* checking replacement functions ... OK
* checking foreign function calls ... OK
* checking R code for possible problems ... OK
* checking Rd files ... OK
* checking Rd metadata ... OK
* checking Rd cross-references ... OK
* checking for missing documentation entries ... OK
* checking for code/documentation mismatches ... OK
* checking Rd \usage sections ... OK
* checking Rd contents ... OK
* checking for unstated dependencies in examples ... OK
* checking contents of ‘data’ directory ... OK
* checking data for non-ASCII characters ... OK
* checking LazyData ... OK
* checking data for ASCII and uncompressed saves ... OK
* checking installed files from ‘inst/doc’ ... OK
* checking files in ‘vignettes’ ... OK
* checking examples ... OK
* checking for unstated dependencies in vignettes ... OK
* checking package vignettes in ‘inst/doc’ ... OK
* checking running R code from vignettes ...
  ‘figma.Rmd’ using ‘UTF-8’... OK
  ‘http-errors.Rmd’ using ‘UTF-8’... OK
 NONE
* checking re-building of vignette outputs ... OK
* checking PDF version of manual ... OK
* DONE

Status: OK



### In Windows 10 (using R 4.2.2)

running with `R CMD check --as-cran figma_0.1.0.tar.gz` on the terminal:

* using log directory 'E:/Users/pedro/Documents/Projetos/pkgs/figma.Rcheck'
* using R version 4.2.2 (2022-10-31 ucrt)
* using platform: x86_64-w64-mingw32 (64-bit)
* using session charset: UTF-8
* using option '--as-cran'
* checking for file 'figma/DESCRIPTION' ... OK
* checking extension type ... Package
* this is package 'figma' version '0.1.0'
* package encoding: UTF-8
* checking CRAN incoming feasibility ... NOTE
Maintainer: 'Pedro Duarte Faria <pedropark99@gmail.com>'

New submission
* checking package namespace information ... OK
* checking package dependencies ... OK
* checking if this is a source package ... OK
* checking if there is a namespace ... OK
* checking for executable files ... OK
* checking for hidden files and directories ... OK
* checking for portable file names ... OK
* checking whether package 'figma' can be installed ... OK
* checking installed package size ... OK
* checking package directory ... OK
* checking for future file timestamps ... OK
* checking 'build' directory ... OK
* checking DESCRIPTION meta-information ... OK
* checking top-level files ... OK
* checking for left-over files ... OK
* checking index information ... OK
* checking package subdirectories ... OK
* checking R files for non-ASCII characters ... OK
* checking R files for syntax errors ... OK
* checking whether the package can be loaded ... OK
* checking whether the package can be loaded with stated dependencies ... OK
* checking whether the package can be unloaded cleanly ... OK
* checking whether the namespace can be loaded with stated dependencies ... OK
* checking whether the namespace can be unloaded cleanly ... OK
* checking loading without being on the library search path ... OK
* checking use of S3 registration ... OK
* checking dependencies in R code ... OK
* checking S3 generic/method consistency ... OK
* checking replacement functions ... OK
* checking foreign function calls ... OK
* checking R code for possible problems ... OK
* checking Rd files ... OK
* checking Rd metadata ... OK
* checking Rd line widths ... OK
* checking Rd cross-references ... OK
* checking for missing documentation entries ... OK
* checking for code/documentation mismatches ... OK
* checking Rd \usage sections ... OK
* checking Rd contents ... OK
* checking for unstated dependencies in examples ... OK
* checking contents of 'data' directory ... OK
* checking data for non-ASCII characters ... OK
* checking LazyData ... OK
* checking data for ASCII and uncompressed saves ... OK
* checking installed files from 'inst/doc' ... OK
* checking files in 'vignettes' ... OK
* checking examples ... OK
* checking for unstated dependencies in vignettes ... OK
* checking package vignettes in 'inst/doc' ... OK
* checking re-building of vignette outputs ... OK
* checking PDF version of manual ... OK
* checking for non-standard things in the check directory ... OK
* checking for detritus in the temp directory ... OK
* DONE
Status: 1 NOTE




### In Windows 10 (using Rdevel)

running with `devtools::check()`:

─  using log directory 'C:/Users/pedro/AppData/Local/Temp/Rtmpi0apfR/file2318704c2f70/figma.Rcheck' (835ms)
─  using R Under development (unstable) (2022-10-11 r83083 ucrt)
─  using platform: x86_64-w64-mingw32 (64-bit)
─  using session charset: UTF-8
─  using options '--no-manual --as-cran'
✔  checking for file 'figma/DESCRIPTION'
─  checking extension type ... Package
─  this is package 'figma' version '0.1.0'
─  package encoding: UTF-8
✔  checking package namespace information
✔  checking package dependencies (37.2s)
✔  checking if this is a source package ...
✔  checking if there is a namespace
✔  checking for executable files (616ms)
✔  checking for hidden files and directories ...
✔  checking for portable file names
✔  checking whether package 'figma' can be installed (3.1s)
✔  checking installed package size ... 
✔  checking package directory ... 
✔  checking for future file timestamps ... 
✔  checking 'build' directory ...
✔  checking DESCRIPTION meta-information ... 
✔  checking top-level files
✔  checking for left-over files
✔  checking index information ... 
✔  checking package subdirectories (380ms)
✔  checking R files for non-ASCII characters ... 
✔  checking R files for syntax errors ... 
✔  checking whether the package can be loaded ... 
✔  checking whether the package can be loaded with stated dependencies ... 
✔  checking whether the package can be unloaded cleanly ... 
✔  checking whether the namespace can be loaded with stated dependencies ... 
✔  checking whether the namespace can be unloaded cleanly (447ms)
✔  checking loading without being on the library search path (429ms)
✔  checking dependencies in R code (784ms)
✔  checking S3 generic/method consistency (551ms)
✔  checking replacement functions ... 
✔  checking foreign function calls ... 
✔  checking R code for possible problems (4.1s)
✔  checking Rd files (442ms)
✔  checking Rd metadata ... 
✔  checking Rd line widths ... 
✔  checking Rd cross-references ... 
✔  checking for missing documentation entries ... 
✔  checking for code/documentation mismatches (669ms)
✔  checking Rd usage sections (891ms)
✔  checking Rd contents ... 
✔  checking for unstated dependencies in examples ... 
✔  checking contents of 'data' directory ...
✔  checking data for non-ASCII characters ... 
✔  checking LazyData
✔  checking data for ASCII and uncompressed saves ... 
✔  checking installed files from 'inst/doc' ...
✔  checking files in 'vignettes'
✔  checking examples (1s)
✔  checking for unstated dependencies in vignettes (358ms)
✔  checking package vignettes in 'inst/doc' ...
✔  checking re-building of vignette outputs (3.2s)
✔  checking for non-standard things in the check directory
✔  checking for detritus in the temp directory ...
   
   
── R CMD check results ────────────────────────────────────────────────────────────────────────────── figma 0.1.0 ────
Duration: 1m 1.1s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔



### In R-hub (macOS 10.13.6 High Sierra, R-release, CRAN's setup)

* using log directory ‘/Users/userRRILygqB/figma.Rcheck’
* using R version 4.1.1 (2021-08-10)
* using platform: x86_64-apple-darwin17.0 (64-bit)
* using session charset: UTF-8
* checking for file ‘figma/DESCRIPTION’ ... OK
* checking extension type ... Package
* this is package ‘figma’ version ‘0.1.0’
* package encoding: UTF-8
* checking package namespace information ... OK
* checking package dependencies ... OK
* checking if this is a source package ... OK
* checking if there is a namespace ... OK
* checking for executable files ... OK
* checking for hidden files and directories ... OK
* checking for portable file names ... OK
* checking for sufficient/correct file permissions ... OK
* checking whether package ‘figma’ can be installed ... OK
* checking installed package size ... OK
* checking package directory ... OK
* checking ‘build’ directory ... OK
* checking DESCRIPTION meta-information ... OK
* checking top-level files ... OK
* checking for left-over files ... OK
* checking index information ... OK
* checking package subdirectories ... OK
* checking R files for non-ASCII characters ... OK
* checking R files for syntax errors ... OK
* checking whether the package can be loaded ... OK
* checking whether the package can be loaded with stated dependencies ... OK
* checking whether the package can be unloaded cleanly ... OK
* checking whether the namespace can be loaded with stated dependencies ... OK
* checking whether the namespace can be unloaded cleanly ... OK
* checking loading without being on the library search path ... OK
* checking dependencies in R code ... OK
* checking S3 generic/method consistency ... OK
* checking replacement functions ... OK
* checking foreign function calls ... OK
* checking R code for possible problems ... OK
* checking Rd files ... OK
* checking Rd metadata ... OK
* checking Rd cross-references ... OK
* checking for missing documentation entries ... OK
* checking for code/documentation mismatches ... OK
* checking Rd \usage sections ... OK
* checking Rd contents ... OK
* checking for unstated dependencies in examples ... OK
* checking contents of ‘data’ directory ... OK
* checking data for non-ASCII characters ... OK
* checking LazyData ... OK
* checking data for ASCII and uncompressed saves ... OK
* checking installed files from ‘inst/doc’ ... OK
* checking files in ‘vignettes’ ... OK
* checking examples ... OK
* checking for unstated dependencies in vignettes ... OK
* checking package vignettes in ‘inst/doc’ ... OK
* checking running R code from vignettes ...
  ‘figma.Rmd’ using ‘UTF-8’... OK
  ‘http-errors.Rmd’ using ‘UTF-8’... OK
 NONE
* checking re-building of vignette outputs ... OK
* checking PDF version of manual ... OK
* DONE

Status: OK




### In R-hub (Ubuntu Linux 20.04.1 LTS, R-devel, GCC)


* using log directory ‘/home/docker/figma.Rcheck’
* using R Under development (unstable) (2022-10-31 r83219)
* using platform: x86_64-pc-linux-gnu (64-bit)
* using session charset: UTF-8
* checking for file ‘figma/DESCRIPTION’ ... OK
* checking extension type ... Package
* this is package ‘figma’ version ‘0.1.0’
* package encoding: UTF-8
* checking package namespace information ... OK
* checking package dependencies ... OK
* checking if this is a source package ... OK
* checking if there is a namespace ... OK
* checking for executable files ... OK
* checking for hidden files and directories ... OK
* checking for portable file names ... OK
* checking for sufficient/correct file permissions ... OK
* checking whether package ‘figma’ can be installed ... OK
* checking installed package size ... OK
* checking package directory ... OK
* checking ‘build’ directory ... OK
* checking DESCRIPTION meta-information ... OK
* checking top-level files ... OK
* checking for left-over files ... OK
* checking index information ... OK
* checking package subdirectories ... OK
* checking R files for non-ASCII characters ... OK
* checking R files for syntax errors ... OK
* checking whether the package can be loaded ... OK
* checking whether the package can be loaded with stated dependencies ... OK
* checking whether the package can be unloaded cleanly ... OK
* checking whether the namespace can be loaded with stated dependencies ... OK
* checking whether the namespace can be unloaded cleanly ... OK
* checking loading without being on the library search path ... OK
* checking dependencies in R code ... OK
* checking S3 generic/method consistency ... OK
* checking replacement functions ... OK
* checking foreign function calls ... OK
* checking R code for possible problems ... OK
* checking Rd files ... OK
* checking Rd metadata ... OK
* checking Rd cross-references ... OK
* checking for missing documentation entries ... OK
* checking for code/documentation mismatches ... OK
* checking Rd \usage sections ... OK
* checking Rd contents ... OK
* checking for unstated dependencies in examples ... OK
* checking contents of ‘data’ directory ... OK
* checking data for non-ASCII characters ... OK
* checking LazyData ... OK
* checking data for ASCII and uncompressed saves ... OK
* checking installed files from ‘inst/doc’ ... OK
* checking files in ‘vignettes’ ... OK
* checking examples ... OK
* checking for unstated dependencies in vignettes ... OK
* checking package vignettes in ‘inst/doc’ ... OK
* checking running R code from vignettes ...
  ‘figma.Rmd’ using ‘UTF-8’... OK
  ‘http-errors.Rmd’ using ‘UTF-8’... OK
 NONE
* checking re-building of vignette outputs ... OK
* checking PDF version of manual ... OK
* DONE

Status: OK

