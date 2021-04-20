type key = string

let key_from_string s = 
  let buffer = Buffer.create (String.length s) in
  String.iter (function
    | 'a'..'z' as c -> Buffer.add_char buffer c
    | 'A'..'Z' as c -> 
        Char.code c - Char.code 'A' + Char.code 'a'
        |> Char.chr
        |> Buffer.add_char buffer
    | _ -> ()) s;
  Buffer.contents buffer

let key_to_string key = key

let vigenere_square =
  let square = Array.make_matrix 26 26 'a' in
  for i=0 to 25 do
    for j=0 to 25 do
      square.(i).(j) <- Utils.from_index ((i + j) mod 26) 
    done;
  done;
  square

let vigenere_square_inv =
  let square = Array.make_matrix 26 26 'a' in
  for i=0 to 25 do
    for j=0 to 25 do
      square.(i).((i + j) mod 26) <- Utils.from_index j
    done
  done;
  square

let encode_char_with square key index c =
  let index = index mod (String.length key) in
  let i = key.[index] |> Utils.index |> Utils.unwrap in
  let get_subst j =
    square.(i).(j) in
  if Utils.is_uppercase c then
    match Utils.index (Char.lowercase_ascii c) with
      | Some(j) -> 
          get_subst j
          |> Char.uppercase_ascii
      | None -> assert false
  else
    match Utils.index c with
      | Some(j) -> get_subst j
      | None -> c

let encode_char key index c =
  encode_char_with vigenere_square key index c

let encode key source =
  String.mapi (encode_char key) source

let decode_char key index c =
  encode_char_with vigenere_square_inv key index c

let decode key source =
  String.mapi (decode_char key) source

module Stream = struct
  type mode = Encode | Decode 
  type t = int ref * key * mode 

  let make_encoder key = (ref 0, key, Encode)
  let make_decoder key = (ref 0, key, Decode)

  let next (index, key, rev) c = 
    let coder = match rev with
      | Encode -> encode_char
      | Decode -> decode_char in
    let result = coder key !index c in
    incr index;
    result

  let back (index, _, _) = if !index == 0 then () else decr index
  
  let reset (index, _, _) = index := 0

  let index (index, _, _) = !index
end
