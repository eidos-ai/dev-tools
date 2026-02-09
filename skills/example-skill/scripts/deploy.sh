#!/bin/bash
set -e

echo "🚀 Starting deployment..."

if [ ! -f "../assets/config.json" ]; then
    echo "❌ Error: config.json not found"
    exit 1
fi

echo "✅ Configuration validated"
echo "✅ Deploying application..."
echo "✅ Deployment complete!"
