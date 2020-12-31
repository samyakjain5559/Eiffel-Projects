note
	description: "[
		A database storing key-value entries.
		Abstractly, a database is viewed as a mathematical relation where:
		  - Domain is the set of search keys.
		  - Range is the set of data values.
		Informally, one may also consider a relation as a set of key-value pairs or mappings.
	]"
	author: "Jinho Hwang"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	DATABASE[K -> COMPARABLE, V -> attached ANY]


-- In order to make DATABASE and all its descendants iterable,
-- we must inherit it from ITERABLE[...] where ... is the correct instantiation of G.
-- TODO: Remove comments from the inherit clause below to start implementing the iterator pattern.
inherit
	ITERABLE[TUPLE[key: K; value: V]]

feature -- Abstraction Function

	model: REL[K, V]
			-- Return the `Current` database as a relation between keys and data values.
			-- This is the so-called `abstraction function`, used to specify mathematical contracts.
			-- There are two ways for understanding each member in the relation:
			--    1. A tuple `[k, v]` that maps from a key `k` to a value `v`.
			--    2. An instance of`PAIR[K, V]`, where K is the type of key and V the type of value.
		deferred
			-- Implementation of this abstraction function is deferred to its descendant classes, i.e.,
			-- TREE_DB and LINEAR_DB.
		ensure
			unchanged_count:
				-- This postcondition is given to you. Do not modify.
				count = old count
			unchanged_implementation:
				-- TODO: Complete this postcondition.
				-- Hint: All the key-value entry before calling `model` should match
				--       all the key-value entry after calling `model`.
				Current.model ~ old Current.model.deep_twin

			all_key_value_tuples_exist_as_model_pairs:
				-- TODO: Complete this postcondition.
				-- Hints: 1. First implement the current DATABSE so that it is iteratble.
				--           2. Each key-value entry in the `Current` database exists as a corresponding pair in the `Result` relation.
				across
				  Current is ls_db
				all
					Result.domain.has(ls_db.key) and Result.range.has(ls_db.value)
				end

			all_model_pairs_exist_as_key_value_tuples:
				-- TODO: Complete this postcondition.
				-- Hints: 1. `Result` relation is already iterable.
				--           2. Each key-value pair in the `Result` relation exists as a corresponding entry in `Current` database.
				across
				  Result is ls_rel
				all
					Current.has_key (ls_rel.first) and (Current.search (ls_rel.first) ~ ls_rel.second)
				end

		end

-- Remove comments from the inherit clause below to start implementing the iterator pattern.
feature -- Iteration Cursor

	new_cursor: ITERATION_CURSOR [TUPLE[key: K; value: V]]
			-- Returns a cursor to iterate through database.
		deferred
			-- Implementation of this abstraction function is deferred to its descendant classes, i.e.,
			-- TREE_DB and LINEAR_DB.
		end

