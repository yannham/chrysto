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
