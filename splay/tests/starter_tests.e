note
	description: "Starter test cases."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	STARTER_TESTS

inherit
	TEST_ENVIRONMENT

create
	make

feature {NONE} -- Initialization

	make
			-- initialize tests
		do
			env_empty

			add_make_external_tests
			add_make_internal_tests
			add_set_to_internal_tests
			add_insert_left_tests
			add_insert_right_tests
			add_count_tests
			add_min_node_tests
			add_max_node_tests
			add_tree_search_tests
			add_value_search_tests
			add_has_tests
			add_has_node_tests
			add_nodes_tests
			add_is_same_tree_tests

			add_splay_has_tests
			add_splay_has_node_tests
			add_splay_count_tests
			add_splay_is_empty_tests
			add_splay_relink_tests
		end

feature -- make_external

	add_make_external_tests
		do
			add_boolean_case (agent tn_make_external2)
			add_boolean_case (agent tn_make_external3)
		end

	tn_make_external3: BOOLEAN
		local
			l_tree_node: TREE_NODE[STRING, STRING]
		do
			comment ("tn_make_external3: make string key value then check if key value are not attached")

			create l_tree_node.make_external

			Result := not attached l_tree_node.key and not attached l_tree_node.value
		end

	tn_make_external2: BOOLEAN
		local
			l_tree_node: TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_make_external2: make then check left right not attached")

			create l_tree_node.make_external

			Result := not attached l_tree_node.left and not attached l_tree_node.right
		end

feature -- make_internal

	add_make_internal_tests
		do
			add_boolean_case (agent tn_make_internal3)
		end

	tn_make_internal3: BOOLEAN
		local
			l_tree_node: TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_make_internal3: make then check key and value")

			create l_tree_node.make_internal (1, 1)

			Result := l_tree_node.value = 1 and l_tree_node.key = 1
		end

feature -- set_to_internal

	add_set_to_internal_tests
		do
			add_boolean_case (agent tn_set_to_internal1)
		end

	tn_set_to_internal1: BOOLEAN
		local
			l_node: like root_int_int
		do
			comment ("tn_set_to_internal1: make external node, set it an internal node")

			create l_node.make_external

			l_node.set_to_internal(1,1)

			Result :=
				l_node.key = 1
				and
				l_node.value = 1
				and
				attached l_node.left as a_l_node_left and then
				a_l_node_left.is_external
				and
				attached l_node.right as a_l_node_right and then
				a_l_node_right.is_external
		end

feature -- insert_left

	add_insert_left_tests
		do
			add_violation_case_with_tag ("left_is_external", agent tn_insert_left1)
			add_boolean_case (agent tn_insert_left4)
		end

	tn_insert_left4: BOOLEAN
		local
			l_left_node, l_tree_node: TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_insert_left4: make two internal node and insert one to left")

			create l_tree_node.make_internal (5, 5)
			create l_left_node.make_internal (1, 1)

			l_tree_node.insert_left(l_left_node)

			Result :=
				l_tree_node.left ~ l_left_node
				and
				l_left_node.parent ~ l_tree_node
		end

	tn_insert_left1
		local
			l_tree_node1, l_tree_node2, l_tree_node3: TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_insert_left1: PRECONDITION, insert_left, left_is_external")

			create l_tree_node1.make_internal(1, 1)
			create l_tree_node2.make_internal(2, 2)
			create l_tree_node3.make_internal(3, 3)

			l_tree_node3.insert_left(l_tree_node2)
			l_tree_node3.insert_left(l_tree_node1)
		end

feature -- insert_right

	add_insert_right_tests
		do
			add_violation_case_with_tag ("right_is_external", agent tn_insert_right1)
			add_boolean_case(agent tn_insert_right4)
		end

	tn_insert_right4: BOOLEAN
		local
			l_right_node, l_tree_node: TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_insert_right4: make two internal node and insert one to right")

			create l_tree_node.make_internal (5, 5)
			create l_right_node.make_internal (10, 10)

			l_tree_node.insert_right(l_right_node)

			Result := l_tree_node.right ~ l_right_node and l_right_node.parent ~ l_tree_node

		end

	tn_insert_right1
		local
			l_tree_node1, l_tree_node2, l_tree_node3: TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_insert_right1: PRECONDITION, insert_right, right_is_external")

			create l_tree_node1.make_internal(1, 1)
			create l_tree_node2.make_internal(2, 2)
			create l_tree_node3.make_internal(3, 3)

			l_tree_node1.insert_right(l_tree_node2)
			l_tree_node1.insert_right(l_tree_node3)
		end

