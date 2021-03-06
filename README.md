# gist-compile

[![Join the chat at https://gitter.im/claymcleod/gist-compile](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/claymcleod/gist-compile?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge) [![Gem Version](https://badge.fury.io/rb/gist-compile.svg)](http://badge.fury.io/rb/gist-compile)

"gist-compile" is a tool I created to index your Github Gists (and the backend to a website I created, called [Gnippets](http://gnippets.com). Currently, the supported outputs are JSON, Markdown, and HTML. [View the results here](https://github.com/claymcleod/gist-compile/tree/master/gc_products). The usage is simple:

## Downloading using Rubygems

1. Install the gem using Rubygems ```gem install gist-compile```
2. Start gist-compile! ```gist-compile start -u "claymcleod"```

## Downloading manually

1. Clone the repo
2. Change the gist-compile directory ```cd <gist-compile folder location>```
3. Make the binary executable ```chmod +x bin/gist-compile```
4. Start gist-compile! ```bin/gist-compile start -u "claymcleod"```


## Formatting your gists

Before you run gist-compile, you should format each Gist you want compiled like so:

```
# Title: Simple Ruby Datamining Example
# Authors: Clay McLeod
# Description: La tee
#               da
# Section: Learning Ruby
# Subsection: Simple Examples

...code...
```

A few rules:

1. This comment must be at the top of your gist file (shebangs are the only thing that may go above them)
2. You must format your comment using single line comment character (multi-line comments not supported!)
3. You must include a section and a subsection.

