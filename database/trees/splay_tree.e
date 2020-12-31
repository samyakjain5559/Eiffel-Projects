note
	description: "[
		A self balancing binary search tree using a rotation called splaying.

		A splay tree lets most frequently(recently) accessed elements stay near
		the root. This allows comparably faster lookup to a recently accessed
		elements than a normal binary search tree.

		A splay tree does not have logarithmic upper bound respect to the height
		of the tree, however the splay tree has a gurenteed amortised logarithmic
		running time for insertions, searches, and deletion.
		]"
	author: "Samyak Jain"
	date: "$Date$"
	revision: "$Revision$"

class
	SPLAY_TREE [K -> COMPARABLE, V -> ANY]

inherit
	BALANCED_BST [K, V]
		redefine
			out
		end

create 	-- Contrast this `create` clause with it being absent in `BALANCED_BST`.
		-- Because the current class is effective (not deferred), we must delcare
		-- a `create` clause that lists all commands that can be used as constructors.
	make

feature {NONE} -- Command

	make
			-- Makes the current balanced splay tree empty.
		do
			-- This implementation is given to you. Do not modify.
			create root.make_external
		ensure
			-- These postconditions are completed for you. Do not modify.
			root_exists:
				attached root
			root_empty:
				attached root as a_root and then
				a_root.count = 0
		end

feature -- Attribute

	root: TREE_NODE[K, V]
			-- The root of the splay tree.
			-- This root is never Void (i.e., it is always attached).

feature -- Traversal

	nodes: LIST[like root]  -- `like root`: each member in the list has its type
							-- corresponding to that of `root` (anchor type)
			-- Returns a linear order corresponding to an in-order traversal from the `root`.
		do
			-- This implementation is given to you. Do not modify.
			-- Caveat: The correctness of {SPLAY_TREE}.nodes depends solely on {TREE_NODE}.nodes that you implement.
			Result := root.nodes
		end

feature -- Basic

	has (p_key: K): BOOLEAN
			-- Does the current tree have a node storing key equal to `p_key`?
		do
			-- TODO: Implement this query so that the postcondition is satisfied.
			-- Hint: A splay tree has its root of type TREE_NODE.
			Result := root.has(p_key)
		ensure then -- In a descendant class, a `then` is needed after `ensure`. This is called sub-contracting, and we will learn about this later.
			root_has_the_node_with_the_p_key:
				-- TODO: Complete this postcondition.
				-- Hint: Return value is logically equivalent to whether or not `p_key` exists in the current tree.
				Result = root.has (p_key)
		end

	has_node (p_node: TREE_NODE[K,V]): BOOLEAN
			-- Does Current tree have a node same key as p_node?
		do
			-- TODO: Implement this query so that the postcondition is satisfied.
			-- Hint: A splay tree has its root of type TREE_NODE.
			Result := root.has_node(p_node)
		ensure then -- In a descendant class, a `then` is needed after `ensure`. This is called sub-contracting, and we will learn about this later.
			root_has_the_p_node:
				-- TODO: Complete this postcondition.
				-- Hint: Return value is logically equivalent to whether or not `p_node` exists in the current tree.
				Result = root.has_node (p_node)
		end

	count: INTEGER
			-- Returns the number of nodes in the tree.
		do
			-- TODO: Implement this query so that the postcondition is satisfied.
			-- Hint: A splay tree has its root of type TREE_NODE.
			Result := root.count -- then root.count is the count.
		ensure then -- In a descendant class, a `then` is needed after `ensure`. This is called sub-contracting, and we will learn about this later.
			root_count:
				-- TODO: Complete this postcondition.
				-- Hint: Return value is the same as the size of subtree rooted as `root`.
				Result = root.count
		end

	is_empty: BOOLEAN
			-- Checks if the BST has no nodes.
		do
			-- TODO: Implement this query so that the postcondition is satisfied.
			-- Hint: When is this tree empty?
			Result := root.is_external
		ensure then -- In a descendant class, a `then` is needed after `ensure`. This is called sub-contracting, and we will learn about this later.
			empty_if_count_is_zero:
				-- TODO: Complete this postcondition.
				-- Hint: Return value is logically equivalent to whether or not the subtree rooted at `root` is empty.
				Result = (count = 0)
		end

	relink (p_parent, p_child: TREE_NODE[K, V]; p_make_left_child: BOOLEAN)
			-- If `p_make_left_child` is true, replace `p_child` as the left child of `p_parent`.
			-- Otherwise, replace `p_child` as the right child of `p_parent`.
		do
			-- TODO: Complete the implementation so that the postcondition is satisfied.
			p_child.parent := p_parent
			if
				p_make_left_child -- If the child must be left child,
			then
				p_parent.left := p_child
			else
				p_parent.right := p_child
			end
		ensure
			childs_parent_is_linked:
				-- TODO: Complete this postcondition.
				-- Hint: p_child's parent must be consistent.
				p_child.parent = p_parent
			case_of_relinking_the_left_child:
				-- TODO: Complete this postcondition.
				p_make_left_child implies p_parent.left = p_child
			case_of_relinking_the_right_child:
				-- TODO: Complete this postcondition.
				not p_make_left_child implies p_parent.right = p_child
		end

