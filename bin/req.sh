#!/bin/bash

grep "$@" /logs/shakti/shakti.log | bunyan
