note
	description: "[
		A class representing a tree node in a SPLAY_TREE.
		
		A tree node has a comparable key and a value, and a left child, 
		a right child, and a parent pointers. 
		
		A tree node may be either internal or external. 
		An internal node has two non-void children,
		and an external node has two void children.
		
		A node should always keep track of bidirectional pointer reference.
		(i.e. a child must reference their parent, and parent must 
		refer to the child by its either of left or right child.)
		The left, right, and parent pointers must not be itself.
		(i.e. no circular reference)
		]"
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_NODE[K -> COMPARABLE, V -> ANY]
		-- The two variables K and V above are called type parameters (K for search keys and V for data values). A client
		-- or user of the TREE NODE class must specify what K and V are when declaring a variable. As an example, by
		-- writing node 1: TREE NODE[INTEGER, PERSON] , the stored keys are integers and values are references of person
		-- objects. As another example, by writing node 2: TREE NODE[STRING, REAL] , the stored keys are references
		-- of string objects and values are single point float values.

inherit
	COMPARABLE
		-- A tree node may be compared to another node by their keys
		-- using comparison operators: `~`, `>`, `<`, `<=`, `>=`.
		-- Inheriting `COMPARABLE` requires client(TREE_NODE) to
		-- implement `is_less`.
		undefine
			out
		end

	DEBUG_OUTPUT
		undefine
			is_equal
		redefine
			out
		end

create
	make_internal, make_external
		-- A tree node may be created as an internal node or
		-- an external node.

-- Note. All features marked with `TODO` in the TREE_NODE class are considered as basic.

feature -- Comparable

	is_less alias "<" (other: TREE_NODE[K, V]): BOOLEAN
			-- Does this node have a smaller key than the node `other`?
		do
			-- This implementation is given to you. Do not modify.
			if
				attached key as a_key and
				attached other.key as a_other_key
			then
				Result := a_key < a_other_key
			end
		end

feature {TREE_NODE, ES_TEST} -- Initialization

	make_external
			-- Makes an external (empty) node.
		do
			-- Implementation does nothing. Do not modify.
		ensure
			-- The postconditions `no_left_child`, `no_right_child` are
			-- completed for you. Do not modify.
			no_left_child:
				not attached left
			no_right_child:
				not attached right
			no_parent:
				-- TODO: complete this postcondition.
				not attached parent
		end

	make_internal (p_key: K; p_value: V)
			-- Makes an internal node.
		do
			-- This implementation is given to you. Do not modify.
			key := p_key
			value := p_value

			create left.make_external

			if
				attached left as a_left
			then
				a_left.parent := Current
			end

			create right.make_external

			if
				attached right as a_right
			then
				a_right.parent := Current
			end
		ensure
			-- The postconditions `key_exists`, `value_exists` are
			-- completed for you. Do not modify.
			key_exists:
				attached key
			value_exists:
				attached value
			left_is_external:
				-- TODO: Complete this postcondition.
				-- Hint. `left` is detachable, so for void safety, the compiler
				-- would not allow you to call `left.is_external` directly.
				-- You'd need to make sure that `left`, the call target, is not void.
				attached left as a_left and then
				a_left.is_external
			right_is_external:
				-- TODO: complete this postcondition.
				-- Hint. See above.
				attached right as a_right and then
				a_right.is_external
			result_node_is_internal:
				is_internal
		end

feature -- Attributes

	key: detachable K assign set_key
		-- The keyword `assign` is used to indicate an assigner command `set_key`,
		-- which can set the value of the attribute `key`.
		-- Without the assigner command, the `key` attribute
		-- will never be changed after the initialization of `Current`.

	value: detachable V assign set_value

	parent: detachable like Current assign set_parent

	left: like parent assign set_left

	right: like left assign set_right

	sibling: like right
		do
			-- This implementation is given to you. Do not modify.
			if
				attached parent as a_parent
			then
				if
					current = a_parent.left
				then
					Result := a_parent.right
				else
					Result := a_parent.left
				end
			else
				-- Result is nothing.
			end
		ensure
			-- These postconditions are completed for you. Do not modify.
			current_is_left_of_parent_means_result_is_right:
				attached parent as a_parent
				implies
				(
					(
						attached a_parent.left as a_left and then
						a_left = Current
					)
					implies
					(
						attached a_parent.right as a_right and then
						Result = a_right
					)
				)
			current_is_right_of_parent_means_result_is_left:
				attached parent as a_parent
				implies
				(
					(
						attached a_parent.right as a_right and then
						a_right = Current
					)
					implies
					(
						attached a_parent.left as a_left and then
						Result = a_left
					)
				)
			current_no_parent_means_no_result:
				not attached parent as a_parent
				implies
				not attached Result
		end

