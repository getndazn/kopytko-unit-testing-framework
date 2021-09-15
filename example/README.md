# Kopytko-unit-testing-framework example

## Setup

***Because of [NPM v7 local dependencies  bug](https://github.com/npm/cli/issues/3593)***
it is required to exceptionally pack the kopytko-unit-testing-framework first:
@todo once kopytko-packager is published, check if this is still necessary.

1. Install kopytko-unit-testing-framework's dependencies: `cd .. && npm ci`
2. Create NPM package: `npm pack`
3. Install example app unit-testing-framework dependencies
`cd example && npm ci`
4. Install packed unit-testing-framework: `npm i ../kopytko-unit-testing-framework-0.0.1.tgz`

## Usage
```shell
npm test -- --rokuIP=<IP>
```
Example: `npm test -- --rokuIP=192.168.3.2`
