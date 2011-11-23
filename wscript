#!/usr/bin/env python
# -*- coding: utf-8 -*-

VERSION = '0.0.2'
APPNAME = 'rikai-notify'

top = '.'
out = 'build'

def options(opt):
    opt.load('compiler_c')
    opt.load('vala')

def configure(conf):
    conf.load('compiler_c vala')
    # maybe older versions are ok, but 0.8 is not
    conf.check_vala((0, 14, 0))
    conf.check_cfg(package='sqlite3', uselib_store='SQLITE', mandatory=True,
            args='--cflags --libs')
    conf.check_cfg(package='gtk+-2.0', uselib_store='GTK', mandatory=True,
            args='--cflags --libs')
    # libnotify 0.5 is not ok, 0.6 neither
    conf.check_cfg(package='libnotify', uselib_store='NOTIFY', mandatory=True,
            atleast_version="0.7", args='--cflags --libs')

def build(bld):
    bld.recurse('src')
