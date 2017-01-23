#!/bin/bash

java -cp cljs.jar:openlayers-3.15.1.jar:src clojure.main build.clj

read -n 1 -s -p "Press any key to continue"
