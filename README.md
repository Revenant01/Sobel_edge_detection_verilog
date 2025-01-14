# Sobel Edge Detection in Verilog

![License](https://img.shields.io/badge/license-MIT-blue.svg) 
![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)

This project implements the Sobel edge detection algorithm in Verilog for image processing tasks. The Sobel operator is commonly used to detect edges in images by calculating the gradient magnitude at each pixel. This project explores Verilog, digital image processing, and hardware acceleration techniques for image processing.

---

## Table of Contents
- [Project Overview](#project-overview)
- [Objectives](#objectives)
- [Project Description](#project-description)
- [Implementation Steps](#implementation-steps)
- [Modules Documentation](#modules-documentation)
- [Installation](#installation)
- [Usage](#usage)
- [Project Structure](#project-structure)
- [Evaluation Criteria](#evaluation-criteria)
- [References](#references)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

---

## Project Overview

This project provides an opportunity to implement and simulate a hardware-based edge detection solution. It involves using the Sobel operator to process images and generate an edge map, highlighting transitions in pixel intensity.

---

## Objectives

- Implement the Sobel edge detection algorithm in Verilog.
- Learn the fundamentals of edge detection and digital image processing.
- Gain experience in hardware design and simulation for image processing applications.

---

## Project Description

The Sobel edge detection algorithm uses two 3x3 convolution kernels to compute the image intensity gradient at each pixel. This highlights edges in the image based on gradient magnitude.

### Sobel Kernels:
- Horizontal kernel (Gx):
- Vertical kernel (Gy):

  
The project involves designing Verilog modules to compute these convolutions and combine the results to produce an edge-detected image.

---

## Implementation Steps

### Step 1: Project Setup
- Install Siemens Questa for Verilog simulation.
- Define the method for inputting and outputting image data (e.g., simulation files or FPGA I/O).

### Step 2: Understanding the Sobel Operator
- Study the Sobel operator and its convolution kernels.
- Understand convolution operations for edge detection in images.

### Step 3: Verilog Module Design
- To integrate the Sobel operator, define a top-level Verilog module (`sobel_top.v`).
- Design a controller module (`controller.v`) to manage the Sobel filter logic.
- Implement convolution logic and gradient magnitude calculations.

### Step 4: Testing and Simulation
- Write test benches for simulation with sample image data.
- Use Siemens Questa for testing and waveform analysis.

### Step 5: Final Report and Deliverables
- Submit Verilog code, testbenches, and simulation results.
- Include a final report documenting the design process, challenges, and results.

---

## Modules Documentation

The project consists of two main Verilog modules along with other sub-modules:

1. [sobel_top.v](sobel_top.md):
 - Integrates the Sobel operator and handles input/output.
 - Processes 9 pixels per clock cycle using a sliding window approach.

2. [controller.v](controller.md):
 - Manages control signals and timing for the Sobel filter.

---

## Installation

1. Clone the repository:
 ```bash
 git clone https://github.com/username/sobel_edge_detection.git