feature -- Intermediate

	-- For simplicity of this lab, we do not consider postconditions for this section of intermediate splay operations.
	-- As an optional challenge, what postconditions can you come up with?
	-- Discuss your answer with Jinho (TA) or Jackie (instructor).
	-- Do not include your answer in the submission for grading.

	rotate (p_node: TREE_NODE[K, V])
			-- Performs a single rotation from the node `p_node`.
		require
			-- These preconditions are given to you. Do not modify them.
			has_a_parent_to_rotate:
				attached p_node.parent
		local
			x, y, z: detachable like p_node
		do
			-- TODO: Complete the implementation.
			-- Hint: Refer to the `Problem` and `Tutorials` sections of your lab instructions for details.

			x := p_node
			y := x.parent -- We know this exists. (x is not a root)
			if
				attached y as a_y -- If parent exists
								  -- (we know parent exists.)
			then
				if
					attached a_y.parent as y_parent
				then
					z := y_parent
				end

				if
					attached z as a_z -- If the grandparent exists,
				then
					relink(z, x, (y = z.left))
--				    z           z   -- Make x attached to left child. (if y is left child)
--				   /           /
--				  y    -->    x
--				 /           / \
--				x           L   R
--			   / \
--			  L   R
				else -- If the grandparent does not exist,
					root := x
					x.parent := Void

--					|           |		
--				    y           x   -- x becomes root of the tree
--				   / 	-->    / \
--				  x           L   R
-- 				 / \
--				L   R
				end

				if
					x = a_y.left -- If x was y's left child,
				then
					if
						attached x.right as a_x_right 	-- if right child exists,
					then
						relink(a_y, a_x_right, true) 	-- x's right child becomes y's left.
					end

					relink(x, a_y, false)			-- y becomes x's right child.
--				    z           z   -- Make x attached to left child. (if y is left child)
--				   / 		   /	-- x.left, x, y has made a rotation.
--				  x    -->    x
--				 / \         / \
--				L   R		L	y
--							   /
--							  R
--
				else -- If x was y's right child,
					if
						attached x.left as a_x_left 	-- if left child exists,
					then
						relink(a_y, a_x_left, false)	-- x's left child becomes y's right.
					end

					relink(x, a_y, true)			-- y becomes left child of x.
--					z		    z           z   -- Make x attached to left child. (if y is left child)
--				   /		   / 		   /	-- x.left, x, y has made a rotation.
--				  y		-->   x    -->    x
--				   \		 / \         / \
--					x		L   R	    y   R
--				   / \					 \
--				  L   R					  L
				end
			end
		end

	splay(p_node: TREE_NODE[K,V])
			-- Iteratively, performs splay operation(s) from the node `p_node` up to the root.
		do
			-- TODO: Complete the implementation.
			-- Hint: Refer to the `Problem` and `Tutorials` sections of your lab instructions for details.
			from
			until
				p_node = root
			loop
				if
					attached p_node.parent as a_parent
				then
					if
						attached a_parent.parent as a_grand_parent
					then
						-- there is a grand parent
						if
							(
								attached a_grand_parent.left as a_grand_parent_left and then
								a_parent = a_grand_parent_left
							) -- does grand-parent-and-parent slant to the left
							=
							(
								attached a_parent.left as a_parent_left and then
								p_node = a_parent_left
							) -- does parent-and-node slant to the left
						then
							-- grand-parent-parent-node slants the same way
							-- zig-zig case
							rotate(a_parent)
							rotate(p_node)
						else
							-- grand-parent-parent-node slants different ways
							-- zig-zag
							rotate(p_node)
							rotate(p_node)
						end
					else -- if grand parent does not exists,
						-- zig (with a parent, but no grand parent)
						rotate(p_node)
					end
				end
			end
		end

