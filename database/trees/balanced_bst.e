note
	description: "A class representing a balanced binary search tree (BST)."
	author: "Samyak Jain"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	-- Design Decision:
	-- This class should be deferred, because we do not wish to instantiate it at runtime.
	-- Instead, it being a deferred class acts as an interface (i.e., static type),
	-- and polymorphism allows its descendant classes (e.g., AVL, SPLAY) to be the dynamic types.
	-- Dynamic binding makes sure that an object of static type BALANCED_BST
	-- is rebalanced according to its dynamic type (either AVL rotations or SPLAY operations).
	-- See test features in `BALANCED_BST_TEST` where the static type of `bst` is BALANCED_BST,
	-- but the dynamic types are initialized to either `SPLAY_TREE` (which you are assigned to do in this lab) or
	-- `AVL_TREE` (which can be a natural extension to this lab).
	BALANCED_BST[K -> COMPARABLE, V -> ANY]

inherit
	DEBUG_OUTPUT

-- Notice that there is no `create` clause,
-- so as to disallow any constructors to cretae objects of this deferred class.

feature -- Traversal

	nodes: LIST[TREE_NODE[K, V]]
			-- Returns a linear order corresponding to an in-order traversal from the `root`.
		deferred
		end

feature -- Basic

	has (p_key: K): BOOLEAN
			-- Does the current tree have a node storing key equal to `p_key`?
		deferred
		end

	has_node (p_node: TREE_NODE[K,V]): BOOLEAN
			-- Does Current tree have a node same key as p_node?
		deferred
		end

	count: INTEGER
			-- Returns the number of nodes in the tree.
		deferred
		end

	is_empty: BOOLEAN
			-- Checks if the BST has no nodes.
		deferred
		end

feature -- Intermediate

	search (p_key: K): detachable V
			-- Returns the value mapped from the key `p_key`.
		deferred
		end

	insert (p_key: K; p_value: V)
			-- Inserts a new node with the key `p_key` and the value `p_value`.
		require
		-- This precondition is given to you. Do not modify it.
			no_previously_existing_key:
				not has(p_key)
		deferred
		end

feature -- Advanced

	delete (p_key: K)
			-- Deletes an existing node with a key `p_key`.
		require
		-- This precondition is given to you. Do not modify it.
			a_node_with_p_key_exists:
				has(p_key)
		deferred
		end

feature -- Out

	debug_output: STRING
			-- Debugger will show the `Result`.
			-- Do not modify this.
		deferred
		end
end
