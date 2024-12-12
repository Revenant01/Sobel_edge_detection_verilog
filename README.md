# Sobel Edge Detection in Verilog

## Introduction

This project involves implementing the Sobel edge detection algorithm using Verilog. The Sobel operator, a fundamental tool in image processing, is used to highlight edges in images. The purpose of this project is to provide hands-on experience with Verilog and digital image processing, while demonstrating how hardware acceleration can enhance image processing tasks.

## Objectives

- Implement the Sobel edge detection algorithm in Verilog.
- Understand edge detection principles and digital image processing basics.
- Learn to manage and manipulate image data using Verilog.
- Gain experience in hardware design and simulation for image processing applications.

## Project Description

The Sobel edge detector uses convolution with two 3x3 kernels to compute the gradient of the image intensity at each pixel, identifying edges in the image. This project creates a Verilog module that performs this operation on grayscale images. The design will incorporate the use of block RAM or shift registers to manage image data, and pipelining techniques will be applied to improve throughput.

### Sobel Operator Kernels

**Horizontal Kernel:**

