#!/bin/bash

set -e

echo "🦞 OpenClaw Bot - Starting..."

# Create config directory
mkdir -p ~/.openclaw

# Generate random gateway token
GATEWAY_TOKEN=$(openssl rand -hex 32)
echo "🔑 Generated gateway token: $GATEWAY_TOKEN"

# Generate openclaw.json with MiniMax Portal (API Key auth)
cat > ~/.openclaw/openclaw.json << EOF
{
  "messages": {
    "ackReactionScope": "group-mentions"
  },
  "agents": {
    "defaults": {
      "maxConcurrent": 4,
      "subagents": {
        "maxConcurrent": 8
      },
      "compaction": {
        "mode": "safeguard"
      },
      "workspace": "/root/.openclaw/workspace",
      "models": {
        "minimax/MiniMax-M2.1": {
          "alias": "minimax-m2.1"
        },
        "minimax/MiniMax-M2.1-lightning": {
          "alias": "minimax-m2.1-lightning"
        }
      },
      "model": {
        "primary": "minimax/MiniMax-M2.1"
      }
    }
  },
  "gateway": {
    "mode": "local",
    "auth": {
      "mode": "token",
      "token": "$GATEWAY_TOKEN"
    },
    "port": 18789,
    "bind": "lan",
    "tailscale": {
      "mode": "off",
      "resetOnExit": false
    }
  },
  "plugins": {
    "entries": {
      "telegram": {
        "enabled": true
      }
    }
  },
  "models": {
    "providers": {
      "minimax-portal": {
        "baseUrl": "https://api.minimax.io/anthropic",
        "apiKey": "${MINIMAX_API_KEY}",
        "api": "anthropic-messages",
        "models": [
          {
            "id": "MiniMax-M2.1",
            "name": "MiniMax M2.1",
            "reasoning": false,
            "input": [
              "text"
            ],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 200000,
            "maxTokens": 8192
          },
          {
            "id": "MiniMax-M2.1-lightning",
            "name": "MiniMax M2.1 Lightning",
            "reasoning": false,
            "input": [
              "text"
            ],
            "cost": {
              "input": 0,
              "output": 0,
              "cacheRead": 0,
              "cacheWrite": 0
            },
            "contextWindow": 200000,
            "maxTokens": 8192
          }
        ]
      }
    }
  },
  "channels": {
    "telegram": {
      "enabled": true,
      "botToken": "${TELEGRAM_BOT_TOKEN}"
    }
  },
  "skills": {
    "install": {
      "nodeManager": "npm"
    }
  }
}
EOF

echo "✅ Configuration generated"
echo "🚀 Starting OpenClaw Gateway..."

# Run the original command
exec "$@"
