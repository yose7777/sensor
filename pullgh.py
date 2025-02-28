import os

# Ganti dengan URL repository GitHub milikmu
GITHUB_REPO_URL = "https://github.com/yose7777/sensor.git"
BRANCH_NAME = "main"  # Ubah jika menggunakan branch lain

def run_git_pull():
    try:
        # Inisialisasi Git jika belum ada
        os.system("git init")

        # Tambahkan remote jika belum ada
        os.system(f"git remote add origin {GITHUB_REPO_URL}")

        # Cek apakah remote sudah terhubung
        os.system("git remote -v")

        # Tarik (pull) perubahan terbaru dari GitHub
        os.system(f"git pull origin {BRANCH_NAME}")

        print("✅ Pull dari GitHub berhasil!")
    except Exception as e:
        print(f"❌ Terjadi kesalahan: {e}")

if __name__ == "__main__":
    run_git_pull()