feature -- count

	add_count_tests
		do
			add_boolean_case (agent tn_count2)
			add_boolean_case (agent tn_count3)
		end

	tn_count3: BOOLEAN
		do
			comment ("tn_count3: env_empty, check if count is 0")

			env_empty

			Result := root_int_int.count = 0
		end

	tn_count2: BOOLEAN
		do
			comment ("tn_count2: env_int_int, check if root count is same as node list count")

			env_int_int

			Result := root_int_int.count = node_list_int_int.count
		end

feature -- min_node

	add_min_node_tests
		do
			add_boolean_case (agent tn_min_node2)
		end

	tn_min_node2: BOOLEAN
		do
			comment ("tn_min_node2: env_int_int, min nodes from subtrees")

			env_int_int

			Result :=
				node_list_int_int[1].min_node = node_list_int_int[1]
				and
				node_list_int_int[2].min_node = node_list_int_int[1]
				and
				node_list_int_int[7].min_node = node_list_int_int[5]
				and
				root_int_int.min_node = node_list_int_int[1]
		end

feature -- max_node

	add_max_node_tests
		do
			add_boolean_case (agent tn_max_node2)
		end

	tn_max_node2: BOOLEAN
		local
		do
			comment ("tn_max_node2: env_int_int, max nodes from subtrees")

			env_int_int

			Result :=
				node_list_int_int[1].max_node = node_list_int_int[1]
				and
				node_list_int_int[2].max_node = node_list_int_int[3]
				and
				node_list_int_int[7].max_node = node_list_int_int[9]
				and
				root_int_int.max_node = node_list_int_int[9]
		end

feature -- tree_search

	add_tree_search_tests
		do
			add_boolean_case (agent tn_tree_search3)
			add_boolean_case (agent tn_tree_search4)
			add_boolean_case (agent tn_tree_search5)
			add_boolean_case (agent tn_tree_search6)
			add_boolean_case (agent tn_tree_search7)
		end

	tn_tree_search7: BOOLEAN
		do
			comment ("tn_tree_search7: env_int_int, tree searches key less than minimum and bigger than maximum")

			env_int_int

			Result :=
				root_int_int.tree_search (-999) = node_list_int_int[1].left
				and
				root_int_int.tree_search (999) = node_list_int_int.last.right
		end

	tn_tree_search6: BOOLEAN
		do
			comment ("tn_tree_search6: env_int_int, tree searches for all the nodes in the tree")

			env_int_int

			Result :=
				across
					1 |..| node_list_int_int.count is i
				all
					root_int_int.tree_search (i) = node_list_int_int[i]
				end
		end

	tn_tree_search5: BOOLEAN
		local
			l_node: TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_tree_search5: search left `-420` and `1337` from a tree with an internal node with a key `1`")

			create l_node.make_internal(1, 1)

			Result :=
				l_node.tree_search (-420) = l_node.left
				and
				l_node.tree_search (1337) = l_node.right
		end

	tn_tree_search4: BOOLEAN
		local
			l_node: TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_tree_search4: search `1` from the tree with an internal node with key `1`")

			create l_node.make_internal(1, 1)

			Result := l_node.tree_search (1) = l_node
		end

	tn_tree_search3: BOOLEAN
		local
			l_node: TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_tree_search3: search `1` from the tree with an external node")

			create l_node.make_external

			Result := l_node.tree_search (1) = l_node
		end

feature -- value_search

	add_value_search_tests
		do
			add_boolean_case (agent tn_value_search2)
			add_boolean_case (agent tn_value_search3)
		end

	tn_value_search3: BOOLEAN
		local
			l_node: like root_int_int
		do
			comment ("tn_value_search3: env_int_int, value search non-existing keys")

			env_int_int

			create l_node.make_external

			Result :=
				root_int_int.value_search (-999) = l_node.value
				and
				root_int_int.value_search (999) = l_node.value
		end

	tn_value_search2: BOOLEAN
		do
			comment ("tn_value_search2: env_int_int, value search all of node list")

			env_int_int

			Result :=
				across
					1 |..| node_list_int_int.count is i
				all
					root_int_int.value_search(i) = i
				end
		end

