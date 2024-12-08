import os
import re
import importlib
from PIL import Image
from typing import Any, Dict, List, Optional, Tuple


def convert_images_to_grid(
    images: List[Image.Image],
    ncols: int = 8,
    grid_sz: int = 64
) -> Image.Image:
    """
    Convert a list of images to a grid.

    Args:
        images (List[Image.Image]): List of images to convert.
        k (int): Number of images to include in the grid.
        ncols (int): Number of columns in the grid.
        grid_sz (int): Size of each grid cell.

    Returns:
        Image.Image: The grid image.
    """
    # Create a grid of subplots
    k = len(images)
    nrows = (k - 1) // ncols + 1
    grid = Image.new('RGB', (ncols * grid_sz, nrows * grid_sz))

    # Iterate over the top k images
    for i, image in enumerate(images):
        # Resize the image to fit the grid size
        resized_image = image.resize((grid_sz, grid_sz))

        # Calculate the position of the image in the grid
        x = (i % ncols) * grid_sz
        y = (i // ncols) * grid_sz

        # Paste the resized image onto the grid
        grid.paste(resized_image, (x, y))

    return grid


def find_and_import_module(folder_name, module_name):
    found = False
    for module_path in os.listdir(folder_name):
        module_path = module_path.split(".")[0]
        if module_path.lower() == module_name.lower():
            found = True
            break

    if not found:
        raise ValueError(f"Cannot find module {module_name} in {folder_name}.")

    # Import the module dynamically
    parent_module = folder_name.replace("/", ".")
    full_module_name = f"{parent_module}.{module_path}"
    module = importlib.import_module(full_module_name)
    return module


def check_substrings(text, list_of_substrings):
    # Start building the regex pattern with lookaheads for each sublist
    pattern = ""
    for substrings in list_of_substrings:
        # Create a pattern segment for the current list of substrings
        substrings_pattern = f"({'|'.join(map(re.escape, substrings))})"
        # Add a lookahead for this pattern segment
        pattern += f"(?=.*{substrings_pattern})"

    # Use re.search to check if the text matches the full pattern
    if re.search(pattern, text):
        return True
    else:
        return False


class LAIONVis:
    def __init__(self, path="data/abc/laion_subset"):
        self.path_list = sorted([f'{path}/images/{x}' for x in os.listdir(f'{path}/images')])
        self.length = len(self.path_list)

        with open(f'{path}/captions.txt', 'r') as f:
            self.caption_list = [s.strip() for s in f.readlines()]

    def __getitem__(self, idx):
        # get image and caption
        img = Image.open(self.path_list[idx])
        img = img.convert('RGB')

        # center crop
        w, h = img.size
        if w > h:
            img = img.crop(((w - h) // 2, 0, (w + h) // 2, h))
        elif h > w:
            img = img.crop((0, (h - w) // 2, w, (h + w) // 2))

        caption = self.caption_list[idx]
        return img, caption


class ExemplarVis:
    def __init__(self, exemplar_paths):
        self.path_list = exemplar_paths
        self.length = len(self.path_list)
    
    def __getitem__(self, idx):
        img = Image.open(self.path_list[idx])
        img = img.convert('RGB')

        # center crop
        w, h = img.size
        if w > h:
            img = img.crop(((w - h) // 2, 0, (w + h) // 2, h))
        elif h > w:
            img = img.crop((0, (h - w) // 2, w, (h + w) // 2))

        return img
