#!/usr/bin/env python
# -*- coding: utf-8 -*-

VERSION = '0.0.1'
APPNAME = 'jmdict-notify'

top = '.'
out = 'build'

def options(opt):
    opt.load('compiler_c')
    opt.load('vala')

def configure(conf):
    conf.load('compiler_c vala')

def build(bld):
    bld.recurse('src')
