#!/bin/bash
# DO NOT EDIT THIS FILE

ocamlbuild -use-ocamlfind main.cmo state.cmo command.cmo card.cmo player.cmo table.cmo ai.cmo ui.cmo
if [[ $? -ne 0 ]]; then
  cat <<EOF
===========================================================
WARNING

Your code currently does not compile.  You will receive
little to no credit for submitting this code. Check the
error messages above carefully to determine what is wrong.
See a consultant for help if you cannot determine what is
wrong.
===========================================================
EOF
  exit 1
fi

cat >checktypes.ml <<EOF
(* DO NOT EDIT THIS FILE *)
let ai_command : State.state -> Command.command = Ai.ai_command
let card_rep_ok : Card.card -> Card.card = Card.rep_ok
let init_card : Card.rank -> Card.suit -> Card.card = Card.init_card
let string_of_card : Card.card -> string = Card.string_of_card
let parse : string -> Command.command = Command.parse
let cmd_to_string : Command.command -> string = Command.cmd_to_string
let repl : State.state -> unit = Main.repl
let playgame : unit -> unit = Main.playgame
let init_player : string -> Table.deck -> Player.player * Table.deck = Player.init_player
let string_of_hand : Player.hand -> string = Player.string_of_hand
let initial_state : Player.player list -> Table.deck -> string -> State.state = State.initial_state
let string_of_state : State.state -> string = State.string_of_state
let is_valid_command : State.state -> Command.command -> bool = State.is_valid_command
let do' : State.state -> Command.command -> State.state = State.do'
let blinds : State.state -> State.state = State.blinds
let next_player : State.state -> Player.player = State.next_player
let new_play_round : State.state -> State.state = State.new_play_round
let new_play_round_new_deck : State.state -> State.state = State.new_play_round_new_deck
let table_rep_ok : Table.deck -> Table.deck = Table.rep_ok
let shuffle : Table.deck -> Table.deck = Table.shuffle
let new_deck : unit -> Table.deck = Table.new_deck
let flip_new_card : Table.table -> Table.table = Table.flip_new_card
let make_hand : Table.deck -> Table.table * Card.card * Card.card = Table.make_hand
let print_facedown : unit -> unit = Ui.print_facedown
let print_two_cards : Card.card -> Card.card -> unit = Ui.print_two_cards
let print_three_cards : Card.card -> Card.card -> Card.card -> unit = Ui. print_three_cards
let print_four_cards : Card.card -> Card.card -> Card.card -> Card.card -> unit = Ui.print_four_cards
let print_five_cards : Card.card -> Card.card -> Card.card -> Card.card -> Card.card -> unit = Ui.print_five_cards
let print_pot : int -> unit = Ui.print_pot
let print_no_cards : int -> unit = Ui.print_no_cards
let build_table : State.state -> unit = Ui.build_table
let win_message : unit -> unit = Ui.win_message
let lose_message : unit -> unit = Ui.lose_message
let check_make_hand : Table.deck -> Table.table * Card.card * Card.card = Table.make_hand
let check_rep_ok : Table.deck -> Table.deck = Table.rep_ok
EOF

if ocamlbuild -use-ocamlfind checktypes.byte ; then
  cat <<EOF
===========================================================
Your function names and types look good to me.
Congratulations!
===========================================================
EOF
else
  cat <<EOF
===========================================================
WARNING

Your function names and types look broken to me.  The code
that you submit might not compile on the grader's machine,
leading to heavy penalties.  Please fix your names and
types.  Check the error messages above carefully to
determine what is wrong.  See a consultant for help if you
cannot determine what is wrong.
===========================================================
EOF
fi