feature -- has

	add_has_tests
		do
			add_boolean_case (agent tn_has2)
			add_boolean_case (agent tn_has3)
		end

	tn_has3: BOOLEAN
		do
			comment ("tn_has3: env_int_int, check if the tree has a node with key 15 and -5 (which don't exist) ")

			env_int_int

			Result :=
				(root_int_int.has(15) = false)
				and
				(root_int_int.has(-5) = false)
		end

	tn_has2: BOOLEAN
		do
			comment ("tn_has2: env_int_int, check if all nodes in node list exist in the tree")

			env_int_int

			Result :=
				across
					1 |..| node_list_int_int.count is i
				all
					root_int_int.has(i)
				end
		end

feature -- has_node

	add_has_node_tests
		do
			add_boolean_case (agent tn_has_node2)
			add_boolean_case (agent tn_has_node3)
		end

	tn_has_node3: BOOLEAN
		local
			l_node_list: like node_list_int_int
		do
			comment ("tn_has_node3: env_int_int, check if different nodes with same keys evaluate `has_node` true in the tree")

			env_int_int

			l_node_list := node_list_int_int.deep_twin

			Result :=
				across
					l_node_list is i_node
				all
					root_int_int.has_node (i_node)
				end
		end

	tn_has_node2: BOOLEAN
		do
			comment ("tn_has_node2: env_int_int, check if all node_list_int_int nodes `has_node` in the tree")

			env_int_int

			Result :=
				across
					node_list_int_int is i_node
				all
					root_int_int.has_node (i_node)
				end
		end

feature -- nodes

	add_nodes_tests
		do
			add_boolean_case (agent tn_nodes3)
		end

	tn_nodes3: BOOLEAN
		local
			l_nodes: like root_int_int.nodes
		do
			comment ("tn_nodes3: env_int_int, check if `nodes` is sorted")

			env_int_int

			l_nodes := bst_int_int.nodes
			--l_nodes := root_int_int.nodes

			Result :=
				across
					1 |..| (l_nodes.count - 1) is i
				all
					l_nodes[i] <= l_nodes[i+1]
				end
		end


feature -- is_same_tree

	add_is_same_tree_tests
		do
			add_boolean_case (agent tn_is_same_tree1)
			add_boolean_case (agent tn_is_same_tree2)
			add_boolean_case (agent tn_is_same_tree3)
			add_boolean_case (agent tn_is_same_tree4)
		end

	tn_is_same_tree4: BOOLEAN
		local
			l_1, l_2, l_3, l_4, l_5, l_6, l_7, l_8: TREE_NODE[STRING, STRING]
			l2_1, l2_2, l2_3, l2_4, l2_5, l2_6, l2_7: TREE_NODE[STRING, STRING]
		do
			comment ("tn_is_same_tree4: string tree clone with maximum removed")

			create l_1.make_internal ("a", "a")
			create l_2.make_internal ("b", "b")
			create l_3.make_internal ("c", "c")
			create l_4.make_internal ("d", "d")
			create l_5.make_internal ("e", "e")
			create l_6.make_internal ("f", "f")
			create l_7.make_internal ("g", "g")
			create l_8.make_internal ("h", "h")


			l_2.insert_left (l_1)
			l_2.insert_right (l_3)

			l_6.insert_left (l_5)


			l_7.insert_left (l_6)
			l_7.insert_right (l_8)

			l_4.insert_left (l_2)
			l_4.insert_right (l_7)

			create l2_1.make_internal ("a", "a")
			create l2_2.make_internal ("b", "b")
			create l2_3.make_internal ("c", "c")
			create l2_4.make_internal ("d", "d")
			create l2_5.make_internal ("e", "e")
			create l2_6.make_internal ("f", "f")
			create l2_7.make_internal ("g", "g")


			l2_2.insert_left (l2_1)
			l2_2.insert_right (l2_3)

			l2_6.insert_left (l2_5)


			l2_7.insert_left (l2_6)

			l2_4.insert_left (l2_2)
			l2_4.insert_right (l2_7)

			Result := not l_4.is_same_tree(l2_4)
		end

	tn_is_same_tree3: BOOLEAN
		local
			l_1, l_2, l_3, l_4, l_5, l_6, l_7, l_8: TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_is_same_tree3: env_int_int clone with maximum removed")

			env_int_int

			create l_1.make_internal (1, 1)
			create l_2.make_internal (2, 2)
			create l_3.make_internal (3, 3)
			create l_4.make_internal (4, 4)
			create l_5.make_internal (5, 5)
			create l_6.make_internal (6, 6)
			create l_7.make_internal (7, 7)
			create l_8.make_internal (8, 8)

			l_2.insert_left (l_1)
			l_2.insert_right (l_3)

			l_6.insert_left (l_5)


			l_7.insert_left (l_6)
			l_7.insert_right (l_8)

			l_4.insert_left (l_2)
			l_4.insert_right (l_7)

			Result := not l_4.is_same_tree(root_int_int)
		end

	tn_is_same_tree2: BOOLEAN
		local
			l_2, l_3, l_4, l_5, l_6, l_7, l_8, l_9: TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_is_same_tree2: env_int_int clone with minimum removed")

			env_int_int

			create l_2.make_internal (2, 2)
			create l_3.make_internal (3, 3)
			create l_4.make_internal (4, 4)
			create l_5.make_internal (5, 5)
			create l_6.make_internal (6, 6)
			create l_7.make_internal (7, 7)
			create l_8.make_internal (8, 8)
			create l_9.make_internal (9, 9)

			l_2.insert_right (l_3)

			l_6.insert_left (l_5)

			l_8.insert_right (l_9)

			l_7.insert_left (l_6)
			l_7.insert_right (l_8)

			l_4.insert_left (l_2)
			l_4.insert_right (l_7)

			Result := not l_4.is_same_tree(root_int_int)
		end

	tn_is_same_tree1: BOOLEAN
		local
			l_1, l_2, l_3, l_4, l_5, l_6, l_7: TREE_NODE[INTEGER, INTEGER]
			l2_1, l2_2, l2_3, l2_4, l2_5, l2_6, l2_7: TREE_NODE[INTEGER, INTEGER]
		do
			comment ("tn_is_same_tree1: create two trees with same keys and structure and check between roots")

			create l_1.make_internal (1, 1)
			create l_2.make_internal (2, 2)
			create l_3.make_internal (3, 3)
			create l_4.make_internal (4, 4)
			create l_5.make_internal (5, 5)
			create l_6.make_internal (6, 6)
			create l_7.make_internal (7, 7)

			l_2.insert_left (l_1)
			l_2.insert_right (l_3)

			l_6.insert_left (l_5)
			l_6.insert_right (l_7)

			l_4.insert_left (l_2)
			l_4.insert_right (l_6)

			create l2_1.make_internal (1, 1)
			create l2_2.make_internal (2, 2)
			create l2_3.make_internal (3, 3)
			create l2_4.make_internal (4, 4)
			create l2_5.make_internal (5, 5)
			create l2_6.make_internal (6, 6)
			create l2_7.make_internal (7, 7)

			l2_2.insert_left (l2_1)
			l2_2.insert_right (l2_3)

			l2_6.insert_left (l2_5)
			l2_6.insert_right (l2_7)

			l2_4.insert_left (l2_2)
			l2_4.insert_right (l2_6)

			Result := l_4.is_same_tree(l2_4)
		end

