# cnp-nodejs-base

[![Build Status](https://dev.azure.com/hmcts/CNP/_apis/build/status/NodeJS%20base%20image%20build?branchName=master)](https://dev.azure.com/hmcts/CNP/_build/latest?definitionId=97&branchName=master)

## Images

| Tag                                                           | OS             | NodeJS version |
| ------------------------------------------------------------- | -------------- | -------------- |
| `hmcts.azurecr.io/hmcts/base/node/alpine-lts-8:latest`        | Alpine 3.9     | LTS 8          |
| `hmcts.azurecr.io/hmcts/base/node/alpine-lts-10:latest`       | Alpine 3.9     | LTS 10         |
| `hmcts.azurecr.io/hmcts/base/node/stretch-slim-lts-8:latest`  | Debian stretch | LTS 8          |
| `hmcts.azurecr.io/hmcts/base/node/stretch-slim-lts-10:latest` | Debian stretch | LTS 10         |

## Background

These images are based on nodeJS official ones using [LTS versions](https://github.com/nodejs/Release#release-schedule), with the addition of a specific `hmcts` user, used for consistent runtime parameters.

Here are the defaults properties you inherit from using those base images:

| Directive | Value                                                                                   |
| --------- | --------------------------------------------------------------------------------------- |
| `WORKDIR` | `/opt/app` (default), accessible as `$WORKDIR` as well                                  |
| `CMD`     | `["yarn", "start"]` (default)                                                           |
| `USER`    | - `root` (default)<br> - `hmcts` which you are entitled to use for your runtime process |

_Nota Bene_:

- These images are primarily aimed at application runtimes, nothing prevents the use of other intermediate images to build your projects.
- By default when the image is initially launched it will run under the context of the `root` user. This is to help support the install of dependencies during the build phase. However you may switch to the `hmcts` user for the runtime processes.
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

However you can though still push them from your workstation using the `make sandbox` command.

## License

This project is licensed under the MIT License - see the [LICENSE](https://github.com/hmcts/ccd-definition-designer-api/blob/master/LICENSE.md) file for details.
