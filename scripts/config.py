import os
from pathlib import Path

# Define base directory
BASE_DIR = Path(__file__).resolve().parent.parent

# Data paths
DATA_DIR = BASE_DIR / "data"
RAW_DATA_PATH = DATA_DIR / "raw" / "creditcard.csv"
PROCESSED_DATA_PATH = DATA_DIR / "processed" / "processed_data.csv"

# Model paths
MODELS_DIR = BASE_DIR / "models"
MODEL_PATH = MODELS_DIR / "fraud_detection_model.pkl"

# Results paths
RESULTS_DIR = BASE_DIR / "results"
METRICS_PATH = RESULTS_DIR / "metrics.json"
CONFUSION_MATRIX_PATH = RESULTS_DIR / "confusion_matrix.png"
ROC_CURVE_PATH = RESULTS_DIR / "roc_curve.png"
PREDICTIONS_PATH = RESULTS_DIR / "predictions.csv"  # Add this line


# Logs paths
LOGS_DIR = BASE_DIR / "logs"
PIPELINE_LOG_PATH = LOGS_DIR / "pipeline.log"

# Preprocessing parameters
TARGET_COLUMN = "Class"
TEST_SIZE = 0.2
RANDOM_STATE = 42

# Model hyperparameters (example for RandomForestClassifier)
MODEL_HYPERPARAMETERS = {
    "n_estimators": 100,
    "max_depth": None,
    "min_samples_split": 2,
    "min_samples_leaf": 1,
    "random_state": RANDOM_STATE,
}

# SMOTE parameters
SMOTE_PARAMETERS = {
    "random_state": RANDOM_STATE,
}

# Ensure directories exist
os.makedirs(DATA_DIR / "raw", exist_ok=True)
os.makedirs(DATA_DIR / "processed", exist_ok=True)
os.makedirs(MODELS_DIR, exist_ok=True)
os.makedirs(RESULTS_DIR, exist_ok=True)
os.makedirs(LOGS_DIR, exist_ok=True)