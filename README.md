# OpenClaw Bot 🦞🤖

**AI-powered Telegram bot platform - Build ANY type of bot you want!**

- 🔬 Latest research papers & trends
- 📰 Real-time news & updates
- 🤖 Powered by MiniMax M2.1 (via MiniMax Portal API)
- 🐳 One-command Docker deployment
- 🔑 Simple API key authentication
- 🔐 Your data stays private

---

## ⚡ Quick Start

### Prerequisites
- Docker & Docker Compose installed
- Telegram account
- MiniMax Portal API key

### Step 1: Get API Keys

#### MiniMax Portal API
1. Go to https://api.minimax.io/
2. Sign up and get your API key
3. Copy it

Or You can get 7 days free trial if you follow this 
Runtime: Node ≥22.

```bash
npm install -g openclaw@latest
# or: pnpm add -g openclaw@latest

openclaw onboard --install-daemon
```
Follow the instructions and to setup manually OpenClaw and Selecting MiniMax Portal as your model provider using o-auth. And then copy the coding plan api key from OpenClaw and paste it in the .env file.

### Step 2: Create Telegram Bot
1. Open Telegram
2. Find **@BotFather**

### Step 2: Create Telegram Bot
1. Open Telegram
2. Find **@BotFather**
3. Send `/newbot`
4. Follow instructions
5. Copy your bot token

### Step 3: Clone & Deploy

```bash
# Clone repository
git clone https://github.com/rehanali53/openclaw-bot.git
cd openclaw-bot

# Copy environment template
cp .env.example .env

# Edit .env with your credentials
nano .env
# Or: code .env (VS Code)
# Or: notepad .env (Windows)

# Start the bot (one command!)
docker-compose up
```

That's it! Your bot is running. 🚀

### Step 4: Use Your Bot

#### First Time Pairing (Important!)
When you connect to your bot for the first time, you need to approve the pairing:

1. **Start the bot** (if not already running):
   ```bash
   docker-compose up -d
   ```

2. **Find your bot on Telegram** (username from @BotFather)

3. **Send `/start`** - You'll receive a **pairing code** like:
   ```
   Pairing code: abc123xyz
   ```

4. **Approve the pairing** by running this command:
   ```bash
   docker exec openclaw-bot pnpm openclaw pairing approve telegram abc123xyz
   ```
   Replace `abc123xyz` with your actual pairing code.

5. **You're connected!** Now you can use the bot:
   - "What's the latest in AI research?"
   - "Tell me about recent breakthroughs in quantum computing"
   - "What are trending topics in machine learning?"

#### Using the Bot
Once paired, you can ask anything about latest research:

---

## 📋 Available Commands

In Telegram:

```text
/start - Start the bot
/research [topic] - Get latest research papers
/news [topic] - Get latest news
/trends - Show trending topics
/explain [topic] - Explain technical concept
/help - Show all commands
```

Examples:

```text
/research machine learning
/news bitcoin
/trends AI 2026
/explain neural networks
```

---

## 🔧 Configuration

### .env File Options

```text
# Required
TELEGRAM_BOT_TOKEN=your_bot_token
MINIMAX_API_KEY=your_api_key

# To make it really rearch bot you need to add firecrawl 
# Firecrawl Web Scraping
FIRECRAWL_API_KEY=your_firecrawl_key  # Get from https://firecrawl.dev

# Optional - Bot Behavior
NEWS_FETCH_INTERVAL=6          # Hours
RESEARCH_RESULTS_COUNT=5       # Number of papers to fetch
THINKING_LEVEL=high            # off, minimal, low, medium, high
```

---

## 🔐 Gateway Authentication Token

### How It Works
- The gateway auth token is **auto-generated** by OpenClaw on first startup
- Stored in `/root/.openclaw/openclaw.json` inside the container
- **Persisted** using Docker named volumes across container restarts
- No need to manually configure it

### Getting Your Token
Once the bot is running, retrieve the auto-generated token:

**Method 1: Read from config**
```bash
docker exec openclaw-bot cat /root/.openclaw/openclaw.json | grep -A 2 "auth"
```

**Method 2: Check logs**
```bash
docker-compose logs openclaw-bot | grep -i token
```

**Method 3: Copy config file**
```bash
docker cp openclaw-bot:/root/.openclaw/openclaw.json ./openclaw.json
cat ./openclaw.json
```

---

## 💾 Data Persistence

### Docker Volumes
The bot uses named volumes to persist data:

- **openclaw-config**: Stores configuration and auth token
- **openclaw-workspace**: Stores bot workspace and conversation history

### Managing Volumes

**View volumes:**
```bash
docker volume ls
```

**Inspect config volume:**
```bash
docker volume inspect openclaw-research-bot_openclaw-config
```

**Backup data:**
```bash
# Backup config
docker run --rm -v openclaw-research-bot_openclaw-config:/data -v ${PWD}:/backup alpine tar czf /backup/config-backup.tar.gz -C /data .

# Backup workspace
docker run --rm -v openclaw-research-bot_openclaw-workspace:/data -v ${PWD}:/backup alpine tar czf /backup/workspace-backup.tar.gz -C /data .
```