feature -- Status setting
		-- All set commands except `set_to_internal`
		-- are implemented. Do not modify.
	set_parent (p_node: like parent)
			-- Sets Current's parent.
		do
			parent := p_node
		ensure
			parent = p_node
		end

	set_left (p_node: like left)
			-- Sets Current's left.
		do
			left := p_node
		ensure
			left = p_node
		end

	set_right (p_node: like right)
			-- Sets Current's right.
		do
			right := p_node
		ensure
			right = p_node
		end

	set_key (p_key: like key)
			-- Sets Current's key.
		do
			key := p_key
		ensure
			key = p_key
		end

	set_value (p_value: like value)
			-- Sets Current's value.
		do
			value := p_value
		ensure
			value = p_value
		end

	set_to_internal (p_key: K; p_value: V)
			-- Transforms the Current external node to be an internal node storing `p_key` and `p_value`.
		require
			is_external
		local
			l_parent: like parent
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hints: You must transform the external `Current` node to an internal node that has
			--		  `p_key` and `p_value`. Think about the difference between the definition of
			-- 		  an internal node and an external node. Make sure to satisfy the postconditions.
			l_parent := parent
			make_internal(p_key, p_value)
			parent := l_parent
		ensure
			-- These postconditions are completed for you. Do not modify.
			current_is_internal:
				is_internal
			parent_does_not_change:
				parent = (old parent)
		end

feature -- Insertion

	insert_left (p_node: like Current)
			-- Inserts the tree node `p_node` in the left external child,
			-- by replacing the left external node with the `p_node`.
			-- This command is used to build trees from scratch.
			-- e.g., {STARTER_TESTS}.env_int_int
		require
			p_node_is_inertnal_node:
				p_node.is_internal
			smaller_than_Current:
				p_node < Current
			left_is_external:
				-- TODO: Complete this precondition.
				-- Hint: left child must be external.
				attached left as a_left and then a_left.is_external
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			left := p_node
			p_node.parent := Current
		ensure
			left_is_assigned:
				-- TODO: Complete this postcondition.
				-- Hint: left child must be `p_node`.
				attached left as a_left and then a_left = p_node
			keep_left_parent_reference:
				-- TODO: Complete this postcondition.
				-- Hint: The left child keeps its parent reference correctly.
				attached left as a_left2 and then a_left2.parent = Current
		end

	insert_right (p_node: like Current)
			-- Inserts the tree node `p_node` in the right external child,
			-- by replacing the right external node with the `p_node`.
			-- This command is used to build trees from scratch.
			-- e.g., {STARTER_TESTS}.env_int_int
		require
			p_node_is_inertnal_node:
				p_node.is_internal
			bigger_or_equal_to_Current:
				Current < p_node
			right_is_external:
				-- TODO: Complete this precondition.
				-- Hint: right child must be external.
				attached right as a_right and then a_right.is_external
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			right := p_node
			p_node.parent := Current
		ensure
			right_is_assigned:
				-- TODO: Complete this postcondition.
				-- Hint: right child must be `p_node`.
				attached right as a_right and then a_right = p_node
			keep_right_parent_reference:
				-- TODO: Complete this postcondition.
				-- Hint: The right child keeps its parent reference correctly.
				attached right as a_right2 and then a_right2.parent = Current
		end

