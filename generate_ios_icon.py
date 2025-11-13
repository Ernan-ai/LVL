"""
Generate iOS app icons with octopus skull logo
"""
from PIL import Image
import os

# Icon sizes needed for iOS
icon_sizes = [
    ("Icon-App-20x20@1x.png", 20),
    ("Icon-App-20x20@2x.png", 40),
    ("Icon-App-20x20@3x.png", 60),
    ("Icon-App-29x29@1x.png", 29),
    ("Icon-App-29x29@2x.png", 58),
    ("Icon-App-29x29@3x.png", 87),
    ("Icon-App-40x40@1x.png", 40),
    ("Icon-App-40x40@2x.png", 80),
    ("Icon-App-40x40@3x.png", 120),
    ("Icon-App-60x60@2x.png", 120),
    ("Icon-App-60x60@3x.png", 180),
    ("Icon-App-76x76@1x.png", 76),
    ("Icon-App-76x76@2x.png", 152),
    ("Icon-App-83.5x83.5@2x.png", 167),
    ("Icon-App-1024x1024@1x.png", 1024),
]

logo_path = "assets/images/logo.png"
output_dir = "ios/Runner/Assets.xcassets/AppIcon.appiconset"

def create_icon(size, filename):
    """Create an icon with black background and white octopus logo"""
    # Create black background
    background = Image.new('RGB', (size, size), color='black')
    
    # Load the logo
    try:
        logo = Image.open(logo_path).convert('RGBA')
    except FileNotFoundError:
        print(f"Error: Logo not found at {logo_path}")
        print("Please ensure logo.png exists in assets/images/")
        return
    
    # Invert colors: convert black to white for visibility
    # Get pixel data
    pixels = logo.load()
    width, height = logo.size
    
    for y in range(height):
        for x in range(width):
            r, g, b, a = pixels[x, y]
            # Invert RGB while keeping alpha
            pixels[x, y] = (255 - r, 255 - g, 255 - b, a)
    
    # Calculate logo size (95% of icon size with minimal padding)
    logo_size = int(size * 0.95)
    logo_resized = logo.resize((logo_size, logo_size), Image.Resampling.LANCZOS)
    
    # Calculate position to center logo
    position = ((size - logo_size) // 2, (size - logo_size) // 2)
    
    # Paste logo onto background
    # If logo has transparency, use it as mask
    if logo_resized.mode == 'RGBA':
        background.paste(logo_resized, position, logo_resized)
    else:
        background.paste(logo_resized, position)
    
    # Save the icon
    filepath = os.path.join(output_dir, filename)
    background.save(filepath, 'PNG')
    print(f"Created: {filename} ({size}x{size})")

# Generate all icon sizes
print("Generating iOS app icons with octopus logo...")
print(f"Logo source: {logo_path}")
print(f"Output directory: {output_dir}\n")

# Check if logo exists
if not os.path.exists(logo_path):
    print(f"❌ Error: Logo not found at {logo_path}")
    print("Please add logo.png to assets/images/ folder first")
    exit(1)

for filename, size in icon_sizes:
    create_icon(size, filename)

print("\nAll icons generated successfully!")
print("Icons are ready in: ios/Runner/Assets.xcassets/AppIcon.appiconset/")
