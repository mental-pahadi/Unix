#!/bin/bash

# ==========================================
#     SIMPLE VOTING SYSTEM 
# ==========================================

# File to store all data
VOTE_FILE="voting_data.txt"

# Initialize file if it doesn't exist
touch "$VOTE_FILE"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Count votes
count_votes() {
  naruto=$(grep -c "Naruto" "$VOTE_FILE")
  kakashi=$(grep -c "Kakashi" "$VOTE_FILE")
  itachi=$(grep -c "Itachi" "$VOTE_FILE")
}

# Show main menu
show_menu() {
  echo -e "${CYAN}"
  echo "========================================"
  echo "    -----SIMPLE VOTING SYSTEM------- "
  echo "========================================"
  echo -e "${NC}"
  echo -e "${YELLOW}1) Voting List${NC}"
  echo -e "${YELLOW}2) Show Results${NC}"
  echo -e "${YELLOW}3) Reset Voting${NC}"
  echo -e "${YELLOW}4) Exit${NC}"
  echo -e "${CYAN}========================================${NC}"
}

# Voting logic
voting_list() {
  echo ""
  echo -e "${BLUE}Please enter your username:${NC}"
  read -r username

  # Duplicate check
  if grep -q "^$username :" "$VOTE_FILE"; then
    echo -e "${RED}⚠️  Sorry $username, you have already voted!${NC}"
    return
  fi

  echo ""
  echo -e "${MAGENTA}Choose your Candidate:${NC}"
  echo -e "${YELLOW}1) Naruto${NC}"
  echo -e "${YELLOW}2) Kakashi${NC}"
  echo -e "${YELLOW}3) Itachi${NC}"
  echo ""
  echo -e "${CYAN}Enter your choice (1-3):${NC}"
  read -r choice

  case $choice in
    1) echo "$username : Naruto" >> "$VOTE_FILE"; echo -e "${GREEN} $username voted for Naruto!${NC}" ;;
    2) echo "$username : Kakashi" >> "$VOTE_FILE"; echo -e "${GREEN} $username voted for Kakashi!${NC}" ;;
    3) echo "$username : Itachi" >> "$VOTE_FILE"; echo -e "${GREEN} $username voted for Itachi!${NC}" ;;
    *) echo -e "${RED}❌ Invalid choice! Please try again.${NC}" ;;
  esac
}

# Show voting results
show_results() {
  count_votes
  echo ""
  echo -e "${CYAN}========================================${NC}"
  echo -e "${MAGENTA}             🗳️  VOTING RESULTS${NC}"
  echo -e "${CYAN}========================================${NC}"
  echo -e "${YELLOW}Naruto:${NC}  ${GREEN}$naruto votes${NC}"
  echo -e "${YELLOW}Kakashi:${NC} ${GREEN}$kakashi votes${NC}"
  echo -e "${YELLOW}Itachi:${NC}  ${GREEN}$itachi votes${NC}"
  echo -e "${CYAN}----------------------------------------${NC}"
  total=$((naruto + kakashi + itachi))
  echo -e "${BLUE}Total votes cast: ${YELLOW}$total${NC}"
  echo -e "${CYAN}----------------------------------------${NC}"

  # Determine winner
  if (( naruto > kakashi && naruto > itachi )); then
    echo -e "${GREEN}🏆 Winner: Naruto with $naruto votes!${NC}"
  elif (( kakashi > naruto && kakashi > itachi )); then
    echo -e "${GREEN}🏆 Winner: Kakashi with $kakashi votes!${NC}"
  elif (( itachi > naruto && itachi > kakashi )); then
    echo -e "${GREEN}🏆 Winner: Itachi with $itachi votes!${NC}"
  else
    echo -e "${YELLOW}🤝 It's a tie!${NC}"
  fi
}

# Reset votes
reset_voting() {
  echo -e "${RED}Are you sure you want to reset all votes? (y/n):${NC}"
  read -r confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    > "$VOTE_FILE"
    echo -e "${GREEN}All votes and user data have been reset.${NC}"
  else
    echo -e "${YELLOW} Reset cancelled.${NC}"
  fi
}

# Main loop
while true; do
  show_menu
  echo ""
  echo -e "${CYAN}Enter your choice (1-4):${NC}"
  read -r option

  case $option in
    1) voting_list ;;
    2) show_results ;;
    3) reset_voting ;;
    4) echo -e "${GREEN}Thank you for using the Voting System!${NC}"; break ;;
    *) echo -e "${RED}Invalid option! Please choose 1-4.${NC}" ;;
  esac

  echo ""
  echo -e "${YELLOW}Press Enter to continue...${NC}"
  read -r
  clear
done
