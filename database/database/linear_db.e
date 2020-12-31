note
	description: "A specialized kind of database implemented by linear data structures."
	author: "Samyak Jain"
	date: "$Date$"
	revision: "$Revision$"

class
	LINEAR_DB[K -> {COMPARABLE, HASHABLE}, V -> attached ANY]
	-- Here the the generic parameter `K` must be instantiated by a class
	-- that is a descendant of both COMPARABLE and HASHABLE (e.g., STRING, INTEGER).

inherit
	DATABASE[K, V]

create
	make

feature {ITERATION_CURSOR, ES_TEST} -- Restricted Attributes
	-- These two attributes are only accessible by any class that is a descendant of `ITERATION_CURSOR` or of `ES_TEST`.
	-- e.g., Your own iteration cursor class might access these `keys` and `values` attributes.
	-- Do not modify these attributes: they must be used to implement the deferred routines inherited from `DATABASE`.

	-- These two variable declarations indicate two client-supplier relations
	-- between `LINEAR_DB` (client) and `ARRAY` and `HASH_TABLE` (suppliers).
	-- Hint: See the instructions PDF on how to use `keys` and `values` to represent a database.
	keys: ARRAY[K]
	values: HASH_TABLE[V, K]

feature {DATABASE} -- Initialization

	make
			-- Makes an empty linear database via empty `keys` and `values`.
		do
			-- This implementation is given to you. Do not modify.
			create keys.make_empty
			create values.make (10)

			keys.compare_objects
			values.compare_objects
		ensure
			-- All these postconditions are given to you. Do not modify them.
			empty_db:
				model.count = 0
			keys_compare_object:
				keys.object_comparison
			values_compare_object:
				values.object_comparison
		end

feature -- Abstraction Function

	model: REL[K, V]
			-- The public, abstract view of a `DATABASE`.
			-- This is the so-called `abstraction function` which
			-- converts/promotes the implementation (i.e., `keys` and `values`) to a mathematical object (i.e., `REL`).
		local
			tuples: ARRAY[TUPLE[K,V]]
			s : INTEGER
		do
			-- TODO: Implement this abstraction function
			-- You are expeced to explore the available queries/commands of the REL class in MATHMODELS.
			-- so that `model` can be used to write contracts of all routines in the parent class `DATABASE`.
			-- Make sure that your implementation satisfies the inherited postcondition from DATABASE.
			-- You are responsible for exploring the available queries/commands of the REL class in MATHMODELS.

			create Result.make_empty -- This first line of implementation is given to you.
			create tuples.make_empty
            from
            	s := 1
            until
            	s > keys.count
            loop
            	if attached values[keys[s]] as ls_value then
            		tuples.force ([keys[s], ls_value], tuples.count+1)
            	end
            	s := s+1
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
			create {LINEAR_IT[K, V]} Result.make(Current)
		end

feature -- Implementation of Deferred Routines from `DATABASE`

	count: INTEGER
			-- Returns the number of mappings in the current database.
		do
			-- TODO: Implement this query so that
			-- the inherited postcondition from `{DATABASE}.count` is satisfied.
			--i := Current.model.as_array.count
            Result := values.count
		-- Implicitly, postcondition from `{DATABASE}.count` is inherited here.
		end

	has_key(p_key: K): BOOLEAN
			-- Returns true if a mapping with `p_key` exists. False otherwise.
		do
			-- TODO: Implement this query so that
			-- the inherited postcondition from `{DATABASE}.has_key` is satisfied.
            Result := values.has (p_key)

		-- Implicitly, postcondition from `{DATABASE}.has_key` is inherited here.
		end

	search(p_key: K): detachable V
			-- Searches for matching value given a key `p_key`.
			-- If `p_key` does not exist, return `Void`.
			-- Note. There is no precondition for this query.
		do
			-- TODO: Implement this feature so that `{DATABASE}.search` specifications are satisfied.
             if values.has (p_key) then
             	Result := values.item (p_key)          -- CHECK FOR VOID
             end

		-- Implicitly, postcondition from `{DATABASE}.search` is inherited here.
		end

	insert(p_key: K; p_value: V)
			-- Inserts a [`p_key`, `p_value`] mapping into the database.
			-- See the inherited precondition of `{DATABASE}.insert`.
		do
			-- TODO: Implement this command so that
			-- the inherited postcondition from `{DATABASE}.insert` is satisfied.
			values.extend (p_value,p_key)
            keys.force (p_key, keys.count+1)
		-- Implicitly, postcondition from `{DATABASE}.insert` is inherited here.
		end

	delete(p_key: K)
			-- Deletes the mapping whose key is `p_key`.
			-- See the inherited precondition of `{DATABASE}.delete`.
		local
			temp_arr : ARRAY[K]
			s: INTEGER
		do
			-- TODO: Implement this command so that
			-- the inherited postcondition from `{DATABASE}.delete` is satisfied.
            values.remove (p_key)
            create temp_arr.make_empty
            from
              s := 1
            until
              s > keys.count
            loop
                if keys[s] ~ p_key then
                else
                	temp_arr.force (keys[s], temp_arr.count+1)
                end
                s := s+1
            end
            keys := temp_arr
		-- Implicitly, postcondition from `{DATABASE}.delete` is inherited here.
		end

invariant
	-- All these invariants are given to you. Do not modify them.
	key_data_pair_count_same:
		keys.count = values.count

	all_key_exists_in_data:
		across
			keys is i_key
		all
			values.has_key (i_key)
		end
end
