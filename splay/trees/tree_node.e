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
		-- The two variables `K` and `V` above are called type parameters (`K` for search keys and `V` for data values). A client
		-- or user of the `TREE_NODE` class must specify what `K` and `V` are when declaring a variable. As an example, by
		-- writing `node_1: TREE NODE[INTEGER, PERSON]`, the stored keys are integers and values are references of person
		-- objects. As another example, by writing `node_2: TREE NODE[STRING, REAL]`, the stored keys are references
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
				attached left as a_left    -- if left is not empty then set its parent
			then
				a_left.parent := Current  -- means the parent of left node of this new internal node is current(means this node itself)
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
				-- Hint: `left` is detachable, so for void safety, the compiler
				-- would not allow you to call `left.is_external` directly.
				-- You'd need to make sure that `left`, the call target, is not void.
			   attached left as alan_left
				   and then
       	 	         alan_left.is_external


			right_is_external:
				-- TODO: complete this postcondition.
				-- Hint: See above.
			  attached right as alan_right
				   and then
       	 	         alan_right.is_external


			result_node_is_internal:
				is_internal
		end

feature -- Attributes

	key: detachable K assign set_key   -- can call treenode.key to set key without setter
		-- The keyword `assign` is used to indicate an assigner command `set_key`,
		-- which can set the value of the attribute `key`.
		-- Without the assigner command, the `key` attribute
		-- will never be changed after the initialization of `Current`.

	value: detachable V assign set_value

	parent: detachable like Current assign set_parent  -- parent has all this as well

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
			-- Sets `Current`'s parent.
		do
			parent := p_node
		ensure
			parent = p_node
		end

	set_left (p_node: like left)
			-- Sets `Current`'s left.
		do
			left := p_node
		ensure
			left = p_node
		end

	set_right (p_node: like right)
			-- Sets `Current`'s right.
		do
			right := p_node
		ensure
			right = p_node
		end

	set_key (p_key: like key)
			-- Sets `Current`'s key.
		do
			key := p_key
		ensure
			key = p_key
		end

	set_value (p_value: like value)
			-- Sets `Current`'s value.
		do
			value := p_value
		ensure
			value = p_value
		end

	set_to_internal (p_key: K; p_value: V)
			-- Transforms the current external node to be an internal node storing `p_key` and `p_value`.
		require
			is_external
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hints: You must transform the external `Current` node to an internal node that has
			--		  `p_key` and `p_value`. Think about the difference between the definition of
			-- 		  an internal node and an external node. Make sure to satisfy the postconditions.
           current.key := p_key
           current.value := p_value

           create left.make_external

			if
				attached left as a_left    -- if left is not empty then set its parent else if left is external node so parent void
			then
				a_left.parent := Current  -- means the parent of left node of this new internal node is current(means this node itself)
			end

		   create right.make_external

			if
				attached right as a_right
			then
				a_right.parent := Current
			end

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
			-- e.g., `{STARTER_TESTS}.env_int_int`
		require
			p_node_is_inertnal_node:
				p_node.is_internal
			smaller_than_Current:
				p_node < Current
			left_is_external:
				-- TODO: Complete this precondition.
				-- Hint: left child must be external.
				attached left as alan_left
				   and then
       	 	         alan_left.is_external

		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			  Current.set_left (p_node)
              p_node.set_parent (Current)

		ensure
			left_is_assigned:
				-- TODO: Complete this postcondition.
				-- Hint: `Current`'s left child must be `p_node`.
				attached left as al_left
				and then
				left ~ p_node

			keep_left_parent_reference:
				-- TODO: Complete this postcondition.
				-- Hint: The left child keeps its parent reference correctly.
				p_node.parent ~ Current
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
				attached right as alan_right
				   and then
       	 	         alan_right.is_external
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
              Current.set_right (p_node)
              p_node.set_parent (Current)

		ensure
			right_is_assigned:
				-- TODO: Complete this postcondition.
				-- Hint: `Current`'s right child must be `p_node`.
				right ~ p_node

			keep_right_parent_reference:
				-- TODO: Complete this postcondition.
				-- Hint: The right child keeps its parent reference correctly.
				p_node.parent ~ Current
		end

