import numpy as np
from PIL import Image

def read_image_from_txt(file_path):
  with open(file_path, 'r') as file:
    # Read the first line to get width and height
    width, height = map(int, file.readline().strip().split())
    
    # Initialize an empty array for the image
    image_array = np.zeros((height, width, 3), dtype=np.uint8)
    
    # Read each pixel line by line
    for y in range(height):
      for x in range(width):
        pixel_data = file.readline().strip()
        r = int(pixel_data[0:8], 2)
        g = int(pixel_data[8:16], 2)
        b = int(pixel_data[16:24], 2)
        image_array[y, x] = [r, g, b]
  
  return image_array

def save_image(image_array, output_path):
  image = Image.fromarray(image_array)
  image.save(output_path)

if __name__ == "__main__":
  input_file = 'binary_output.txt'
  output_image = 'output_image.png'
  
  image_array = read_image_from_txt(input_file)
  save_image(image_array, output_image)