feature -- splay_has

	add_splay_has_tests
		do
			add_boolean_case (agent splay_has1)
			add_boolean_case (agent splay_has2)
			add_boolean_case (agent splay_has3)
			add_boolean_case (agent splay_has4)
		end

	splay_has4: BOOLEAN
		local
			l_array: ARRAY[STRING]
		do
			comment ("splay_has4: env_root_insert_str_str, `has` on keys that do not exist in the tree")

			env_root_insert_str_str

			l_array := <<"america", "zone", "abc", "Canada", "A">>

			Result :=
				across
					l_array is i_item
				all
					not bst_str_str.has (i_item)
				end
		end

	splay_has3: BOOLEAN
		local
			l_nodes: like bst_str_str.nodes
		do
			comment ("splay_has3: env_root_insert_str_str, check `has` on all nodes the tree have")

			env_root_insert_str_str

			l_nodes := bst_str_str.nodes

			Result :=
				across
					l_nodes is i_node
				all
					attached i_node.key as a_i_node_key and then
					bst_str_str.has(a_i_node_key)
				end
		end

	splay_has2: BOOLEAN
		local
			l_array: ARRAY[INTEGER]
		do
			comment ("splay_has2: env_root_insert_int_int, `has` on keys that do not exist in the tree")

			env_root_insert_int_int

			l_array := <<-999, -450, 0, 500, 1000>>

			Result :=
				across
					l_array is i_item
				all
					not bst_int_int.has (i_item)
				end
		end

	splay_has1: BOOLEAN
		local
			l_nodes: like bst_int_int.nodes
		do
			comment ("splay_has1: env_root_insert_int_int, check `has` on all nodes the tree have")

			env_root_insert_int_int

			l_nodes := bst_int_int.nodes

			Result :=
				across
					l_nodes is i_node
				all
					attached i_node.key as a_i_node_key and then
					bst_int_int.has(a_i_node_key)
				end
		end

