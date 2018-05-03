#!/bin/bash
## error-404-html
## version 0.0.3a - the-html
##################################################
. $( dirname ${0} )/include.sh
##################################################
error-404-title-template() {
 title "$( basename ${file} ) not found"
}
#-------------------------------------------------
error-404-head() {
 cat << EOF
<head>
<meta name="robots" content="noindex, nofollow">
$( file-charset )
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
<style>
body,h1,h2,h3,h4,h5 {font-family: "Raleway", sans-serif}
</style>
$( title-template )
</head>
EOF
}
#-------------------------------------------------
if-document-h1() { h1 404. Page not found ; }
#-------------------------------------------------
if-document-intro() { true ; }
#-------------------------------------------------
grid-navigation-column() { true ; }
#-------------------------------------------------
the-head() { error-404-head ; }
#-------------------------------------------------
the-content() {
 p "The page you are looking for is nowhere to be found. Please check the URL or return to the $( u $( a $( if-bloginfo-url && { echo "index.html" ; true ; } || get-bloginfo-url ) Home Page ) )."
}
#-------------------------------------------------
error-404-initialize() {
 initialize
}
#-------------------------------------------------
error-404-html-list() {
 error-404-initialize 
 the-html
}
#-------------------------------------------------
error-404-html() {
 error-404-html-list
}
##################################################
if [ ${#} -ge 2 -a -f "${1}" -a -f "${2}" ] 
then
 file="${1}"
 bloginfo="${2}"
 navigation=${@:3}
else
 exit 1 # wrong args
fi
##################################################
error-404-html
##################################################