feature -- Advanced

	search (p_key: K): detachable V
			-- Returns the value mapped from the search key `p_key`.
		local
			l_node, l_splay_node: TREE_NODE[K, V]
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hint 1: You might want to reuse how search is done in TREE_NODE.
			-- Hint 2: The current tree after a successful search should be restructured
			-- 		so that more frequently accessed nodes are brought closer to the root.
			-- Hint 3: Refer to the `Problem` and `Tutorials` sections of your lab instructions for details.


			l_node := root.tree_search(p_key) -- Do an attempt to search the node with key p_key.
			l_splay_node := l_node
			if
				l_splay_node.is_external
			then
				l_splay_node := l_splay_node.parent
			end

			if
				attached l_splay_node as a_l_splay_node
			then
				splay(a_l_splay_node)
			end

			if
				l_node.is_external
			then
				-- respected value does not exsits. Returns nothing.
			else -- l_node.is_internal
				Result := l_node.value 	-- result must be the search result from root.
			end
		ensure then -- In a descendant class, a `then` is needed after `ensure`. This is called sub-contracting, and we will learn about this later.
			-- This postcondition is completed for you. Do not modify.
			count_is_same:
				count = old count

			case_of_key_found:
				-- TODO: Complete this postcondition.
				-- Hint: If `p_key` exists within the subtree rooted at `Current`,
				-- 		the result must be the value of the node we searched.
				has(p_key) implies Result = root.tree_search (p_key).value

			case_of_key_not_found:
				-- TODO: Complete this postcondition.
				-- Hint: If `p_key` does not exist within the subtree rootd at `Current`,
				-- 		the result must be the value of the node that does not explicitly hold a value.
				not has(p_key) implies Result = (create {TREE_NODE[K, V]}.make_external).value

			consistent_in_orders:
				-- TODO: Complete this postcondition.
				-- Hint 1. Performing in-order traversals before and after the search operation
				-- 		   yield two identical sequences of nodes.
				-- Hint 2. If you want to compare contents two lists, say list1 ~ list2,
				--		   you must make sure that list1.object_comparison and list2.object_comparison are both true.
				--		   e.g., writing `list1.compare_objects` changes `list1.object_comparison` to true.
				-- 		   Otherwise, list1 ~ list2 will only compare references of their stored items.
				-- Hint 3. Rather than comparing two lists directly using ~, you may write a
				--		   logical quantification (universal or existential) to compare them.
				across
					1 |..| count is i
				all
					nodes[i] ~ (old nodes.deep_twin)[i]
				end

				-- Notes to instructor/TAs:
				-- If the students write this postcondition instead of
				-- using across, they must write `Result.compare_objects` in {TREE_NODE}.nodes.
				-- Otherwise, `nodes.object_comparison` is false by default, and we will have
				-- postcondition violations.
				-- Only delete this for the starter code.
				--				nodes ~ old nodes.deep_twin
		end

	insert (p_key: K; p_value: V)
			-- Inserts a new node with the key `p_key` and the value `p_value`.
			-- It is required that `p_key` is not an existing key.
			-- It is expected that after the key-value pair is inserted into the tree,
			-- splay operation(s) are performed from the new node up to the root.
		require else -- In a descendant class, an `else` is needed after `require`. This is called sub-contracting, and we will learn about this later.
			-- This precondition is given to you. Do not modify it.
			no_previously_existing_key:
				not has(p_key)
		local
			l_from_node: TREE_NODE[K, V]
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hint: Refer to the `Problem` and `Tutorials` sections of your lab instructions for details.

			l_from_node := root.tree_search (p_key)	-- We are guranteed to not find a node
													-- (precondition said we don't have a node with the key p_key)
			l_from_node.set_to_internal (p_key, p_value)
			splay(l_from_node)
		ensure then -- In a descendant class, a `then` is needed after `ensure`. This is called sub-contracting, and we will learn about this later.
			size_incremented:
				-- TODO: Complete this postcondition.
				count = old count + 1
			has_inserted_node:
				-- TODO: Complete this postcondition.
				has(p_key)
			other_nodes_unchanged:
				-- TODO: Complete this postcondition.
				-- Hint: Consider comparing the old list of `nodes` (from an in-order traversal) with the new list of `nodes`.
				--		 		Every node except the one that was inserted should be same.
				across
					1 |..| (old count) is i
				all
					attached (old nodes.deep_twin)[i].key as a_k
					and then
					(
						a_k < p_key
						implies
						(old nodes.deep_twin)[i] ~ nodes[i]
					)
					and then
					(
						a_k > p_key
						implies
						(old nodes.deep_twin)[i] ~ nodes[i + 1]
					)
				end
		end

	delete (p_key: K)
		-- Deletes an existing node with the key equal to `p_key`.
		-- Supplier requires that:
		-- 		A node with the key `p_key` exists.
		-- 		This node is an internal node.
		-- See the precondition of {BALANCED_BST}.delete.
		local
			l_node, l_replacement: TREE_NODE[K, V]
			l_parent: detachable TREE_NODE[K, V]
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hint: Refer to the `Problem` and `Tutorials` sections of your lab instructions for details.

			l_node := root.tree_search (p_key) -- guranteed to find it

			splay(l_node)

			if
				attached l_node.left as a_l_node_left and then
				attached l_node.right as a_l_node_right
			then
				if
					a_l_node_left.is_internal and then
					a_l_node_right.is_internal
				then
					root := a_l_node_left
					root.parent := Void
					splay (root.max_node)

					relink (root, a_l_node_right, false)
				elseif
					a_l_node_left.is_internal
				then
					root := a_l_node_left
					root.parent := Void
				else
					root := a_l_node_right
					root.parent := Void
				end
			end
		ensure then -- In a descendant class, a `then` is needed after `ensure`. This is called sub-contracting, and we will learn about this later.
			size_decremented:
				-- TODO: Complete this postcondition.
				count = old count - 1
			has_removed_node:
				-- TODO: Complete this postcondition.
				not has(p_key)
			other_nodes_unchanged:
				-- TODO: Complete this postcondition.
				-- Hint: Consider comparing the old list of `nodes` (from an in-order traversal) with the new list of `nodes`.
				--		 Every node except the one that was deleted should be same.
				across
					1 |..| (old count) is i
				all
					attached (old nodes.deep_twin)[i].key as a_k
					and then
					(
						a_k < p_key
						implies
						(old nodes.deep_twin)[i] ~ nodes[i]
					)
					and then
					(
						a_k > p_key
						implies
						(old nodes.deep_twin)[i] ~ nodes[i - 1]
					)
				end
		end

feature -- Out

	debug_output: STRING
			-- Debugger will show the `Result`.
			-- Do not modify this.
			-- [x<--(1, 1)-->(2, 2), x<--(2, 2)-->x]
		do
			Result := out
		end

	out: STRING
			-- Do not modify this.
			-- [x<--(1, 1)-->(2, 2), x<--(2, 2)-->x]
		do
			Result := "["

			across
				nodes is i_node
			loop
				if
					attached i_node.left as a_left and then
					attached i_node.right as a_right
				then
					Result := Result
						+ a_left.out
						+ "<--"
						+ i_node.out
						+ "-->"
						+ a_right.out
				else
					Result := Result
				end

				if
					i_node /= nodes.last
				then
					Result := Result + ", "
				end
			end

			Result := Result + "]"

		end

invariant
	-- These class invariants are given to you. Do not modify them.
	-- However, you may study them carefully because they
	-- specify the defintions of external vs. internal nodes.

	no_root_means_count_is_zero:
		(root.is_external) = (root.count = 0)

	root_does_not_have_a_parent:
		not attached root.parent

	count_one_or_more_means_root_exists:
		(root.count >= 1) = (root.is_internal)

	nodes_are_sorted:
		across
			1 |..| (root.count - 1) is i
		all
			root.nodes[i] < root.nodes[i + 1]
		end

	left_child_keeps_reference_to_parent:
		(
			across
				nodes is i_node
			all
				attached i_node.left as a_left implies
				a_left.parent = i_node
			end
		)

	right_child_keeps_reference_to_parent:
		(
			across
				nodes is i_node
			all
				attached i_node.right as a_right implies
				a_right.parent = i_node
			end
		)

	left_is_smaller:
		across
			nodes is i_node
		all
			(
				attached i_node.left as a_left and then
				a_left.is_internal
			)
			implies
			a_left < i_node
		end

	right_is_bigger:
		across
			nodes is i_node
		all
			(
				attached i_node.right as a_right and then
				a_right.is_internal
			)
			implies
			i_node < a_right
		end

end
