let print_square square =
  for i=0 to 25 do
    for j=0 to 25 do
      Printf.printf "%c" square.(i).(j)
    done;
    Printf.printf "\n"
  done

let mykey = Vigenere.key_from_string "le rouge est le noir";;
let crypted = Vigenere.encode mykey "bonjour, ceci est un message en clair!";;
let clear = Vigenere.decode mykey crypted;;