feature -- Status Query

	is_external: BOOLEAN
			-- Is the Current node external node? ( Does this node have both left and right not attached? )
		do
			-- This implementation is given to you. Do not modify.
			Result := not attached left and not attached right
		ensure
			has_no_children:
				-- This postcondition is completed for you. Do not modify.
				Result = (not attached left and not attached right)
		end

	is_internal: BOOLEAN
			-- Is the Current node internal node? ( Does this node have either left and right attached? )
		do
			-- This implementation is given to you. Do not modify.
			Result := not is_external
		ensure
			has_a_child:
				-- This postcondition is completed for you. Do not modify.
				Result = (attached left or attached right)
		end

	count: INTEGER
			-- Returns the number of descendants of the tree rooted at `Current`.
			-- Descendants include itself (if internal) and internal nodes.
		do
			-- TODO: Implement this query so that the postcondition is satisfied.
			if
				attached left as a_left and then a_left.is_internal -- if left node exists,
			then
				Result := Result + a_left.count -- add the left node counts.
			end

			if
				attached right as a_right and then a_right.is_internal -- if right node exists,
			then
				Result := Result + a_right.count -- add the right node counts.
			end

			if
				is_internal
			then
				Result := Result + 1 -- Finally, add the current node.
			end
		ensure
			correct_result:
				-- TODO: Complete this postcondition.
				-- Hint: the return value of this query (Result) is the same as the size
				-- of the linear version (`nodes`) of the tree rooted at Current.
				Result = nodes.count
		end

	min_node: TREE_NODE[K, V]
			-- Returns the node with minimum key from the tree rooted at `Current`.
		require
			current_is_not_external:
				not is_external
		do
			-- TODO: Implement this query so that the postcondition is satisfied.
			if
				attached left as a_left and then 	-- If left child exists,
				a_left.is_internal					-- and if the left node is internal node,
			then
				Result := a_left.min_node -- min node from left subtree is the minimum node.
			else -- If left is external,
				Result := Current -- then the current is the minimum subtree.
			end
		ensure
			left_external_means_current_is_minimum:
				-- TODO: Complete this postcondition.
				-- Hint: `left` being external means `Current` is a leaf node.
				attached left as a_left and then a_left.is_external implies Result = Current
			result_is_minimum_in_this_subtree:
				-- TODO: Complete this postcondition.
				-- Hint: the result is the smallest node among all the descendants.
				Result = nodes.first
			result_is_internal:
				-- This postcondition is completed for you. Do not modify.
				Result.is_internal
		end

	max_node: TREE_NODE[K, V]
			-- Returns the node with maximum key from the tree rooted at `Current`.
		require
			current_is_not_external:
				not is_external
		do
			-- TODO: Implement this query so that the postcondition is satisfied.
			if
				attached right as a_right and then 	-- If right child exists,
				a_right.is_internal					-- and if the left node is internal node,
			then
				Result := a_right.max_node -- max node from right subtree is the maximum node.
			else -- If right is external,
				Result := Current -- then the current is the maximum subtree.
			end
		ensure
			right_external_means_current_is_maximum:
				-- TODO: Complete this postcondition.
				-- Hint: `right` being external means `Current` is a leaf node.
				attached right as a_right and then a_right.is_external implies Result = Current
			result_is_maximum_in_this_subtree:
				-- TODO: Complete this postcondition.
				-- Hint: the result is the biggest node among all the descendants.
				Result = nodes.last
			result_is_internal:
				-- This postcondition is completed for you. Do not modify.
				Result.is_internal
		end