feature -- Deferred Routines

	count: INTEGER
			-- Returns the number of mappings in the current database.
		deferred
			-- Implementation of this routine is deferred to its descendant classes.
		ensure
			nothing_changed:
				-- TODO: Complete this postcondition.
				-- Hint: Abstract views of the database as relations before and after the routine call should be the same.
				Current.model ~ old Current.model.deep_twin    --- CONFIRM
			consistent_counts:
				-- TODO: Compelete this postcondition.
				-- Hint: The result should be consistent with the model's size.
				Result ~ Current.model.as_array.count
		end

	has_key(p_key: K): BOOLEAN
			-- Returns true if a mapping with key `p_key` exists. False otherwise.
		deferred
			-- Implementation of this routine is deferred to its descendant classes.
		ensure
			nothing_changed:
				-- TODO: Complete this postcondition.
				-- Hint: Abstract views of the database as relations before and after the routine call should be the same.
				Current.model ~ old Current.model.deep_twin
			key_exists:
				-- TODO: Complete this postcondition.
				-- Hint: Result is true if and only if `p_key` is a valid domain value of the model.
				Result implies Current.model.domain.has (p_key)
		end

	search(p_key: K): detachable V
			-- Returns the matching value given a key `p_key`.
			-- If `p_key` does not exist, return `Void`.
			-- Note. There is no precondition for this query.
		deferred
			-- Implementation of this routine is deferred to its descendant classes.
		ensure
			nothing_changed:
				-- TODO: Complete this postcondition.
				-- Hint: Abstract views of the database as relations before and after the routine call should be the same.
				Current.model ~ old Current.model.deep_twin
			case_of_key_found:
				-- TODO: Complete this postcondition.
				-- Hint: `p_key` being a valid domain value of the model means that
				--				the model relation uniquely maps`p_key` to the result.
				Current.model.domain.has (p_key) implies (Current.model.image (p_key).count ~ 1)   -- CONFORM
		end

	insert(p_key: K; p_value: V)
			-- Inserts a new mapping [`p_key`, `p_value`] into the database.
		require
			no_previous_entry:
				-- TODO: Complete this precondition.
				-- This precondition is inherited to `TREE_DB` and `LINEAR_DB`.
				-- Hint: Check whether the current database has an entry with key `p_key`.
				not Current.has_key (p_key)
		deferred
			-- Implementation of this routine is deferred to its descendant classes.
		ensure
			entry_added:
				-- TODO: Complete this postcondition.
				-- Hint: How do you compare the models before and after insertion?
				(not old Current.model.domain.has (p_key)) and Current.model.domain.has (p_key)
		end

	delete(p_key: K)
			-- Deletes the mapping whose key is `p_key`.
			-- This precondition is inherited to `TREE_DB` and `LINEAR_DB`.
		require
			existing_entry:
				-- TODO: Complete this precondition.
				-- Hint: The model already has an entry with key `p_key`.
				Current.has_key (p_key)
		deferred
			-- Implementation of this routine is deferred to its descendant classes.
		ensure
			entry_deleted:
				-- TODO: Complete this postcondition.
				-- Hint: How do you compare the models before and after deletion?
				(old Current.model.domain.has (p_key)) and (not Current.model.domain.has (p_key))
		end

feature -- Basic

	override(p_key: K; p_value: V)
			-- Updates the entry with key `p_key` so that `p_key` maps to `p_value`.
			-- If `p_key` is not an existing key, then add a new entry [ `p_key`, `p_value` ].
		do
			-- TODO: Complete this implementation.
            --Current.model.override_by ([p_key,p_value])
            if Current.has_key (p_key) then
            	Current.delete (p_key)
            	Current.insert (p_key, p_value)
            else
            	Current.insert (p_key, p_value)
            end
		ensure
			overriden_result:
				-- TODO: Complete this postcondition.
				-- Hint: How do you compare the models before and after overriding?
				Current.model.image (p_key).has (p_value) and (not old Current.model.image (p_key).has (p_value))
		end

	common_key_db (p_second: DATABASE[K, V]): DATABASE[K, V]
			-- Returns an intersection of `Current` and `p_second`.
			-- That is, a key-value entry is in `Result` if and only if
			-- it is in both `Current` and `p_second` (compared by objects, not references).
			-- The dynamic type of `Result` follows the dynamic type of `Current`.
		do
			-- TODO: Complete this implementation.
			-- Hint: The result database should have the union of the entries
			--       with same keys and values from current database and the 'p_second'.
			create {TREE_DB[K, V]} Result.make
			across
				Current is ls_curr
			loop
				across
				  p_second is ls_sec
				loop
					if (ls_curr.key ~ ls_sec.key)then
					   if attached Current.search(ls_curr.key) as k then
                           -- val := k
                           Result.insert(ls_curr.key,k)
					   end

				    end
				end
			end
		ensure
			nothing_changed:
				-- TODO: Complete this postcondition.
				-- Hint: Abstract views of the database as relations before and after the routine call should be the same.
				Current.model ~ old Current.model.deep_twin
			result_has_common_key_mappings_from_current_database_and_p_second:
				-- TODO: Complete this postcondition.
				-- Hint: How should the result database look like compared with `Current` and `p_second`?
				across
				  Result is ls_res
				all
					Current.has_key (ls_res.key) and p_second.has_key (ls_res.key)
				end
		end

