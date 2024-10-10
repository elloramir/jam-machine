import os
import shutil
import zipfile
import urllib.request
from datetime import datetime

# Função para log
def log_stage(message):
    print(f"[LOG] {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} - {message}")

# Constantes
LOVE2D_URL = "https://github.com/love2d/love/releases/download/11.5/love-11.5-win64.zip"
LOVE2D_ZIP = "love-11.5-win64.zip"
DIST_DIR = "dist"
LOVE2D_DIR = os.path.join(DIST_DIR, "love-11.5-win64")

# Funções auxiliares
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
    
    log_stage(f"Iniciando compactação do diretório {source_dir} para {output_zip}.")
    
    with zipfile.ZipFile(output_zip, 'w', zipfile.ZIP_DEFLATED) as zipf:
        for root, dirs, files in os.walk(source_dir):
            # Exclui diretórios que não devem ser compactados
            if any(excluded in root for excluded in exclude_dirs):
                continue

            for file in files:
                file_path = os.path.join(root, file)
                # Relativo ao diretório base
                arcname = os.path.relpath(file_path, start=source_dir)
                zipf.write(file_path, arcname=arcname)
    
    log_stage(f"Finalizada a compactação do diretório {source_dir}.")

def unzip_file(zip_path, extract_to):
    with zipfile.ZipFile(zip_path, 'r') as zip_ref:
        zip_ref.extractall(extract_to)

# Etapas do processo

# 1. Limpar o diretório 'dist' e criar um novo
log_stage("Removendo o diretório 'dist' se existir.")
remove_dir_if_exists(DIST_DIR)

log_stage("Criando o diretório 'dist'.")
create_dir_if_not_exists(DIST_DIR)

# 2. Criar o arquivo game.love (um zip do diretório atual), excluindo a pasta dist
log_stage("Criando o arquivo game.love.")
zip_dir(".", os.path.join(DIST_DIR, "game.love"), exclude_dirs=[DIST_DIR])

# 3. Baixar os binários do Love2D
log_stage(f"Baixando os binários do Love2D de {LOVE2D_URL}.")
download_file(LOVE2D_URL, os.path.join(DIST_DIR, LOVE2D_ZIP))

# 4. Descompactar os binários do Love2D
log_stage(f"Descompactando o arquivo {LOVE2D_ZIP}.")
unzip_file(os.path.join(DIST_DIR, LOVE2D_ZIP), DIST_DIR)

# 5. Combinar love.exe com game.love
log_stage("Combinando love.exe com game.love para criar game.exe.")
with open(os.path.join(LOVE2D_DIR, "love.exe"), "rb") as love_exe, \
     open(os.path.join(DIST_DIR, "game.love"), "rb") as game_love, \
     open(os.path.join(LOVE2D_DIR, "game.exe"), "wb") as game_exe:
    game_exe.write(love_exe.read())
    game_exe.write(game_love.read())

# 6. Limpeza de arquivos desnecessários
log_stage("Removendo arquivos desnecessários.")
os.remove(os.path.join(DIST_DIR, LOVE2D_ZIP))
os.remove(os.path.join(DIST_DIR, "game.love"))
for file in ["love.exe", "lovec.exe", "readme.txt", "changes.txt", "license.txt", "love.ico", "game.ico"]:
    os.remove(os.path.join(LOVE2D_DIR, file))

# 7. Criar um arquivo ZIP do diretório love-11.5-win64 com a data atual no nome
log_stage("Criando o arquivo ZIP do diretório love-11.5-win64 com a data no nome.")
current_date = datetime.now().strftime("%d.%m.%Y")
output_zip = os.path.join(DIST_DIR, f"game.win64.{current_date}.zip")
zip_dir(LOVE2D_DIR, output_zip)

# 8. Limpar o diretório love-11.5-win64
log_stage("Limpando o diretório love-11.5-win64.")
remove_dir_if_exists(LOVE2D_DIR)

log_stage("Processo concluído.")
