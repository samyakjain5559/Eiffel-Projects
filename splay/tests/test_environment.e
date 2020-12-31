note
	description: "Test envrionment for test cases."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	TEST_ENVIRONMENT

inherit
	ES_TEST

feature {TEST_ENVIRONMENT}

	make
		deferred
		end


feature {ES_TEST} -- Test attribute

	bst_int_int: SPLAY_TREE [INTEGER, INTEGER]
		-- Splay tree with INTEGER key and INTEGER value.

	bst_str_str: SPLAY_TREE [STRING, STRING]
		-- Splay tree with STRING key and STRING value.

	root_int_int: TREE_NODE[INTEGER, INTEGER]
		-- A TREE_NODE root node.

	node_list_int_int: LIST[like root_int_int]
		-- List of all roots in the tree rooted at root_int_int.

feature {ES_TEST} -- TREE_NODE Test environment

	env_empty
		do
			create bst_int_int.make
			create bst_str_str.make

			create root_int_int.make_external
			create {ARRAYED_LIST[like root_int_int]} node_list_int_int.make (10)
		end

	env_int_int
		-- pre-req: make_internal, insert_left, insert_right
		-- Create a tree like this:
		--          4
		--         / \
		--        2   7
		--       / \ / \
		--      1  3 6  8
		--          /    \
		--         5      9
		-- and inserts the nodes into node_list_int_int
		-- and sets root_int_int with node 4.
		local
			l_1, l_2, l_3, l_4, l_5, l_6, l_7, l_8, l_9: TREE_NODE[INTEGER, INTEGER]
		do
			env_empty

			create l_1.make_internal (1, 1)
			create l_2.make_internal (2, 2)
			create l_3.make_internal (3, 3)
			create l_4.make_internal (4, 4)
			create l_5.make_internal (5, 5)
			create l_6.make_internal (6, 6)
			create l_7.make_internal (7, 7)
			create l_8.make_internal (8, 8)
			create l_9.make_internal (9, 9)

			l_2.insert_left (l_1)
			l_2.insert_right (l_3)

			l_6.insert_left (l_5)

			l_8.insert_right (l_9)

			l_7.insert_left (l_6)
			l_7.insert_right (l_8)

			l_4.insert_left (l_2)
			l_4.insert_right (l_7)

			root_int_int := l_4
			node_list_int_int.force (l_1)
			node_list_int_int.force (l_2)
			node_list_int_int.force (l_3)
			node_list_int_int.force (l_4)
			node_list_int_int.force (l_5)
			node_list_int_int.force (l_6)
			node_list_int_int.force (l_7)
			node_list_int_int.force (l_8)
			node_list_int_int.force (l_9)
		end

feature -- SPLAY_TREE setup

	root_insert_int_int (l_bst: SPLAY_TREE [INTEGER, INTEGER])
			-- Node insertions without using `insert`.
			--          4
			--         / \
			--        2   7
			--       / \ / \
			--      1  3 6  8
			--          /    \
			--         5      9
		local
			l_1, l_2, l_3, l_5, l_6, l_7, l_8, l_9: TREE_NODE[INTEGER, INTEGER]
		do
			create l_1.make_internal (1, 1)
			create l_2.make_internal (2, 2)
			create l_3.make_internal (3, 3)
			l_bst.root.set_to_internal (4, 4)
			create l_5.make_internal (5, 5)
			create l_6.make_internal (6, 6)
			create l_7.make_internal (7, 7)
			create l_8.make_internal (8, 8)
			create l_9.make_internal (9, 9)

			l_2.insert_left (l_1)
			l_2.insert_right (l_3)

			l_6.insert_left (l_5)

			l_8.insert_right (l_9)

			l_7.insert_left (l_6)
			l_7.insert_right (l_8)

			l_bst.root.insert_left (l_2)
			l_bst.root.insert_right (l_7)
		end

	root_insert_str_str (l_bst: SPLAY_TREE[STRING, STRING])
				-- Node insertions without using `insert`.
				--          d
				--         / \
				--        b   g
				--       / \ / \
				--      a  c f  h
				--          /    \
				--         e      i
			local
				l_1, l_2, l_3, l_5, l_6, l_7, l_8, l_9: TREE_NODE[STRING, STRING]
			do
				create l_1.make_internal ("a", "a")
				create l_2.make_internal ("b", "b")
				create l_3.make_internal ("c", "c")
				l_bst.root.set_to_internal ("d", "d")
				create l_5.make_internal ("e", "e")
				create l_6.make_internal ("f", "f")
				create l_7.make_internal ("g", "g")
				create l_8.make_internal ("h", "h")
				create l_9.make_internal ("i", "i")

				l_2.insert_left (l_1)
				l_2.insert_right (l_3)

				l_6.insert_left (l_5)

				l_8.insert_right (l_9)

				l_7.insert_left (l_6)
				l_7.insert_right (l_8)

				l_bst.root.insert_left (l_2)
				l_bst.root.insert_right (l_7)
			end

feature -- SPLAY_TREE Test environment

	env_root_insert_int_int
			-- Tree creation without using `insert`.
			--          4
			--         / \
			--        2   7
			--       / \ / \
			--      1  3 6  8
			--          /    \
			--         5      9
		do
			env_empty
			root_insert_int_int(bst_int_int)
		end

	env_root_insert_str_str
			-- Tree creation without using `insert`.
			--          d
			--         / \
			--        b   g
			--       / \ / \
			--      a  c f  h
			--          /    \
			--         e      i
		do
			env_empty
			root_insert_str_str(bst_str_str)
		end
end
