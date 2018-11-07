#!/bin/sh

VERSION=2.18.0
PORT=8106

cd wiremock && java -jar wiremock-standalone-$VERSION.jar --port $PORT
