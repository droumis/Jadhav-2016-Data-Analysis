#!/usr/bin/env python
# -*- coding: utf-8 -*-

from setuptools import setup

setup(
        name='Jadhav-2016-Data-Analysis',
        version='0.1.0.dev0',
        description='Exploratory analysis of data from Jadhav 2016',
        author='Eric Denovellis',
        author_email='edeno@bu.edu',
        packages=['src'],
        setup_requires=['pytest-runner'],
        tests_require=['pytest']
      )
