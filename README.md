# cnp-nodejs-base

[![Build Status](https://dev.azure.com/hmcts/CNP/_apis/build/status/NodeJS%20base%20image%20build?branchName=master)](https://dev.azure.com/hmcts/CNP/_build/latest?definitionId=97&branchName=master)

## Images

| Image:tag                                    | Content                                        |
| -------------------------------------------- | ---------------------------------------------- |
| `hmcts/base/node/alpine-lts-10:latest`       | Alpine distribution with nodeJS LTS 10 version |
| `hmcts/base/node/stretch-slim-lts-10:latest` | Debian stretch and nodeJS LTS 10 version       |
| `hmcts/base/node/alpine-lts-8:latest`       | Alpine distribution with nodeJS LTS 8 version |
| `hmcts/base/node/stretch-slim-lts-8:latest` | Debian stretch and nodeJS LTS 8 version       |

## Background

These images are based on nodeJS official ones, with the addition of a specific `hmcts` user, used for consistent runtime parameters.

By default when the image is intially launched it will run under the context of the `root` user. This is to help support the install of dependencies during the build phase.

When running your application you should run under the context of the `hmcts` user, this already exists as it is created in these base images.

These images are to be used for application runtimes, nothing prevents the use of other intermediate images to build your projects.

The default workdir has been set to `/opt/app` within these images.

The default cmd has also been set to `[yarn, start]` 
