To build RefIccMAX the following things should be done:

1. Install a LibTiff installation copying the following files into the
Build/XCode/libtiff folder:

libtiff.a
tiff.h
tiffconf.h
tiffio.h
tiffvers.h

2. Install a LibXML installation copying the following files into the 
Build/XCode/libxml folder:

c14n.h
catalog.h
chvalid.h
debugXML.h
dict.h
DOCBparser.h
encoding.h
entities.h
globals.h
hash.h
HTMLparser.h
HTMLtree.h
list.h
nanoftp.h
nanohttp.h
parser.h
parserInternals.h
pattern.h
relaxng.h
SAX.h
SAX2.h
schemasInternals.h
threads.h
tree.h
uri.h
valid.h
xinclude.h
xlink.h
xmlautomata.h
xmlerror.h
xmlexports.h
xmlIO.h
xmlmemory.h
xmlmodule.h
xmlreader.h
xmlregexp.h
xmlsave.h
xmlschemas.h
xmlschemastypes.h
xmlstring.h
xmlunicode.h
xmlversion.h
xmlwin32version.h
xmlwriter.h
xpath.h
xpathInternals.h
xpointer.h

3. Execute the BuildAll.sh script from a bash Terminal console.  This 
should place Release executables in the Testing folder.  To build Debug
executables modify the BuildAll.sh script and set config="Debug".
