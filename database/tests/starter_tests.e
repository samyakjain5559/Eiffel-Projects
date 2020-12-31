note
	description: "All starter tests."
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

class
	STARTER_TESTS

inherit
	TEST_ENVIRONMENT

create
	make

feature
	make
		do
			reset_as_linear_db

			add_boolean_case (agent test_hash_table_retrieval)
			add_boolean_case (agent test_relation_and_tuples)


			add_model_tests

			add_insert_tests
			add_count_tests
			add_search_tests
			add_delete_tests
			add_has_key_tests

			add_override_tests
			add_common_key_db_tests

			add_interval_image_tests

			add_inner_join_tests

-- 			TODO: Uncomment this once you made `DATABASE` iterable.
			add_iterator_tests
		end

feature -- syntax demo

	test_hash_table_retrieval: BOOLEAN
		local
			table: HASH_TABLE[STRING, INTEGER]
			values: LINKED_LIST[STRING]
		do
			comment ("test_hash_table_retrieval: test return value from hash table")

			create table.make (10) -- maximum capacity of 10 entries to begin with
			Result := table.count = 0 and table.is_empty
			check Result end

			table.extend ("value1", 1)
			table.extend ("value2", 2)

			Result := table.count = 2 and table[1] ~ "value1" and table[2] ~ "value2"
			check Result end

			create values.make
			-- Version 1: this line does not compile because
			-- each member of the `values` array is expected to be non-void,
			-- but table[k], from the compiler's point of view, might return void
			-- if k is not an existing key of the has table.

--			values.extend (table[1])

			-- Version 2: assert to the compiler (via a check assertion) that
			-- table[1] and table[2] specifically would return non-void value,
			-- because we are certain that 1 and 2 are existing keys.
			-- Overall a check assertion goes like: check B then S end,
			-- where B is a Boolean expression, and S is a sequene of instructions (assignments, if-statements, loops, etc.).
			check
				-- `attached` is a keyword.
				-- Writing `attached E as VAR` evalues to either true or false.
				-- If `E` is an expression that denotes a non-void (i.e., attached) object, then
				-- let a new local variable `VAR` point to that object.
				-- Otherwise, if `E` is not attached, the expression evalues to false.
				attached table[1] as v1  and attached table[2] as v2
			then
				values.extend (v1)
				values.extend (v2)
			end

			Result := values.count = 2 and values[1] ~ "value1" and values[2] ~ "value2"
		end

	test_relation_and_tuples: BOOLEAN
		local
			rel: REL[INTEGER, STRING]
			domain: SET[INTEGER]
			range: SET[STRING]
			-- pay attention to how we refer to fields `k` and `v` of `tuples`
			tuples: ARRAY[TUPLE[k: INTEGER; v: STRING]]
		do
			comment ("test_relation_and_tuples: test the use of relation and tuples")
            --rel.overriden (range)
 			create rel.make_from_tuple_array (<<[1, "alan"], [2, "mark"], [3, "tom"]>>)
			Result := rel.count = 3 and not rel.is_empty
			check Result end
			--rel.override(rel)

			-- domain of model function
			create domain.make_from_array (<<1, 2, 3>>)
			Result := rel.domain ~ domain
			check Result end

			-- range of model function
			create range.make_from_array (<<"alan", "mark", "tom">>)
			Result := rel.range ~ range
			check Result end

			-- applications of model function
			Result :=
						rel[1].count = 1 and rel[1].has ("alan") -- relational image (returning a set)
						and
						rel.image (2).count = 1 and rel.image(2).has ("mark") -- relational image using the indexing notation & 2 is a domain value
						and
						rel[3].count = 1 and rel[3].has ("tom")
			check Result end

			-- convert model to an array of tuples
			create tuples.make_empty
			across
				rel is pair   -- AS relation is a collection of ordered pair
			loop
				tuples.force ([pair.first, pair.second],   -- first is from set 1 and second is from set 2
									tuples.count + 1)
			end
			Result :=
								tuples.count = 3
						and	tuples[1].k ~ 1 and tuples[1].v ~ "alan"
						and	tuples[2].k ~ 2 and tuples[2].v ~ "mark"
						and	tuples[3].k ~ 3 and tuples[3].v ~ "tom"
		end

