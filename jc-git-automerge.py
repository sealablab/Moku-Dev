#!/usr/bin/env python3

import subprocess
import sys
import os
from typing import Tuple, List

def run_command(cmd: List[str], check: bool = True) -> Tuple[int, str, str]:
    """Run a git command and return the result."""
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=check)
        return result.returncode, result.stdout, result.stderr
    except subprocess.CalledProcessError as e:
        return e.returncode, e.stdout, e.stderr

def get_current_branch() -> str:
    """Get the name of the current branch."""
    _, stdout, _ = run_command(['git', 'branch', '--show-current'])
    return stdout.strip()

def check_clean_working_directory() -> bool:
    """Check if the working directory is clean."""
    _, stdout, _ = run_command(['git', 'status', '--porcelain'])
    return len(stdout.strip()) == 0

def show_changes() -> None:
    """Show current changes in a readable format."""
    print("\n📝 Current changes:")
    print("------------------")
    
    # Show status
    _, status, _ = run_command(['git', 'status', '--short'])
    if status.strip():
        print("\nStatus:")
        print(status)
    
    # Show diff
    _, diff, _ = run_command(['git', 'diff'])
    if diff.strip():
        print("\nDiff:")
        print(diff)
    
    print("------------------")

def stash_changes() -> bool:
    """Stash current changes and return True if successful."""
    print("\n📦 Stashing your changes...")
    code, _, stderr = run_command(['git', 'stash', 'save', 'Auto-stashed by jc-git-automerge'], check=False)
    if code != 0:
        print(f"❌ Error stashing changes: {stderr}")
        return False
    return True

def pop_stash() -> bool:
    """Pop the most recent stash and return True if successful."""
    print("\n📦 Restoring your changes...")
    code, _, stderr = run_command(['git', 'stash', 'pop'], check=False)
    if code != 0:
        print(f"⚠️  Warning: Could not restore changes: {stderr}")
        print("Your changes are still in the stash. Run 'git stash pop' to restore them.")
        return False
    return True

def main():
    # Get current branch
    current_branch = get_current_branch()
    if current_branch == 'main':
        print("❌ Error: You're already on the main branch!")
        sys.exit(1)

    print(f"🔄 Starting merge process from {current_branch} to main...")

    # Check for uncommitted changes
    has_stashed = False
    if not check_clean_working_directory():
        print("⚠️  You have uncommitted changes!")
        show_changes()  # Show changes before asking
        response = input("\nWould you like to stash these changes and restore them after merging? (y/n): ").lower()
        if response == 'y':
            if not stash_changes():
                sys.exit(1)
            has_stashed = True
        else:
            print("Please commit or stash your changes before merging.")
            sys.exit(1)

    # Switch to main branch
    print("\n📌 Switching to main branch...")
    code, _, stderr = run_command(['git', 'checkout', 'main'], check=False)
    if code != 0:
        print(f"❌ Error switching to main: {stderr}")
        if has_stashed:
            pop_stash()
        sys.exit(1)

    # Pull latest changes
    print("\n📥 Pulling latest changes from main...")
    code, _, stderr = run_command(['git', 'pull', 'origin', 'main'], check=False)
    if code != 0:
        print(f"❌ Error pulling latest changes: {stderr}")
        if has_stashed:
            pop_stash()
        sys.exit(1)

    # Merge the branch
    print(f"\n🔄 Merging {current_branch} into main...")
    code, stdout, stderr = run_command(['git', 'merge', current_branch], check=False)
    
    if code != 0:
        if "refusing to merge unrelated histories" in stderr:
            print("\n⚠️  Unrelated histories detected. Attempting to merge with --allow-unrelated-histories...")
            code, stdout, stderr = run_command(['git', 'merge', current_branch, '--allow-unrelated-histories'], check=False)
        
        if code != 0:
            print("\n❌ Merge conflicts detected!")
            print("\nTo resolve conflicts:")
            print("1. Edit the conflicting files")
            print("2. Run: git add .")
            print("3. Run: git commit -m 'Resolved merge conflicts'")
            print("4. Run: git push origin main")
            if has_stashed:
                pop_stash()
            sys.exit(1)

    # Push changes
    print("\n📤 Pushing changes to remote...")
    code, _, stderr = run_command(['git', 'push', 'origin', 'main'], check=False)
    if code != 0:
        print(f"❌ Error pushing changes: {stderr}")
        if has_stashed:
            pop_stash()
        sys.exit(1)

    # Switch back to original branch
    print(f"\n📌 Switching back to {current_branch}...")
    code, _, stderr = run_command(['git', 'checkout', current_branch], check=False)
    if code != 0:
        print(f"⚠️  Warning: Could not switch back to {current_branch}: {stderr}")

    # Restore stashed changes if we stashed them
    if has_stashed:
        pop_stash()

    print("\n✅ Successfully merged and pushed changes!")
    print(f"✨ {current_branch} has been merged into main")

if __name__ == "__main__":
    main() 