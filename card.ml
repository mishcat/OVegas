type suit = Heart | Club | Diamond | Spade

type rank = int

type card = rank * suit

let init_card r s =
  if ((r >= 1 && r <= 12)
  && (s = Heart || s = Club || s = Diamond || s = Spade)) then (r, s)
  else failwith "Not a valid card"

let rep_ok c =
  failwith "Unimplemented"

let string_of_card c =
  failwith "Unimplemented"