feature -- model

	add_model_tests
		do
			add_boolean_case (agent dbt_model1)
			add_boolean_case (agent dbt_model3)
			add_boolean_case (agent dbt_model5)
			add_boolean_case (agent dbt_model7)
		end

	dbt_model7: BOOLEAN
		local
		do
			comment ("dbt_model7: int LINEAR_DB, check if its model maps all the keys and values")
			reset_as_linear_db

			env_int_int (db_int_int)

			if
				attached {LINEAR_DB[INTEGER, INTEGER]} db_int_int as a_db
			then
				Result :=
					across
						a_db.model is i_pair
					all
						attached i_pair.first as a_key and then
						attached i_pair.second as a_value
						and then
						a_db.values [a_key] ~ a_value
					end
			end

		end

	dbt_model5: BOOLEAN
		local
		do
			comment ("dbt_model5: int TREE_DB, check if its model maps all the keys and values")
			reset_as_tree_db

			env_int_int (db_int_int)

			if
				attached {TREE_DB[INTEGER, INTEGER]} db_int_int as a_db
			then
				Result :=
					across
						a_db.model is i_pair
					all
						attached i_pair.first as a_key and then
						attached i_pair.second as a_value
						and then
						a_db.search (a_key) ~ a_value
					end
			end
		end

	dbt_model3: BOOLEAN
		local
		do
			comment ("dbt_model3: int LINEAR_DB, check if its keys and its values map to a model")
			reset_as_linear_db

			env_int_int (db_int_int)

			if
				attached {LINEAR_DB[INTEGER, INTEGER]} db_int_int as a_db
			then

				Result :=
					across
						a_db.keys is i_key
					all
						attached a_db.model.domain_restricted_by (i_key).range as a_range
						and then
						a_range.count = 1
						and then
						a_range.has (a_db.values[i_key])
					end
			end

		end

	dbt_model1: BOOLEAN
		local
			l_bst: BALANCED_BST[INTEGER, INTEGER]
			l_list: LIST[TREE_NODE[INTEGER, INTEGER]]
		do
			comment ("dbt_model1: int TREE_DB, check if its keys and its values map to a model")
			reset_as_tree_db

			env_int_int (db_int_int)

			if
				attached {TREE_DB[INTEGER, INTEGER]} db_int_int as a_db
			then
				l_bst := a_db.bst
				l_list := l_bst.nodes

				Result :=
					across
						l_list is l_node
					all
						(
							attached l_node.key as a_key and then
							attached l_node.value as a_value
						)
						implies
						(
							attached a_db.model.domain_restricted_by(a_key).range as a_range
							and then
							a_range.count = 1
							and then
							a_range.has(a_value)
						)
					end
			end



		end

feature -- insert

	add_insert_tests
		do
			add_boolean_case (agent dbt_insert1)
			add_boolean_case (agent dbt_insert2)
			add_boolean_case (agent dbt_insert3)
			add_boolean_case (agent dbt_insert4)
		end

	dbt_insert6
	 	local
	 	do
	 		comment ("dbt_insert6: PRECONDITION, no_previous_entry")
			reset_as_linear_db
			db_str_str.insert ("A", "TEST3")
			db_str_str.insert ("A", "TEST2")
	 	end

	dbt_insert5: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_insert5: insert A, K, E, S, Z, T, I, P, Q, H")
			reset_as_linear_db
			db_str_str.insert ("A", "TEST3")
			db_str_str.insert ("K", "TEST2")
			db_str_str.insert ("E", "TEST4")
			db_str_str.insert ("S", "TEST1")
			db_str_str.insert ("Z", "TEST5")
			db_str_str.insert ("T", "TEST6")
			db_str_str.insert ("I", "TEST7")
			db_str_str.insert ("P", "TEST10")
			db_str_str.insert ("Q", "TEST8")
			db_str_str.insert ("H", "TEST9")
			Result := db_str_str.count = 10
	 	end

	 dbt_insert4: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_insert4: insert 1, 10, 2, 9, 3, 8, 4, 7, 5, 6")
			reset_as_linear_db
			db_int_int.insert (1, 1)
			db_int_int.insert (10, 1)
			db_int_int.insert (2, 1)
			db_int_int.insert (9, 1)
			db_int_int.insert (3, 1)
			db_int_int.insert (8, 1)
			db_int_int.insert (4, 1)
			db_int_int.insert (7, 1)
			db_int_int.insert (5, 1)
			db_int_int.insert (6, 1)
			Result := db_int_int.count = 10
	 	end

	 dbt_insert3: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_insert3: insert 3 ~ 1")
			reset_as_linear_db

			db_int_int.insert (3, 1)
			db_int_int.insert (2, 2)
			db_int_int.insert (1, 3)
			Result := db_int_int.count = 3
	 	end

	 dbt_insert2: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_insert2: insert 1 ~ 3")
			reset_as_linear_db

			db_int_int.insert (1, 1)
			db_int_int.insert (2, 2)
			db_int_int.insert (3, 3)
			Result := db_int_int.count = 3
	 	end

	 dbt_insert1: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_insert1: insert 1")
			reset_as_linear_db

			db_int_int.insert (1, 1)
			Result := db_int_int.count = 1
	 	end

