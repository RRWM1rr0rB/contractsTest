# contracts

## generate contracts

1. export correct GOPATH, ex: `export GOPATH = ''`
2. execute `make all`

## to use local contracts in project edit `go.mod`

```go.mod
replace github.com/WM1rr0rB8/contractsTest/gen/go/order_service => /path/to/contractsTest/gen/go/order_service
```

## development

create `~/.netrc` file (token from internal gitlab):
```
machine github.com
  login <login>
  password <token>
```
and set the environment variable `GOPRIVATE` to `github.com/common/*`