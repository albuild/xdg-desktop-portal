# albuild-xdg-desktop-portal

Yet another unofficial xdg-desktop-portal package for Amazon Linux 2.

## Install (Amazon WorkSpaces)

### Instructions

1. Download the prebuilt package from [the Release page](https://github.com/albuild/xdg-desktop-portal/releases/tag/0.1.0).

1. Install the package.

    ```
    sudo yum install -y albuild-xdg-desktop-portal-0.1.0-1.amzn2.x86_64.rpm
    ```

## Build (Amazon WorkSpaces)

### System Requirements

* Docker

### Instructions

1. Clone this repository.

    ```
    git clone https://github.com/albuild/xdg-desktop-portal.git
    ```

1. Go to the repository.

    ```
    cd xdg-desktop-portal
    ```

1. Build a new image.

    ```
    bin/build
    ```

1. Extract a built package from the built image. The package will be copied to the ./rpm directory.

    ```
    bin/cp
    ```

1. Delete the built image.

    ```
    bin/rmi
    ```
