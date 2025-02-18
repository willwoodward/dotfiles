import os
import argparse


def create_symlink(src, dst):
    """Create a symlink from src to dst, if not already existing."""
    if not os.path.exists(dst):
        try:
            os.symlink(src, dst)
            print(f"Symlink created: {dst} -> {src}")
        except Exception as e:
            print(f"Failed to create symlink {dst} -> {src}: {e}")
    else:
        print(f"File in destination exists: {dst}")


def del_file(dst):
    """Deletes the file at dst if it exists."""
    if os.path.exists(dst):
        os.remove(dst)


def setup_symlinks(force=False):
    """Set up symlinks for common config files."""
    scripts_dir = os.path.dirname(os.path.abspath(__file__))
    dotfiles_dir = os.path.dirname(scripts_dir)

    # List of config files to symlink
    config_files = {
        ".bashrc": ".bashrc",
        ".inputrc": ".inputrc",
        ".profile": ".profile",
        ".bash_aliases": ".bash_aliases",
        ".bash_logout": ".bash_logout"
    }

    if force:
        # Remove destination files
        for config, filename in config_files.items():
            dst = os.path.expanduser(f"~/{config}")
            del_file(dst)

    for config, filename in config_files.items():
        src = os.path.join(dotfiles_dir, filename)
        dst = os.path.expanduser(f"~/{config}")
        create_symlink(src, dst)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('-f', action='store_true', help='Forces setup by removing destination files if they already exist.')
    args = parser.parse_args()

    setup_symlinks(args.f)