feature -- Status Query

	is_external: BOOLEAN
			-- Is the `Current` node external node? ( Does this node have both `left` and `right` not attached? )
		do
			-- This implementation is given to you. Do not modify.
			Result := not attached left and not attached right
		ensure
			has_no_children:
				-- This postcondition is completed for you. Do not modify.
				Result = (not attached left and not attached right)
		end

	is_internal: BOOLEAN
			-- Is the `Current` node internal node? ( Does this node have either `left` and `right` attached? )
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
            Result := count_helper(Current)
		ensure
			correct_result:

				-- TODO: Complete this postcondition.
				-- Hint: the return value of this query (`Result`) is the same as the size
				-- of the linear version (`nodes`) of the tree rooted at `Current`.
				  Result = Current.nodes.count

		end

	count_helper(p_node: like Current.left): INTEGER
	   local
	      l1,l2 : INTEGER
	   do
	     check attached p_node as ls_node  then
	     	if ls_node.is_external then
	   	  	   Result := 0
	   	    else
	   	     l1 := 1+ count_helper(ls_node.left)   -- recursion logic taken from height of tree from EECS 2011 Winter 2020 lecture slide
	   	     l2 := 1+ count_helper(ls_node.right)
	   	     Result := l1 + l2 - 1
	   	    end

	   	  end
	   end

	min_node: TREE_NODE[K, V]
			-- Returns the node with minimum key from the tree rooted at `Current`.
		require
			current_is_not_external:
				not is_external
		do
			-- TODO: Implement this query so that the postcondition is satisfied.
			create Result.make_external
			Result := min_node_helper(Current)
		ensure
			left_external_means_current_is_minimum:
				-- TODO: Complete this postcondition.
				-- Hint: `left` being external means `Current` is a leaf node.
				attached Current.left as ls_left and then
			     	(ls_left.is_external implies (Result = Current))

			result_is_minimum_in_this_subtree:
				-- TODO: Complete this postcondition.
				-- Hint: the `Result` is the smallest node among all the descendants.
				Result = min_node_postcond(Current)

			result_is_internal:
				-- This postcondition is completed for you. Do not modify.
				Result.is_internal
		end

	min_node_helper(p_node : like Current.left): TREE_NODE[K, V]

        local
        	temp: TREE_NODE[K, V]
        	b : BOOLEAN
	    do

          check attached p_node as ls_node  then
          	temp := ls_node
            check attached ls_node.left as ls_left then
            	b := not (ls_left.is_external)
                if b then
	     		    temp := min_node_helper(ls_node.left)
	     	    end
            end

            Result := temp
	   	  end
	    end

	    min_node_postcond(p_node : like Current.left): TREE_NODE[K, V]

        local
        	temp: TREE_NODE[K, V]
        	b : BOOLEAN
	    do

          check attached p_node as ls_node  then
          	temp := ls_node
            check attached ls_node.left as ls_left then
            	b := not (ls_left.is_external)
                if b then
	     		    temp := min_node_helper(ls_node.left)
	     	    end
            end

            Result := temp
	   	  end
	    end

	max_node: TREE_NODE[K, V]
			-- Returns the node with maximum key from the tree rooted at `Current`.
		require
			current_is_not_external:
				not is_external
		do
			-- TODO: Implement this query so that the postcondition is satisfied.
			create Result.make_external
			Result := max_node_helper(Current)
		ensure
			right_external_means_current_is_maximum:
				-- TODO: Complete this postcondition.
				-- Hint: `right` being external means `Current` is a leaf node.
			  attached Current.right as ls_right and then
			     	(ls_right.is_external implies (Result = Current))



			result_is_maximum_in_this_subtree:
				-- TODO: Complete this postcondition.
				-- Hint: the `Result` is the biggest node among all the descendants.
				Result = max_node_postcond(Current)

			result_is_internal:
				-- This postcondition is completed for you. Do not modify.
				Result.is_internal
		end

    max_node_helper(p_node : like Current.left): TREE_NODE[K, V]

        local
        	temp: TREE_NODE[K, V]
        	b : BOOLEAN
	    do

          check attached p_node as ls_node  then
          	temp := ls_node
            check attached ls_node.right as ls_right then
            	b := not (ls_right.is_external)
                if b then
	     		    temp := max_node_helper(ls_node.right)
	     	    end
            end

            Result := temp
	   	  end
	    end

	max_node_postcond(p_node : like Current.left): TREE_NODE[K, V]

        local
        	temp: TREE_NODE[K, V]
        	b : BOOLEAN
	    do

          check attached p_node as ls_node  then
          	temp := ls_node
            check attached ls_node.right as ls_right then
            	b := not (ls_right.is_external)
                if b then
	     		    temp := max_node_helper(ls_node.right)
	     	    end
            end

            Result := temp
	   	  end
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
			create Result.make_external
			Result := tree_search_helper(Current, p_key)

		ensure
			case_of_key_found:
				-- TODO: Complete this postcondition.
				-- Hint: When we found the node, the result must be the current node due to the recursive
				-- nature of this query.
				 (not Current.is_external) implies (Result ~ tree_search_helper(Current, p_key))   -- CHECK

			case_of_key_not_found:
				-- TODO: Complete this postcondition.
				-- Hint: If the node is external, it means the `Result` must be the current node.
				 Current.is_external implies (Result = Current)


		end

		tree_search_helper(p_node : like Current.left ; k: K): TREE_NODE[K, V]   -- tree search logic taken fromEECS 2011 lecture notes Summer 2020

		  do
              create Result.make_external
              if attached p_node as ls_node then

                if attached ls_node.key as ls_key then

			      if ls_node.is_external then
                       Result := ls_node
			      else
