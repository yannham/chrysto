// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Char from "../../../../../../../usr/local/lib/node_modules/bs-platform/lib/es6/char.js";
import * as $$Array from "../../../../../../../usr/local/lib/node_modules/bs-platform/lib/es6/array.js";
import * as Bytes from "../../../../../../../usr/local/lib/node_modules/bs-platform/lib/es6/bytes.js";
import * as $$Buffer from "../../../../../../../usr/local/lib/node_modules/bs-platform/lib/es6/buffer.js";
import * as $$String from "../../../../../../../usr/local/lib/node_modules/bs-platform/lib/es6/string.js";
import * as Caml_array from "../../../../../../../usr/local/lib/node_modules/bs-platform/lib/es6/caml_array.js";
import * as Caml_bytes from "../../../../../../../usr/local/lib/node_modules/bs-platform/lib/es6/caml_bytes.js";
import * as Caml_string from "../../../../../../../usr/local/lib/node_modules/bs-platform/lib/es6/caml_string.js";
import * as Utils$Chrysto from "./utils.bs.js";

function inv(subst) {
  var buffer = Caml_bytes.caml_create_bytes(26);
  $$String.iteri((function (i, c) {
          var rev_index = Utils$Chrysto.unwrap(Utils$Chrysto.index(c));
          return Caml_bytes.set(buffer, rev_index, Utils$Chrysto.from_index(i));
        }), subst);
  return Bytes.to_string(buffer);
}

function subst_from_key(key) {
  var key$1 = $$String.lowercase_ascii(key);
  var buffer = $$Buffer.create(26);
  var found = Caml_array.caml_make_vect(26, false);
  $$String.iter((function (c) {
          var i = Utils$Chrysto.index(c);
          if (i === undefined) {
            return ;
          }
          if (Caml_array.get(found, i) === true) {
            return ;
          }
          if (Caml_array.get(found, i) === false) {
            Caml_array.set(found, i, true);
            return $$Buffer.add_char(buffer, c);
          }
          throw {
                RE_EXN_ID: "Assert_failure",
                _1: [
                  "mono.ml",
                  23,
                  13
                ],
                Error: new Error()
              };
        }), key$1);
  $$Array.iteri((function (index, added) {
          if (!added) {
            return $$Buffer.add_char(buffer, Utils$Chrysto.from_index(index));
          }
          
        }), found);
  return $$Buffer.contents(buffer);
}

function key_of_subst(subst) {
  return subst;
}

function encode_char(subst, c) {
  if (Utils$Chrysto.is_uppercase(c)) {
    var i = Utils$Chrysto.index(Char.lowercase_ascii(c));
    if (i !== undefined) {
      return Char.uppercase_ascii(Caml_string.get(subst, i));
    }
    throw {
          RE_EXN_ID: "Assert_failure",
          _1: [
            "mono.ml",
            39,
            16
          ],
          Error: new Error()
        };
  }
  var i$1 = Utils$Chrysto.index(c);
  if (i$1 !== undefined) {
    return Caml_string.get(subst, i$1);
  } else {
    return c;
  }
}

function encode(subst, source) {
  return $$String.map((function (param) {
                return encode_char(subst, param);
              }), source);
}

function decode_char(subst, c) {
  return encode_char(inv(subst), c);
}

function decode(subst, source) {
  var subst$1 = inv(subst);
  return $$String.map((function (param) {
                return encode_char(subst$1, param);
              }), source);
}

export {
  subst_from_key ,
  key_of_subst ,
  inv ,
  encode ,
  encode_char ,
  decode ,
  decode_char ,
  
}
/* No side effect */
