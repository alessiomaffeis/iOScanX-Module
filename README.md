iOScanX-Module
============

The SXModule object is defined by the [ScanX framework](https://github.com/alessiomaffeis/ScanX) as an Objective-C protocol.
ScanX’s SXScanner expects all the analysis modules objects to be conforming to the SXModule protocol.

As an addendum to the formal definition of the SXModule protocol, the iOScanX project also includes iOScanX-Module, which is a stub of a loadable bundle having a SXModule-conforming class as the main entry point.

iOScanX-Module defines the loadable bundle’s structure and basic behaviour, and it is supposed to be a specimen for building analysis modules compatible with the iOScanX application.
