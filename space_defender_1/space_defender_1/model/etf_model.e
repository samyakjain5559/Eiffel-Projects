note
	description: "A default business model."
	author: "Samyak Jain"
	date: "$Date$"
	revision: "$Revision$"

class
	ETF_MODEL

inherit
	ANY
		redefine
			out
		end


create {ETF_MODEL_ACCESS}
	make

feature {NONE} -- Initialization
	make
			-- Initialization for `Current'.
		do
			create s.make_empty
			i := 1
			r := 0
			col := 0
			max_player_step := 0
			fix_project_mov := 0
			i := 0
			create flag.make_empty
			create array.make_filled("",0,0)
            create shiploc.make
            create projloc.make
            create collide_loc
            create collide_loc_pass
            create keyval.make(10)
            --create history.make
            create history.make_empty
            cursor_position := 0
            write_flag := true
            create last_write.make
		end

feature -- model attributes
	s : STRING
	write_flag : BOOLEAN
	r,col,i2 : INTEGER
	i: INTEGER
	max_player_step:INTEGER
	fix_project_mov:INTEGER
	flag : STRING
	game_on : BOOLEAN
	array : ARRAY2 [STRING]
	collide_loc : TUPLE[colr:INTEGER;colc:INTEGER]
	collide_loc_pass : TUPLE[colr:INTEGER;colc:INTEGER]
	shiploc : LINKED_LIST[TUPLE[trow:INTEGER;tcol:INTEGER]]
	projloc : LINKED_LIST[TUPLE[prow:INTEGER;pcol:INTEGER]]
	keyval : HASH_TABLE[STRING,INTEGER]
	--history : LINKED_LIST[COMMANDS]
	history : ARRAY[COMMANDS]
	cursor_position : INTEGER
	last_write : LINKED_LIST[STRING]

feature -- model operations

    play(row: INTEGER_32 ; column: INTEGER_32 ; player_mov: INTEGER_32 ; project_mov: INTEGER_32)  -- begin play

        local
        	array_temp : ARRAY2 [STRING]
        	lsr,lsc : INTEGER
        do
            max_player_step := player_mov
            fix_project_mov := project_mov
            projloc.wipe_out  -- Reset proj for new game
            last_write.wipe_out
            shiploc.wipe_out
            collide_loc.colr := 0
            collide_loc.colc := 0
            keyval.put ("A", 1)
            keyval.put ("B", 2)
            keyval.put ("C", 3)
            keyval.put ("D", 4)
            keyval.put ("E", 5)
            keyval.put ("F", 6)
            keyval.put ("G", 7)
            keyval.put ("H", 8)
            keyval.put ("I", 9)
            keyval.put ("J", 10)
            r := row
            col := column
            i2 := 0
            create array_temp.make_filled ("", row, column)
            array := array_temp
            from
            	lsr := 1
            until
            	lsr > row
            loop
            	from
            		lsc := 1
            	until
            		lsc > column
            	loop
            		if lsr = (row/2).ceiling and lsc = 1 then
                        array.put ("S", lsr, lsc)
                        shiploc.extend([lsr,lsc])
                        shiploc.forth
                    else
                    	array.put ("_", lsr, lsc)
            		end
            		lsc := lsc + 1
            	 end
            	 lsr := lsr + 1
            end
            if write_flag then
            	i := i+1
                flag := "play"
            else
            	flag := "doredo"
            end


            game_on := true
        end

    fire   -- fires a projectile
        do

	        if game_on then
	          if not (shiploc.count = 0) then
	          	 if projloc.count = 0 then
	          	 	i2 := 0
	          	 	array.put ("*", shiploc.last.trow, (shiploc.last.tcol+1))

	                projloc.extend([shiploc.last.trow,shiploc.last.tcol+1])
	                projloc.forth
	                if write_flag then
            	        i := i+1
                        flag := "fire"
                    else
                    	flag := "doredo"
                    end
	             else
	             	i2 := 0
	                update_allproj
	                if collide_pass then
	                	  array.put ("_", collide_loc_pass.colr,collide_loc_pass.colc)
					      array.put ("X",shiploc.last.trow ,shiploc.last.tcol)
                          flag := "collidepass"
				          if write_flag then
	            	            i := i+1
	                      end

		                  game_on := false   -- reset
		                  create history.make_empty
		                  create last_write.make
       	                  cursor_position := 0
	                else
		                if (shiploc.last.tcol+1) <= col then
		                	array.put ("*", shiploc.last.trow, (shiploc.last.tcol+1)) -- still fire a new proj
		                end


		             	projloc.extend([shiploc.last.trow,shiploc.last.tcol+1])
		             	projloc.forth
		             	if write_flag then
	            	       i := i+1
                           flag := "fire"
                        else
                        	flag := "doredo"
	                    end
                   end
	          	 end

	          end
	        else
	        	flag := "noplay"
	        end
        end

     undo_fire  -- undo fire
         do

         	 if not (shiploc.count = 0) then
	          	 if projloc.count = 0 then

						  flag := "doundo"

	             else
	                --undo_proj
	                if (shiploc.last.tcol+1) <= col then

	                	array.put ("_", projloc.last.prow, (projloc.last.pcol)) -- still fire a new proj
	                	projloc.back
	                    projloc.remove_right
	                end
                     undo_proj

						  flag := "doundo"

	          	 end

	          end

         end

    update_allproj    -- move projectile
         local
         	in : INTEGER
         do
         	    in := 1
         	    across                                          -- increment prev proj as well
             		projloc is movloc
             	loop
             		if (movloc.pcol <= col) and (movloc.pcol >= 1) then
						array.put ("_", movloc.prow, movloc.pcol)
             		end

             		if movloc.pcol+fix_project_mov <= col then
             				array.put ("*", movloc.prow, movloc.pcol+fix_project_mov)
             		end

             	    	projloc.put_i_th ([movloc.prow,(movloc.pcol+fix_project_mov)], in)
             		--end
             		in := in + 1
             	end
         end

         undo_proj          -- undo projectiles

              	local
         	       in : INTEGER
                do
         	    in := 1
         	    across                                          -- increment prev proj as well
             		projloc is movloc
             	loop
             		if movloc.pcol <= col then
						array.put ("_", movloc.prow, movloc.pcol)
             		end

             		if (movloc.pcol-fix_project_mov >= 1) and (movloc.pcol-fix_project_mov <= array.width) then
             				array.put ("*", movloc.prow, movloc.pcol-fix_project_mov)   -- create * at - fixval
             		end

             	    	projloc.put_i_th ([movloc.prow,(movloc.pcol-fix_project_mov)], in) -- undo location for each projectile by - fixval
             		--end
             		in := in + 1
             	end

              end

    move(mrow:INTEGER ; mcol:INTEGER)      -- move ship
        local
        	step_row : INTEGER
        	step_col : INTEGER
        	steps : INTEGER
        do
            if shiploc.count /= 0 then
		        	i2 := 0
		           if ( mrow /= 0 and mcol /= 0 and shiploc.count /=0 ) then

		               if projloc.count /= 0 then
				           	update_allproj
				       end

				       if collide_pass then
	                	  array.put ("_", collide_loc_pass.colr,collide_loc_pass.colc)
					      array.put ("X",shiploc.last.trow ,shiploc.last.tcol)
                          flag := "collidepass"
				          if write_flag then
	            	            i := i+1
	                      end

		                  game_on := false   -- reset
		                  create history.make_empty
		                  create last_write.make
       	                  cursor_position := 0

		               elseif collide(mrow,mcol) then
		               	  array.put ("_", shiploc.last.trow, shiploc.last.tcol)
			           	  array.put ("X", collide_loc.colr, collide_loc.colc)
                          flag := "collide"
		                  if write_flag then
	            	            i := i+1
	                      end

		                  game_on := false   -- reset
		                  create history.make_empty
		                  create last_write.make
       	                  cursor_position := 0

		               else
--		                  if projloc.count /= 0 then
--				           	update_allproj
--				          end
			              array.put ("_", shiploc.last.trow, shiploc.last.tcol)
			           	  array.put ("S", mrow, mcol)
			           	  shiploc.extend ([mrow,mcol])  -- extend the ship loc which is used by fire command as well
			           	  shiploc.forth


			           	  if write_flag then
	            	         i := i+1
                             flag := "move"
                          else
                          	 flag := "doredo"
	                      end

		              end
		           end

		        --end
		    end
        end

     collide(mrow: INTEGER ; mcol: INTEGER):BOOLEAN
         local
         	crow,ccol,c1,c2,c_step : INTEGER
         do
            crow := shiploc.last.trow
            ccol := shiploc.last.tcol
         	if mrow < crow then  -- vertical case so row diff and col is same
         		c_step := -1
            else
            	c_step := 1
         	end
	            from
                   c1 := crow
	            until
                   (c1 = mrow) or (Result)
	            loop
	            	 crow := crow + c_step
                     across
                       projloc is ploc
                     loop
                     	if (ploc.prow = crow) and (ploc.pcol = ccol) and (not Result) then
                     		Result := true
	            			collide_loc := [crow,ccol]
                     	end

                     end

                    c1 := c1 + c_step
	            end

	            if not Result then
	            	if ccol > mcol then  -- vertical case so row same and col is diff
	            		c_step := -1
	                else
	                	c_step := 1
	            	end
	            	from
	            		c2 := ccol
	            	until
	            		(c2 = mcol) or (Result)
	            	loop
	            		ccol := ccol + c_step
	            		across
	            		  projloc is ploc
	            		loop
	            			if (ploc.prow = crow) and (ploc.pcol = ccol) and (not Result)  then
	                     		Result := true
		            			collide_loc := [crow,ccol]
                     	    end
	            		end

	            		c2 := c2 + c_step

	            	end
	            end

         end

     collide_my(mrow: INTEGER ; mcol: INTEGER):BOOLEAN
        do
            --if shiploc.last.trow = mrow then
                    across
	            	  projloc is ploc
	            	loop
	            		--mrow = ploc.prow
	            		if (mrow >= ploc.prow and shiploc.last.trow <= ploc.prow) or (mrow <= ploc.prow and shiploc.last.trow >= ploc.prow)   then
	            			--(mcol >= (ploc.pcol-fix_project_mov)) and (mcol <= ploc.pcol)
	            			if mcol = shiploc.last.tcol then
	            			   Result := true
	            			   collide_loc := [mrow,ploc.pcol]
	            			elseif ((ploc.pcol <= mcol) and (ploc.pcol >= shiploc.last.tcol)) or ((ploc.pcol >= mcol) and (ploc.pcol <= shiploc.last.tcol)) then
	            				    if mrow = shiploc.last.trow then
	            				    	Result := true
		                                collide_loc := [mrow,ploc.pcol]
	            				    end

		            	    end
		            	end
	                end
	        --end

        end

    undo_move         -- undo move of ship
        do

	            if projloc.count /= 0 then
				      undo_proj
				end
				      array.put ("_", shiploc.last.trow, shiploc.last.tcol)

				      if (not shiploc.before and shiploc.count > 0) then
				      	shiploc.back
				        shiploc.remove_right
				      end
				      if not shiploc.is_empty then
				      	array.put ("S", shiploc.last.trow, shiploc.last.tcol)
				      end


		          flag := "doundo"
		          --i := cursor_position

        end


    collide_temp(mrow: INTEGER ; mcol: INTEGER):BOOLEAN   -- see if collition occur
       local
       	inc : INTEGER
       	c : INTEGER
       do

       	  if shiploc.last.trow = mrow then
                    across
	            	  projloc is ploc
	            	loop
	            		if mrow = ploc.prow then
	            			if mcol >= ploc.pcol then
	                            Result := true
	                            collide_loc := [mrow,ploc.pcol]
	            			end
		            	end
	                end
          elseif shiploc.last.trow > mrow then

	            from
	            	inc := shiploc.last.trow
	            until
                    inc <= mrow
	            loop
	            	across
	            	  projloc is ploc
	            	loop
	            		if mrow = ploc.prow then
	            			if mcol >= ploc.pcol then
	                            Result := true
	                            collide_loc := [mrow,ploc.pcol]
	            			end
		            	end
	            	end

                    inc := inc - 1
	            end
          elseif shiploc.last.trow < mrow then
                from
	            	inc := shiploc.last.trow
	            until
                    inc >= mrow
	            loop
	            	across
	            	  projloc is ploc
	            	loop
	            		if mrow = ploc.prow then
	            			if mcol >= ploc.pcol then
	                            Result := true
	                            collide_loc := [mrow,ploc.pcol]
	            			end
		            	end
	            	end

                    inc := inc + 1
	            end
          end
       end

    pass        -- execute pass command
       do

	       if game_on then
	       	  i2 := 0
		       	  if shiploc.count /=0 then
		       	  	   if projloc.count /= 0 then
				           	update_allproj
				       end
				       if collide_pass then
				       	  --array.put ("_", collide_loc.colr , (projloc.last.pcol-fix_project_mov))
			       	  	  array.put ("_", collide_loc_pass.colr,collide_loc_pass.colc)
					      array.put ("X",shiploc.last.trow ,shiploc.last.tcol)
                          flag := "collidepass"
				          if write_flag then
	            	            i := i+1
	                      end

		                  game_on := false   -- reset
		                  create history.make_empty
       	                  cursor_position := 0
	       	           else

					       if write_flag then
		            	   i := i+1
                           flag := "pass"
                           else
                           	 flag := "doredo"
		                   end
	                   end
		       	  end
	      else
	       	  flag := "noplay"
	      end
       end

    collide_pass : BOOLEAN
       do
       	           across
	            	  projloc is ploc
	            	loop
	            		if shiploc.last.trow = ploc.prow then
	            			--((shiploc.last.tcol >= ploc.pcol) and (shiploc.last.tcol <= (ploc.prow-fix_project_mov)))
	            			if ((shiploc.last.tcol <= ploc.pcol ) and (shiploc.last.tcol >= (ploc.pcol-fix_project_mov))) then
	                            Result := true
	                            collide_loc_pass := [ploc.prow,ploc.pcol]  -- use this
	            			end
		            	end
	                end
       end

    undo_pass        -- undo pass command
       do
       	  if game_on then
       	  	 if shiploc.count /=0 then
       	  	 	 if projloc.count /= 0 then
       	  	 	 	 undo_proj
       	  	 	 end
       	  	 	  flag := "doundo"

       	  	 end
       	  else
       	  	 flag := "noplay"
       	  end
       end

    abort        -- end the game
       do

       	  if game_on then
       	  	i2 := 0
       	  	flag := "abort"
       	  	--if write_flag then
            	i := i+1

            --end
       	    game_on := false

       	    create history.make_empty
       	    cursor_position := 0
       	  else
       	  	flag := "noplay"
       	  end

       end


     add_command(c : COMMANDS)    -- add commands into linked list
        local
        	p,ii,write_count : INTEGER
        do
        	-- remove partial
        	if history.count /= cursor_position then
        		p := history.count - cursor_position
        		history.remove_tail (p)
        		write_count := last_write.count-1
        		from
      	          	ii := (last_write.index)
      	        until
      		        ii > write_count -- put when to exit , (exit condition)
      	        loop
		            --last_write.remove_right
		            last_write.remove_right
		            ii := ii + 1
      	        end
        		--last_write.remove_right
        		--i := cursor_position
        		i2 := 0
        	end
            history.force (c, history.count+1)
            cursor_position := cursor_position + 1
        end
     decrement_cursor
        do
        	cursor_position := cursor_position - 1
        end
     increment_cursor
        do
        	cursor_position := cursor_position + 1
        end
    change_flag(set:STRING)       -- update flag to print commands
       do
       	flag := set
       end

    change_write_flag(set:BOOLEAN)
       do
       	write_flag := set
       end
    change_i2(in : INTEGER)
       do
       	 i2 := in
       end
    change_i(in : INTEGER)
       do
       	 i := in
       end
	default_update
			-- Perform update to the model state.
		do
			i := i + 1
		end

	reset
			-- Reset model state.
		do
			make
		end

	entire_grid : STRING        -- create entire grid
	    local
	    	inc_row,inc_col,in : INTEGER
	    	arr : ARRAY [STRING]
	    do
		    	create Result.make_from_string ("")
		    	create arr.make_empty
				arr.force ("A", arr.count+1)
				arr.force ("B", arr.count+1)
				arr.force ("C", arr.count+1)
				arr.force ("D", arr.count+1)
				arr.force ("E", arr.count+1)
				arr.force ("F", arr.count+1)
				arr.force ("G", arr.count+1)
				arr.force ("H", arr.count+1)
				arr.force ("I", arr.count+1)
				arr.force ("J", arr.count+1)

                from
                	inc_row := 1
                until
                	inc_row > r
                loop
                     from
                        inc_col := 1
                     until
                        inc_col > col
                     loop
	                     	if (inc_row=1 and inc_col = 1) then -- for 1 to 10 print
	                     		from
	                     		   in := 1
	                     		until
	                     			in > col
	                     		loop
	                     			Result.append (in.out)
	                     			if in >= 9 and in < col then
	                     			   Result.append (" ")
	                     			elseif in < 9 and in < col then
	                     			   Result.append ("  ")
	                     			end
	                     		    in := in + 1
	                     		end
	                     	    Result.append ("%N")
	                     	end

	                     if (inc_col = 1 and inc_row <= r) then
	                     	   Result.append("    ")
                               Result.append(arr[inc_row])  --
                     		   Result.append(" ")
                        end

                     	--Result.append("_")  --
                     	Result.append(array.item (inc_row, inc_col))  -- the elements here
                     	if inc_col < col then
                     	   Result.append ("  ")
                     	end
                        inc_col := inc_col + 1
                     end -- col end

                     if inc_row < r then
                     	Result.append ("%N")
                     end
                     inc_row := inc_row + 1
                end
	    end

feature -- queries
	out : STRING      -- output
	    local
	    	inc_row,inc_col,in,arrin,l : INTEGER
	    	arr : ARRAY [STRING]
	    	b1,b2 : BOOLEAN
		do
		    create Result.make_from_string ("  ")
			-- This is how the message and output is given to user

			if (flag ~ "play") then  -- for play and fire

			    Result.append ("state:")
	            Result.append (i.out)
	            Result.append (".")
	            Result.append ("0")
	            Result.append (", ok")
	            Result.append ("%N")
				Result.append ("      ")
				--if write_flag then
					last_write.extend (Result)  -- add coomand to write list and before grid
	                last_write.forth
	            --end
	             write_flag := true
				Result.append (entire_grid)
                flag.replace_blank  -- reset the flag
            elseif flag ~ "fire" then
            	Result.append ("state:")
	            Result.append (i.out)
	            Result.append (".")
	            Result.append ("0")
	            Result.append (", ok")
	            Result.append ("%N")
	            Result.append ("  ")
	            if projloc.count = 1 then
		            Result.append("The Starfighter fires a projectile at: ")
		            Result.append ("[")
		            if attached keyval.item (projloc.first.prow) as t then
		            	Result.append (t.to_string_8)
		            end
		            Result.append (",")
		            Result.append ((projloc.first.pcol-1).out)
		            Result.append ("]")
		        else
		        	in := 1  -- just a counter
		        	across
		        		projloc is tuple_loc
		        	loop
					    if (in >= 1 and in < projloc.count) then
					         if (tuple_loc.pcol-fix_project_mov) <= col then

						    	 Result.append("A projectile moves: ")
			                     Result.append ("[")
			                     if attached keyval.item (tuple_loc.prow) as t then
			            	       Result.append (t.to_string_8)
			                     end
						         --Result.append (keyval.item (tuple_loc.prow))
						         Result.append (",")
						         Result.append ((tuple_loc.pcol-fix_project_mov).out) -- to go 1 step behind
						         Result.append ("]")
						         Result.append (" -> ")
						         if (tuple_loc.pcol <= col) then
		                             Result.append ("[")
		                             if attached keyval.item (tuple_loc.prow) as t then
				            	       Result.append (t.to_string_8)
				                     end
		                             --Result.append (keyval.item (tuple_loc.prow))
							         Result.append (",")
							         Result.append ((tuple_loc.pcol).out)  -- to 1 step behind so not add fix inc
							         Result.append ("]")
							         Result.append ("%N  ")
							     else
							     	 Result.append ("out of the board")
							     	 Result.append ("%N  ")
							     end

						     end

		        		end
		        		if in = projloc.count then
		        			 Result.append("The Starfighter fires a projectile at: ")
		                     Result.append ("[")
		                     if attached keyval.item (tuple_loc.prow) as t then
		            	       Result.append (t.to_string_8)
		                     end
					         --Result.append (keyval.item (tuple_loc.prow))
					         Result.append (",")
					         Result.append ((tuple_loc.pcol-1).out)
					         Result.append ("]")
					    end
		        		in := in + 1
		        	end
	            end
	                    Result.append ("%N")
			            Result.append ("      ")
			            --if write_flag then
				            last_write.extend (Result)  -- add coomand to write list
	                        last_write.forth
	                    --end
	                      write_flag := true  -- reset the bool for next command to add its words
			            Result.append (entire_grid)
                flag.replace_blank  -- reset the flag
            elseif flag ~ "move" then
            	Result.append ("state:")
	            Result.append (i.out)
	            Result.append (".")
	            Result.append ("0")
	            Result.append (", ok")
	            Result.append ("%N")
	            Result.append ("  ")
            	if projloc.count /=0 then
            		across
            			projloc is movloc
            		loop
                          l := (movloc.pcol-fix_project_mov)
            			  if l <= (col) then
            			     Result.append("A projectile moves: ")
		                     Result.append ("[")
		                     if attached keyval.item (movloc.prow) as t then
		            	       Result.append (t.to_string_8)
		                     end
					         --Result.append (keyval.item (tuple_loc.prow))
					         Result.append (",")
					         Result.append ((movloc.pcol-fix_project_mov).out)
					         Result.append ("]")
					         Result.append (" -> ")
					         if (movloc.pcol <= col) then
	                             Result.append ("[")
	                             if attached keyval.item (movloc.prow) as t then
			            	       Result.append (t.to_string_8)
			                     end
	                             --Result.append (keyval.item (tuple_loc.prow))
						         Result.append (",")
						         Result.append ((movloc.pcol).out)
						         Result.append ("]")
						         Result.append ("%N  ")
						     else
						    	 Result.append ("out of the board")
						    	 Result.append ("%N  ")
						     end

					      end

            		end
            	end
		            		Result.append("The Starfighter moves: [")
		                    in := 1
			                    across
			                      shiploc is ls_ship
			                    loop
			                    	if in = (shiploc.count-1) then   -- get 2nd last element
	                                   if attached keyval.item (ls_ship.trow) as t then
			            	               Result.append (t.to_string_8)
			                           end
			                           Result.append (",")
			                    	   Result.append (ls_ship.tcol.out)
			                    	   Result.append ("]")
			                    	end
			                    	in := in + 1
			                    end
				                    Result.append (" -> ")
		                            Result.append ("[")
		                            if attached keyval.item (shiploc.last.trow) as t then
				            	               Result.append (t.to_string_8)
				                    end
		                            --Result.append (keyval.item (shiploc.last.trow).to_string_8)
		                            Result.append (",")
		                            if attached (shiploc.last.tcol) as t1 then
				            	               Result.append (t1.out)
				                    end
				                    Result.append ("]")
	            	--end
                         Result.append ("%N")
				         Result.append ("      ")
				         --if write_flag then
				         	last_write.extend (Result)  -- add coomand to write list
	                        last_write.forth
				         --end
                         write_flag := true
				         Result.append (entire_grid)
	            	     flag.replace_blank  -- reset the flag
	        elseif flag ~ "collide" then

                Result.append ("state:")
	            Result.append (i.out)
	            Result.append (".")
	            Result.append ("0")
	            Result.append (", ok")
	            Result.append ("%N")
	            Result.append ("  ")
                 if projloc.count /=0 then
            		across
            			projloc is movloc
            		loop
            		      if (movloc.pcol-fix_project_mov) <= col then
            			     Result.append("A projectile moves: ")
		                     Result.append ("[")
		                     if attached keyval.item (movloc.prow) as t then
		            	       Result.append (t.to_string_8)
		                     end
					         --Result.append (keyval.item (tuple_loc.prow))
					         Result.append (",")
					         Result.append ((movloc.pcol-fix_project_mov).out)
					         Result.append ("]")
					         Result.append (" -> ")
					         if (movloc.pcol <= col) then
                                 Result.append ("[")
	                             if attached keyval.item (movloc.prow) as t then
			            	       Result.append (t.to_string_8)
			                     end
	                             --Result.append (keyval.item (tuple_loc.prow))
						         Result.append (",")
						         Result.append ((movloc.pcol).out)
						         Result.append ("]")
						         Result.append ("%N  ")
						     else
						         Result.append ("out of the board")
						         Result.append ("%N  ")
						     end

					      end

            		end
            	 end
		            		Result.append("The Starfighter moves and collides with a projectile: [")
		                            if attached keyval.item (shiploc.last.trow) as t then
				            	               Result.append (t.to_string_8)
				                    end
                                    --Result.append (shiploc.last.trow)  -- as the time of collition the final destination was not saved
                                    Result.append (",")
			                    	Result.append (shiploc.last.tcol.out)
			                    	Result.append ("]")
				                    Result.append (" -> ")
		                            Result.append ("[")
		                            if attached keyval.item (collide_loc.colr) as t then
				            	               Result.append (t.to_string_8)
				                    end
		                            --Result.append (keyval.item (shiploc.last.trow).to_string_8)
		                            Result.append (",")
		                            Result.append (collide_loc.colc.out)
				                    Result.append ("]")
	            	     Result.append ("%N")
				         Result.append ("      ")
				         Result.append (entire_grid)
				         Result.append ("%N")
				         Result.append("  The game is over. Better luck next time!")
	            	     flag.replace_blank  -- reset the flag

	        elseif flag ~ "collidepass" then
                        Result.append ("state:")
			            Result.append (i.out)
			            Result.append (".")
			            Result.append ("0")
			            Result.append (", ok")
			            Result.append ("%N")
			            Result.append ("  ")
			            	Result.append("A projectile moves and collides with the Starfighter: [")
		                            if attached keyval.item (collide_loc_pass.colr) as t then -- for any proj
				            	               Result.append (t.to_string_8)
				                    end
                                    --Result.append (shiploc.last.trow)  -- as the time of collition the final destination was not saved
                                    Result.append (",")
			                    	Result.append ((collide_loc_pass.colc-fix_project_mov).out)
			                    	Result.append ("]")
				                    Result.append (" -> ")
		                            Result.append ("[")
		                            if attached keyval.item (shiploc.last.trow) as t then
				            	               Result.append (t.to_string_8)
				                    end
		                            --Result.append (keyval.item (shiploc.last.trow).to_string_8)
		                            Result.append (",")
		                            Result.append (shiploc.last.tcol.out)
				                    Result.append ("]")

				                    Result.append ("%N")  -- proj display
				                    --Result.append ("  ")

				             if (projloc.count > 1) then
			            		across
			            			projloc is movloc
			            		loop
			            			if ( (movloc.prow = collide_loc_pass.colr)) then
			            				b1 := ( (movloc.prow = collide_loc_pass.colr))
			            		    else
			            		      	b1 := ( (movloc.prow /= collide_loc_pass.colr))
			            			end

                                    b2 := ((movloc.pcol /= collide_loc_pass.colc))
			            			if b1 and b2 then


			            		      if (movloc.pcol-fix_project_mov) <= col then
			            			     Result.append("  A projectile moves: ")
					                     Result.append ("[")
					                     if attached keyval.item (movloc.prow) as t then
					            	       Result.append (t.to_string_8)
					                     end
								         --Result.append (keyval.item (tuple_loc.prow))
								         Result.append (",")
								         Result.append ((movloc.pcol-fix_project_mov).out)
								         Result.append ("]")
								         Result.append (" -> ")
								         if (movloc.pcol <= col) then
			                                 Result.append ("[")
				                             if attached keyval.item (movloc.prow) as t then
						            	       Result.append (t.to_string_8)
						                     end
				                             --Result.append (keyval.item (tuple_loc.prow))
									         Result.append (",")
									         Result.append ((movloc.pcol).out)
									         Result.append ("]")
									         Result.append ("%N")
									     else
									         Result.append ("out of the board")
									         Result.append ("%N")
									     end

								      end
                                    end
			            		end
			            	 end

	            	     --Result.append ("%N")
				         Result.append ("      ")
				         Result.append (entire_grid)
				         Result.append ("%N")
				         Result.append("  The game is over. Better luck next time!")
	            	     flag.replace_blank  -- reset the flag


	        elseif flag ~ "pass" then
	        	    Result.append ("state:")
		            Result.append (i.out)
		            Result.append (".")
		            Result.append ("0")
		            Result.append (", ok")
		            Result.append ("%N")
		            Result.append ("  ")
                     if projloc.count /=0 then
            		across
            			projloc is movloc
            		loop
            			   if (movloc.pcol-fix_project_mov) <= col then
            			     Result.append("A projectile moves: ")
		                     Result.append ("[")
		                     if attached keyval.item (movloc.prow) as t then
		            	       Result.append (t.to_string_8)
		                     end
					         --Result.append (keyval.item (tuple_loc.prow))
					         Result.append (",")
					         Result.append ((movloc.pcol-fix_project_mov).out)
					         Result.append ("]")
					         Result.append (" -> ")
					         if (movloc.pcol <= col) then
	                             Result.append ("[")
	                             if attached keyval.item (movloc.prow) as t then
			            	       Result.append (t.to_string_8)
			                     end
	                             --Result.append (keyval.item (tuple_loc.prow))
						         Result.append (",")
						         Result.append ((movloc.pcol).out)
						         Result.append ("]")
						         Result.append ("%N  ")
						     else
						         Result.append ("out of the board")
						         Result.append ("%N  ")
						     end

					       end

            		end
            	end
		            		Result.append("The Starfighter stays at: [")
		                    if attached keyval.item (shiploc.last.trow) as t then
				            	      Result.append (t.to_string_8)
				            end
                             --Result.append (shiploc.last.trow)  -- as the time of collition the final destination was not saved
                             Result.append (",")
			                 Result.append (shiploc.last.tcol.out)
			                 Result.append ("]")

	            	--end

                         Result.append ("%N")
                         Result.append ("      ")
                        -- if write_flag then
					         last_write.extend (Result)  -- add coomand to write list
	                         last_write.forth
	                    -- end
	                        write_flag := true
				         Result.append (entire_grid)
	            	     flag.replace_blank  -- reset the flag
	        elseif flag ~ "abort" then
	        	Result.append ("state:")
	            Result.append (i.out)
	            Result.append (".")
	            Result.append ("0")
	            Result.append (", ok")
	            Result.append ("%N")
	            Result.append ("  ")
	        	  Result.append ("Game has been exited.")
	        elseif flag ~ "noplay" then
	        	Result.append ("state:")
	            Result.append (i.out)
	            Result.append (".")
	            Result.append (i2.out)
	            Result.append (", error")
	            Result.append ("%N")
	            Result.append ("  ")
                  Result.append ("Not in game.")
            elseif flag ~ "nothing_undo" then
            	Result.append ("state:")
	            Result.append (i.out)
	            Result.append (".")
	            Result.append (i2.out)
	            Result.append (", error")
	            Result.append ("%N")
	            Result.append ("  ")
            	  Result.append ("Nothing left to undo.")
            elseif flag ~ "nothing_redo" then
            	Result.append ("state:")
	            Result.append (i.out)
	            Result.append (".")
	            Result.append (i2.out)
	            Result.append (", error")
	            Result.append ("%N")
	            Result.append ("  ")
            	 Result.append ("Nothing left to redo.")
            elseif flag ~ "gameison" then
            	Result.append ("state:")
	            Result.append (i.out)
	            Result.append (".")
	            Result.append (i2.out)
	            Result.append (", error")
	            Result.append ("%N")
	            Result.append ("  ")
            	  Result.append ("Please end the current game before starting a new one.")
            elseif flag ~ "doundo" then
            	  --create Result.make_from_string ("  ")
                  Result.wipe_out
            	  if not last_write.before then
            	    last_write.back
            	    if not last_write.off then
            	    	Result.append (last_write.item)
            	    end

            	  end
            	  flag.replace_blank  -- reset the flag
            	  --Result.append (entire_grid)

            elseif flag ~ "doredo" then
            	   Result.wipe_out
            	 if not last_write.after then
            	    last_write.forth
            	    if not last_write.off then
            	    	Result.append (last_write.item)
            	    end
            	end
            	write_flag := true
            	flag.replace_blank  -- reset the flag
            elseif flag ~ "outbound" then
            	Result.append ("state:")
	            Result.append (i.out)
	            Result.append (".")
	            Result.append (i2.out)
	            Result.append (", error")
	            Result.append ("%N")
	            Result.append ("  ")
            	  Result.append ("The location to move to is outside of the board.")
            elseif flag ~ "morestep" then
            	Result.append ("state:")
	            Result.append (i.out)
	            Result.append (".")
	            Result.append (i2.out)
	            Result.append (", error")
	            Result.append ("%N")
	            Result.append ("  ")
            	  Result.append ("The location to move to is out of the Starfighter's movement range.")
            elseif flag ~ "sameloc" then
            	Result.append ("state:")
	            Result.append (i.out)
	            Result.append (".")
	            Result.append (i2.out)
	            Result.append (", error")
	            Result.append ("%N")
	            Result.append ("  ")
            	   Result.append ("The Starfighter is already at that location.")
            elseif flag ~ "exceedmove" then
            	Result.append ("state:")
	            Result.append (i.out)
	            Result.append (".")
	            Result.append (i2.out)
	            Result.append (", error")
	            Result.append ("%N")
	            Result.append ("  ")
            	   Result.append ("Starfighter movement should not exceed row - 1 + column - 1 size of the board.")
            else
            	Result.append ("Welcome to Space Defender Version 1.")

			end
		end

end




