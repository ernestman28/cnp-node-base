# cnp-nodejs-base

[![Build Status](https://dev.azure.com/hmcts/CNP/_apis/build/status/NodeJS%20base%20image%20build?branchName=master)](https://dev.azure.com/hmcts/CNP/_build/latest?definitionId=97&branchName=master)

## Images

| Image:tag                                  | Content                                        |
| ------------------------------------------ | ---------------------------------------------- |
| hmcts/base/node/alpine-lts-10:latest       | Alpine distribution with nodeJS LTS 10 version |
| hmcts/base/node/stretch-slim-lts-10:latest | Debian stretch and nodeJS LTS 10 version       |

## Reasoning

These images are based on nodeJS official ones, with the addition of a specific `hmcts` user, used for consistent runtime parameters.

These images are ought to be used for application runtimes, nothing prevents the use of other intermediate images to build your projects.
