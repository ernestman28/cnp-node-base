# cnp-nodejs-base

[![Build Status](https://dev.azure.com/hmcts/CNP/_apis/build/status/NodeJS%20base%20image%20build?branchName=master)](https://dev.azure.com/hmcts/CNP/_build/latest?definitionId=97&branchName=master)

- [Images list](#images-list)
- [Background](#background)
- [Sample use](#sample-use)
- [Troubleshooting](#troubleshooting)
- [Pulling base images](#pulling-base-images)
- [Building images locally](#building-images-locally)
- [Building images for sandbox](#building-images-for-sandbox)
- [License](#license)

## Images list

| Tag                                                           | OS             | NodeJS version |
| ------------------------------------------------------------- | -------------- | -------------- |
| `hmcts.azurecr.io/hmcts/base/node/alpine-lts-8:latest`        | Alpine 3.9     | LTS 8          |
| `hmcts.azurecr.io/hmcts/base/node/alpine-lts-10:latest`       | Alpine 3.9     | LTS 10         |
| `hmcts.azurecr.io/hmcts/base/node/stretch-slim-lts-8:latest`  | Debian stretch | LTS 8          |
| `hmcts.azurecr.io/hmcts/base/node/stretch-slim-lts-10:latest` | Debian stretch | LTS 10         |

## Background

These images are based on nodeJS official ones using [LTS versions](https://github.com/nodejs/Release#release-schedule), with the addition of a specific `hmcts` user, used for consistent runtime parameters.

Here are the defaults properties you inherit from using those base images:

| Directive | Default Values                               |
| --------- | -------------------------------------------- |
| `WORKDIR` | `/opt/app`, accessible as `$WORKDIR` as well |
| `CMD`     | `["yarn", "start"]`                          |
| `USER`    | `hmcts`                                      |

_Nota Bene_:

- These images are primarily aimed at application runtimes, nothing prevents the use of other intermediate images to build your projects.
- By default when the image is initially launched it will run under the context of the `hmcts` user. However you may have to switch to the `root` user to install OS dependencies.
- The distroless nodeJS base image has been ruled out as it is still [pretty experimental](https://github.com/GoogleContainerTools/distroless/#docker)

## Sample use

```Dockerfile
### base image ###
FROM hmcts.azurecr.io/hmcts/base/node/stretch-slim-lts-8 as base
COPY package.json yarn.lock ./
RUN yarn install

### runtime image ###
FROM base as runtime
COPY . .
# make sure you use the hmcts user
USER hmcts
```

You can also leverage on alpine distributions to create smaller runtime images:

```Dockerfile
### base image ###
FROM hmcts.azurecr.io/hmcts/base/node/alpine-lts-10 as base
COPY package.json yarn.lock ./
RUN yarn install --production

### build image (Debian) ###
FROM hmcts.azurecr.io/hmcts/base/node/stretch-slim-lts-10 as build
COPY package.json yarn.lock ./
RUN yarn install && yarn build

### runtime image (Alpine) ###
FROM base as runtime
COPY --from=build dist ./
USER hmcts
```

## Troubleshooting

#### Permission issues when I install apk/apt dependencies

Apk/apt packages installation requires the `root` user so you may switch temporarily to this user. e.g.:

```Dockerfile
### build image (Debian) ###
FROM hmcts.azurecr.io/hmcts/base/node/stretch-slim-lts-10 as base

USER root
RUN apt-get update && apt-get install ...
USER hmcts

COPY package.json yarn.lock ./
...
```

#### Yarn install fails because of permission issues

Depending on the post-installation steps, some script might need permissions on files owned by the root user. If this is the case, you can copy files from the host as `hmcts` user:

```Dockerfile
...
COPY --chown=hmcts:hmcts package.json yarn.lock .
...
```

## Pulling base images

You will need to be authenticated to pull those images from ACR:

```shell
$ az acr login --subscription <subscription ID> --name hmcts
```

The subscription ID can be found when you log in to Azure. Make sure you use the non-prod one as AKS has hitherto been used on staging environments only.

## Building images locally

If you do not have the registry credentials, you can still build those images locally, using the `make` command:

```shell
$ make
```

This will generate the right tags so that you can use those images to build other nodejs-based projects open-sourced by HMCTS.

## Building images for sandbox

Sandbox is as its named, a _sandbox_ registry. Thus, the base images are not automatically pushed in the sandbox registry `hmctssandbox`.

However you can though still push them from your workstation using the following command:

```shell
$ make sandbox
```

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/hmcts/ccd-definition-designer-api/blob/master/LICENSE.md) file for details.
