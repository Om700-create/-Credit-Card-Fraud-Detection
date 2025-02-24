import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from scripts.config import PROCESSED_DATA_PATH, MODEL_PATH, TARGET_COLUMN, TEST_SIZE, RANDOM_STATE, MODEL_HYPERPARAMETERS
from scripts.utils import load_data, save_model

def train_model():
    """
    Train a Random Forest model:
    - Load the processed dataset.
    - Split into training and testing sets.
    - Train the model.
    - Save the trained model.
    """
    # Load the processed dataset
    df = load_data(PROCESSED_DATA_PATH)

    # Separate features and target
    X = df.drop(columns=[TARGET_COLUMN])
    y = df[TARGET_COLUMN]

    # Split into training and testing sets
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=TEST_SIZE, random_state=RANDOM_STATE)

    # Train a Random Forest model
    model = RandomForestClassifier(**MODEL_HYPERPARAMETERS)
    model.fit(X_train, y_train)

    # Save the trained model
    save_model(model, MODEL_PATH)

    print("Model training completed. Model saved.")

if __name__ == "__main__":
    train_model()