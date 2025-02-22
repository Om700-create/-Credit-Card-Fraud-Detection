import os
from pathlib import Path

# Define the project structure
project_structure = {
    "data": ["raw", "processed"],
    "notebooks": [
        "1_data_exploration.ipynb",
        "2_data_preprocessing.ipynb",
        "3_model_training.ipynb",
        "4_model_evaluation.ipynb",
    ],
    "scripts": ["data_pipeline.py", "train_model.py", "predict.py", "utils.py", "config.py"],
    "models": ["fraud_detection_model.pkl"],
    "app": ["app.py", "templates/index.html", "static/style.css"],
    "tests": ["test_data_pipeline.py", "test_model.py"],
    "results": ["metrics.txt", "confusion_matrix.png", "roc_curve.png"],
    "logs": ["pipeline.log"],
    ".github/workflows": ["ci-cd.yml"],
}

# Create the project structure
def create_project_structure(base_path: str):
    base_path = Path(base_path)

    for folder, files_or_subfolders in project_structure.items():
        folder_path = base_path / folder
        folder_path.mkdir(parents=True, exist_ok=True)  # Create parent directories if they don't exist

        for item in files_or_subfolders:
            item_path = folder_path / item
            if "/" in item:  # It's a nested file (e.g., templates/index.html)
                subfolder = item.split("/")[0]
                subfolder_path = folder_path / subfolder
                subfolder_path.mkdir(parents=True, exist_ok=True)  # Create parent directories
                file_path = subfolder_path / item.split("/")[1]
                file_path.touch()
            else:  # It's a file or subfolder
                if "." in item:  # It's a file
                    item_path.touch()
                else:  # It's a subfolder
                    item_path.mkdir(parents=True, exist_ok=True)

    # Create additional files
    (base_path / "requirements.txt").touch()
    (base_path / "setup.py").touch()
    (base_path / "README.md").touch()
    (base_path / ".gitignore").touch()
    (base_path / "LICENSE").touch()
    (base_path / "Dockerfile").touch()

    print(f"Project structure created at: {base_path}")

# Main function
if __name__ == "__main__":
    create_project_structure(".")