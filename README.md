# gist-compile

gist-compile is a tool I created to index your Github Gists. Currently, the two supported outputs are Markdown and HTML. The usage is simple:

1. Clone the repo
2. Make the binary executable ```chmod +x bin/gist-compile```
3. Start gist-compile! ```bin/gist-compile start -u "claymcleod"```


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


[View the results here](https://github.com/claymcleod/gist-compile/tree/master/prod).
