open Big_int

module Big_int_BaseConverter =
struct
  type base = string
  exception Conversion_error of string 

  let revstr str =
    let rec rev str revstr offset = match offset with
	len when len = String.length str -> revstr
      | _ ->
	revstr.[offset] <- str.[((String.length str)-1) - offset];
	rev str revstr (offset+1)
    in
    let reversed = String.create (String.length str) in
    rev str reversed 0


  let big_int_of_base basenbr base baseprefix =
  (* Extracts the prefix part of the number. If the number size is smaller than the prefix size,
   *  e.g. "a" for hexadecimal, consider the prefix is an empty string.
   * It is necessary since this function is meant to work with AND without the base prefix. 
   *)
    let prefix =
      try
	String.sub basenbr 0 (String.length baseprefix)
      with Invalid_argument ia -> ""
    in
    let offset = if prefix = baseprefix then 2 else 0
    in
    (* Strips the prefix (if any) of the value *)
    let value = String.sub basenbr offset ((String.length basenbr) - offset)
    in
    let rev = revstr value
    in
    (* A number value (symbol, or character) in ANY base  is equal to (character position in base string) * (base length)^(char offset in the number string from the right).
     * Previously reversing the string lets us simply increment the offset.
     *)
    let rec big_int_of_value nbr base big_nbr ofs = match ofs with
      | len when len = String.length nbr -> big_nbr
      | _ -> let charValue =
	       try
		 mult_big_int (big_int_of_int (String.index base nbr.[ofs])) (power_int_positive_int (String.length base) ofs)
	       with
		 Not_found -> raise (Conversion_error ("Invalid character: " ^ (String.make 1 nbr.[ofs])))
	     in
	     big_int_of_value nbr base (add_big_int big_nbr charValue) (ofs+1)
    in
    big_int_of_value rev base zero_big_int 0

      
  let value_of_hex hex_nbr = big_int_of_base hex_nbr "0123456789ABCDEF" "0x"
  let value_of_bin bin_nbr = big_int_of_base bin_nbr "01" "0b"
  let value_of_oct oct_nbr = big_int_of_base oct_nbr "01234567" "0o"
  let value_of_dec dec_nbr = big_int_of_string dec_nbr
  let value_of_string str_nbr =
    let prefix =
      try
	String.sub str_nbr 0 2 (* since all the prefixes we know are actually 2-characters long *)
      with Invalid_argument ia -> ""
    in
    match prefix with
      "0x" -> value_of_hex str_nbr
    | "0b" -> value_of_bin str_nbr
    | "0o" -> value_of_oct str_nbr
    | _    -> value_of_dec str_nbr 

  let string_of_value value base = 
    let baseLen = big_int_of_int (String.length base)
    in
    let rec get_superior value baseLen sup = match sup with
      x when ge_big_int (div_big_int value sup) baseLen -> get_superior value baseLen (mult_big_int sup baseLen)
    | _ -> sup
    in
    let sup = get_superior value baseLen unit_big_int
    in
    let rec build_string value base baseLen sup str = match sup with
	x when eq_big_int x zero_big_int -> str
      | _ -> build_string (mod_big_int value sup) base baseLen (div_big_int sup baseLen) (str ^ (String.make 1 (base.[int_of_big_int (div_big_int value sup)])))
    in
    build_string value base baseLen sup ""
      
      
    
      
  let hex_string_of_value value = string_of_big_int value
  let bin_string_of_value value = string_of_big_int value
  let oct_string_of_value value = string_of_big_int value
  let dec_string_of_value value = string_of_big_int value
end


module Int_BaseConverter = 
struct
  type base = string
    
  let value_of_hex str = int_of_string str
  let value_of_bin str = int_of_string str
  let value_of_oct str = int_of_string str
  let value_of_dec str = int_of_string str
  let value_of_string str = int_of_string str
    
  let string_of_value value base = (string_of_int value) ^ base 
  let hex_string_of_value value = string_of_int value 
  let bin_string_of_value value = string_of_int value 
  let oct_string_of_value value = string_of_int value 
  let dec_string_of_value value = string_of_int value
end