--               ls_key.is_greater (p_key)
                    if ls_key.is_equal (k) then  --case1
                      Result := ls_node
                    elseif k.is_less (ls_key) then  -- case 2
                      Result := tree_search_helper(ls_node.left, k)
                    else -- case 3
                      Result := tree_search_helper(ls_node.right, k)
                    end
                  end
			    end

              end

		  end

	value_search (p_key: K): detachable V
			-- Returns mapped value from the key `p_key` from an internal node
			-- by searching the subtree rooted at `Current`.
		local
			node : TREE_NODE[K, V]
		do
			-- TODO: Implement this query so that the postcondition is satisfied.
			-- Hint: Think of various cases of search for `p_key`.
			node := tree_search(p_key)
			Result := node.value

		ensure
			case_of_key_found:
				-- TODO: Complete this postcondition.
				-- Hint: `p_key` existing means that the return value is same as one we find within
				-- 		 the same tree.
				Result = tree_search(p_key).value

			-- We do not worry about specifying the other case (`case_of_key_not_found`).
			-- As an optional exercise, you are encouraged to think about how you might write it.
		end

	has (p_key: K): BOOLEAN
			-- Returns true if the subtree rooted at `Current` has an internal node with
			-- the key `p_key` among its descendants. Returns false otherwise.
		local
			node : TREE_NODE[K, V]
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hint: Think of various cases of search for `p_key`.
           node := tree_search(p_key)

           --check attached node as ls_node then

             if node.is_external then
             	Result := false
             else
             	Result := true
             end

           --end

		ensure
			correct_search_result:
				-- TODO: Complete this postcondition.
				-- Hint: Result must be same as if we found the `p_key` from subtree rooted at `Current`.
				Result = has_postcond(p_key)
		end

		has_postcond(p_key: K):BOOLEAN
        local
			node : TREE_NODE[K, V]
		do
		     node := tree_search(p_key)
             if node.is_external then
             	Result := false
             else
             	Result := true
             end
		end

	has_node (p_node: TREE_NODE[K,V]): BOOLEAN
			-- Returns true if the subtree rooted at `Current` has
			-- an internal node with the same key as `p_node` among its descendants.
			-- Returns false otherwise.
		local
			node : TREE_NODE[K, V]
			k : detachable K
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hint: You may use previous queries.
			--check attached ls_node.key as ls_key then
			k := p_node.key
            Result := has_node_helper(Current,p_node)

		ensure
			correct_search_result:
				-- TODO: Complete this postcondition.
				-- Hint: Result must be same as the internal node we found from subtree rooted at `Current` with the key `p_key`.
				Result ~ has_node_helper(Current,p_node)
		end

	has_node_helper(p_node : like Current.left ; other_node: like Current.left): BOOLEAN

		  do
              --create Result.make_external
              check attached p_node as ls_node then

                check attached other_node as ls_other then

			      if ls_node.is_external then
                       Result := false
			      else
