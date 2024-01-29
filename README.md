# HREP (Href Regular Expression Parser)

HREP allows you to retrieve strings in the corresponding lines according to the given regular expression. We will try to explain the capacity of HREP with some sample codes.

~~~ruby
html = <<-html
  <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
  <html>
   <head>
    <title>Index of /data/synoptic/sunspots_earth</title>
   </head>
   <body>
  <h1>Index of /data/synoptic/sunspots_earth</h1>
    <table>
     <tr><th valign="top"><img src="/icons/blank.gif" alt="[ICO]"></th><th><a href="?C=N;O=D">Name</a></th><th><a href="?C=M;O=A">Last modified</a></th><th><a href="?C=S;O=A">Size</a></th><th><a href="?C=D;O=A">Description</a></th></tr>
     <tr><th colspan="5"><hr></th></tr>
  <tr><td valign="top"><img src="/icons/image2.gif" alt="[IMG]"></td><td><a href=".jpgsunspots_4096_20230724.jpg">sunspots_512_20230724.jpg</a></td><td align="right">2023-07-24 19:54  </td><td align="right"> 34K</td><td>&nbsp;</td></tr>
  <tr><td valign="top"><img src="/icons/image2.gif" alt="[IMG]"></td><td><a href="sunspots_4096_20230725.jpg">sunspots_512_20230725.jpg</a></td><td align="right">2023-07-25 19:54  </td><td align="right"> 35K</td><td>&nbsp;</td></tr>
  <tr><td valign="top"><img src="/icons/image2.gif" alt="[IMG]"></td><td><a href="sunspots_1024_20230729.jpg">sunspots_512_20230729.jpg</a></td><td align="right">2023-07-29 19:54  </td><td align="right"> 35K</td><td>&nbsp;</td></tr>
  <tr><td valign="top"><img src="/icons/image2.gif" alt="[IMG]"></td><td><a href="sunspots_1024_20230730.jpg">sunspots_512_20230730.jpg</a></td><td align="right">2023-07-30 19:54  </td><td align="right"> 35K</td><td>&nbsp;</td></tr>
  <tr><td valign="top"><img src="/icons/image2.gif" alt="[IMG]"></td><td><a href="sunspots_512_20230731.jpg">sunspots_512_20230731.jpg</a></td><td align="right">2023-07-31 19:54  </td><td align="right"> 34K</td><td>&nbsp;</td></tr>
  <tr><td valign="top"><img src="/icons/image2.gif" alt="[IMG]"></td><td><a href="sunspots_512_20240128.jpg">sunspots_512_20240128.jpg</a></td><td align="right">2024-01-28 15:54  </td><td align="right"> 35K</td><td>&nbsp;</td></tr>
     <tr><th colspan="5"><hr></th></tr>
  </table>
  </body></html>
html

html_lines  = html.split("\n")
href_regexp = /href=\"(?<href_link>[^"]*)"/
~~~

> NOTE: The mentioned **html_lines** and **href_regexp** variables will be used throughout the document as defined above.


This example shows a simple use of the hrep parse feature. In this example, with the regex **href=\"(?<href_link>[^"]*)"**, it starts with **href="** and ends with **"**, and contains a name among these tags expressions are sought.

~~~ruby
link_arr  = HREP.parse(regexp: href_regexp, lines: html_lines)
# [["?C=N;O=D"], [".jpgsunspots_4096_20230724.jpg"], ["sunspots_4096_20230725.jpg"], ["sunspots_1024_20230729.jpg"], ["sunspots_1024_20230730.jpg"], ["sunspots_512_20230731.jpg"], ["sunspots_512_20240128.jpg"]]
~~~


For example, let's say we want to get only the links starting with "sunspot", containing "_512_" and the extension "jpg" (those ending with .jpg) from the structure we have. We can also define a regex like /href=\"sunspot(?<href_link>[^"]*)\.jpg"/ for this operation. However, since defining the words containing "_512_" with regex will confuse our expression, we use our block and must have lists to do this. We can carry out transactions.

~~~ruby
must_have_list = [ /^sunspots/, /_512_/, /\.jpg$/ ]

link_arr  = HREP.parse(regexp: href_regexp, lines: html_lines, must_have_list: must_have_list)
# [["sunspots_512_20230731.jpg"], ["sunspots_512_20240128.jpg"]]
~~~

> NOTE: Each definition in **must_have_list** must appear within a regex-restricted expression. In addition, if any expression in the **block_list** array is included in the expression captured with regex, these strings will also be removed.

~~~ruby
block_list     = ["sunspots_512_20240128"]
must_have_list = [ /^sunspots/, /_512_/, /\.jpg$/ ]

link_arr  = HREP.parse(regexp: href_regexp, lines: html_lines, must_have_list: must_have_list, block_list: block_list)
# [["sunspots_512_20230731.jpg"]]
~~~

> NOTE: While **must_have_list** supports regex, **block_list** does not currently support regex expressions.

Additionally, the regex parameter supports multiple fields. The result produced is included in the relevant result array.

~~~ruby
href_regexp2    = /href=\"(?<field>[^"]*)\.(?<extention>jpg)"/
must_have_list = [ /^sunspots/, /_512_/, /jpg$/ ]

link_arr  = HREP.parse(regexp: href_regexp2, lines: html_lines, must_have_list: must_have_list)
# [["sunspots_512_20230731", "jpg"], ["sunspots_512_20240128", "jpg"]]
~~~