feature -- count

	add_count_tests
		do
			add_boolean_case(agent dbt_count1)
		end

	dbt_count1: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_count1: count, insert 10")
			reset_as_linear_db
			env_int_int (db_int_int)

			Result := db_int_int.count = 10
	 	end

feature -- search

	add_search_tests
		do
			add_boolean_case(agent dbt_search1)
			add_boolean_case(agent dbt_search2)
		end

	dbt_search2: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_search2: search 10")
			reset_as_linear_db
			env_int_int (db_int_int)

			Result := db_int_int.search (10) = 10
	 	end

	dbt_search1: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_search1: search 1")
			reset_as_linear_db
			env_int_int (db_int_int)

			Result := db_int_int.search (1) = 1
	 	end

feature -- delete

	add_delete_tests
		do
			add_boolean_case(agent dbt_delete1)
			add_boolean_case(agent dbt_delete2)
		end

	dbt_delete2: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_delete2: delete `i`")
			reset_as_linear_db
			env_str_str (db_str_str)
			db_str_str.delete ("i")

			Result := db_str_str.count = 9
	 	end

	dbt_delete1: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_delete1: delete 1")
			reset_as_linear_db
			env_int_int (db_int_int)
			db_int_int.delete (4)
            db_int_int.delete (8)
			Result := db_int_int.count = 8
	 	end

feature -- has_key

	add_has_key_tests
		do
			add_boolean_case(agent dbt_has_key1)
			add_boolean_case(agent dbt_has_key2)
		end

	dbt_has_key2: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_has_key2: has_key `i`")
			reset_as_linear_db
			env_str_str (db_str_str)
			Result := db_str_str.has_key ("i")
	 	end

	dbt_has_key1: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_has_key1: has_key 1")
			reset_as_linear_db
			env_int_int (db_int_int)
			Result := db_int_int.has_key (1)
	 	end

feature -- override

	add_override_tests
		do
			add_boolean_case(agent dbt_override1)
			add_boolean_case(agent dbt_override2)
			add_boolean_case(agent dbt_override3)
			add_boolean_case(agent dbt_override4)
		end

	dbt_override4: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_override4: override (`Z`, `ZZZ`)")
	 		reset_as_linear_db
			env_str_str (db_str_str)

			db_str_str.override ("Z", "ZZZ")
			Result := db_str_str.search ("Z") ~ "ZZZ"
	 	end

	dbt_override3: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_override3: override (`A`, `AAA`)")
	 		reset_as_linear_db
			env_str_str (db_str_str)
			db_str_str.override ("a", "AAA")
			Result := db_str_str.search ("a") ~ "AAA"
	 	end

	dbt_override2: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_override2: override (11, 999)")
			reset_as_linear_db
			env_int_int (db_int_int)

			db_int_int.override (11, 999)
			Result := db_int_int.search (11) = 999
	 	end

	dbt_override1: BOOLEAN
	 	local
	 	do
	 		comment ("dbt_override1: override (1, 372)")
			reset_as_linear_db
			env_int_int (db_int_int)

			db_int_int.override (1, 372)
			Result := db_int_int.search (1) = 372
	 	end