feature -- Status report

	tree_search (p_key: K): TREE_NODE[K, V]
			-- Returns either: 1. The node with the key `p_key` or
			-- 				   2. An external node where the node with the key `p_key` supposed to be.
		do
			-- TODO: Implement this query so that the postcondition is satisfied.
			-- Hints: Cover the 4 cases of search:
			-- Case 1: Current node is external.
			-- Current node is internal and:
			-- Case 2: Current node's key matches `p_key`.
			-- Case 3: Current node's key is bigger than `p_key`.
			-- Case 4: Current node's key is smaller than `p_key`.
			if
				is_external -- If leaf node,
			then
				Result := Current 	-- 1. external node Current is where the node with key p_key supposed to be.
			else -- If internal node,
				if
					attached key as a_key -- internal node implies key exists, so this is always the case.
				then
					if
						p_key ~ a_key -- If the node with the key p_key is found,
					then
						Result := Current -- return the node with the key p_key. (Current)
					elseif
						p_key < a_key -- If the node with the key p_key is less than current node,
					then
						if
							attached left as a_left	-- If left exists, (Whether it is external or internal)	
						then
							Result := a_left.tree_search(p_key) -- Result is left subtree's tree search result.
						else -- If left is void,
							Result := Current -- This never happens, because this node is internal. This is here for syntax reason.
						end
					else -- p_key > a_key, If the node with the key p_key is bigger than current node,
						if
							attached right as a_right -- If right exists, (Whether it is external or internal)
						then
							Result := a_right.tree_search(p_key) -- Result is right subtree's tree search result.
						else -- If right void,
							Result := Current -- This never happens, because this node is internal. This is here for syntax reason.
						end
					end
				else -- If key does not exist, but this route never happens, as this is internal node case.
					Result := Current
				end
			end
		ensure
			case_of_key_found:
				-- TODO: Complete this postcondition.
				-- Hint: When we found the node, the result must be the current node due to the recursive
				-- nature of this query.
				(attached key as a_key and then p_key ~ a_key) implies Result = Current
			case_of_key_not_found:
				-- TODO: Complete this postcondition.
				-- Hint: If the node is external, it means result must be the Current node.
				is_external implies Result = Current

		end

	value_search (p_key: K): detachable V
			-- Returns mapped value from the key `p_key` from an internal node
			-- by searching the subtree rooted at `Current`.
		local
			l_node: TREE_NODE[K, V]
		do
			-- TODO: Implement this query so that the postcondition is satisfied.
			-- Hint. Think of various cases of search for `p_key`.

			l_node := tree_search(p_key) -- Find a node with p_key.

			if
				l_node.is_internal and
				l_node.key ~ p_key
			then
				Result := l_node.value -- return its value.
			else
				-- Otherwise, we do not return anything.
			end
		ensure
			case_of_key_found:
				-- TODO: Complete this postcondition.
				-- Hint: `p_key` existing means that the return value is same as one we find within
				-- 		 the same tree.
				has(p_key)
				implies
				attached tree_search(p_key) as a_node and then
				a_node.is_internal and then
				(Result = a_node.value)
			-- We do not worry about specifying the other case (`case_of_key_not_found`).
			-- As an optional exercise, you are encouraged to think about how you might write it.
		end

	has (p_key: K): BOOLEAN
			-- Returns true if the subtree rooted at `Current` has an internal node with
			-- the key `p_key` among its descendants. Returns false otherwise.
		local
			l_node: TREE_NODE[K, V]
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hint. Think of various cases of search for `p_key`.

			l_node := tree_search(p_key)
			if
				l_node.is_internal and
				attached l_node.key as a_key
			then
				Result := a_key ~ p_key
			end
		ensure
			correct_search_result:
				-- TODO: Complete this postcondition.
				-- Hint: Result must be same as if we found the p_key from subtree rooted at `Current`.
				Result
				=
				(
					attached tree_search(p_key) as a_node and then
					a_node.is_internal and then
					attached a_node.key as a_key and then
					a_key ~ p_key
				)
		end

	has_node (p_node: TREE_NODE[K,V]): BOOLEAN
			-- Returns true if the subtree rooted at `Current` has
			-- an internal node with the same key as `p_node` among its descendants.
			-- Returns false otherwise.
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hint. You may use previous queries.
			if
				is_external -- If the Current node is external,
			then
				Result := false
			else -- If the Current node is internal,
				if
					attached p_node.key as p_key -- we know that key exists,
				then
					Result := has(p_key) -- check if there is a node with p_key.
				end
			end
		ensure
			correct_search_result:
				-- This postcondition is completed for you. Do not modify.
				Result = (attached p_node.key as a_p_node_key and then has(a_p_node_key))
		end

feature -- Conversion

	nodes: LIST[TREE_NODE[K, V]]
			-- Returns a linear ordering of nodes which corresponds to
			-- an in-order traversal of the tree rooted at Current.
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hint: To satisfy the void safety required by the compiler,
			-- you must first initialize the return value `Result`.
			-- Notice that the static return type of this query is a deferred class `LIST`,
			-- to create an object, you must use one of its effective descendant classes.

			-- Make an empty list of nodes.
			create {ARRAYED_LIST[TREE_NODE[K, V]]} Result.make(count)

