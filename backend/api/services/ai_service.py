import json
import logging
import re
from typing import Dict

import requests

OLLAMA_URL = "http://127.0.0.1:11434/api/generate"
MODEL_NAME = "mistral"

logger = logging.getLogger(__name__)


def analyze_text(text: str) -> Dict:
    """Send extracted text to Ollama Mistral and return a dict matching the
    exact schema:

    {
      "summary": "string",
      "short_notes": ["string", "..."],
      "questions": ["string", "..."],
      "answers": ["string", "..."]
    }

    This function forces the model to return ONLY valid JSON, logs the raw
    response for debugging, and raises a visible error if parsing fails.
    """
    if not text or not text.strip():
        raise ValueError("No text to analyze. Ensure extracted text is provided.")

    # Strong prompt that forces JSON-only output with exact schema, no markdown
    # or extra text. Use deterministic sampling.
    prompt = (
        "You are an academic assistant.\n"
        "Analyze the following text and respond ONLY with valid JSON that exactly "
        "matches this schema (no markdown, no explanation, no extra text):\n\n"
        "{\n"
        "  \"summary\": \"string\",\n"
        "  \"short_notes\": [\"string\", \"...\"],\n"
        "  \"questions\": [\"string\", \"...\"],\n"
        "  \"answers\": [\"string\", \"...\"]\n"
        "}\n\n"
        "If you cannot produce content, return empty string/arrays for the fields.\n\n"
        "TEXT:\n"
        f"{text}\n"
    )

    try:
        response = requests.post(
            OLLAMA_URL,
            json={
                "model": MODEL_NAME,
                "prompt": prompt,
                "max_tokens": 1024,
                "temperature": 0.0,
            },
            timeout=60,
        )
        response.raise_for_status()

        # Prefer to inspect response.json() to see structured fields returned
        # by Ollama, but always keep the raw text for logging and parsing.
        raw_response_text = None
        try:
            resp_json = response.json()
            # Ollama may return a list or a dict. Try to extract the completion
            if isinstance(resp_json, list) and resp_json:
                # first item may contain 'completion' or 'text'
                raw_response_text = (
                    resp_json[0].get("completion")
                    or resp_json[0].get("text")
                    or json.dumps(resp_json)
                )
            elif isinstance(resp_json, dict):
                raw_response_text = (
                    resp_json.get("completion")
                    or resp_json.get("text")
                    or resp_json.get("content")
                    or json.dumps(resp_json)
                )
            else:
                raw_response_text = json.dumps(resp_json)
        except ValueError:
            # Not JSON; fall back to plain text
            raw_response_text = response.text

        logger.debug("Raw Ollama response: %s", raw_response_text)

        # Attempt direct JSON parse
        try:
            parsed = json.loads(raw_response_text)
            return parsed
        except Exception as e:
            # Try to extract a JSON substring if the model added stray text
            try:
                start = raw_response_text.find("{")
                end = raw_response_text.rfind("}")
                if start != -1 and end != -1 and end > start:
                    candidate = raw_response_text[start : end + 1]
                    parsed = json.loads(candidate)
                    logger.warning("Parsed JSON from substring of model output.")
                    return parsed
            except Exception:
                # Fallthrough to logging the original error
                pass

            # Surface the error clearly instead of silently swallowing it
            logger.error(
                "Failed to parse JSON from Ollama response: %s\nRaw response: %s",
                str(e),
                raw_response_text,
            )
            raise ValueError(
                "Failed to parse JSON from Ollama response. See logs for raw output."
            )

    except Exception:
        logger.exception("Error while communicating with Ollama model")
        # Re-raise so the failure is visible to calling code / API layer
        raise



def analyze_text_with_ollama(text: str) -> dict:
    prompt = f"""
You are an academic assistant.

Analyze the text below and return ONLY valid JSON.
No markdown. No explanations.

Schema:
{{
  "summary": "string",
  "short_notes": ["string"],
  "questions": ["string"],
  "answers": ["string"]
}}

Text:
\"\"\"{text}\"\"\"
"""

    response = requests.post(
        OLLAMA_URL,
        json={
            "model": MODEL_NAME,
            "prompt": prompt,
            "stream": False
        },
        timeout=120
    )

    raw_output = response.json().get("response", "").strip()

    # DEBUG (keep during development)
    print("OLLAMA RAW OUTPUT:\n", raw_output)

    return json.loads(raw_output)
