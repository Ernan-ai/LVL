"""
Generate iOS app icons with black background and ">/" text
"""
from PIL import Image, ImageDraw, ImageFont
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

output_dir = "ios/Runner/Assets.xcassets/AppIcon.appiconset"

def create_icon(size, filename):
    """Create an icon with black background and '>/' text"""
    # Create black background
    img = Image.new('RGB', (size, size), color='black')
    draw = ImageDraw.Draw(img)
    
    # Calculate font size (roughly 40% of icon size)
    font_size = int(size * 0.4)
    
    try:
        # Try to use a monospace font
        font = ImageFont.truetype("consola.ttf", font_size)
    except:
        try:
            font = ImageFont.truetype("cour.ttf", font_size)
        except:
            # Fallback to default font
            font = ImageFont.load_default()
    
    # Text to draw
    text = ">/"
    
    # Get text bounding box for centering
    bbox = draw.textbbox((0, 0), text, font=font)
    text_width = bbox[2] - bbox[0]
    text_height = bbox[3] - bbox[1]
    
    # Calculate position to center text
    x = (size - text_width) // 2
    y = (size - text_height) // 2 - bbox[1]  # Adjust for baseline
    
    # Draw white text
    draw.text((x, y), text, fill='white', font=font)
    
    # Save the icon
    filepath = os.path.join(output_dir, filename)
    img.save(filepath, 'PNG')
    print(f"Created: {filename} ({size}x{size})")

# Generate all icon sizes
print("Generating iOS app icons...")
print(f"Output directory: {output_dir}\n")

for filename, size in icon_sizes:
    create_icon(size, filename)

print("\n✓ All icons generated successfully!")
print("Icons are ready in: ios/Runner/Assets.xcassets/AppIcon.appiconset/")
