from flask import Flask, jsonify
import os

app = Flask(__name__)

# Endpoint di base per verificare lo stato di salute dell'app
@app.route('/api/health')
def health_check():
    return jsonify({
        "status": "healthy",
        "message": "Sistema gestionale operativo",
        "environment": os.environ.get("ENVIRONMENT", "Agnostic-Local")
    }), 200

if __name__ == '__main__':
    # Usiamo la porta 8080 come standard per i container non-root
    app.run(host='0.0.0.0', port=8080)