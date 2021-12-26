#!/usr/bin/env zsh

set -e

ruby_tag="3.1.0"
openssl_tag="openssl-3.0.1"

install_prefix=$INSTALL_PREFIX

if [ "$install_prefix" = "" ]; then
    install_prefix=/usr/local
fi

git clone --depth=1 -b $openssl_tag https://github.com/openssl/openssl.git openssl
pushd openssl
./Configure darwin64-$(uname -m) \
            no-shared \
            no-tests \
            -DOPENSSL_USE_IPV6=1 \
            CC=clang CXX=clang++ \
            --prefix=$install_prefix
make -j
sudo make install
popd

tar -xvf ruby-$ruby_tag.tar.gz
pushd ruby-$ruby_tag
./configure CFLAGS="-I$install_prefix/include" \
            LDFLAGS="-L$install_prefix/lib" \
            CC=clang CXX=clang++ \
            --prefix=$install_prefix
make -j
sudo make install
popd
