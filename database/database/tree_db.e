note
	description: "[
		A specialized kind of database implemented by a balanced binary search tree.
	]"
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_DB[K -> COMPARABLE, V -> attached ANY]
		-- There are two type parameters `K` (for the type of keys) and `V` (for the type of values).
		-- When a client declares a TREE_DB object,
		-- 		K must be instantiated into a descendant class of COMPARABLE (e.g., INTEGER, STRING).
		-- 		V can be instantiated into a descendant class of ANY (i.e., any class).
		-- e.g., STRING, INTEGER, TREE_NODE.

inherit
	DATABASE[K, V] -- Remark: Given that DATABSE is iterable, TREE_DB is also iterable.
		-- Whatever type K and V are instantiated into,
		-- the `K` and `V` type parameters in class DATABASE are instantiated accordingly.
		-- e.g., When a client declares `TREE_DB[INTEGER, STRING]`,
		-- 			`K` is instantiated to `INTEGER` (which is comparable), and `V` to `STRING`.
		--			Simultaneously, `TREE_DB[INTEGER, STRING]` works like a `DATABASE[INTEGER, STRING]`.

create
	make

feature {ITERATION_CURSOR, ES_TEST} -- Restricted Attribute
	-- This attribute is only accessible by any class that is a descendant of `ITERATION_CURSOR` or of `ES_TEST`.
	-- e.g., Your own iteration cursor class might access this `bst` attribute.
	-- Do not modify this attribute: it is used to implement the deferred routines inherited from `DATABASE`.

	-- This variable declaration indicates a client-supplier relation
	-- between `TREE_DB` (client) and `BALANCED_BST` (supplier).
	bst: BALANCED_BST[K, V]

feature {DATABASE} -- Initialization

	make
			-- Makes an empty tree database via an empty splay tree.
		do
			-- This implementation is given to you. Do not modify.
			create {SPLAY_TREE[K, V]} bst.make
		ensure
			empty_db:
				-- This postcondition is given to you. Do not modify.
				model.count = 0
		end

feature -- Abstraction Function

	model: REL[K, V]
			-- The public, abstract view of a `DATABASE`.
			-- This is the so-called `abstraction function` which
			-- converts/promotes the implementation (i.e., `bst`) to a mathematical object (i.e., `REL`).
		local
			tuples: ARRAY[TUPLE[K,V]]
		do
			-- TODO: Implement this abstraction function
			-- You are expeced to explore the available queries/commands of the REL class in MATHMODELS.
			-- so that `model` can be used to write contracts of all routines in the parent class `DATABASE`.
			-- Make sure that your implementation satisfies the inherited postcondition from DATABASE.

			create Result.make_empty -- This first line of implementation is given to you.
			create tuples.make_empty
            across
            	bst.nodes is ls_node
            loop
            	if attached ls_node.key as key and attached ls_node.value as val then
                      tuples.force ([key,val], tuples.count+1)
            	end

            end
            Result.make_from_tuple_array (tuples)
		-- Implicitly, postcondition from `{DATABASE}.model` is inherited here.
		end

-- TODO: Remove comments from the inherit clause below to start implementing the iterator pattern.
feature -- Iterator Cursor

	new_cursor: ITERATION_CURSOR [TUPLE[key: K; value: V]]
			-- Returns an iteration cursor for the current class.
		do
			-- This implementation is given to you. Do not modify.
			create {TREE_IT[K, V]} Result.make(Current)
		end

feature -- Implementation of Deferred Routines from `DATABASE`

	count: INTEGER
			-- Returns the number of mappings in the current database.
		do
			-- This implementation is given to you. Do not modify.
			Result := bst.count

		-- Implicitly, postcondition from `{DATABASE}.count` is inherited here.
		end

	has_key(p_key: K): BOOLEAN
			-- Returns true if a mapping with `p_key` exists. False otherwise.
		do
			-- This implementation is given to you. Do not modify.
			Result := bst.has (p_key)

		-- Implicitly, postcondition from `{DATABASE}.has_key` is inherited here.
		end

	search(p_key: K): detachable V
			-- Searches for matching value given a key `p_key`.
			-- If `p_key` does not exist, return `Void`.
			-- Note. There is no precondition for this query.
		do
			-- This implementation is given to you. Do not modify.
			Result := bst.search (p_key)

		-- Implicitly, postcondition from `{DATABASE}.search` is inherited here.
		end

	insert(p_key: K; p_value: V)
			-- Inserts a [`p_key`, `p_value`] mapping into the database.
			-- See the inherited precondition of `{DATABASE}.insert`.
		do
			-- This implementation is given to you. Do not modify.
			bst.insert (p_key, p_value)

		-- Implicitly, postcondition from `{DATABASE}.insert` is inherited here.
		end

	delete(p_key: K)
			-- Deletes the mapping whose key is `p_key`.
			-- See the inherited precondition of `{DATABASE}.delete`.
		do
			-- This implementation is given to you. Do not modify.
			bst.delete (p_key)

		-- Implicitly, postcondition from `{DATABASE}.delete` is inherited here.
		end
end