feature -- common_key_db

	add_common_key_db_tests
		do
			add_boolean_case(agent dbt_common_key_db1)
			add_boolean_case(agent dbt_common_key_db2)
			add_boolean_case(agent dbt_common_key_db3)
			add_boolean_case(agent dbt_common_key_db4)
		end

	dbt_common_key_db4: BOOLEAN
		local
			l_duplicate_db: like db_int_int
			l_result_db: like db_int_int
		do
			comment ("dbt_common_key_db4: common key db_int_int, db_int_int none")
			reset_as_linear_db
			env_int_int (db_int_int)

			l_duplicate_db := db_int_int.deep_twin

			across
				1 |..| db_int_int.count is i
			loop
				db_int_int.delete (i)
			end

			l_result_db := db_int_int.common_key_db (l_duplicate_db)
			Result := l_result_db.count = 0
		end

	dbt_common_key_db3: BOOLEAN
		local
			l_duplicate_db: like db_int_int
			l_result_db: like db_int_int
		do
			comment ("dbt_common_key_db3: common key db_int_int, other db smaller")
			reset_as_linear_db
			env_int_int (db_int_int)

			l_duplicate_db := db_int_int.deep_twin

			l_duplicate_db.delete (1)
			l_duplicate_db.delete (3)
			l_duplicate_db.delete (5)
			l_duplicate_db.delete (7)
			l_duplicate_db.delete (9)

			l_result_db := db_int_int.common_key_db (l_duplicate_db)
			Result := l_result_db.count = 5 and
				l_result_db.search (2) = 2 and
				l_result_db.search (4) = 4 and
				l_result_db.search (6) = 6 and
				l_result_db.search (8) = 8 and
				l_result_db.search (10) = 10
		end

	dbt_common_key_db2: BOOLEAN
		local
			l_duplicate_db: like db_int_int
			l_result_db: like db_int_int
		do
			comment ("dbt_common_key_db2: common key db_int_int, db_int_int smaller")
			reset_as_linear_db
			env_int_int (db_int_int)

			l_duplicate_db := db_int_int.deep_twin

			db_int_int.delete (1)
			db_int_int.delete (3)
			db_int_int.delete (5)
			db_int_int.delete (7)
			db_int_int.delete (9)

			l_result_db := db_int_int.common_key_db (l_duplicate_db)
			Result := l_result_db.count = 5 and
				l_result_db.search (2) = 2 and
				l_result_db.search (4) = 4 and
				l_result_db.search (6) = 6 and
				l_result_db.search (8) = 8 and
				l_result_db.search (10) = 10
		end


	dbt_common_key_db1: BOOLEAN
		local
			l_duplicate_db: like db_int_int
			l_result_db: like db_int_int
		do
			comment ("dbt_common_key_db1: common key db_int_int clone")
			reset_as_linear_db
			env_int_int (db_int_int)

			l_duplicate_db := db_int_int.deep_twin
			l_result_db := db_int_int.common_key_db (l_duplicate_db)
			Result := l_result_db.count = 10 and
				l_result_db.search (1) = 1 and
				l_result_db.search (2) = 2 and
				l_result_db.search (3) = 3 and
				l_result_db.search (4) = 4 and
				l_result_db.search (5) = 5 and
				l_result_db.search (6) = 6 and
				l_result_db.search (7) = 7 and
				l_result_db.search (8) = 8 and
				l_result_db.search (9) = 9 and
				l_result_db.search (10) = 10
		end

