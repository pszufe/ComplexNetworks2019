#!/bin/bash

export JULIA_NUM_THREADS=1
julia 5_locking.jl

export JULIA_NUM_THREADS=$(nproc)
julia 5_locking.jl