--			Result.compare_objects -- we only need this, if nodes are compared
-- directly using ~ (e.g., see postcondition `consistent_in_orders` of {BALANCED_BST}.search).

			if
				attached left as a_left and then a_left.is_internal -- If left is internal,
			then
				Result.append(a_left.nodes) -- include the roots of the left subtree.
			end

			if
				is_internal -- Include this node only if this is internal node. (This is needed for when Current is empty)
			then
				Result.force (Current) -- Include the root.
			end


			if
				attached right as a_right and then a_right.is_internal -- If right subtree exists from the root,
			then
				Result.append(a_right.nodes) -- include the roots of the right subtree.
			end
		ensure
			number_of_nodes_not_changed:
				-- This postcondition is completed for you. Do not modify.
				count = old count
			inorder_means_result_is_sorted_incrementally:
				-- TODO: Implement this postcondition.
				across
					1 |..| (count - 1) is i
				all
					Result[i] < Result[i+1]
				end
			no_tree_structure_changed:
				-- TODO: Complete this postcondition.
				-- Hint: the tree rooted at Current **before** calling `nodes` has
				-- the same structure (defined by `is_same_tree`) as that **after** calling `nodes`.
				-- Hint. Invoking `is_same_tree(node)` is effectively invoking `Current.is_same_tree(node)`.
				Current.is_same_tree(old Current.deep_twin)
		end

feature -- Helper features for postconditions

	is_same_tree(other: TREE_NODE[K, V]): BOOLEAN
			-- Is the tree rooted at Current same (in terms of structure) as tree rooted at other?
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hint. Current and `other` denote the same tree if:
			-- 1. Current and `other` are the same node (by content, not refernce).
			-- 			Notice that `is_less_than` is already implemented for you.
			--			According to COMPARABLE, parent of TREE_NODE, `is_equal` is then
			--			defined as: n1.is_equal(n2) <=> not (n1 < n2) and not (n2 < n2).
			--			That is, you can just use ~ to compare the two nodes.
			-- 2. Recursively, Current's left subtree, if existing, is the same tree as other's left subtree, if existing.
			--		And similarly for the Current's right subtree and other's right subtree.

			Result := -- True if both root, left and right subtree are same.
				Current ~ other -- are both roots same?
				and then -- Are both left subtrees same?
					(
						( -- Are both subtree's left attached?
							attached left as a_left
							and
							attached other.left as a_other_left
						)
						implies
						( -- If so, are both left subtree same?
							a_left.is_same_tree (a_other_left)
						)
					)
					and
					(
						-- If any one of them are not attached,
					  	-- Are both not attached?
						(
							not attached left = not attached other.left
						)
					)
				and then -- Are both right subtrees same?
					(
						( -- Are both subtree's right attached?
							attached right as a_right
							and
							attached other.right as a_other_right
						)
						implies
						( -- If so, are both right subtree same?
							a_right.is_same_tree (a_other_right)
						)
					)
					and
					(
						-- If any one of them are not attached,
					  	-- Are both not attached?
						(
							not attached right = not attached other.right
						)
					)
		end


feature -- Out

	debug_output: STRING
			-- Debugger will show the `Result`.
		do
			Result := out
		end

	out: STRING
			-- Do not modify this.
		do
			if
				attached key as a_key and then
				attached value as a_value
			then
				Result := "(" + a_key.out + ", " + a_value.out + ")"
			else
				Result := "x"
			end

		end

invariant
	-- These class invariants are given to you. Do not modify them.
	-- However, you may study them carefully because they
	-- specify the defintions of external vs. internal nodes.

	if_internal_then_key_value_exist:
		is_internal implies attached key and attached value

	if_internal_then_left_and_right_exist:
		is_internal implies attached left and attached right

	if_external_then_left_and_right_do_not_exist:
		is_external implies not attached left and not attached right

	left_is_not_itself:
		attached left as a_left
		implies
		a_left /= Current

	right_is_not_itself:
		attached right as a_right
		implies
		a_right /= Current

	parent_is_not_itself:
		attached parent as a_parent
		implies
		a_parent /= Current
end
