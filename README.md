# openlayers-cljs-compile-error-repo

I've created this repo to present the error I encountered while developing a cljs project that it included [openlayers](https://github.com/cljsjs/packages/tree/master/openlayers) lib in its deps.

The error message is: *java.io.IOException: The filename, directory name, or volume label syntax is incorrect*. This error only happens on Windows (I tested it on a Linux machine also).

This was tested with Java 8 on Windows 10 with Clojure and ClojureScript
versions 1.8.0 and 1.9.293 respectfully and openlayers 3.15.1 version.

The problem presentation is based on [ClojureScript Quick start guide](https://clojurescript.org/guides/quick-start). It shows a minimal representation of the problem.

Interesting to mention, when build with lein cljsbuild plugin it compiles successfully and when built with Figwheel it shows the same problem.
