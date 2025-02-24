import pandas as pd
from imblearn.over_sampling import SMOTE
from scripts.config import RAW_DATA_PATH, PROCESSED_DATA_PATH, TARGET_COLUMN, RANDOM_STATE
from scripts.utils import load_data, save_data

def preprocess_data(df):
    """
    Preprocess the dataset:
    - Separate features and target.
    - Apply SMOTE to handle class imbalance.
    - Return balanced features and target.
    """
    X = df.drop(columns=[TARGET_COLUMN])
    y = df[TARGET_COLUMN]

    # Apply SMOTE to balance the dataset
    smote = SMOTE(random_state=RANDOM_STATE)
    X_res, y_res = smote.fit_resample(X, y)

    return X_res, y_res

def create_time_based_features(df):
    """
    Create time-based features:
    - Extract hour of the day.
    - Create a binary feature indicating whether the transaction occurred during the day or night.
    """
    df["Hour"] = df["Time"] % (24 * 3600) // 3600  # Extract hour of the day
    df["Is_Night"] = df["Hour"].apply(lambda x: 1 if x < 6 or x >= 18 else 0)  # Day/Night indicator
    return df

def create_interaction_features(df):
    """
    Create interaction features between highly correlated features.
    """
    df["V11_V4"] = df["V11"] * df["V4"]
    df["V17_V14"] = df["V17"] * df["V14"]
    return df

def create_aggregated_features(df):
    """
    Create aggregated features (e.g., mean, standard deviation) for groups of related features.
    """
    df["V_mean"] = df[["V1", "V2", "V3", "V4", "V5", "V6", "V7", "V8", "V9", "V10"]].mean(axis=1)
    df["V_std"] = df[["V1", "V2", "V3", "V4", "V5", "V6", "V7", "V8", "V9", "V10"]].std(axis=1)
    return df

def run_data_pipeline():
    """
    Run the data pipeline:
    - Load the raw dataset.
    - Preprocess the data.
    - Save the processed dataset.
    """
    # Load the raw dataset
    df = load_data(RAW_DATA_PATH)

    # Create time-based, interaction, and aggregated features
    df = create_time_based_features(df)
    df = create_interaction_features(df)
    df = create_aggregated_features(df)

    # Preprocess the data (handle class imbalance)
    X_res, y_res = preprocess_data(df)

    # Combine features and target into a single DataFrame
    processed_df = pd.DataFrame(X_res, columns=df.drop(columns=[TARGET_COLUMN]).columns)
    processed_df[TARGET_COLUMN] = y_res

    # Save the processed dataset
    save_data(processed_df, PROCESSED_DATA_PATH)

    print("Data pipeline completed. Processed dataset saved.")

if __name__ == "__main__":
    run_data_pipeline()