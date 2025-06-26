#!/bin/bash

# Initial player money
money=200

# Roulette wheel numbers
# Red: 1, 3, 5, 7, 9, 12, 14, 16, 18, 19, 21, 23, 25, 27, 30, 32, 34, 36
# Black: 2, 4, 6, 8, 10, 11, 13, 15, 17, 20, 22, 24, 26, 28, 29, 31, 33, 35
# Green: 0
red_numbers=(1 3 5 7 9 12 14 16 18 19 21 23 25 27 30 32 34 36)

# --- Functions ---

# Function to check if a value is in an array
contains_element() {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

# Function to display the main interface
display_board() {
    clear
    echo "================================="
    echo "    🔴 ⚫ Welcome to Roulette ⚫ 🔴"
    echo "================================="
    echo
    echo "         Player's Money: \$${money}"
    echo
    echo "================================="
}

# Function for the spinning animation
spin_animation() {
    local spins=15
    local last_num=-1
    echo "Spinning the wheel..."
    for i in $(seq 1 $spins); do
        num=$((RANDOM % 37)) # Numbers 0-36
        # Simple color representation for animation
        if [[ $num -eq 0 ]]; then
            color_char="🟢"
        elif contains_element "$num" "${red_numbers[@]}"; then
            color_char="🔴"
        else
            color_char="⚫"
        fi
        echo -ne " ${num} ${color_char}\r"
        sleep 0.15
    done
    echo "" # New line after animation
}

# --- Main Game Loop ---

while true; do
    display_board
    
    # Check if player has money
    if (( money == 0 )); then
        echo "You've run out of money! Thanks for playing."
        break
    fi

    # Get the player's bet amount
    while true; do
        read -p "Enter your bet amount (or 'quit'): " bet
        if [[ "$bet" == "quit" ]]; then
            echo "You are leaving with \$${money}. Goodbye!"
            exit 0
        fi
        # Check if input is a positive integer
        if [[ "$bet" =~ ^[1-9][0-9]*$ && $bet -le $money ]]; then
            break
        else
            echo "Invalid bet. Please enter a number up to \$${money}."
        fi
    done

    # Get the player's color choice
    while true; do
        read -p "Bet on (r)ed or (b)lack? " choice
        case "$choice" in
            [rR] | [rR][eE][dD] ) player_color="red"; break;;
            [bB] | [bB][lL][aA][cC][kK] ) player_color="black"; break;;
            * ) echo "Invalid choice. Please enter 'r' or 'b'.";;
        esac
    done

    # Subtract bet from money
    money=$((money - bet))
    display_board
    echo "You bet \$${bet} on ${player_color}."
    echo ""

    # Spin the wheel
    spin_animation
    winning_number=$((RANDOM % 37)) # Generate the final number

    # Determine winning color
    if [[ $winning_number -eq 0 ]]; then
        winning_color="green"
        color_symbol="🟢"
    elif contains_element "$winning_number" "${red_numbers[@]}"; then
        winning_color="red"
        color_symbol="🔴"
    else
        winning_color="black"
        color_symbol="⚫"
    fi
    
    echo "The ball landed on: ${winning_number} ${color_symbol}"

    # Determine win or loss
    if [[ "$winning_color" == "$player_color" ]]; then
        payout=$((bet * 2))
        money=$((money + payout))
        echo "🎉🎉 You win! You get \$${payout}. 🎉🎉"
    else
        echo "Sorry, you lost your bet of \$${bet}."
    fi
    
    read -n 1 -s -r -p "Press any key to play again."
done