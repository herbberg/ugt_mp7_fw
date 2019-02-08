#!/usr/bin/env python2
# -*- coding: utf-8 -*-

"""startSim.py -- starting simulation of gtl_fdl_wrapper with Vivado
"""

import subprocess
import argparse
import logging
import ConfigParser
import sys, os, re
import socket

HB_PC = 'powerslave'
"""if HB_PC => Bergauer PC 'powerslave' Xilinx Vivado installation location = '/opt/Xilinx/Vivado."""
"""else => Default Xilinx Vivado installation location = '/opt/xilinx/Vivado'."""
if socket.gethostname() == HB_PC:
    VIVADO_BASE_DIR = '/opt/Xilinx/Vivado'
else:
    VIVADO_BASE_DIR = '/opt/xilinx/Vivado'

EXIT_SUCCESS = 0
EXIT_FAILURE = 1

def run_command(*args):
    command = ' '.join(args)
    logging.info(">$ %s", command)
    os.system(command)

def vivado_t(version):
    """Validates Xilinx Vivado version number."""
    if not re.match(r'^\d{4}\.\d+$', version):
        raise ValueError("not a xilinx vivado version: '{version}'".format(**locals()))
    return version

def parse_args():
    """Parse command line arguments."""
    parser = argparse.ArgumentParser()
    parser.add_argument('vivado', type=vivado_t, help="xilinx vivado version to run, eg. '2016.4'")
    parser.add_argument('config', type=os.path.abspath, help="build configuration file to read")
    #parser.add_argument('--menu', metavar = 'path', help = 'menue folder path', type = os.path.abspath, required = True)
    parser.add_argument('--testvector', metavar = 'path', help = 'testvector file path')
    return parser.parse_args()

def main():
    """Main routine."""

    # Parse command line arguments.
    args = parse_args()

    # Setup console logging
    logging.basicConfig(format = '%(levelname)s: %(message)s', level = logging.DEBUG)

    config = ConfigParser.RawConfigParser()
    config.read(args.config)

    logging.info("contents of config file '%s'", args.config)
    for section in config.sections():
        for option in config.options(section):
            logging.info(" %s.%s: %s", section, option, config.get(section, option))

    menu = config.get('menu', 'name')
    #print 'menu=', menu
    build = config.get('menu', 'build')
    #print 'build=', build    
    modules = int(config.get('menu', 'modules'))
    #print 'modules=', modules
    buildarea = config.get('firmware', 'buildarea')
    #print 'buildarea=', buildarea
    tv = os.path.abspath(args.testvector)
    #print 'tv=', tv
    menu_location = config.get('menu', 'location')
    #print 'menu location=', menu_location

    logging.info("start Vivado simulation")

    # settings filename
    settings64 = os.path.join(VIVADO_BASE_DIR, args.vivado, 'settings64.sh')
    if not os.path.isfile(settings64):
        raise RuntimeError(
            "no such Xilinx Vivado settings file '{settings64}'\n" \
            "  check if Xilinx Vivado {args.vivado} is installed on this machine.".format(**locals())
        )

    for i in range(modules):
        command = 'bash -c "source {settings64}; cd {buildarea}; python sim/scripts/run_vivado_simulation.py --menu {menu_location} --testvector {tv}"'.format(**locals())
        #print 'command= ', command
        run_command(command)

    logging.info("done.")

if __name__ == '__main__':
    try:
        main()
    except RuntimeError as e:
        logging.error(format(e))
        sys.exit(EXIT_FAILURE)
    sys.exit(EXIT_SUCCESS)
