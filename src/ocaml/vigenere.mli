type key

val key_from_string : string -> key
val key_to_string : key -> string

val vigenere_square : (char array) array
val vigenere_square_inv : (char array) array

val encode : key -> string -> string
val encode_char : key -> int -> char -> char
val decode : key -> string -> string
val decode_char : key -> int -> char -> char

module Stream : sig
  type t

  val make_encoder : key -> t
  val make_decoder : key -> t

  val next : t -> char -> char
  val back : t -> unit
  val reset : t -> unit

  val index : t -> int
end
