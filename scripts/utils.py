import pandas as pd
import numpy as np
import logging
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import train_test_split
from sklearn.metrics import (
    classification_report,
    confusion_matrix,
    roc_auc_score,
    roc_curve,
    precision_recall_curve,
    average_precision_score,
)
from sklearn.preprocessing import StandardScaler
from imblearn.over_sampling import SMOTE
import joblib
import json
import os
from pathlib import Path

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")

def load_data(file_path: str) -> pd.DataFrame:
    """
    Load data from a CSV file.
    
    Args:
        file_path (str): Path to the CSV file.
    
    Returns:
        pd.DataFrame: Loaded data as a DataFrame.
    """
    logging.info(f"Loading data from {file_path}")
    return pd.read_csv(file_path)

def save_data(df: pd.DataFrame, file_path: str):
    """
    Save a DataFrame to a CSV file.
    
    Args:
        df (pd.DataFrame): DataFrame to save.
        file_path (str): Path to save the CSV file.
    """
    logging.info(f"Saving data to {file_path}")
    df.to_csv(file_path, index=False)

def preprocess_data(df: pd.DataFrame, target_column: str, test_size: float = 0.2, random_state: int = 42):
    """
    Preprocess the data by splitting into features and target, scaling, and handling class imbalance.
    
    Args:
        df (pd.DataFrame): Input DataFrame.
        target_column (str): Name of the target column.
        test_size (float): Proportion of the dataset to include in the test split.
        random_state (int): Random seed for reproducibility.
    
    Returns:
        tuple: X_train, X_test, y_train, y_test
    """
    logging.info("Preprocessing data...")
    
    # Split features and target
    X = df.drop(columns=[target_column])
    y = df[target_column]
    
    # Scale numerical features
    scaler = StandardScaler()
    X = scaler.fit_transform(X)
    
    # Handle class imbalance using SMOTE
    smote = SMOTE(random_state=random_state)
    X_res, y_res = smote.fit_resample(X, y)
    
    # Split into train and test sets
    X_train, X_test, y_train, y_test = train_test_split(X_res, y_res, test_size=test_size, random_state=random_state)
    
    logging.info("Data preprocessing completed.")
    return X_train, X_test, y_train, y_test

def evaluate_model(model, X_test, y_test):
    """
    Evaluate the model and generate performance metrics.
    
    Args:
        model: Trained model.
        X_test: Test features.
        y_test: Test labels.
    
    Returns:
        dict: Dictionary containing evaluation metrics.
    """
    logging.info("Evaluating model...")
    
    # Predictions
    y_pred = model.predict(X_test)
    y_pred_proba = model.predict_proba(X_test)[:, 1]
    
    # Classification report
    report = classification_report(y_test, y_pred, output_dict=True)
    
    # Confusion matrix
    cm = confusion_matrix(y_test, y_pred)
    
    # ROC-AUC score
    roc_auc = roc_auc_score(y_test, y_pred_proba)
    
    # Precision-Recall curve
    precision, recall, _ = precision_recall_curve(y_test, y_pred_proba)
    avg_precision = average_precision_score(y_test, y_pred_proba)
    
    # Save metrics
    metrics = {
        "classification_report": report,
        "confusion_matrix": cm.tolist(),
        "roc_auc_score": roc_auc,
        "average_precision_score": avg_precision,
    }
    
    logging.info("Model evaluation completed.")
    return metrics

def save_metrics(metrics: dict, file_path: str):
    """
    Save evaluation metrics to a JSON file.
    
    Args:
        metrics (dict): Dictionary containing evaluation metrics.
        file_path (str): Path to save the JSON file.
    """
    logging.info(f"Saving metrics to {file_path}")
    with open(file_path, "w") as f:
        json.dump(metrics, f, indent=4)

def plot_confusion_matrix(cm, file_path: str):
    """
    Plot and save the confusion matrix.
    
    Args:
        cm: Confusion matrix.
        file_path (str): Path to save the plot.
    """
    logging.info(f"Saving confusion matrix plot to {file_path}")
    plt.figure(figsize=(8, 6))
    sns.heatmap(cm, annot=True, fmt="d", cmap="Blues", cbar=False)
    plt.xlabel("Predicted")
    plt.ylabel("Actual")
    plt.title("Confusion Matrix")
    plt.savefig(file_path)
    plt.close()

def plot_roc_curve(y_test, y_pred_proba, file_path: str):
    """
    Plot and save the ROC curve.
    
    Args:
        y_test: True labels.
        y_pred_proba: Predicted probabilities.
        file_path (str): Path to save the plot.
    """
    logging.info(f"Saving ROC curve plot to {file_path}")
    fpr, tpr, _ = roc_curve(y_test, y_pred_proba)
    plt.figure(figsize=(8, 6))
    plt.plot(fpr, tpr, label=f"ROC Curve (AUC = {roc_auc_score(y_test, y_pred_proba):.2f})")
    plt.plot([0, 1], [0, 1], "k--")
    plt.xlabel("False Positive Rate")
    plt.ylabel("True Positive Rate")
    plt.title("ROC Curve")
    plt.legend()
    plt.savefig(file_path)
    plt.close()

def save_model(model, file_path: str):
    """
    Save the trained model to a file.
    
    Args:
        model: Trained model.
        file_path (str): Path to save the model.
    """
    logging.info(f"Saving model to {file_path}")
    joblib.dump(model, file_path)

def load_model(file_path: str):
    """
    Load a trained model from a file.
    
    Args:
        file_path (str): Path to the saved model.
    
    Returns:
        model: Loaded model.
    """
    logging.info(f"Loading model from {file_path}")
    return joblib.load(file_path)