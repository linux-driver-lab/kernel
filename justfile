run: build
    docker run --rm -i -t \
        -v ./shared:/home/lab/shared \
        --device=/dev/net/tun \
        --cap-add=NET_ADMIN \
        linux-driver-lab-fedora

build:
    docker build -f docker/fedora/Dockerfile . \
        --build-arg USER_ID=$(id -u) \
        --tag linux-driver-lab-fedora
