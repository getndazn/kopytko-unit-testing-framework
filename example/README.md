# Kopytko-unit-testing-framework example

## Setup

Because NPM links local dependency and kopytko-packager trying to find all dependencies in direct node_modules/ directory
it is required to exceptionally pack the kopytko-unit-testing-framework first:

1. Install kopytko-unit-testing-framework's dependencies: `cd .. && npm ci`
2. Create NPM package: `npm pack`
3. Install example app unit-testing-framework dependencies
`cd example && npm ci`
4. Install packed unit-testing-framework: `npm i ../dazn-kopytko-unit-testing-framework-0.0.1.tgz`

## Usage
```shell
npm test -- --rokuIP=<IP>
```
Example: `npm test -- --rokuIP=192.168.3.2`
