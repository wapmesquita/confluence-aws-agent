import os
import json
import boto3
from slack_bolt import App
from slack_bolt.adapter.flask import SlackRequestHandler
from flask import Flask, request
import requests

# Load secrets from AWS Secrets Manager
region = os.environ.get("AWS_REGION", "us-east-1")
secret_name = os.environ.get("SLACK_SECRET_NAME")

session = boto3.session.Session()
client = session.client(service_name='secretsmanager', region_name=region)

get_secret_value_response = client.get_secret_value(SecretId=secret_name)
secret = json.loads(get_secret_value_response['SecretString'])

SLACK_BOT_TOKEN = secret["slack_bot_token"]
SLACK_SIGNING_SECRET = secret["slack_signing_secret"]
AGENT_API_URL = os.environ.get("AGENT_API_URL", "https://your-agent-api-endpoint")

app = App(token=SLACK_BOT_TOKEN, signing_secret=SLACK_SIGNING_SECRET)
flask_app = Flask(__name__)
handler = SlackRequestHandler(app)

@app.event("app_mention")
def handle_mention(event, say):
    user_text = event['text']
    # Call your agent here with user_text, get response
    response = requests.post(
        AGENT_API_URL,
        json={"input": user_text}
    )
    agent_response = response.json().get("answer", "Sorry, I couldn't get an answer.")
    say(agent_response)

@flask_app.route("/slack/events", methods=["POST"])
def slack_events():
    return handler.handle(request)

if __name__ == "__main__":
    flask_app.run(host="0.0.0.0", port=3000)
