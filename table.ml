open Card

exception InvalidDeck
exception EmptyDeck

type deck = card list

type table = deck * card list option

(* [has13ofSuitHelper d h c d s] is true if [d] has thirteen cards for each distinct 
   suit, false otherwise *)
let rec has13ofSuitHelper (d:deck) hrt clb dmd spd =
  match d with
  | [] -> (spd = 13) && (clb = 13) && (hrt = 13) && (dmd = 13)
  | (_,s)::t -> begin
      match (s:suit) with
      | Heart -> has13ofSuitHelper t (hrt + 1) clb dmd spd
      | Club -> has13ofSuitHelper t hrt (clb + 1) dmd spd
      | Diamond -> has13ofSuitHelper t hrt clb (dmd + 1) spd
      | Spade -> has13ofSuitHelper t hrt clb dmd (spd + 1)
  end

(* [has4ofRankHelper d rArr] is true if [d] has four cards of each distinct 
   rank, false otherwise *)
let rec has4ofRankHelper (d:deck) rankArray =
  match d with
  | [] -> Array.fold_left (fun acc x -> acc && (x=4)) true rankArray
  | (r,_)::t -> begin
      let i = r - 2 in
      let _ = (rankArray.(i) <- (rankArray.(i) + 1)) in
      has4ofRankHelper t rankArray
  end

let rep_ok d =
  let has52 = (List.length d = 52) in
  let has13ofSuit = has13ofSuitHelper d 0 0 0 0 in
  let has4ofRank = has4ofRankHelper d (Array.make 13 0) in
  if (has52 && has13ofSuit && has4ofRank) then d else raise InvalidDeck

(* Reference: https://github.com/jakekara/ocaml-cardstuff/blob/master/cards.ml *)
let shuffle d =
  let rec shuffle_helper acc pull_from_d =
    if (List.length pull_from_d = 0) && (List.length acc = 52) then acc
    else begin
      Random.self_init ();
      let n = Random.int (List.length pull_from_d) in
      let chosen_card = List.nth pull_from_d n in
      let pull_from_d' = List.filter (fun x -> x <> chosen_card) pull_from_d in
      shuffle_helper (chosen_card::acc) pull_from_d'
    end in
  shuffle_helper [] (rep_ok d)

(* [suit_from_n n] is the suit representation of the int [n] *)
let suit_from_n n =
  match n with
  | 0 -> Heart
  | 1 -> Club
  | 2 -> Diamond
  | 3 -> Spade
  | _ -> raise InvalidCard

let new_deck () =
  let rec new_deck_helper acc nth_card =
    let suit_of_nth = nth_card / 13 in
    let rank_of_nth = (nth_card mod 13) in
    let rank_of_nth' = (if rank_of_nth = 0 || rank_of_nth = 13 || rank_of_nth = 26 || rank_of_nth = 39 then 13 else rank_of_nth) in
    if nth_card == 52 then List.rev acc
    else new_deck_helper ((init_card (rank_of_nth'+1) (suit_from_n suit_of_nth))::acc) (nth_card + 1) in
  new_deck_helper [] 0

let rec flip_new_card (deck, cards) =
  match deck with
  | h::t -> begin
    (* Pattern match cards to exract the value (middle cards) from the option *)
    match cards with
    | Some old_cards -> begin
      let (new_deck:deck) = t in
      let (new_mid:card list option) = Some (old_cards @ [h]) in
      ((new_deck, new_mid):table)
    end
    | None -> let (new_deck:deck) = t in
      let (new_mid:card list option) = Some ([] @ [h]) in
      ((new_deck, new_mid):table)
  end
  | [] -> raise EmptyDeck

let rec make_hand deck =
  match deck with
  | c1::c2::t -> begin
    ((t, None), c1, c2)
  end
  | _ -> raise EmptyDeck