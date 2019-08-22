#!/bin/bash

export JULIA_NUM_THREADS=1
julia 4_sum_thread.jl

export JULIA_NUM_THREADS=2
julia 4_sum_thread.jl

export JULIA_NUM_THREADS=$(nproc)
julia 4_sum_thread.jl


