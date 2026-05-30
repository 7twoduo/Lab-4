#!/usr/bin/env bash
set -euo pipefail

DELAY="${DELAY:-0.005}"
GAP="${GAP:-6}"
FORCE_SIDE_BY_SIDE="${FORCE_SIDE_BY_SIDE:-0}"
FORCE_SEQUENTIAL="${FORCE_SEQUENTIAL:-0}"

ART_DIR="./art"

files=()
[[ -f "$ART_DIR/gojo1.txt" ]] && files+=("$ART_DIR/gojo1.txt")
[[ -f "$ART_DIR/gojo2.txt" ]] && files+=("$ART_DIR/gojo2.txt")
[[ -f "$ART_DIR/gojo3.txt" ]] && files+=("$ART_DIR/gojo3.txt")

if [[ ${#files[@]} -eq 0 ]]; then
  echo "[ERROR] No art files found in ./art"
  exit 1
fi

gap_text="$(printf "%${GAP}s" "")"

terminal_width="${COLUMNS:-120}"
if command -v tput >/dev/null 2>&1; then
  terminal_width="$(tput cols 2>/dev/null || echo "$terminal_width")"
fi

max_width() {
  awk '{ if (length($0) > max) max = length($0) } END { print max + 0 }' "$1"
}

total_width=0
for f in "${files[@]}"; do
  w="$(max_width "$f")"
  total_width=$((total_width + w + GAP))
done

print_slow_file() {
  local file="$1"
  while IFS= read -r line || [[ -n "$line" ]]; do
    printf '%s\n' "$line"
    sleep "$DELAY"
  done < "$file"
}

print_stage() {
  local msg="$1"
  printf '\n'
  printf '====================================================================\n'
  printf '   %s\n' "$msg"
  printf '====================================================================\n\n'
  sleep 0.4
}

print_side_by_side() {
  local tmpdir
  tmpdir="$(mktemp -d)"

  local normalized=()
  local max_lines=0

  for f in "${files[@]}"; do
    lines="$(wc -l < "$f" | tr -d ' ')"
    [[ "$lines" -gt "$max_lines" ]] && max_lines="$lines"
  done

  local i=0
  for f in "${files[@]}"; do
    out="$tmpdir/art_$i.txt"
    cp "$f" "$out"

    current_lines="$(wc -l < "$out" | tr -d ' ')"
    while [[ "$current_lines" -lt "$max_lines" ]]; do
      printf '\n' >> "$out"
      current_lines=$((current_lines + 1))
    done

    normalized+=("$out")
    i=$((i + 1))
  done

  paste -d '' "${normalized[@]}" | while IFS= read -r line || [[ -n "$line" ]]; do
    printf '%s\n' "$line"
    sleep "$DELAY"
  done

  rm -rf "$tmpdir"
}

print_sequential() {
  local stage=1

  for f in "${files[@]}"; do
    case "$stage" in
      1) print_stage "STAGE 01 // LIMITLESS ONLINE" ;;
      2) print_stage "STAGE 02 // CURSED ENERGY STABILIZED" ;;
      3) print_stage "STAGE 03 // HOLLOW PURPLE BUILD COMPLETE" ;;
      *) print_stage "STAGE $stage // DOMAIN EXPANSION CONTINUES" ;;
    esac

    print_slow_file "$f"
    stage=$((stage + 1))
  done

  print_stage "BUILD COMPLETE // SYSTEM ONLINE"
}

printf '\n'
printf '[ GOJO BUILD BANNER SYSTEM ]\n'
printf '[ Terminal width detected: %s columns ]\n' "$terminal_width"
printf '[ Estimated side-by-side width: %s columns ]\n' "$total_width"
printf '\n'
sleep 0.5

if [[ "$FORCE_SEQUENTIAL" == "1" ]]; then
  print_sequential
elif [[ "$FORCE_SIDE_BY_SIDE" == "1" ]]; then
  print_side_by_side
elif [[ "$total_width" -le "$terminal_width" ]]; then
  print_side_by_side
else
  echo "[INFO] Terminal is not wide enough for side-by-side."
  echo "[INFO] Switching to sequential Gojo mode."
  sleep 0.7
  print_sequential
fi