feature -- interval_image

	add_interval_image_tests
		do
			add_boolean_case(agent dbt_interval_image1)
			add_boolean_case(agent dbt_interval_image2)
			add_boolean_case(agent dbt_interval_image3)
		end

	dbt_interval_image3: BOOLEAN
		local
			l_list: LIST[INTEGER]
		do
			comment ("dbt_interval_image3: env_int_int, [8, 50)")
			reset_as_linear_db
			env_int_int (db_int_int)

			l_list := db_int_int.interval_image (8, 50)
			Result := l_list.count = 3 and
				l_list.has (8) and
				l_list.has (9) and
				l_list.has (10)
		end

	dbt_interval_image2: BOOLEAN
		local
			l_list: LIST[INTEGER]
		do
			comment ("dbt_interval_image2: env_int_int, [-5, 3)")
			reset_as_linear_db
			env_int_int (db_int_int)

			l_list := db_int_int.interval_image (-5, 3)
			Result := l_list.count = 2 and
				l_list.has (1) and
				l_list.has (2)
		end

	dbt_interval_image1: BOOLEAN
		local
			l_list: LIST[INTEGER]
		do
			comment ("dbt_interval_image1: env_int_int, [3, 7)")
			reset_as_linear_db
			env_int_int (db_int_int)

			l_list := db_int_int.interval_image (3, 7)
			Result := l_list.count = 4 and
				l_list.has (3) and
				l_list.has (4) and
				l_list.has (5) and
				l_list.has (6)
		end

feature -- inner_join

	add_inner_join_tests
		do
			add_boolean_case(agent dbt_inner_join1)
			add_boolean_case(agent dbt_inner_join2)
			add_boolean_case(agent dbt_inner_join3)
			add_boolean_case(agent dbt_inner_join4)
		end

	dbt_inner_join4: BOOLEAN
		local
			l_relation: REL[INTEGER, PAIR[INTEGER, STRING]]
		do
			comment ("dbt_inner_join4: int_int, and int_str, no int_str entries")
			reset_as_linear_db
			env_int_int (db_int_int)

			l_relation := db_int_int.inner_join (db_int_str)
			Result := l_relation.count = 0
		end

	dbt_inner_join3: BOOLEAN
		local
			l_relation: REL[INTEGER, PAIR[INTEGER, STRING]]
		do
			comment ("dbt_inner_join3: int_int, and int_str, int_int only odd keys")
			reset_as_linear_db
			env_int_int (db_int_int)

			db_int_int.delete (2)
			db_int_int.delete (4)
			db_int_int.delete (6)
			db_int_int.delete (8)
			db_int_int.delete (10)

			db_int_str.insert (1, "a")
			db_int_str.insert (2, "b")
			db_int_str.insert (3, "c")
			db_int_str.insert (4, "d")
			db_int_str.insert (5, "e")
			db_int_str.insert (6, "f")
			db_int_str.insert (7, "g")
			db_int_str.insert (8, "h")
			db_int_str.insert (9, "i")
			db_int_str.insert (10, "j")

			l_relation := db_int_int.inner_join (db_int_str)
			Result := l_relation.count = 5 and
					l_relation.domain_restricted_by (1).has ([1, create {PAIR[INTEGER, STRING]}.make(1, "a")]) and
					l_relation.domain_restricted_by (3).has ([3, create {PAIR[INTEGER, STRING]}.make(3, "c")]) and
					l_relation.domain_restricted_by (5).has ([5, create {PAIR[INTEGER, STRING]}.make(5, "e")]) and
					l_relation.domain_restricted_by (7).has ([7, create {PAIR[INTEGER, STRING]}.make(7, "g")]) and
					l_relation.domain_restricted_by (9).has ([9, create {PAIR[INTEGER, STRING]}.make(9, "i")])
		end

	dbt_inner_join2: BOOLEAN
		local
			l_relation: REL[INTEGER, PAIR[INTEGER, STRING]]
		do
			comment ("dbt_inner_join2: int_int, and int_str, int_str only odd keys")
			reset_as_linear_db
			env_int_int (db_int_int)

			db_int_str.insert (1, "a")
			db_int_str.insert (3, "c")
			db_int_str.insert (5, "e")
			db_int_str.insert (7, "g")
			db_int_str.insert (9, "i")

			l_relation := db_int_int.inner_join (db_int_str)
			Result := l_relation.count = 5 and
					l_relation.domain_restricted_by (1).has ([1, create {PAIR[INTEGER, STRING]}.make(1, "a")]) and
					l_relation.domain_restricted_by (3).has ([3, create {PAIR[INTEGER, STRING]}.make(3, "c")]) and
					l_relation.domain_restricted_by (5).has ([5, create {PAIR[INTEGER, STRING]}.make(5, "e")]) and
					l_relation.domain_restricted_by (7).has ([7, create {PAIR[INTEGER, STRING]}.make(7, "g")]) and
					l_relation.domain_restricted_by (9).has ([9, create {PAIR[INTEGER, STRING]}.make(9, "i")])
		end

	dbt_inner_join1: BOOLEAN
		local
			l_relation: REL[INTEGER, PAIR[INTEGER, STRING]]
		do
			comment ("dbt_inner_join1: int_int, and int_str")
			reset_as_linear_db
			env_int_int (db_int_int)

			db_int_str.insert (1, "a")
			db_int_str.insert (2, "b")
			db_int_str.insert (3, "c")
			db_int_str.insert (4, "d")
			db_int_str.insert (5, "e")
			db_int_str.insert (6, "f")
			db_int_str.insert (7, "g")
			db_int_str.insert (8, "h")
			db_int_str.insert (9, "i")
			db_int_str.insert (10, "j")

			l_relation := db_int_int.inner_join (db_int_str)
			Result := l_relation.count = 10 and
					l_relation.domain_restricted_by (1).has ([1, create {PAIR[INTEGER, STRING]}.make(1, "a")]) and
					l_relation.domain_restricted_by (2).has ([2, create {PAIR[INTEGER, STRING]}.make(2, "b")]) and
					l_relation.domain_restricted_by (3).has ([3, create {PAIR[INTEGER, STRING]}.make(3, "c")]) and
					l_relation.domain_restricted_by (4).has ([4, create {PAIR[INTEGER, STRING]}.make(4, "d")]) and
					l_relation.domain_restricted_by (5).has ([5, create {PAIR[INTEGER, STRING]}.make(5, "e")]) and
					l_relation.domain_restricted_by (6).has ([6, create {PAIR[INTEGER, STRING]}.make(6, "f")]) and
					l_relation.domain_restricted_by (7).has ([7, create {PAIR[INTEGER, STRING]}.make(7, "g")]) and
					l_relation.domain_restricted_by (8).has ([8, create {PAIR[INTEGER, STRING]}.make(8, "h")]) and
					l_relation.domain_restricted_by (9).has ([9, create {PAIR[INTEGER, STRING]}.make(9, "i")]) and
					l_relation.domain_restricted_by (10).has ([10, create {PAIR[INTEGER, STRING]}.make(10, "j")])
		end

