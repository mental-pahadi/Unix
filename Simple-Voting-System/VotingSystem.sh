#!/bin/bash

# ==========================================
#     ---  SIMPLE VOTING SYSTEM  ---
# ==========================================
# Description : A simple Bash-based voting program that allows
#               users to vote for their favorite candidate,
#               prevents duplicate votes, shows live results,
#               and lets the admin reset or manage votes securely.
#
# Creator       : ☠️PAHADI☠️
# Creation Year : 2025
# ==========================================

VOTE_FILE="voting_data.txt"
touch "$VOTE_FILE"

# ===== Admin Password =====
ADMIN_PASS="pahadi01"

# ===== Colors =====
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# ===== Count votes =====
count_votes() {
  rohan=$(grep -c "Rohan" "$VOTE_FILE")
  mohan=$(grep -c "Mohan" "$VOTE_FILE")
  sohan=$(grep -c "Sohan" "$VOTE_FILE")
}

# ===== Admin login =====
admin_login() {
  echo -e "${BLUE}Enter admin password:${NC}"
  read -s password
  if [[ $password != "$ADMIN_PASS" ]]; then
    echo -e "${RED}❌ Incorrect password!${NC}"
    return 1
  fi
  return 0
}

# ===== Menu =====
show_menu() {
  echo -e "${CYAN}"
  echo "========================================"
  echo "    ---  SIMPLE VOTING SYSTEM  ---"
  echo " Description : A simple Bash-based voting program that allows
               users to vote for their favorite candidate,
               prevents duplicate votes, shows live results,
               and lets the admin reset or manage votes easily.

  Creator       : ☠️PAHADI☠️
  Creation Year : 2025"
  echo "========================================"
  echo -e "${NC}"
  echo -e "${YELLOW}1) Voting List${NC}"
  echo -e "${YELLOW}2) Show Results${NC}"
  echo -e "${YELLOW}3) Reset Voting (Admin)${NC}"
  echo -e "${YELLOW}4) View Voters (Admin)${NC}"
  echo -e "${YELLOW}5) Export Results (Admin)${NC}"
  echo -e "${YELLOW}6) Delete a Voter (Admin)${NC}"
  echo -e "${YELLOW}7) Exit${NC}"
  echo -e "${CYAN}========================================${NC}"
}

# ===== Voting logic =====
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
  echo -e "${YELLOW}1) Rohan${NC}"
  echo -e "${YELLOW}2) Mohan${NC}"
  echo -e "${YELLOW}3) Sohan${NC}"
  echo ""
  echo -e "${CYAN}Enter your choice (1-3):${NC}"
  read -r choice

  case $choice in
    1) echo "$username : Rohan" >> "$VOTE_FILE"; echo -e "${GREEN} $username voted for Rohan!${NC}" ;;
    2) echo "$username : Mohan" >> "$VOTE_FILE"; echo -e "${GREEN} $username voted for Mohan!${NC}" ;;
    3) echo "$username : Sohan" >> "$VOTE_FILE"; echo -e "${GREEN} $username voted for Sohan!${NC}" ;;
    *) echo -e "${RED}❌ Invalid choice! Please try again.${NC}" ;;
  esac
}

# ===== Show results =====
show_results() {
  count_votes
  echo ""
  echo -e "${CYAN}========================================${NC}"
  echo -e "${MAGENTA}             🗳️  VOTING RESULTS${NC}"
  echo -e "${CYAN}========================================${NC}"
  echo -e "${YELLOW}Rohan:${NC}  ${GREEN}$rohan votes${NC}"
  echo -e "${YELLOW}Mohan:${NC}  ${GREEN}$mohan votes${NC}"
  echo -e "${YELLOW}Sohan:${NC}  ${GREEN}$sohan votes${NC}"
  echo -e "${CYAN}----------------------------------------${NC}"
  total=$((rohan + mohan + sohan))
  echo -e "${BLUE}Total votes cast: ${YELLOW}$total${NC}"
  echo -e "${CYAN}----------------------------------------${NC}"

  if (( rohan > mohan && rohan > sohan )); then
    echo -e "${GREEN}🏆 Winner: Rohan with $rohan votes!${NC}"
  elif (( mohan > rohan && mohan > sohan )); then
    echo -e "${GREEN}🏆 Winner: Mohan with $mohan votes!${NC}"
  elif (( sohan > rohan && sohan > mohan )); then
    echo -e "${GREEN}🏆 Winner: Sohan with $sohan votes!${NC}"
  else
    echo -e "${YELLOW}🤝 It's a tie!${NC}"
  fi
}

# ===== Reset votes =====
reset_voting() {
  admin_login || return
  echo -e "${RED}Are you sure you want to reset all votes? (y/n):${NC}"
  read -r confirm
  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    > "$VOTE_FILE"
    echo -e "${GREEN}All votes and user data have been reset.${NC}"
  else
    echo -e "${YELLOW} Reset cancelled.${NC}"
  fi
}

# ===== View all voters =====
view_voters() {
  admin_login || return
  echo -e "${CYAN}--- VOTER LIST ---${NC}"
  if [[ ! -s "$VOTE_FILE" ]]; then
    echo -e "${RED}No votes have been cast yet.${NC}"
  else
    cat "$VOTE_FILE"
  fi
}

# ===== Export results =====
export_results() {
  admin_login || return
  count_votes
  total=$((rohan + mohan + sohan))
  {
    echo "------ VOTING RESULTS ------"
    echo "Rohan:  $rohan votes"
    echo "Mohan:  $mohan votes"
    echo "Sohan:  $sohan votes"
    echo "Total Votes: $total"
    echo "Generated on: $(date)"
  } > results_summary.txt
  echo -e "${GREEN}Results exported successfully to results_summary.txt${NC}"
}

# ===== Delete specific voter =====
delete_voter() {
  admin_login || return
  echo -e "${BLUE}Enter username to delete:${NC}"
  read -r user
  if grep -q "^$user :" "$VOTE_FILE"; then
    sed -i "/^$user :/d" "$VOTE_FILE"
    echo -e "${GREEN}Deleted vote for $user.${NC}"
  else
    echo -e "${RED}No record found for $user.${NC}"
  fi
}

# ===== Main loop =====
while true; do
  show_menu
  echo ""
  echo -e "${CYAN}Enter your choice (1-7):${NC}"
  read -r option

  case $option in
    1) voting_list ;;
    2) show_results ;;
    3) reset_voting ;;
    4) view_voters ;;
    5) export_results ;;
    6) delete_voter ;;
    7) echo -e "${GREEN}Thank you for using the Voting System!${NC}"; break ;;
    *) echo -e "${RED}Invalid option! Please choose 1-7.${NC}" ;;
  esac

  echo ""
  echo -e "${YELLOW}Press Enter to continue...${NC}"
  read -r
  clear
done