**Restore data:**
```bash
# Restore config
docker run --rm -v openclaw-research-bot_openclaw-config:/data -v ${PWD}:/backup alpine tar xzf /backup/config-backup.tar.gz -C /data
```

**Reset (delete volumes):**
```bash
docker-compose down -v
```

---

## 🚀 Deployment Options

### Local Development
```bash
docker-compose up
```

### Production (Detached)
```bash
docker-compose up -d
```

### View Logs
```bash
docker-compose logs -f
```

### Approve Telegram Pairing
```bash
# When you get a pairing code from Telegram bot, approve it:
docker exec openclaw-bot pnpm openclaw pairing approve telegram <code>

# List all paired connections:
docker exec openclaw-bot pnpm openclaw pairing list
```

---

## 🎨 Customize Your Bot

> **💡 This is YOUR bot - make it whatever you want!**
> 
> I wanted a research bot, so I added the Firecrawl skill to scrape web content and gather latest information. But you can make it **any bot you prefer** by adding the skills you need!
> 
> Deploy it locally or in the cloud, customize it with skills, and you'll have your own personalized smart assistant! 🚀

---

### Adding Firecrawl Skill (Optional but good if you want latest information from the web - Web Scraping)

**Firecrawl** enhances your bot with advanced web scraping, search, and content extraction capabilities.

#### Step 1: Access Container
```bash
docker exec -it openclaw-bot bash
```

#### Step 2: Install Firecrawl Skill
```bash
# Navigate to workspace
cd /root/.openclaw/workspace

# Install the skill
npx skills add https://github.com/firecrawl/cli --skill firecrawl
```

#### Step 3: Install Firecrawl CLI
```bash
# Install globally in container
npm install -g firecrawl-cli

# Verify installation
firecrawl --version
```

#### Step 4: Authenticate (Choose One)

**Option 1 : API Key (Recommended for Docker)**
```bash
# Set environment variable
export FIRECRAWL_API_KEY="your-api-key-here"
```

**Option 2: Browser Login**
```bash
# Opens browser for authentication
firecrawl login --browser

# Verify
firecrawl --status
```

#### Step 5: Exit and Restart
```bash
exit  # Exit container
```

Then in your terminal:
```bash
docker-compose restart
```

**Your bot can now:**
- Scrape any webpage
- Search the web for latest info
- Extract clean markdown from URLs
- Handle JavaScript-heavy sites


### Stop Bot
```bash
docker-compose down
```

---

## 🛠️ Troubleshooting

### Bot doesn't respond
- **Check pairing**: Make sure you approved the pairing code (see Step 4)
- Check `.env` file has correct `TELEGRAM_BOT_TOKEN`
- Check logs: `docker-compose logs -f`

### Can't pair with Telegram
```bash
# Get a new pairing code by restarting the conversation
# In Telegram, send: /start

# Then approve with the new code:
docker exec openclaw-research-bot pnpm openclaw pairing approve telegram <your-code>
```

### List all paired devices
```bash
docker exec openclaw-research-bot pnpm openclaw pairing list
```

### API errors
- Verify `MINIMAX_API_KEY` or `NVIDIA_API_KEY` is valid
- Check API quota/limits
- Try alternative API provider

### Docker build fails
- Ensure Docker is running
- Check internet connection
- For build errors, rebuild with: `docker-compose build --no-cache`

### node-llama-cpp build errors
The Dockerfile uses `node:22-slim` (Debian-based) instead of Alpine to support native compilation. If you see cmake or build-related errors:
```bash
# Clean everything and rebuild
docker-compose down -v
docker system prune -a
docker-compose build --no-cache
docker-compose up -d
```

### Need to reset everything
```bash
# Stop and remove containers + volumes
docker-compose down -v

# Rebuild and restart
docker-compose up --build
```

### Can't access gateway token
- Token is auto-generated on first run
- Persisted in `openclaw-config` volume
- Use methods in "Gateway Authentication Token" section above

---

## 📦 Project Structure

```
openclaw-bot/
├── .env.example           # Configuration template
├── docker-compose.yml     # Docker orchestration
├── Dockerfile             # Container image
├── docker-entrypoint.sh   # Startup script
├── README.md              # This file
```

---

## 🤝 Contributing

Contributions welcome! Feel free to:
- Report bugs
- Suggest features
- Submit pull requests

---

## 📄 License

MIT License - Feel free to use and modify!

---

## 🙏 Acknowledgments

- [OpenClaw](https://github.com/openclaw/openclaw) - The AI framework powering this bot
- [MiniMax](https://platform.minimax.ai/) - AI model provider
- [DailyDoseOfDS](https://www.dailydoseofds.com/)

---

## 💡 Tips

1. **Save costs**: Use MiniMax free tier for testing
2. **Privacy**: All data stays on your server/device
3. **Customization**: Edit `docker-entrypoint.sh` to modify bot behavior
4. **Scaling**: Deploy on VPS, AWS, or cloud platform of choice

---

**Questions?** Open an issue or reach out!

Happy researching! 🦞🔬
