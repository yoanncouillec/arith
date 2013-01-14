type expr_arith = 
  | EConst of int
  | EAdd of expr_arith * expr_arith
  | ESub of expr_arith * expr_arith

type instr = 
  | IConst of int
  | IAdd
  | ISub

type machine = int list * instr list

let rec compile = function
  | EConst n -> [IConst n]
  | EAdd (e1, e2) -> (compile e1) @ (compile e2) @ [IAdd]
  | ESub (e1, e2) -> (compile e1) @ (compile e2) @ [ISub]

let rec eval (integers, instructions) =
  match instructions with
    | [] -> List.hd integers
    | (IConst n) :: rest -> eval (n :: integers, rest)
    | _ as instr :: rest ->
	match integers with
	  | n2 :: n1 :: integers ->
	      begin
		match instr with
		  | IAdd -> eval ((n1 + n2) :: integers, rest)
		  | ISub -> eval ((n1 - n2) :: integers, rest)
		  | _ -> failwith "Should not append"
	      end
	  | _ -> failwith "Should not append"

let expansion = function 
  | IConst n -> "pushq $" ^ (string_of_int n) ^ "\n"
  | IAdd -> "popq %rax\naddq %rax, (%rsp)\n"
  | ISub -> "popq %rax\nsubq %rax, (%rsp)\n"

let rec string_of_expr_arith = function
  | EConst n -> string_of_int n
  | EAdd (e1, e2) -> "(" ^ (string_of_expr_arith e1) ^ " + " ^ 
      (string_of_expr_arith e2) ^ ")"
  | ESub (e1, e2) -> "(" ^ (string_of_expr_arith e1) ^ " - " ^ 
    (string_of_expr_arith e2) ^ ")"

let string_of_instr = function
  | IConst n -> "CONST(" ^ (string_of_int n) ^ ")"
  | IAdd -> "ADD"
  | ISub -> "SUB"

let output_instr channel = function
  | IConst n -> output_byte channel 0 ; output_binary_int channel n
  | IAdd -> output_byte channel 1
  | ISub -> output_byte channel 2

let input_instr channel = 
  match input_byte channel with
    | 0 -> IConst (input_binary_int channel)
    | 1 -> IAdd
    | 2 -> ISub
    | _ -> failwith "Unknown opcode"
