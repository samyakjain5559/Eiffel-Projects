note
	description: "Itertion cursor for `LINEAR_DB`. (Inverse order iteration)"
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	LINEAR_IT[K -> {COMPARABLE, HASHABLE}, V -> attached ANY]

inherit
	ITERATION_CURSOR[TUPLE[K,V]]

create
	make

feature{NONE} -- attribute
  l_db : LINEAR_DB[K, V]
 -- hash_ic : HASH_TABLE_ITERATION_CURSOR[V,K]   -- HASH_TABLE_ITERATION_CURSOR logic learned from tutorial video EECS 3311 LAB2
 i_keys :ARRAY[K]
 i_values: HASH_TABLE[V, K]
 cursor : INTEGER
feature {NONE} -- Initialization

	make (p_db: LINEAR_DB[K, V])
		do
			-- TODO: Complete this implementation.
			l_db := p_db
			--hash_ic := p_db.values.new_cursor
            i_keys := p_db.keys
            i_values := p_db.values
		    cursor := p_db.keys.count
		end

feature -- Access

	item: TUPLE[key: K; value: V]
			-- Item at current cursor position.
		do
			-- TODO: Complete this implementation.
            create Result
			if attached i_values[i_keys[cursor]] as ls_value then
                 Result := [i_keys[cursor],ls_value]
            end
		end

feature -- Status report	

	after: BOOLEAN
			-- Are there no more items to iterate over?
		do
			-- TODO: Complete this implementation.
            Result := cursor < i_keys.lower
		end

feature -- Cursor movement

	forth
			-- Move to next position.
		do
			-- TODO: Complete this implementation.
            cursor := cursor - 1
		end

end
