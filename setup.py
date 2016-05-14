#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import re
import sys

from setuptools import setup


def get_version(package):
    """
    Return package version as listed in `__version__` in `init.py`.
    """
    init_py = open(os.path.join(package, 'deform.py')).read()
    return re.search("^__version__ = ['\"]([^'\"]+)['\"]$", init_py, re.MULTILINE).group(1)


def get_packages(package):
    """
    Return root package and all sub-packages.
    """
    return [dirpath
            for dirpath, dirnames, filenames in os.walk(package)
            if os.path.exists(os.path.join(dirpath, '__init__.py'))]


def get_package_data(package):
    """
    Return all files under the root package, that are not in a
    package themselves.
    """
    walk = [(dirpath.replace(package + os.sep, '', 1), filenames)
            for dirpath, dirnames, filenames in os.walk(package)
            if not os.path.exists(os.path.join(dirpath, '__init__.py'))]

    filepaths = []
    for base, filenames in walk:
        filepaths.extend([os.path.join(base, filename)
                          for filename in filenames])
    return {package: filepaths}


version = get_version('src/')


if sys.argv[-1] == 'publish':
    os.system("python setup.py sdist upload")
    print("You probably want to also tag the version now:")
    print("  git tag -a %s -m 'version %s'" % (version, version))
    print("  git push --tags")
    sys.exit()


setup(
    name='cli-deform',
    version=version,
    url='https://github.com/deformio/cli-deform/',
    license='MIT',
    description='Command-line client for Deform.io',
    author='Gennady Chibisov',
    author_email='web-chib@ya.ru',
    install_requires=[
        'click>=6.3',
        'python-deform>=0.0.6',
        'pygments>=2.1.3',
        'colorama>=0.3.7',
    ],
    entry_points="""
        [console_scripts]
        deform=src.deform:cli
    """,
    packages=get_packages('src'),
    package_data=get_package_data('src'),
)
