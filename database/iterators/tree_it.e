note
	description: "Iteration cursor for TREE_DB. (Postorder iteration)"
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_IT[K -> COMPARABLE, V -> attached ANY]

inherit
	ITERATION_CURSOR[TUPLE[K,V]]

create
	make

feature -- attributes
    t_db : TREE_DB[K, V]
    nodes_list : LIST[TREE_NODE[K, V]]
    cursor : INTEGER
feature {NONE} -- Initialization

	make (p_db: TREE_DB[K, V])
		do
			-- TODO: Complete this implementation.
			t_db := p_db
			nodes_list := p_db.bst.nodes
			cursor := p_db.bst.nodes.count
		end

feature -- Access

	item: TUPLE[key: K; value: V]
			-- Item at current cursor position.
		do
			-- TODO: Complete this implementation.
		   create Result
		   if attached nodes_list[cursor].key as ls_key and attached nodes_list[cursor].value as ls_value then
		   	    Result := [ls_key,ls_value]
		   end

		end

feature -- Status report	

	after: BOOLEAN
			-- Are there no more items to iterate over?
		do
			-- TODO: Complete this implementation.
			Result := cursor < nodes_list.lower
		end

feature -- Cursor movement

	forth
			-- Move to next position.
		do
			-- TODO: Complete this implementation.
			cursor := cursor - 1
		end

end
