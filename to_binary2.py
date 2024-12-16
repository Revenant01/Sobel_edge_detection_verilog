from PIL import Image
import numpy as np

def to_binary_with_sliding_window(image_path, output_file_path):
    # Open the image using PIL
    img = Image.open(image_path)
    img = img.convert('RGB')  # Ensure it's in RGB mode

    # Get image size and pixels
    width, height = img.size
    pixels = np.array(img)

    # Open output file in write mode
    with open(output_file_path, 'w') as f:
        # Write the image dimensions at the beginning of the file
        f.write(f'{width} {height}\n')

        # Loop through the image, processing 3x3 blocks (sliding window)
        for row in range(height - 2):  # Ensure 3x3 block fits vertically
            for col in range(width - 2):  # Ensure 3x3 block fits horizontally
                # Extract the 3x3 matrix starting at (col, row)
                matrix = pixels[row:row + 3, col:col + 3]

                # Flatten the matrix into a single row of pixels
                for r in range(3):
                    for c in range(3):
                        # Convert each pixel (R, G, B) to binary
                        r_val, g_val, b_val = matrix[r][c]
                        # Combine R, G, and B into a 24-bit binary number
                        binary_pixel = f'{r_val:08b}{g_val:08b}{b_val:08b}'
                        # Write the binary pixel to the file
                        f.write(binary_pixel + '\n')

# Example usage
to_binary_with_sliding_window('test2.png','output_pixels.txt')
