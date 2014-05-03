YellowCab
=========

Implementation of TAXII message spec as found here: 
http://taxii.mitre.org/specifications/version1.1/TAXII_Services_Specification.pdf
specifically section 4 which refers to TAXII Messages.  This artifacts can be used to build out 
TAXII based services.


Maven is used to manage the Thrift dependencies.  It is expected that you understand how Thrift operates if not the following
URL will help:  http://thrift.apache.org/

To build:

1) Ensure you have thrift installed
2) thrift.exe --gen <language> src/main/resources/yellowcab.thrift