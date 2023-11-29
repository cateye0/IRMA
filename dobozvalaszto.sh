#!/bin/bash
# IRMA beadandó feladat |  Katona Tibor | GQJ32R | 2023.11

# Felhasználótól bekért adatok
read -p "Kérem, adja meg a csomag szélességét: " x
read -p "Kérem, adja meg a csomag magasságát: " y
read -p "Kérem, adja meg a csomag mélységét: " z

# Ellenőrizzük a bemeneti értékeket
if ! [[ "$x" =~ ^[0-9]+$ ]] || ! [[ "$y" =~ ^[0-9]+$ ]] || ! [[ "$z" =~ ^[0-9]+$ ]]
    then
        echo "Csak természetes számok lehetnek a bemeneti értékek!"
        exit 1
fi

# Csomagoló dobozok méretei és nevei
box_1="40 20 60 box_1"
box_2="60 40 80 box_2"
box_3="80 60 100 box_3"
box_4="100 80 120 box_4"

# Változó a talált illeszkedő dobozok követéséhez
fit_boxes=()

# Ellenőrzés, hogy melyik dobozba illeszkedik a csomag
for box in "$box_1" "$box_2" "$box_3" "$box_4"; do
    read bx by bz name <<< $box

    if ((bx >= x && by >= y && bz >= z)); then
        fit_boxes+=("$name: $bx $by $bz")
    fi
done

if [ ${#fit_boxes[@]} -eq 0 ]; then
    # Ha nincs ilyen doboz
    printf "\n"
    echo -e "A csomag nem fér bele egyik dobozba sem. \n"
    exit 0
else
    # Ha van, kiválasztjuk az optimális dobozt
    optimal_box=""
    min_difference=0

    for fit_box in "${fit_boxes[@]}"; do
        read name bx by bz <<< $fit_box
        difference=$((bx - x + by - y + bz - z))

        if [ -z "$optimal_box" ] || ((difference < min_difference)); then
            optimal_box="$fit_box"
            min_difference=$difference
        fi
    done

    num_fit_boxes=${#fit_boxes[@]}
    if [ $num_fit_boxes -eq 1 ]; then
        printf "\n"
        echo "Egy lehetséges doboz van."
    else
        printf "\n"
        echo "Több mint egy lehetséges doboz van ($num_fit_boxes)."
    fi

    # Kiírjuk az optimális dobozt
    printf "\n"
    echo -e "Az optimális doboz: $optimal_box \n"

    # Kiírjuk az összes illeszkedő dobozt, beleértve az optimálist is
    echo -e "Az összes illeszkedő doboz: \n"
    for fit_box in "${fit_boxes[@]}"; do
        echo "$fit_box"
    done
        printf "\n"

fi
