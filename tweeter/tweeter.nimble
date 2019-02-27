# Package

version       = "0.1.0"
author        = "code life"
description   = "A simple Twitter clone using Jester framework which is written using Nim lang"
license       = "LGPL-3.0"
srcDir        = "src"
bin           = @["tweeter"]
skipExt       = @["nim"]

# Dependencies

requires "nim >= 0.19.4"
requires "jester >= 0.4.1"
