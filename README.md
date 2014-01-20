iOScanX-Module
============

The SXModule object is defined by the ScanX framework as an Objective-C protocol. A protocol is a way of declaring a group of methods expected to be used for a particular situation. The concept is similar to that of the abstract class, but while a class interface declares the methods and properties associated with itself, a protocol, by contrast, is used to declare methods and properties that are independent of any specific class hierarchy.

ScanX’s SXScanner expects all the analysis modules objects to be conforming to the SXModule protocol. This means that the objects’ class must implement the required methods.

As an addendum to the formal definition of the SXModule protocol, the iOScanX project also includes iOScanX-Module, which is a stub of a loadable bundle having a SXModule-conforming class as the main entry point. Loadable bundles consist of executable code plus any resources needed to support that code, stored in a bundle directory. They can be lazily, dynamically loaded into an application at runtime, and allow other developers to extend the original functionality of the application.

iOScanX-Module defines the loadable bundle’s structure and basic behaviour, and it is supposed to be a specimen for building analysis modules compatible with the iOScanX application.
