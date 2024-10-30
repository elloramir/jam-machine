import os
import shutil
import zipfile
import urllib.request
from datetime import datetime

DIST_DIR = "dist"

LOVE2D_URL = "https://github.com/love2d/love/releases/download/11.5/love-11.5-win64.zip"
LOVE2D_DIR = os.path.join(DIST_DIR, "love-11.5-win64")
LOVE2D_ZIP = "love-11.5-win64.zip"


def log_stage(message):
    print(f"[LOG] {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - {message}")


def remove_dir_if_exists(directory):
    if os.path.exists(directory):
        shutil.rmtree(directory)


def create_dir_if_not_exists(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)


def download_file(url, output_path):
    urllib.request.urlretrieve(url, output_path)


def zip_dir(source_dir, output_zip, exclude_dirs=None):
    if exclude_dirs is None:
        exclude_dirs = []
    
    log_stage(f"Starting to zip the directory {source_dir} to {output_zip}.")
    
    with zipfile.ZipFile(output_zip, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for root, dirs, files in os.walk(source_dir):
            # Exclude directories that should not be zipped
            if any(excluded in root for excluded in exclude_dirs):
                continue

            for file in files:
                file_path = os.path.join(root, file)
                # Relative to the base directory
                arcname = os.path.relpath(file_path, start=source_dir)
                zipf.write(file_path, arcname=arcname)
    
    log_stage(f"Finished zipping the directory {source_dir}.")


def unzip_file(zip_path, extract_to):
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall(extract_to)


def build_game():
    # Step 1: Clean 'dist' directory and create a new one
    log_stage("Removing 'dist' directory if it exists.")
    remove_dir_if_exists(DIST_DIR)

    log_stage("Creating 'dist' directory.")
    create_dir_if_not_exists(DIST_DIR)

    # Step 2: Create the game.love file (a zip of the current directory), excluding the dist folder
    log_stage("Creating the game.love file.")
    zip_dir(".", os.path.join(DIST_DIR, "game.love"), exclude_dirs=[DIST_DIR])

    # Step 3: Download Love2D binaries
    log_stage(f"Downloading Love2D binaries from {LOVE2D_URL}.")
    download_file(LOVE2D_URL, os.path.join(DIST_DIR, LOVE2D_ZIP))

    # Step 4: Unzip Love2D binaries
    log_stage(f"Unzipping the file {LOVE2D_ZIP}.")
    unzip_file(os.path.join(DIST_DIR, LOVE2D_ZIP), DIST_DIR)

    # Step 5: Combine love.exe with game.love
    log_stage("Combining love.exe with game.love to create game.exe.")
    with open(os.path.join(LOVE2D_DIR, "love.exe"), "rb") as love_exe, \
         open(os.path.join(DIST_DIR, "game.love"), "rb") as game_love, \
         open(os.path.join(LOVE2D_DIR, "game.exe"), "wb") as game_exe:
        game_exe.write(love_exe.read())
        game_exe.write(game_love.read())

    # Step 6: Clean up unnecessary files
    log_stage("Removing unnecessary files.")
    os.remove(os.path.join(DIST_DIR, LOVE2D_ZIP))
    os.remove(os.path.join(DIST_DIR, "game.love"))
    for file in ["love.exe", "lovec.exe", "readme.txt", "changes.txt", "license.txt", "love.ico", "game.ico"]:
        os.remove(os.path.join(LOVE2D_DIR, file))

    # Step 7: Create a ZIP file of the love-11.5-win64 directory with the current date in the name
    log_stage("Creating a ZIP file of the love-11.5-win64 directory with the current date in the name.")
    current_date = datetime.now().strftime("%d.%m.%Y")
    output_zip = os.path.join(DIST_DIR, f"game.win64.{current_date}.zip")
    zip_dir(LOVE2D_DIR, output_zip)

    # Step 8: Clean the love-11.5-win64 directory
    log_stage("Cleaning the love-11.5-win64 directory.")
    remove_dir_if_exists(LOVE2D_DIR)

    log_stage("Process completed.")


if __name__ == "__main__":
    build_game()
