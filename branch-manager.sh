#!/bin/bash
MEMBERS_FILE="../members.json"
GIT_CONFIG_FILE="../.git/config"

function usage {
    echo "Git onboarding script (Project-specific)"
    echo "Usage: bash onboard.sh [command]"
    echo ""
    echo "Commands:"
    echo "  -s   Register a unique nickname for this project"
    echo "  -d   Remove nickname configuration from this project"
    echo ""
    exit 1
}

if [ -z "$1" ]; then
    usage
fi

# Function to attempt git pull and push on main/master
function git_sync {
    BRANCHES=("main" "master")

    for BRANCH in "${BRANCHES[@]}"; do
        echo "Trying to sync with $BRANCH branch..."
        if git pull --rebase origin "$BRANCH" && git push origin "$BRANCH"; then
            echo "Successfully synced with $BRANCH."
            return 0
        fi
    done

    echo "Error: Failed to sync with both main and master branches. Resolve conflicts manually."
    exit 1
}

# Ensure members.json exists
function ensure_members_file {
    if [ ! -f "$MEMBERS_FILE" ]; then
        echo "{}" > "$MEMBERS_FILE"
        echo "Created new $MEMBERS_FILE file."
    fi
}

# Register nickname for this project
if [ "$1" == "-s" ]; then
    echo "Starting Git configuration for this project..."

    # Ensure members.json exists
    ensure_members_file

    # Pull latest changes before modifying the file
    git_sync

    # Prompt for nickname
    read -p "Enter your Git nickname (this will be used as a branch prefix): " GIT_NICKNAME

    # Check if the nickname already exists
    if jq -e --arg nick "$GIT_NICKNAME" '.[$nick] != null' "$MEMBERS_FILE" >/dev/null; then
        echo "Error: The nickname '$GIT_NICKNAME' is already taken. Please choose a different one."
        exit 1
    fi

    # Prompt for full name
    read -p "Enter your full name: " FULL_NAME

    # Add the new nickname to members.json safely
    jq --arg nick "$GIT_NICKNAME" --arg name "$FULL_NAME" '. + {($nick): $name}' "$MEMBERS_FILE" > tmp.json && mv tmp.json "$MEMBERS_FILE"

    echo "Added '$GIT_NICKNAME' to $MEMBERS_FILE."

    # Commit and push changes safely
    git add "$MEMBERS_FILE"
    git commit -m "Register nickname: $GIT_NICKNAME"
    git_sync

    exit 0
fi

# Unregister nickname from this project
if [ "$1" == "-d" ]; then
    echo "Removing Git configuration for this project..."

    # Ensure members.json exists
    ensure_members_file

    # Pull latest changes before modifying the file
    git_sync

    # Get current nickname from Git configuration
    CURRENT_NICKNAME=$(git config --file "$GIT_CONFIG_FILE" --get branch.username)

    if [ -n "$CURRENT_NICKNAME" ]; then
        # Remove nickname from members.json safely
        jq "del(.\"$CURRENT_NICKNAME\")" "$MEMBERS_FILE" > tmp.json && mv tmp.json "$MEMBERS_FILE"
        echo "Removed '$CURRENT_NICKNAME' from $MEMBERS_FILE."
    fi

    # Commit and push changes safely
    git add "$MEMBERS_FILE"
    git commit -m "Unregister nickname: $CURRENT_NICKNAME"
    git_sync

    exit 0
fi

echo "Invalid command."
usage