feature -- Intermediate

	interval_image (p_first, p_finish: K): LIST[V]
			-- Returns a list of values mapped from
			-- keys which are within the interval of [`p_first`, `p_finish`).
			-- Note. `[` means inclusive, `)` means exclusive.
			-- e.g., [1, 100) denotes a range of 99 numbers.
		require
			p_first_smaller_than_p_finish:
				-- This precondition is given to you. Do not modify it.
				p_first < p_finish
		do
			-- TODO: Complete this implementation.
			create {ARRAYED_LIST[V]} Result.make (1)
			across
				Current is ls_curr
			loop
				if (ls_curr.key >= p_first) and (ls_curr.key < p_finish) then
					if attached Current.search(ls_curr.key) as k then
                        Result.force (k)
                    end
				end
			end

		ensure
			nothing_changed:
				-- TODO: Complete this postcondition.
				-- Hint: Abstract views of the database as relations before and after the routine call should be the same.
				Current.model ~ old Current.model.deep_twin

			correct_values_are_included_in_result:
				-- TODO: Complete this postcondition.
				-- Hint: The value of each pair in the model, whose key is within the interval, is included in the result.
				across
					Current.model.domain is key
				all
					attached Current.search (key) as val and then
					(((key >= p_first) and (key < p_finish)) implies Result.has (val))
				end

			result_includes_correct_values_only:
				-- TODO: Complete this postcondition.
				-- Hint: Every value in the result has its associated key, within the interval, in model.
				across
					Result is ls_res
				all
				    across
				    	Current.model.range_restricted_by (ls_res) is key
				    all
                        (key.first >= p_first) and (key.first < p_finish)
				    end
				end

		end


feature -- Advanced

	inner_join (other: DATABASE[K, STRING]): REL[K, PAIR[V, STRING]]
 			-- Returns a relation consisting of mappings [k, (v, s)],
 			-- where [k, v] is a valid entry in the `Current` database,
 			-- and [k, s] is a valid entry in the `other` database.
 		local
 			tuples : ARRAY[TUPLE[k: K; v: PAIR[V,STRING]]]  -- use v any as tuple pair as well
		do
			-- TODO: Complete this implementation.
			create Result.make_empty
			create tuples.make_empty
            across
            	Current is ls_curr
            loop

               if attached Current.search(ls_curr.key) as k and attached other.search(ls_curr.key) as oth then
               	      if other.has_key (ls_curr.key) then
               	      	 tuples.force ([ls_curr.key,create {PAIR[V,STRING]}.make(k,oth)], tuples.count+1)
               	      end

               end
            end
            Result.make_from_tuple_array (tuples)
		ensure
			nothing_changed:
				-- TODO: Complete this postcondition.
				-- Hint: Abstract views of the database as relations before and after the routine call should be the same.s
				Current.model ~ old Current.model.deep_twin

			result_exists_in_current_database:
				-- TODO: Complete this postcondition.
				-- Hint: Each entry [k, (v, s)] in the result relation should have
				--			[k, v] a valid entry in the `Current` database.
				across
					Result is ls_res
				all
					Current.has_key (ls_res.first) and Current.search (ls_res.first) ~ ls_res.second.first

				end

			result_exists_in_other_database:
				-- TODO: Complete this postcondition.
				-- Hint: Each entry [k, (v, s)] in the result relation should have
				--			[k, s] a valid entry in the `other` database.
				across
					Result is ls_res
				all
					other.has_key (ls_res.first) and other.search (ls_res.first) ~ ls_res.second.second

				end

			common_key_mapping_exists_in_result:
				-- TODO: Complete this postcondition.
				-- Hint: For each common key `k` between the `Current` and `other` databases,
				-- 		 	the result relation has an entry whose
				-- 				+ key is `k`
				-- 				+ value is a pair consisting of `k`'s associated values in `Current` and `other`.
				across
					(Current) is ls_comm
				all
					across
					   other is oth
					all
						attached other.search (oth.key) as v and then
						(oth.key ~ ls_comm.key implies Result.in_range ([ls_comm.value,v], Result.range))
					end
				end
		end

end
