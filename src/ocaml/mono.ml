type subst = string

let index c =
  let diff = Char.code c - Char.code 'a' in
  if diff >= 0 && diff < 26 then
    Some(diff)
  else
    None

let unwrap = function
  | Some(v) -> v
  | None -> failwith "unwrap"

let from_index i = Char.chr (Char.code 'a' + i)

let is_uppercase c = c >= 'A' && c <= 'Z'

let inv subst =
  let buffer = Bytes.create 26 in
  String.iteri (fun i c ->
    let rev_index = index c |> unwrap in
    Bytes.set buffer rev_index (from_index i)) subst;
  Bytes.to_string buffer

let subst_from_key key =
  let key = String.lowercase_ascii key in
  let buffer = Buffer.create 26 in
  let found = Array.make 26 false in
  String.iter (fun c ->
    match index c with
      | Some(i) when found.(i) = true -> ()
      | Some(i) when found.(i) = false ->
          found.(i) <- true;
          Buffer.add_char buffer c
      | None -> ()
      | _ -> assert false)
    key;
  Array.iteri (fun index added ->
    if not added then
      from_index index
      |> Buffer.add_char buffer
    else
      ()) found;
  Buffer.contents buffer

let encode_char subst c =
  if is_uppercase c then
    match index (Char.lowercase_ascii c) with
      | Some(i) -> Char.uppercase_ascii subst.[i]
      | None -> assert false
  else
    match index c with
      | Some(i) -> subst.[i]
      | None -> c

let encode subst source =
  String.map (encode_char subst) source

let decode_char subst c =
  encode_char (inv subst) c

let decode subst source =
  encode (inv subst) source
