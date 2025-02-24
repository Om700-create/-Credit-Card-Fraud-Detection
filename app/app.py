from flask import Flask, request, jsonify, render_template
import pandas as pd
from scripts.config import MODEL_PATH
from scripts.utils import load_model

# Initialize Flask app
app = Flask(__name__)

# Load the trained model
model = load_model(MODEL_PATH)

@app.route("/")
def home():
    """
    Render the home page with a form for inputting transaction data.
    """
    return render_template("index.html")

@app.route("/predict", methods=["POST"])
def predict():
    """
    API endpoint for making predictions.
    """
    try:
        # Get transaction data from the request
        data = request.get_json()

        # Log the incoming data
        print("Incoming Data:", data)

        # Convert data into a DataFrame
        transaction_df = pd.DataFrame([data])

        # Make prediction
        prediction = model.predict(transaction_df)[0]
        prediction_proba = model.predict_proba(transaction_df)[0][1]

        # Log the prediction result
        print("Prediction:", prediction)
        print("Probability:", prediction_proba)

        # Return prediction as JSON response
        return jsonify({
            "prediction": int(prediction),
            "probability": float(prediction_proba),
        })
    except Exception as e:
        # Log any errors
        print("Error:", str(e))
        return jsonify({"error": str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True)
