# Kopytko-unit-testing-framework example

## Setup

***Because of [NPM v7 local dependencies  bug](https://github.com/npm/cli/issues/3593)***
it is required to exceptionally use NPM v6.

1. Install kopytko-unit-testing-framework's dependencies using NPM v6
`cd .. && npm ci`
2. Install example app unit-testing-framework dependencies
`cd example && npm ci`

## Usage
```shell
npm test -- --rokuIP=<IP>
```
Example: `npm test -- --rokuIP=192.168.3.2`
