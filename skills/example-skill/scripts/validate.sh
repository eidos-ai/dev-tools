#!/bin/bash

echo "🔍 Running validation checks..."

if [ -f "../assets/config.json" ]; then
    echo "✅ Configuration file found"
else
    echo "❌ Configuration file missing"
    exit 1
fi

if [ -f "../references/REFERENCE.md" ]; then
    echo "✅ Reference documentation found"
else
    echo "⚠️  Reference documentation missing"
fi

echo "✅ Validation complete!"
