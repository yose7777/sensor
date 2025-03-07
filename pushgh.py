import os

# Ganti URL repository GitHub sesuai dengan milikmu
GITHUB_REPO_URL = "https://github.com/yose7777/sensor.git"

def run_git_commands():
    try:
        # Inisialisasi Git jika belum ada
        os.system("git init")

        # Menambahkan semua perubahan
        os.system("git add .")

        # Commit perubahan dengan pesan
        os.system('git commit -am "initial commit"')

        # Tambahkan remote GitHub jika belum ada
        os.system(f"git remote add origin {GITHUB_REPO_URL}")

        # Cek apakah remote sudah terhubung
        os.system("git remote -v")

        # Push ke branch utama (main)
        os.system("git push origin main")

        print("✅ Push ke GitHub berhasil!")
    except Exception as e:
        print(f"❌ Terjadi kesalahan: {e}")

if __name__ == "__main__":
    run_git_commands()
