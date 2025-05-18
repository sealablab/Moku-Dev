#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import subprocess
import sys
from pathlib import Path

def run(cmd):
    print(f"▶️  {cmd}")
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)

    # Print all output for the user
    print(result.stdout)
    print(result.stderr)

    # Look for magic testbench strings
    passed = "::PASS::ALL_TESTS" in result.stdout
    finished = "::DONE::SIMULATION_DONE" in result.stdout
    failed = "::FAIL::" in result.stdout or "::FAIL::" in result.stderr

    if passed and finished and not failed:
        print("✅ All tests passed and simulation completed.")
        return 0
    elif failed:
        print("❌ A test failure was detected.")
        return 1
    elif finished:
        print("⚠️ Simulation completed, but PASS tag was not found.")
        return 2
    else:
        print("❌ GHDL exited early or unexpectedly.")
        return result.returncode

def main():
    vhd_files = sorted(Path(".").glob("*.vhd"))
    tb_files = [f for f in vhd_files if "_tb" in f.stem]
    dut_files = [f for f in vhd_files if f not in tb_files]

    if not tb_files:
        print("❌ No testbench (*.vhd with '_tb' in name) found.")
        sys.exit(1)

    tb_file = tb_files[0]
    tb_name = tb_file.stem

    print("🔍 [1/4] Analyzing design files with GHDL...")
    for f in dut_files + [tb_file]:
        print(f"  📄 {f.name}")
        subprocess.run(f"ghdl -a --std=08 {f}", shell=True, check=True)

    print(f"🔧 [2/4] Elaborating testbench: {tb_name}")
    subprocess.run(f"ghdl -e --std=08 {tb_name}", shell=True, check=True)

    print("🚦 [3/4] Running simulation...")
    exit_code = run(f"ghdl -r --std=08 {tb_name} --vcd=wave.vcd")

    print("📦 [4/4] Waveform saved to wave.vcd")
    print("    View with: gtkwave wave.vcd &")

    sys.exit(exit_code)

if __name__ == "__main__":
    main()
