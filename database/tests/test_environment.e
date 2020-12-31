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

feature {ES_TEST} -- Implementation

	db_int_int: DATABASE[INTEGER, INTEGER]

	db_int_str: DATABASE[INTEGER, STRING]

	db_str_str: DATABASE[STRING, STRING]

	reset_as_tree_db
		do
			create {TREE_DB[INTEGER, INTEGER]} db_int_int.make
			create {TREE_DB[INTEGER, STRING]} db_int_str.make
			create {TREE_DB[STRING, STRING]} db_str_str.make
		end

	reset_as_linear_db
		do
			create {LINEAR_DB[INTEGER, INTEGER]} db_int_int.make
			create {LINEAR_DB[INTEGER, STRING]} db_int_str.make
			create {LINEAR_DB[STRING, STRING]} db_str_str.make
		end

feature {ES_TEST} -- Test environment

	env_int_int (p_db: like db_int_int)
		do
			p_db.insert (1, 1)
			p_db.insert (2, 2)
			p_db.insert (3, 3)
			p_db.insert (4, 4)
			p_db.insert (5, 5)
			p_db.insert (6, 6)
			p_db.insert (7, 7)
			p_db.insert (8, 8)
			p_db.insert (9, 9)
			p_db.insert (10, 10)
		end

	env_int_str (p_db: like db_int_str)
		do
			p_db.insert (1, "a")
			p_db.insert (2, "b")
			p_db.insert (3, "c")
			p_db.insert (4, "d")
			p_db.insert (5, "e")
			p_db.insert (6, "f")
			p_db.insert (7, "g")
			p_db.insert (8, "h")
			p_db.insert (9, "i")
			p_db.insert (10, "j")
		end

	env_str_str (p_db: like db_str_str)
		do
			p_db.insert ("a", "a")
			p_db.insert ("b", "b")
			p_db.insert ("c", "c")
			p_db.insert ("d", "d")
			p_db.insert ("e", "e")
			p_db.insert ("f", "f")
			p_db.insert ("g", "g")
			p_db.insert ("h", "h")
			p_db.insert ("i", "i")
			p_db.insert ("j", "j")
		end


end
