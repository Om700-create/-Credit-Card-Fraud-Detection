import pandas as pd
from scripts.config import MODEL_PATH, PROCESSED_DATA_PATH, PREDICTIONS_PATH
from scripts.utils import load_model, load_data, save_data

def make_predictions():
    """
    Make predictions using the trained model:
    - Load the trained model.
    - Load new data for prediction.
    - Make predictions.
    - Save the predictions.
    """
    # Load the trained model
    model = load_model(MODEL_PATH)

    # Load new data for prediction
    new_data = load_data(PROCESSED_DATA_PATH)  # Replace with the path to new data if available

    # Drop the target column (if present) to match the features used during training
    if "Class" in new_data.columns:
        new_data = new_data.drop(columns=["Class"])

    # Make predictions
    predictions = model.predict(new_data)

    # Save the predictions
    predictions_df = pd.DataFrame(predictions, columns=["Predicted_Class"])
    save_data(predictions_df, PREDICTIONS_PATH)

    print("Predictions completed. Predictions saved.")

if __name__ == "__main__":
    make_predictions()