# openlayers-cljs-compile-error-repo

I've created this repo to present the error I encountered while developing a cljs project that it included [openlayers](https://github.com/cljsjs/packages/tree/master/openlayers) lib in its deps.

The error message is: *java.io.IOException: The filename, directory name, or volume label syntax is incorrect*. This error only happens on Windows (I tested it on a Linux machine also).

This was tested with Java 8 on Windows 10 with Clojure and ClojureScript
versions 1.8.0 and 1.9.293 respectfully and openlayers 3.15.1 version.

The problem presentation is based on [ClojureScript Quick start guide](https://clojurescript.org/guides/quick-start). It shows a minimal representation of the problem.

Interesting to mention, when build with lein cljsbuild plugin it compiles successfully and when built with Figwheel it shows the same problem.

Here is the example stacktrace:

```
Copying jar:file:/C:/Users/****/Documents/Projects/openlayers-cljs-compile-error-repo/openlayers-3.15.1.jar!/cljsjs/openlayers/development/ol/events/event.js to out\file:\C:\Users\****\Documents\Projects\openlayers-cljs-compile-error-repo\openlayers-3.15.1.jar!\
cljsjs\openlayers\development\ol\events\event.js
Exception in thread "main" java.io.IOException: The filename, directory name, or volume label syntax is incorrect, compiling:(C:\Users\****\Documents\Projects\openlayers-cljs-compile-error-repo\build.clj:3:1)
        at clojure.lang.Compiler.load(Compiler.java:7391)
        at clojure.lang.Compiler.loadFile(Compiler.java:7317)
        at clojure.main$load_script.invokeStatic(main.clj:275)
        at clojure.main$script_opt.invokeStatic(main.clj:335)
        at clojure.main$script_opt.invoke(main.clj:330)
        at clojure.main$main.invokeStatic(main.clj:421)
        at clojure.main$main.doInvoke(main.clj:384)
        at clojure.lang.RestFn.invoke(RestFn.java:408)
        at clojure.lang.Var.invoke(Var.java:379)
        at clojure.lang.AFn.applyToHelper(AFn.java:154)
        at clojure.lang.Var.applyTo(Var.java:700)
        at clojure.main.main(main.java:37)
Caused by: java.io.IOException: The filename, directory name, or volume label syntax is incorrect
        at java.io.WinNTFileSystem.canonicalize0(Native Method)
        at java.io.WinNTFileSystem.canonicalize(WinNTFileSystem.java:428)
        at java.io.File.getCanonicalPath(File.java:618)
        at java.io.File.getCanonicalFile(File.java:643)
        at cljs.util$mkdirs.invokeStatic(util.cljc:103)
        at cljs.closure$write_javascript.invokeStatic(closure.clj:1566)
        at cljs.closure$source_on_disk.invokeStatic(closure.clj:1590)
        at cljs.closure$output_unoptimized$fn__4569.invoke(closure.clj:1629)
        at clojure.core$map$fn__4785.invoke(core.clj:2646)
        at clojure.lang.LazySeq.sval(LazySeq.java:40)
        at clojure.lang.LazySeq.seq(LazySeq.java:49)
        at clojure.lang.RT.seq(RT.java:521)
        at clojure.core$seq__4357.invokeStatic(core.clj:137)
        at clojure.core$filter$fn__4812.invoke(core.clj:2700)
        at clojure.lang.LazySeq.sval(LazySeq.java:40)
        at clojure.lang.LazySeq.seq(LazySeq.java:56)
        at clojure.lang.RT.seq(RT.java:521)
        at clojure.core$seq__4357.invokeStatic(core.clj:137)
        at clojure.core$map$fn__4785.invoke(core.clj:2637)
        at clojure.lang.LazySeq.sval(LazySeq.java:40)
        at clojure.lang.LazySeq.seq(LazySeq.java:49)
        at clojure.lang.Cons.next(Cons.java:39)
        at clojure.lang.RT.boundedLength(RT.java:1749)
        at clojure.lang.RestFn.applyTo(RestFn.java:130)
        at clojure.core$apply.invokeStatic(core.clj:646)
        at cljs.closure$deps_file.invokeStatic(closure.clj:1330)
        at cljs.closure$output_deps_file.invokeStatic(closure.clj:1352)
        at cljs.closure$output_unoptimized.invokeStatic(closure.clj:1639)
        at cljs.closure$output_unoptimized.doInvoke(closure.clj:1620)
        at clojure.lang.RestFn.applyTo(RestFn.java:139)
        at clojure.core$apply.invokeStatic(core.clj:648)
        at cljs.closure$build.invokeStatic(closure.clj:1975)
        at cljs.build.api$build.invokeStatic(api.clj:198)
        at cljs.build.api$build.invoke(api.clj:187)
        at cljs.build.api$build.invokeStatic(api.clj:190)
        at cljs.build.api$build.invoke(api.clj:187)
        at user$eval24.invokeStatic(build.clj:3)
        at user$eval24.invoke(build.clj:3)
        at clojure.lang.Compiler.eval(Compiler.java:6927)
        at clojure.lang.Compiler.load(Compiler.java:7379)
        ... 11 more
```

Note: User name is masked with '*' but it is consisted of ASCII characters, not spaces or weird letters.

### Linux observations

No error is raised on Linux machines, but the "error" exists. Dependency path is not separated as it
should - it still contains full file URL from jar file, but on Linux ! and : in file path doesn't make
a problem. See the example:

```
goog.addDependency("../file:/home/****/Documents/openlayers-cljs-compile-error-repo/openlayers-3.15.1.jar!/cljsjs/openlayers/development/ol/events/event.js", ['ol.events.Event'], []);
...
```

### Fix

Issue is reported on ClojureScript Jira here [CLJS-1868](http://dev.clojure.org/jira/browse/CLJS-1868).

he problem was in the function that produced relative output paths for deps (lib-rel-path).
It tried to remove the first part of the absolute path with clojure.string/replace, but
it tried it with a wrong match (it did not reproduce the actual first part of the path)
so it effectively did nothing.

Example:```(str (io/file (System/getProperty "user.dir") lib-path) File/separator)```
produced

file:\C:\Users\&ast;&ast;&ast;&ast;\Documents\Projects\openlayers-cljs-compile-error-repo\cljsjs\openlayers\development\

instead of

file:\C:\Users\&ast;&ast;&ast;&ast;\Documents\Projects\openlayers-cljs-compile-error-repo\openlayers-3.15.1.jar!\cljsjs\openlayers\development\

This [fix](CLJS-1868.patch) was submitted to [CLJS-1868](http://dev.clojure.org/jira/browse/CLJS-1868).
