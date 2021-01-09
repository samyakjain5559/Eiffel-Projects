note
	description: ""
	author: "Samyak Jain"
	date: "$Date$"
	revision: "$Revision$"

class
	SCORE_BUCKET       -- IMPLEMENTING COMPOSITE DESIGN PATTERN

create
	make

feature {ETF_MODEL,SCORE_BUCKET,TESTSCORE}
    val : INTEGER
	ornaments: LIST[SCORE_BUCKET]
	isfocus : BOOLEAN
	container_size,times: INTEGER
feature
    make(name:STRING)
        do
        	create {LINKED_LIST[SCORE_BUCKET]} ornaments.make
        	if name ~ "G" then
        		val := 2
        		isfocus := false
        	elseif name ~ "F"  then
        		val := 3
        		isfocus := false
            elseif name ~ "I"  then
        		val := 1
        		isfocus := false
        	elseif name ~ "C"  then
        		val := 0
        		container_size := 4
        		isfocus := true
        		times := 3
        		insert(create {SCORE_BUCKET}.make("F"))

        	elseif name ~ "P"  then
        		val := 0
        		container_size := 3
        		isfocus := true
        		times := 2
        		insert(create {SCORE_BUCKET}.make("I"))
        	end
        end

feature

	insert (f: SCORE_BUCKET)
	local
		check_ls: BOOLEAN
		in : INTEGER
	do
		if  ornaments.count /= 0 then
            from
            	in := 1
            until
            	in > ornaments.count
            loop
                if ornaments[in].isfocus and check_ls = false then
			       if ornaments[in].remain_capacity /= 0 then
					   ornaments[in].insert (f)
				       check_ls := True
			       end
				end
            	in := in + 1
            end

			if check_ls = false then
				ornaments.extend (f)
			end
		else
		    -- EXTEND if count is zero
			ornaments.extend (f)

		end
	end

	tolpoints: INTEGER
	    local
	    	tol,in :INTEGER
		do
			if isfocus then
                from
                	in := 1
                until
                	in > ornaments.count
                loop
                	tol:=tol+ornaments[in].tolpoints
                	in := in + 1
                end

			    if ornaments.count  =  container_size then
				  tol:=tol*times
			    end
			else
				tol:=val
			end
			Result := tol
		end

     remain_capacity: INTEGER
        local
        	remaincap,in : INTEGER
		do
            from
            	in := 1
            until
            	in > ornaments.count
            loop
            	if ornaments[in].isfocus = true then
					remaincap:= ornaments[in].remain_capacity +remaincap
				end
            	in := in + 1
            end

			remaincap:= ( container_size - ornaments.count)+ remaincap

			Result := remaincap
		end
end
