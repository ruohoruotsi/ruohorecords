import os
import glob
from fontTools.ttLib import TTFont

def is_variable_font(font_path):
    """Check if a font file is a variable font (has at least one axis)"""
    try:
        font = TTFont(font_path)
        return "fvar" in font  # 'fvar' table exists in variable fonts
    except Exception:
        return False

def list_variable_fonts():
    """List all installed variable fonts on macOS"""
    font_dirs = [
        "/Users/iroro/github/ruohorecords/generative_logotype/coldtype/rr_fonts/",
        "/System/Library/Fonts/Supplemental",
        "/Library/Fonts",
        os.path.expanduser("~/Library/Fonts")
    ]

    font_files = []
    for directory in font_dirs:
        font_files.extend(glob.glob(os.path.join(directory, "**/*.ttf"), recursive=True))
        font_files.extend(glob.glob(os.path.join(directory, "**/*.otf"), recursive=True))

    variable_fonts = [f for f in font_files if is_variable_font(f)]
    
    print("\n".join(variable_fonts))

if __name__ == "__main__":
    list_variable_fonts()