feature -- splay_has_node

	add_splay_has_node_tests
		do
			add_boolean_case (agent splay_has_node1)
			add_boolean_case (agent splay_has_node2)
			add_boolean_case (agent splay_has_node3)
			add_boolean_case (agent splay_has_node4)
		end

	splay_has_node4: BOOLEAN
		local
			l_array: ARRAY[STRING]
			l_node_array: ARRAY[TREE_NODE[STRING, STRING]]
		do
			comment ("splay_has_node4: env_root_insert_str_str, `has_node` on keys that do not exist in the tree")

			env_root_insert_str_str

			l_array := <<"america", "zone", "abc", "Canada", "A">>

			create l_node_array.make_empty

			across
				l_array is i
			loop
				l_node_array.force (create {TREE_NODE[STRING, STRING]}.make_internal (i, i), l_node_array.count + 1)
			end

			Result :=
				across
					l_node_array is i_item
				all
					not bst_str_str.has_node (i_item)
				end
		end

	splay_has_node3: BOOLEAN
		local
			l_nodes: like bst_str_str.nodes
		do
			comment ("splay_has_node3: env_root_insert_str_str, check `has_node` on all nodes the tree have")

			env_root_insert_str_str

			l_nodes := bst_str_str.nodes

			Result :=
				across
					l_nodes is i_node
				all
					bst_str_str.has_node (i_node)
				end
		end

	splay_has_node2: BOOLEAN
		local
			l_array: ARRAY[INTEGER]
			l_node_array: ARRAY[TREE_NODE[INTEGER, INTEGER]]
		do
			comment ("splay_has_node2: env_root_insert_int_int, `has_node` on keys that do not exist in the tree")

			env_root_insert_int_int

			l_array := <<-999, -450, 0, 500, 1000>>

			create l_node_array.make_empty

			across
				l_array is i
			loop
				l_node_array.force (create {TREE_NODE[INTEGER, INTEGER]}.make_internal (i, i), l_node_array.count + 1)
			end

			Result :=
				across
					l_node_array is i_item
				all
					not bst_int_int.has_node (i_item)
				end
		end

	splay_has_node1: BOOLEAN
		local
			l_nodes: like bst_int_int.nodes
		do
			comment ("splay_has_node1: env_root_insert_int_int, check `has_node` on all nodes the tree have")

			env_root_insert_int_int

			l_nodes := bst_int_int.nodes

			Result :=
				across
					l_nodes is i_node
				all
					bst_int_int.has_node (i_node)
				end
		end

feature -- splay_count

	add_splay_count_tests
		do
			add_boolean_case (agent splay_count1)
			add_boolean_case (agent splay_count2)
			add_boolean_case (agent splay_count3)

		end

	splay_count3: BOOLEAN
		do
			comment ("splay_count3: env_root_insert_str_str, check count")

			env_root_insert_str_str

			Result := bst_str_str.count = 9
		end

	splay_count2: BOOLEAN
		do
			comment ("splay_count2: env_root_insert_int_int, check count")

			env_root_insert_int_int

			Result := bst_int_int.count = 9
		end

	splay_count1: BOOLEAN
		do
			comment ("splay_count1: env_empty, check count")

			env_empty

			Result := bst_int_int.count = 0 and bst_str_str.count = 0
		end

feature -- splay_is_empty

	add_splay_is_empty_tests
		do
			add_boolean_case(agent splay_is_empty1)
		end

	splay_is_empty1: BOOLEAN
		local
		do
			comment ("splay_is_empty1: env_empty, check if empty")

			env_empty

			Result := bst_int_int.is_empty and bst_str_str.is_empty
		end

feature -- splay_relink

	add_splay_relink_tests
		do
			add_boolean_case (agent splay_relink4)
			add_boolean_case (agent splay_relink5)
		end

	splay_relink5: BOOLEAN
		local
			l_node: TREE_NODE[STRING, STRING]
		do
			comment ("splay_relink5: relinking root right child")

			env_root_insert_str_str

			create l_node.make_internal ("k", "k")
			bst_str_str.relink (bst_str_str.root, l_node, False)

			Result :=
				bst_str_str.root.max_node.key ~ "k"
		end

	splay_relink4: BOOLEAN
		local
			l_node: TREE_NODE[STRING, STRING]
		do
			comment ("splay_relink4: relinking root left child")

			env_root_insert_str_str

			create l_node.make_internal ("c", "c")
			bst_str_str.relink (bst_str_str.root, l_node, True)

			Result :=
				bst_str_str.root.min_node.key ~ "c"
		end

end
