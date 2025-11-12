#!/bin/bash
# matrix.sh



cols=$(tput cols)
lines=$(tput lines)
tput civis  # hide cursor

# Clean up on exit
cleanup() {
  tput reset
  tput cnorm
  exit
}
trap cleanup SIGINT EXIT

# Initialize column positions
for ((i=0; i<cols; i++)); do
  column[$i]=0
done

start_time=$(date +%s)
duration=8

# Main loop
while :; do
  elapsed=$(( $(date +%s) - start_time ))
  
  # Fade-out factor (starts after duration)
  if (( elapsed >= duration )); then
    fade=1
  else
    fade=0
  fi

  for ((i=0; i<cols; i++)); do
    if (( RANDOM % 5 == 0 )) && (( fade == 0 )); then
      tput cup ${column[i]} $i
      printf "\033[32m%s\033[0m" "$(printf '%c' $((RANDOM % 93 + 33)))"
      ((column[i]++))
      (( column[i] >= lines )) && column[i]=0
    elif (( fade == 1 )) && (( column[i] > 0 )); then
      # fade out character by replacing with a space
      ((column[i]--))
      tput cup ${column[i]} $i
      printf " "
    fi
  done

  # Stop once all columns have fully faded
  if (( fade == 1 )); then
    all_zero=1
    for ((i=0; i<cols; i++)); do
      (( column[i] != 0 )) && all_zero=0
    done
    (( all_zero == 1 )) && break
  fi

  sleep 0.02
done

cleanup
