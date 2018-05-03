#!/bin/bash
## include
## version 0.0.8a - head template
#set -v -x
##################################################
markdown() { ${SH}/markdown.sh ${@} ; }
file_mime_encoding() { ${SH2}/file-mime-encoding.sh ${@} ; }
cdr() { ${SH2}/cdr.sh ${@} ; }
##################################################
declare -A document
##################################################
head-template() {
 cat << EOF
<head>
$( meta-charset UTF-8 )
<meta name="viewport" content="width=device-width, initial-scale=1">
$( title-template )
$( if-meta-robots )
$( if-link-canonical )
<link rel="stylesheet" href="css/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
<style>
body,h1,h2,h3,h4,h5 {font-family: "Raleway", sans-serif}
</style>
$( if-hljs )
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
  ga('create', 'UA-104620931-1', 'auto');
  ga('send', 'pageview');
</script>
</head>
EOF
}
#-------------------------------------------------
the-head() {
 head-template
}
#-------------------------------------------------
html-template() {
 cat << EOF
<!DOCTYPE html>
<html>
$( the-head )
$( the-body )
</html>
EOF
}
#-------------------------------------------------
the-html() {
 html-template
}
#-------------------------------------------------
body-template() {
 cat << EOF
<body class="w3-light-grey">
<div class="w3-content" style="max-width:1400px">
$( doc-html-header )
$( grid-template )
<!-- .w3-content --></div>
$( doc-html-footer )
</body>
EOF
}
#-------------------------------------------------
the-body() {
 body-template
}
#-------------------------------------------------
index-link-canonical() {
 echo "https://${document['domain']}/"
}
#-------------------------------------------------
default-link-canonical() {
 echo "https://${document['domain']}/${document['name']}.html"
}
#-------------------------------------------------
which-link-canonical() { 
 case ${document['name']} in 
  index) index-link-canonical ;;
  *) default-link-canonical ;;
 esac 
}
#-------------------------------------------------
link-canonical() {
 cat << EOF
<link rel="canonical" href="$( which-link-canonical )" />
EOF
}
#-------------------------------------------------
if-link-canonical() {
 if-bloginfo-url || {
  link-canonical
 } 
}
#-------------------------------------------------
if-hljs() {
 grep -v -e '<code class=' &>/dev/null || {
  hljs
 }
}
#-------------------------------------------------
hljs() {
 cat << EOF
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/styles/default.min.css">
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/9.12.0/highlight.min.js"></script>
<script>hljs.initHighlightingOnLoad();</script>
EOF
}
#-------------------------------------------------
meta-robots-content() { { local candidate_meta_robots ; candidate_meta_robots="${1}" ; }
 case ${candidate_meta_robots} in
  noindex,follow)	echo "noindex, follow"		;;
  noindex,nofollow)	echo "noindex, nofollow"	;;
  index,nofollow)	echo "index, nofollow" 		;;
  default|*) 		echo "index, follow" 		;;
 esac
}
#-------------------------------------------------
meta-robots() { 
 cat << EOF
<meta name="robots" content="$( meta-robots-content ${document['meta-robots']} )">
EOF
}
#-------------------------------------------------
if-meta-robots() {
 test ! "${document['meta-robots']}" || {
  meta-robots
 }
}
#-------------------------------------------------
get-document-info() {
 document['name']=$( basename ${file} )
 test "$( get-bloginfo domain )" && {
  document['domain']=$( get-bloginfo domain )
 } || {
  document['domain']=$( basename $( get-bloginfo-url ) )
 }
}
#-------------------------------------------------
get-document-meta-payload() {
 local document_meta
 local document_meta_name
 local document_meta_value
 document_meta=$(
  cat ${file} \
  | grep \
  -e '<[!]--\s*[a-z-]\+:\([a-z]\|[A-Z]\|[0-9]\|[-,. ]\)*-->' \
  --only-matching \
  | sed -e 's/<!--\s\+//g' \
  -e 's/\s\+-->//g' 
 )
 test ! "${document_meta}" || {
  document_meta_name=$( 
   echo "${document_meta}" | cut -f1 -d:
  )
  document_meta_value=$(
   echo "${document_meta}" | cut -f2 -d:
  )
  document["${document_meta_name}"]="${document_meta_value}" 
 }
}
#-------------------------------------------------
get-document-meta() {
 case $( basename ${0} .sh ) in
  error-404-html) true ;; 
  *) get-document-meta-payload ;;
 esac 
}
#-------------------------------------------------
include() {
 true
}
#-------------------------------------------------
default-title-template() {
 title "$( deslugify ${document['name']} ) | $( if-bloginfo-url || echo ${document['domain']} ; )"
}
#-------------------------------------------------
which-title-template() { { local candidate_title_template_name ; candidate_title_template_name="${1}" ; }
 case ${candidate_title_template_name} in
  error-404-html|error-404) error-404-title-template ;;
  doc-html|default) default-title-template ;;
  *) default-title-template ;;
 esac
}
#-------------------------------------------------
title-template() { 
{ local candidate_title_template_name ; test ${#} -eq 1 && { candidate_title_template_name="${1}" ; true  ; } || { candidate_title_template_name=$( basename ${0} .sh ) ; } ; }
 echo ${0} 1>&2 
 which-title-template ${candidate_title_template_name}
}
#-------------------------------------------------
doc-html-header-template() {
 cat << EOF
<!-- Header -->
<header class="w3-container w3-center w3-padding-32"> 
<h1><b>$( if-bloginfo-name || echo "<a style=\"text-decoration:none;\" href=\"$( get-bloginfo-url )\">$( get-bloginfo-name )</a>" )</b></h1>
<p>$( if-bloginfo-description || get-bloginfo-description )</p>
</header>
EOF
}
#-------------------------------------------------
document-h1() {
 h1 ${document['name']}
}
#-------------------------------------------------
if-document-h1() {
 test ! \
 -a "${document['show-document-heading-one']}" \
 -a "${document['show-document-heading-one']}" = "false" || {
  document-h1
 }
}
#-------------------------------------------------q
document-intro-template() {
 p "${document['document-intro']}" 
}
#-------------------------------------------------
test-document-intro() {
 test ! "${document['document-intro']}" 
}
#-------------------------------------------------
if-document-intro() {
 test-document-intro || {
  document-intro-template
 }
}
#-------------------------------------------------
grid-content-column-template() {
 cat << EOF
<div class="w3-col l8 s12">
<div class="w3-card-4 w3-margin w3-white">
<div class="w3-container">
$( if-document-h1 )
$( if-document-intro )
$( the-content )
<!--.w3-container--></div>
<!--.w3-card--></div>
<!--.w3-col--></div>
EOF
}
#-------------------------------------------------
grid-navigation-column-template() {
 cat << EOF
<div class="w3-col l4">
<div class="w3-card-2 w3-margin w3-margin-top w3-white">
<div class="w3-container">
$( the-navigation )
<!--.w3-container--></div>
<!--.w3-card--></div>
<!--.w3-col--></div>
EOF
}
#-------------------------------------------------
grid-content-column() {
 grid-content-column-template
}
#-------------------------------------------------
grid-navigation-column() {
 grid-navigation-column-template
}
#-------------------------------------------------
grid-template() {
 cat << EOF
<!-- begin Grid -->
<div class="w3-row">
$( grid-content-column )
$( grid-navigation-column )
<!--.w3-row--></div>
<!-- Grid end -->
EOF
}
#-------------------------------------------------
doc-html-navigation-element-template() {
 local navigation_element
 for navigation_element in index ${navigation}
 do
  cat << EOF
<a href="${navigation_element}.html" class="w3-bar-item w3-button w3-mobile">${navigation_element}</a>
EOF
 done
 
}
#-------------------------------------------------
doc-html-navigation-template() {
 cat << EOF
<div class="w3-bar w3-white">
$( doc-html-navigation-element-template )
</div> 
EOF
}
#-------------------------------------------------
the-navigation() {
 doc-html-navigation-template
}
#-------------------------------------------------
doc-html-footer-template() {
 cat << EOF
<footer class="w3-container w3-dark-grey w3-padding-32 w3-margin-top">
<p>&copy; 2018 $( if-bloginfo-url || a $( get-bloginfo-url ) ${document['domain']} )</p>
<!--button class="w3-button w3-black w3-disabled w3-padding-large w3-margin-bottom">Previous</button>
<button class="w3-button w3-black w3-padding-large w3-margin-bottom">Next</button-->
<!--mute in global fields -->
<!--p>Powered by <a href="https://www.w3schools.com/w3css/default.asp" target="_blank" rel="nofollow">w3.css</a></p-->
</footer>
EOF
}
#-------------------------------------------------
doc-html-header() {
 if-bloginfo-name || if-bloginfo-description || doc-html-header-template
}
#-------------------------------------------------
doc-html-grid() {
 doc-html-grid-template
}
#-------------------------------------------------
doc-html-footer() {
 doc-html-footer-template
}
#-------------------------------------------------
if-bloginfo-url() {
 test ! "$( get-bloginfo-url )" != "bloginfo-url"
}
#-------------------------------------------------
if-bloginfo-name() {
 test ! "$( get-bloginfo-name )" != "bloginfo-name"
}
#-------------------------------------------------
if-bloginfo-description() {
 test ! "$( get-bloginfo-description )" != "bloginfo-description"
}
#-------------------------------------------------
get-bloginfo-description() {
 get-bloginfo description
}
#-------------------------------------------------
get-bloginfo-name() {
 get-bloginfo name
}
#-------------------------------------------------
get-bloginfo-url() { { local path ; path="${1}" ; }
 echo $( get-bloginfo url )${path}
}
#-------------------------------------------------
get-bloginfo() { { local record_name ; record_name="${1}" ; }
 local record_value
 record_value=$(
  cdr $( 
   cat ${bloginfo} | grep -e "${record_name}" 
  )
 )
 test "${record_value}" || {
  record_value="bloginfo-${record_name}"
 }
 echo ${record_value}
}
#-------------------------------------------------
file-charsets() { { local charset ; charset="${1}" ; }
 echo ${file} ${charset} 1>&2
 case ${charset} in
  SHIFT_JIS)	echo Shift_JIS ;;
  utf-8) 	echo UTF-8 ;;
  us-ascii) 	echo US-ASCII ;;
  *)		echo ISO-8859-1 ;;
 esac 
}
#-------------------------------------------------
meta-charset() { { local charset ; charset="${1}" ; }
 cat << EOF
<meta charset="${charset}">
EOF
}
#-------------------------------------------------
file-charset() {
 meta-charset-template $( file-charsets $( file_mime_encoding ${file} ) )
}
#-------------------------------------------------
deslugify() { { local text ; text="${@}" ; }
 echo ${text} |
 sed \
  -e 's/[-_]\+/ /g'
}
#-------------------------------------------------
# to do:
# - convert anchor text deslugging to a hook such 
#   such that the default behavior remains
a() { { local href ; href="${1}" ; local text ; text=${@:2} ; }
 cat << EOF
<a href="${href}">$( echo ${text} | sed -e 's/-/ /g' )</a>
EOF
}
#-------------------------------------------------
li() { { local text ; text="${@}" ; }
 tag-fold li ${text}
}
#-------------------------------------------------
ul() { { local text ; text="${@}" ; }
 tag-fold ul ${text}
}
#-------------------------------------------------
p() { { local text ; text="${@}" ; }
 tag-fold p ${text}
}
#-------------------------------------------------
u() { { local text ; text="${@}" ; }
 tag-fold u ${text}
}
#-------------------------------------------------
title() { { local text ; text="${@}" ; }
 tag-fold title ${text}
}
#-------------------------------------------------
tag-fold() { { local tag ; tag="${1}" ; local text ; text=${@:2} ; }
 cat << EOF
<${tag}>${text}</${tag}>
EOF
}
#-------------------------------------------------
h1() { { local text ; text="${@}" ; }
 tag-fold h1 $( deslugify ${text} )
}
#-------------------------------------------------
the-content() {
 #------------------------------------------------
 # original
 #------------------------------------------------
 #markdown ${file}
 #return 
 #------------------------------------------------
 #- ignore first line in doc-html
 # + make the first line in doc special and 
 #   reserved for purpose to be specified at later 
 #   date
 #------------------------------------------------
 local temp_file
 temp_file="temp-${RANDOM}-$( date +%s )-file"
 sed  "1d" ${file} > ${temp_file}
 #head ${temp_file} 1>&2
 markdown ${temp_file}
 test ! -f "${temp_file}" || {
  rm ${temp_file} --verbose 1>&2
 }
 true
 #------------------------------------------------
}
#-------------------------------------------------
initialize() {
 get-document-info
 get-document-meta
}
##################################################
if [ ! ] 
then
 true
else
 exit 1 # wrong args
fi
##################################################
include
##################################################
