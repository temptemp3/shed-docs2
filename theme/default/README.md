# sh2-u2-theme-default

default theme for sh2-u2  
based on W3.CSS blog template

---

**Current**

v0.0.7 - document intro <!-- 2017/08/05 22:50 -->  
\- set document intro using document intro document field 
\- Powered by w3.css

---

**Changelog**

v0.0.6 - document fields <!-- 2017/08/04  8:59 -->   
\- set meta robots using meta-robots document field  
v0.0.5 - the-navigation <!-- 2017/08/03  8:49 -->
v0.0.4 - error-404-html header/footer fix, title template
v0.0.3 - doc-html title fix  
v0.0.2 - if-bloginfo templates   
v0.0.1 - initial 

---

**To do**

- add canonical link element eliminating potention omission in search results
  + in particular, index.html should be linked to bloginfo-url if available
- global fields
  + may use to mute attribution related sections such as 'Powered by ...' without modifying theme

---

## document fields

### how to set document fields

embed document field declaration &lt;-- foo:bar --&gt; in document as html comment

### list of known document fields

meta-robots:noindex,nofollow|noindex,follow|index,nofollow|index|follow

show-document-heading-one:false|!false

document-intro:text

---
