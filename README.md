Easy to use developing environment for LLVM for NEC SX-Aurora VE
================================================================

This repository contains Makefile and scripts to create a developing
environment for LLVM for NEC SX-Aurora VE.

LLVM for VE requires multiple libraries' cross-compile.  Those are little
difficult to handle at the beginning.  So, I made this easy to use developing
environment.

All build operations are performed inside an Apptainer container.
The `make container-<target>` command runs `make <target>` inside
the container, so you don't need to install any build tools on
your host system.

Prerequisites
=============

Install Apptainer and pull the build container into this directory:

    $ apptainer pull docker://jam7/centos7-ve-llvm-build:latest

Prepare source codes
====================

Clone the llvm-project source code.  Use shallow clone if you simply
want to give it a try, or deep clone if you are developing for LLVM
for VE.

    $ make shallow

or

    $ make deep

Quick start
===========

Configure, build, and install clang/llvm for VE:

    $ make container-cmake
    $ make container-install

llvm is built in `build` directory and installed to `./install`.
You can change the install directory:

    $ make container-install DEST=~/.local   # need to use an absolute path

Compile without installation
============================

You can compile clang/llvm without installation:

    $ make container-build

Compile Bootstrapping
=====================

Compile clang/llvm for X86/VE, compile/cross-compile libraries for
X86 and VE, and install them to DEST directory:

    $ make container-ve DEST=~/.local   # need to use an absolute path

Compile for distribution
========================

Compile clang/llvm for X86/VE, compile/cross-compile libraries for
X86 and VE, and install stripped binaries to `./dist` directory:

    $ make container-dist

Debug mode compile
==================

Compile clang/llvm in debug mode.  Compiled clang/llvm are left in
`build-debug` directory:

    $ make container-build-debug

It is also possible to compile and install everything under debug mode:

    $ make container-clean
    $ make container-cmake BUILD_TYPE=Debug
    $ make container-install BUILD_TYPE=Debug

Run tests
=========

Tests are not executed by above commands.  Run them explicitly:

    $ make container-check-llvm
    $ make container-check-clang

You can test cross-compiled libraries on VE:

    $ make container-check-libunwind
    $ make container-check-libcxxabi
    $ make container-check-libcxx
    $ make container-check-openmp

