#!/bin/bash

function set_proxy {
    export https_proxy=$1
    export http_proxy=$1

    echo "[Service]" > ~/proxy.conf
    echo "Environment=\"HTTP_PROXY=$my_clash_verge_proxy\"" >> ~/proxy.conf
    echo "Environment=\"HTTPS_PROXY=$my_clash_verge_proxy\"" >> ~/proxy.conf

    if [ ! -f "/etc/systemd/system/docker.service.d/proxy.conf" ];then
        update_docker_proxy=true
    elif ! $(cmp ~/proxy.conf /etc/systemd/system/docker.service.d/proxy.conf); then
        update_docker_proxy=true
    else
        update_docker_proxy=false
    fi

    if ${update_docker_proxy}; then
        sudo mv ~/proxy.conf /etc/systemd/system/docker.service.d/proxy.conf
        echo -e "${L_FNRED}RESTARTING DOCKER FOR PROXY${L_NC}"
        sudo systemctl daemon-reload
        sudo systemctl restart docker
    else
        rm ~/proxy.conf
    fi
}

function unset_proxy {
    unset https_proxy http_proxy
    sudo rm /etc/systemd/system/docker.service.d/proxy.conf
    echo -e "${L_FNRED}RESTARTING DOCKER${L_NC}"
    sudo systemctl daemon-reload
    sudo systemctl restart docker
}

function dl_clcfg {
    sudo wget -O config.yaml "https://v1.tlsa.top/link/6InZjTxlJoOkwj0UMXr81ziVxFjT37yunjBw?clash=1"
    # "https://api.v1.mk/sub?target=clash&filename=SSRDOG.yaml&new_name=true&url=https%3A%2F%2F131c6b8e0b186c6224a54bbcdf3dfb7f.img-cache-oss-cn-tokyo-aliyuncs-storage.com%2Fs%3Ft%3D131c6b8e0b186c6224a54bbcdf3dfb7f.jpg&insert=false&config=https%3A%2F%2Fraw.githubusercontent.com%2FACL4SSR%2FACL4SSR%2Fmaster%2FClash%2Fconfig%2FACL4SSR_Online.ini"
    # "https://sub.d1.mk/sub?target=clash&filename=SSRDOG.yaml&new_name=true&url=https%3A%2F%2F131c6b8e0b186c6224a54bbcdf3dfb7f.beijing-aliyuncs.sbs%2Fs%3Ft%3D131c6b8e0b186c6224a54bbcdf3dfb7f.jpg&insert=false&config=https%3A%2F%2Fraw.githubusercontent.com%2FACL4SSR%2FACL4SSR%2Fmaster%2FClash%2Fconfig%2FACL4SSR_Online.ini"
    cp /etc/mihomo/config.yaml config.yaml_bk
    sudo mv config.yaml /etc/mihomo/config.yaml
}
