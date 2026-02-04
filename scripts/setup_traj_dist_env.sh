#!/bin/bash
#
# traj-dist environment setup script
# Uses uv to install Python 3.8 and minimal required dependencies
#

set -e  # Exit immediately if a command exits with a non-zero status

echo "========================================"
echo "Setting up traj-dist development environment"
echo "========================================"

# Check if uv is available
if ! command -v uv &> /dev/null; then
    echo "Error: uv is not installed"
    exit 1
fi

# Create virtual environment
echo ""
echo "Step 1: Creating virtual environment..."
if [ -d ".venv" ]; then
    echo "Removing existing virtual environment..."
    rm -rf .venv
fi
uv venv --python 3.8
echo "✓ Virtual environment created successfully"

# Install dependencies
echo ""
echo "Step 2: Installing dependencies..."
source .venv/bin/activate
uv pip install 'pip==25.0.1' 'setuptools==75.3.3' 'wheel==0.45.1' 'numpy==1.17.5' 'Cython==0.29.21' 'Shapely==1.7.1' 'geohash2==1.1' 'pandas==1.3.5' 'scipy==1.3.3' 'pyarrow==17.0.0' 'pydantic==2.10.6' 'polars==1.8.2'
echo "✓ All dependencies installed"

# Clean up old build artifacts
echo ""
echo "Step 3: Cleaning up old build files..."
rm -rf build/ dist/ traj_dist.egg-info/ traj_dist/cydist/*.c traj_dist/cydist/__pycache__/*.so traj_dist/cydist/*.so
echo "✓ Old build files removed"

# Build and install traj-dist
echo ""
echo "Step 4: Building and installing traj-dist..."
python setup.py install
echo "✓ traj-dist has been successfully built and installed"

# Verify installation
echo ""
echo "Step 5: Verifying installation..."
cd /tmp
python -c "import traj_dist.distance as tdist"
echo "✓ traj-dist import successful — installation verified"