--               ls_key.is_greater (p_key)
                     if  ls_node.is_equal(ls_other) then     -- node equate logic taken fromEECS 2011 lecture notes Summer 2020
                       Result := true                        -- Pre order traversal logic learned from EECS 2011 Lecture slides Summer 2020
                     else
                        if has_node_helper(ls_node.left, ls_other) then  -- no need to go further if found alreay found the node
                      	  Result := true
                        else
                      	  Result := has_node_helper(ls_node.right, ls_other)
                        end

                     end
                  end
			    end

              end

		  end

feature -- Conversion

	nodes: LIST[TREE_NODE[K, V]]
			-- Returns a linear ordering of nodes which corresponds to
			-- an in-order traversal of the tree rooted at Current.
		local
		  ss: INTEGER
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hint: To satisfy the void safety required by the compiler,
			-- you must first initialize the return value `Result`.
			-- Notice that the static return type of this query is a deferred class `LIST`,
			-- to create an object, you must use one of its effective descendant classes.

			create {LINKED_LIST[TREE_NODE[K, V]]} Result.make
			Result.compare_objects
			ss := Result.count

			if Current.is_internal then
			    nodes_helper(Current,Result)
			end

		ensure
			number_of_nodes_not_changed:
				-- This postcondition is completed for you. Do not modify.
				count = old count
			inorder_means_result_is_sorted_incrementally:
				-- TODO: Complete this postcondition.
				across
					1 |..| (Result.count - 1) is i
				all
					Result[i] <= Result[i+1]
				end

			no_tree_structure_changed:
				-- TODO: Complete this postcondition.
				-- Hint 1: the tree rooted at Current **before** calling `nodes` has
				-- the same structure (defined by `is_same_tree`) as that **after** calling `nodes`.
				-- Hint 2: Invoking `is_same_tree(node)` is effectively invoking `Current.is_same_tree(node)`.
				Current.is_same_tree(old Current)
		end

	 nodes_helper(p_node : like Current.left; list: LIST[TREE_NODE[K, V]] )

	    do

          if attached p_node as ls_node  then   -- why p_node is empty

          	if attached ls_node.left as ls_left then
                if not (ls_left.is_external) then
	     		    nodes_helper(ls_node.left, list)
	     	    end
            end
            list.extend (ls_node)                      -- Inorder traversal logic learned from EECS 2011 LEcture slides Summer 2020
            if attached ls_node.right as ls_right then
                if not (ls_right.is_external) then
	     		    nodes_helper(ls_node.right , list)
	     	    end
            end
	   	  end
	    end

feature -- Helper features for postconditions

	is_same_tree(other: TREE_NODE[K, V]): BOOLEAN
			-- Is the tree rooted at Current same (in terms of structure) as tree rooted at other?
		do
			-- TODO: Implement this command so that the postcondition is satisfied.
			-- Hint: `Current` and `other` denote the same tree if:
			-- 1. `Current` and `other` are the same node (by content, not refernce).
			-- 			Notice that `is_less_than` is already implemented for you.
			--			According to `COMPARABLE`, parent of `TREE_NODE`, `is_equal` is then
			--			defined as: n1.is_equal(n2) <=> not (n1 < n2) and not (n2 < n2).
			--			That is, you can just use ~ to compare the two nodes.
			-- 2. Recursively, `Current`'s left subtree, if existing, is the same tree as other's left subtree, if existing.
			--		And similarly for the `Current`'s right subtree and `other`'s right subtree.
         Result := is_same_tree_helper(Current , other)

		end

	is_same_tree_helper(p_node: detachable TREE_NODE[K, V] ; other_node: like Current.left) : BOOLEAN
        local
        	l1 : BOOLEAN
        	l2,l3,l4 : BOOLEAN
	    do
	      if attached p_node as ls_node  then
	        if attached other_node as ls_other  then
	          if (ls_other.is_external and then ls_node.is_external) then -- if they are same structurally ad nodes
                    Result := true
	    	  else
                l3 := ((not ls_node.is_external) and then ls_other.is_external )
                l4 := (ls_node.is_external and then (not ls_other.is_external))
	    	    if ( l4 or l3 ) then
	    	    	Result := false
	    	    else

	    	      l1 := is_same_tree_helper(ls_node.left,ls_other.left)
	    	      l2 := is_same_tree_helper(ls_node.right,ls_other.right)
	    	      Result := (ls_other ~ ls_node) and then l1 and then l2   -- see that 2 nodes are same
	    	      --end
	    	    end
	    	  end
	        end
	      end

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
