# figma <img src="man/figures/pkg-logo.png" align="right" style="height:200px" />


<!-- badges: start -->
[![R-CMD-check](https://github.com/pedropark99/figma/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/pedropark99/figma/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->


## Overview

The aim of `figma` package is to provide an easy-to-use client/wrapper for the [Figma API](https://www.figma.com/developers/api). It allows you to bring all data from a Figma file 
to your R session. This includes the data of all objects that you have drawn in this file, and their
respective canvas/page metadata. 

With this kind of data, you can maybe build a custom and automated layout for documents, or create an automated pipeline to build design content for your clients.

Key features of the package:

* Get all data of a Figma file, or a specific canvas/page in the Figma file, or just the metadata about the file;

* Functions from `figma` package can output the data into a `tibble::tibble()` object;

* Returns the raw contents of the HTTP response by default, to give more freedom and information to the user;


## Installation

To get the current development version from github:

```r
devtools::install_github("pedropark99/figma")
```


## Getting started

A good place to start in the `figma` package, is to read the main vignette (which you can access with `vignette("figma")`). But let's give you a brief summary of its features, shall we?

In order to use the Figma API, you need to collect two key variables in the Figma
platform, which are:

- file key: the key (or the ID) that identifies the Figma file that you are interested in;
- token: your personal access token;

The file key is collected through the URL that appears when you access this file in your web browser (
See `vignette("figma")` for more details), and you can create a personal access token in the "Settings"
section of the Figma platform (See `vignette("figma")` for more details).

After you collected these two variables, you can use `figma::get_figma_file()` to collect all data of
your Figma file, like this:

```r
file_key <- "hch8YlkIrYbU3raDzjPvCz"
token <- "My secret and personal access token ..."

# Returns a `response` object:
result <- figma::get_figma_file(
  file_key, token
)
```

By default, `figma::get_figma_file()` returns the raw contents of the HTTP response. However,
you can ask the function to fit the data of your Figma file in a tibble object, if you prefer. Just pass
the `.output_format = "tibble"` argument to the function, like this:

```r
# Returns a `tibble` object:
result <- figma::get_figma_file(
  file_key, token,
  .output_format = "tibble"
)

print(result)
```

```
# A tibble: 5 × 7
  canvas_id canvas_name canvas_type object_id object_name       object_type object_attributes
  <chr>     <chr>       <chr>       <chr>     <chr>             <chr>       <list>           
1 0:1       Page 1      CANVAS      1:2       Background        RECTANGLE   <named list [9]> 
2 0:1       Page 1      CANVAS      5:2       Paragraph         TEXT        <named list [16]>
3 0:1       Page 1      CANVAS      5:3       Arrow             VECTOR      <named list [9]> 
4 5:4       Page 2      CANVAS      5:5       BackgroundPagina2 RECTANGLE   <named list [9]> 
5 5:4       Page 2      CANVAS      5:6       Texto da página 2 TEXT        <named list [16]>
```

Instead of getting the data from the entire Figma file, you might need to collect the data from
a specific page (or a specific set of pages) of this file. If that's your case, you can use
the `figma::get_figma_page()` function.

But in order to use the function, you need to collect a third variable, which is the node ID,
or, in other words, the ID that identifies the page that you are interested in (See `vignette("figma"`
for more details on how to collect this node ID). After you collected this node ID, you could get
this data like this:

```r
node_id <- "0%3A1"
# Returns a `tibble` object:
result <- figma::get_figma_page(
  file_key, token, node_id,
  .output_format = "tibble"
)

print(result)
```

```
# A tibble: 3 × 7
  canvas_id canvas_name canvas_type object_id object_name object_type object_attributes
  <chr>     <chr>       <chr>       <chr>     <chr>       <chr>       <list>           
1 0:1       Page 1      CANVAS      1:2       Background  RECTANGLE   <named list [9]> 
2 0:1       Page 1      CANVAS      5:2       Paragraph   TEXT        <named list [16]>
3 0:1       Page 1      CANVAS      5:3       Arrow       VECTOR      <named list [9]> 
```

On the other hand, for some reason, you might be not interested in the contents of your Figma file, just the
metadata of it. For this case, you can use `figma::get_document_info()` to get this kind of information, like this:

```r
result <- figma::get_document_info(
  file_key, token
)

print(str(result))
```

```
List of 13
 $ id           : chr "0:0"
 $ type         : chr "DOCUMENT"
 $ name         : chr "Untitled"
 $ components   : Named list()
 $ componentSets: Named list()
 $ styles       : Named list()
 $ schemaVersion: int 0
 $ lastModified : chr "2022-10-29T23:35:08Z"
 $ thumbnailUrl : chr "https://s3-alpha-sig.figma.com/thumbnails/446f0181-cfeb-49e7-aec2-36c71aa4b05e?Expires=1667779200&Signature=Mnj"| __truncated__
 $ version      : chr "2539463517"
 $ role         : chr "owner"
 $ editorType   : chr "figma"
 $ linkAccess   : chr "view"
```

See `vignette("figma")` for more details and a more complete introduction to the package.

