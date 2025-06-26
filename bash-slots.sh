#!/bin/bash

# Initial player money
money=100

# Slot machine symbols
symbols=("🍒" "🍊" "🍋" "🔔" "⭐" "💎")

# Function to display the slot machine interface
function display_slots() {
    clear
    echo "==============================="
    echo "  💎 Welcome to Bash Slots! 💎 "
    echo "==============================="
    echo
    echo "       [ ${reels[0]} ] [ ${reels[1]} ] [ ${reels[2]} ]"
    echo
    echo "==============================="
    echo "  Player's Money: \$${money}"
    echo
}

# Function for the spinning animation
function spin_animation() {
    local spins=10
    for i in $(seq 1 $spins); do
        reels[0]=${symbols[$((RANDOM % 6))]}
        reels[1]=${symbols[$((RANDOM % 6))]}
        reels[2]=${symbols[$((RANDOM % 6))]}
        display_slots
        sleep 0.1
    done
}

# Main game loop
while true; do
    reels=("-" "-" "-")
    display_slots
    read -p "Press Enter to bet \$10 (or type 'quit' to exit): " input

    if [[ "$input" == "quit" ]]; then
        echo "Thanks for playing! You are leaving with \$${money}."
        break
    fi

    if (( money < 10 )); then
        echo "You don't have enough money to bet. Game Over!"
        break
    fi

    money=$((money - 10))
    spin_animation

    # Determine winning combinations
    if [[ "${reels[0]}" == "${reels[1]}" && "${reels[1]}" == "${reels[2]}" ]]; then
        echo "🎉🎉🎉 JACKPOT! You won \$100! 🎉🎉🎉"
        money=$((money + 100))
    elif [[ "${reels[0]}" == "${reels[1]}" || "${reels[1]}" == "${reels[2]}" ]]; then
        echo "🎊 You got two in a row! You won \$20! 🎊"
        money=$((money + 20))
    else
        echo "Sorry, you lost. Better luck next time!"
    fi

    read -p "Press Enter to play again."
done