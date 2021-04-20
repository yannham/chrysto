type subst

val subst_from_key : string -> subst
val key_of_subst : subst -> string
val inv : subst -> subst

val encode : subst -> string -> string
val encode_char : subst -> char -> char
val decode : subst -> string -> string
val decode_char : subst -> char -> char
