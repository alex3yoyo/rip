#!/bin/bash

function del_pyc() {
    rm sites/*.pyc
    echo "Removed sites/*.pyc"
    return 0
}

function clean() {
    del_pyc
    echo "Cleaned"
}

clean