-- TODO: Uncomment these tests once you made `DATABASE` iterable.
feature -- iterator

	add_iterator_tests
		do
			add_boolean_case(agent dbt_iterator1)
			add_boolean_case(agent dbt_iterator5)

		end

 	dbt_iterator5: BOOLEAN
		local
			l_list: LIST[TUPLE[INTEGER, INTEGER]]
			b : BOOLEAN
			--i : INTEGER
	 	do
	 		comment ("dbt_iterator5: TREE_DB, int_int, go through 1 ~ 10")
			reset_as_tree_db
			env_int_int (db_int_int)

			create {ARRAYED_LIST[TUPLE[INTEGER, INTEGER]]} l_list.make (db_int_int.count)

			across
				db_int_int is i_item
			loop
				l_list.force (i_item)
			end

			Result :=
				across
					l_list.count |..| 1 is i
				all
					l_list[i][1] ~ i
					and
					l_list[i][2] ~ i
				end
--            from
--            	i := 10
--            until
--            	i < l_list.count
--            loop
--            	b := l_list[i][2] ~ i
--            end

	 	end

 	dbt_iterator1: BOOLEAN
		local
			l_list: LIST[TUPLE[INTEGER, INTEGER]]
	 	do
	 		comment ("dbt_iterator1: LINEAR_DB, int_int, go through 1 ~ 10")
			reset_as_linear_db
			env_int_int (db_int_int)

			create {ARRAYED_LIST[TUPLE[INTEGER, INTEGER]]} l_list.make (db_int_int.count)

			across
				db_int_int is i_item
			loop
				l_list.force (i_item)
			end

			Result :=
				across
					l_list.count |..| 1 is i
				all
					l_list[i][1] ~ i
					and
					l_list[i][2] ~ i
				end

	 	end

end

