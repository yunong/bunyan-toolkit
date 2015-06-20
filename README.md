# bunyan-toolkit
Toolkit for analyzing restify node-bunyan logs.

# Pre-requisites
Ensure that both the `node` and `bunyan` binaries are on your path.

# Installation
```bash
npm install -g bunyan-toolkit
```

# Usage

```bash
# Find all requests that
# 1) have a url with a path 'Prof'
# 2) returned HTTP 200
# 3) has a latency > 600 ms
# 4) includes a header of 'accept-encoding'
# 5) with HTTP method GET
btkit -u Prof -s 200 -l 600 -H 'accept-encoding' -m 'GET' restify.log
```

`btkit` returns all queries as streaming json, so you can additionally process
its output via other tools. To get the prettified output, pipe the command to
`bunyan`
```bash
btkit -u Prof -s 200 -l 600 -H 'accept-encoding' -m 'GET' restify.log | bunyan
```

All of the parameters are optional. So by default,
```bash
btkit restify.log
```
would return all of the restify audit logs. You can additionally add more
parameters to filter the logs:

```bash
btkit -s 500 restify.log | bunyan
```

This returns all the logs the returned a 500 response.

```bash
btki -s 500 -l 250 restify.log
```
would return all restify audit logs that returned a 500 response that also took
longer than 250 ms.


# More info
```bash
btkit -h
```

# Internals
```btkit``` is just a simple bash script that wraps ```bunyan -c```. For more
information on ```bunyan -c``` look
[here](https://github.com/trentm/node-bunyan#cli-usage);
