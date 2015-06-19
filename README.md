# bunyan-toolkit
Toolkit for analyzing restify node-bunyan logs.

# Pre-requisites
Ensure that both the `node` and `bunyan` binaries are on your path.

# Installation
```bash
npm install -g bunyan-toolkit
```

# Examples

```bash
# Find all requests that
# 1) have a url wiht a path 'Prof'
# 2) returned HTTP 200
# 3) has a latency > 600 ms
# 4) includes a header of 'accept-encoding'
# 5) with HTTP method GET
btkit -u Prof -s 200 -l 600 -H 'accept-encoding' -m 'GET' restify.log
```

# More info
```bash
btkit -h
```
