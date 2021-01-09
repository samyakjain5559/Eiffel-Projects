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
	    local
			-- Initialization for `Current'.
			sc : SCORE_BUCKET
		do
			create s.make_empty
			i := 0
			i2 := 0
			setup_mode := false
			setup_cursor := 0
			flag := ""
			in_game := false
			debug_flag := false
			weapon_name := "Standard"
			armour_name := "None"
			engine_name := "Standard"
			power_name := "Recall (50 energy): Teleport back to spawn."
			selected := ""
			projenemycollidesign := ""
			enemyspawn := ""
			tolhealth := 0
			tolenergy := 0
			tolregenh := 0
			tolregene := 0
			tolarmour := 0
			tolvision := 0
			tolmove := 0
			tolmovecost := 0
			tolprojdamage := 0
			tolprojcost := 0
			score := 0
			remainhealth := 0
			remainenergy := 0
			fix_project_mov := 0
			idp := -1
			enemydata_cursor := 0
			projenemycolliderow := 0
			projenemycollidecol := 0
			projenemycollideid := 0
			projenemycollidenumber := 0
			enemyid := 1
			fighterfirecount := 0
			movefighterrow := 0
			movefightercol := 0
			enemyatspawnprojenumber := 0
			projfightercolliderow := 0
			projfightercollidecol := 0
			projecollideprojenumber := 0
			projfcollideprojeid := 0
			projfcollideprojerow := 0
			projfcollideprojecol := 0
			enemycollideprojfrow := 0
			enemycollideprojfcol := 0
			projecollideprojfrow := 0
			projecollideprojfcol := 0
			projfcollideprojeenemyid := 0
			projeatspawnprojid := 0
			projatspawnprojfid := 0
			projatspawnprojfrow := 0
			projatspawnprojfcol := 0
			projfatspawnprojid := 0
			projfspawnatprojfid := 0
			create data.make_empty
			create enemydata.make
			create {LINKED_LIST[TUPLE[trow:INTEGER;tcol:INTEGER]]} shiploc.make
			create {LINKED_LIST[TUPLE[trow:INTEGER;tcol:INTEGER]]} enemyloc.make
			create {LINKED_LIST[TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER;direction:STRING]]} projloc.make
			create fighteraction.make
			create premprint.make
			--create premprint1.make
			create eprojaction.make
			create friendlyprojaction.make
			create collide_loc
			create collide_locenemy
			create collide_enemyloc
            create collide_loc_pass
            create fightermovecollide
            create array.make_filled("",0,0)
            create keyval.make(10)
            create projectile.make_from_string ("")
            create fighterfocus.make
            --create normaltempll.make
            --create premtempll.make
		end

feature -- model attributes
	s : STRING
	i,i2,idp,r,col,g_thresh,f_thresh,c_thresh,i_thresh,p_thresh,score,remainhealth,remainenergy,enemyid,projfightercolliderow,projfightercollidecol :INTEGER
	tolhealth,tolenergy,tolregenh,tolregene,tolarmour,tolvision,tolmove,tolmovecost,tolprojdamage,tolprojcost,projfcollideprojeid,projfcollideprojerow,projfcollideprojecol : INTEGER -- used this to print final out
	setup_mode : BOOLEAN
	setup_cursor,fix_project_mov,projenemycolliderow,projenemycollidecol,projenemycollideid,fighterfirecount,movefighterrow,movefightercol,projeatspawnprojid : INTEGER
	enemycollideprojfrow,enemycollideprojfcol,projecollideprojfrow,projecollideprojfcol,enemyatspawnprojenumber,projecollideprojenumber,projfcollideprojeenemyid : INTEGER
	projatspawnprojfid,projatspawnprojfrow,projatspawnprojfcol,projenemycollidenumber,projfatspawnprojid, projfspawnatprojfid : INTEGER
	fighterfocus : LINKED_LIST[SCORE_BUCKET]
	flag,projectile,enemyspawn : STRING
	in_game,debug_flag : BOOLEAN
	weapon_name,armour_name,engine_name,power_name,projenemycollidesign : STRING -- use these to print
    selected : STRING  -- selected states name
    data : ARRAY[TUPLE[health:INTEGER;energy:INTEGER;regenh:INTEGER;regene:INTEGER;armour:INTEGER;vision:INTEGER;move:INTEGER;movecost:INTEGER;projdamage:INTEGER;projcost:INTEGER]]
    shiploc : LIST[TUPLE[trow:INTEGER;tcol:INTEGER]]
    enemyloc : LIST[TUPLE[trow:INTEGER;tcol:INTEGER]]
	projloc : LIST[TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER;direction:STRING]]
	--premprint : LINKED_LIST[TUPLE[prem:STRING;normal:STRING]]
	premprint : LINKED_LIST[TUPLE[prem:LINKED_LIST[STRING];normal:LINKED_LIST[STRING]]]
    eprojaction,friendlyprojaction,fighteraction  : LINKED_LIST[STRING]
	collide_loc : TUPLE[colr:INTEGER;colc:INTEGER]
	collide_locenemy : TUPLE[colr:INTEGER;colc:INTEGER]
	fightermovecollide : TUPLE[colr:INTEGER;colc:INTEGER] -- final answer of above 2
	collide_enemyloc : TUPLE[colr:INTEGER;colc:INTEGER]
	collide_loc_pass : TUPLE[colr:INTEGER;colc:INTEGER]
	array : ARRAY2 [STRING]
	keyval : HASH_TABLE[STRING,INTEGER]
	enemydata : LINKED_LIST[TUPLE[health :INTEGER;tolhealth:INTEGER;regen:INTEGER;armour:INTEGER;vision:INTEGER;preemprojdamage:INTEGER;notseenprojdamage:INTEGER;seenprojdamage:INTEGER;preemprojmove:INTEGER;notseenprojmove:INTEGER;seenprojmove:INTEGER;preemenemymove:INTEGER;notseenenemymove:INTEGER;seenenemymove:INTEGER;id:INTEGER;sign:STRING;projsign:STRING;spawn_row:INTEGER;spawn_col:INTEGER;canseefighter:BOOLEAN;seenbyfighter:BOOLEAN;dead:BOOLEAN;turn:BOOLEAN]]
	enemydata_cursor : INTEGER
	--normaltempll,premtempll : LINKED_LIST[STRING]
feature -- model operations


    ingamesetup
        local
        	array_temp : ARRAY2 [STRING]
        	lsr,lsc,step_row,step_col,steps  : INTEGER
        	helper : FEATUREHELPER
        do
        	remainhealth := tolhealth  -- full health initially
        	remainenergy := tolenergy
        	if weapon_name ~ "Standard" then
                 fix_project_mov := 5
        	elseif weapon_name ~ "Spread" then
                 fix_project_mov := 1
        	elseif weapon_name ~ "Snipe" then
                 fix_project_mov := 8
        	elseif weapon_name ~ "Rocket" then
                 fix_project_mov := 1     -- doubles every turn
        	elseif weapon_name ~ "Splitter" then
                 fix_project_mov := 0
        	end
            i2 := 0
            i := 0
            create array_temp.make_filled ("", r, col)
            array := array_temp
            from
            	lsr := 1
            until
            	lsr > r
            loop
            	from
            		lsc := 1
            	until
            		lsc > col
            	loop
            	    if shiploc.count = 0  then
	            		step_row := ((r/2).ceiling - lsr)
			            step_col := (1 - lsc)
			            steps := step_row.abs + step_col.abs
			        else
			        	step_row := (shiploc.last.trow - lsr)
			            step_col := (shiploc.last.tcol - lsc)
			            steps := step_row.abs + step_col.abs
			        end
            		if lsr = (r/2).ceiling and lsc = 1 then
                        array.put ("S", lsr, lsc)
                        shiploc.extend([lsr,lsc])
                        shiploc.forth
                    elseif (steps > tolvision) and (not debug_flag) then
                        array.put ("?", lsr, lsc)
                    else
                    	array.put ("_", lsr, lsc)
            		end
            		lsc := lsc + 1
            	 end
            	 lsr := lsr + 1
            end
            flag := "play0"
        end

    fighter_vision(fighterrow:INTEGER ; fightercol:INTEGER)  -- update ? not S
        local
        	lsr,lsc,step_row,step_col,steps  : INTEGER
        do
              -- reset prev ? so _ all place then new ?  -- no need to reset
            from
            	lsr := 1
            until
            	lsr > r
            loop
            	from
            		lsc := 1
            	until
            		lsc > col
            	loop
            	    if shiploc.count = 0  then
	            		step_row := ((r/2).ceiling - lsr)
			            step_col := (1 - lsc)
			            steps := step_row.abs + step_col.abs
			        else
			        	step_row := (fighterrow - lsr)
			            step_col := (fightercol - lsc)
			            steps := step_row.abs + step_col.abs
			        end

                    if (steps > tolvision) and (not debug_flag)  then
                    	if lsr <= array.height and lsc <= array.width then
                    		array.put ("?", lsr, lsc)
                    	end
                    else
                    	if lsr <= array.height and lsc <= array.width then
                    		array.put ("_", lsr, lsc)
                    	end
            		end
            		lsc := lsc + 1
            	 end
            	 lsr := lsr + 1
            end

        end

    num_steps(start_row:INTEGER;start_col:INTEGER;end_row:INTEGER;end_col:INTEGER):INTEGER
        local
        	step_row,step_col  : INTEGER
        do
        		step_row := (start_row - end_row)
			    step_col := (start_col - end_col)
			    Result := step_row.abs + step_col.abs
        end

    play_setup(row: INTEGER_32 ; column: INTEGER_32 ; g_threshold: INTEGER_32 ; f_threshold: INTEGER_32 ; c_threshold: INTEGER_32 ; i_threshold: INTEGER_32 ; p_threshold: INTEGER_32) -- only for initial setup / intialisation first print in setup next
        do
           create s.make_empty
			i := 0
			i2 := 0
			setup_mode := false
			setup_cursor := 0
			flag := ""
			in_game := false
			--debug_flag := false

--			weapon_name := "Standard"
--			armour_name := "None"
--			engine_name := "Standard"
--			power_name := "Recall (50 energy): Teleport back to spawn."
			selected := ""
			projenemycollidesign := ""
			enemyspawn := ""
--			tolhealth := 0
--			tolenergy := 0
--			tolregenh := 0
--			tolregene := 0
--			tolarmour := 0
--			tolvision := 0
--			tolmove := 0
--			tolmovecost := 0
			tolprojdamage := 0
			tolprojcost := 0
			score := 0
			remainhealth := 0
			remainenergy := 0
			fix_project_mov := 0
			idp := -1
			enemydata_cursor := 0
			projenemycolliderow := 0
			projenemycollidecol := 0
			projenemycollideid := 0
			projenemycollidenumber := 0
			enemyid := 1
			fighterfirecount := 0
			movefighterrow := 0
			movefightercol := 0
			enemyatspawnprojenumber := 0
			projfightercolliderow := 0
			projfightercollidecol := 0
			projecollideprojenumber := 0
			projfcollideprojeid := 0
			projfcollideprojerow := 0
			projfcollideprojecol := 0
			enemycollideprojfrow := 0
			enemycollideprojfcol := 0
			projecollideprojfrow := 0
			projecollideprojfcol := 0
			projfcollideprojeenemyid := 0
			projeatspawnprojid := 0
			projatspawnprojfid := 0
			projatspawnprojfrow := 0
			projatspawnprojfcol := 0
			projfatspawnprojid := 0
			projfspawnatprojfid := 0
			--create data.make_empty
			create enemydata.make
			create {LINKED_LIST[TUPLE[trow:INTEGER;tcol:INTEGER]]} shiploc.make
			create {LINKED_LIST[TUPLE[trow:INTEGER;tcol:INTEGER]]} enemyloc.make
			create {LINKED_LIST[TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER;direction:STRING]]} projloc.make
			create fighteraction.make
			create premprint.make
			--create premprint1.make
			create eprojaction.make
			create friendlyprojaction.make
			create collide_loc
			create collide_locenemy
			create collide_enemyloc
            create collide_loc_pass
            create fightermovecollide
            create array.make_filled("",0,0)
            create keyval.make(10)
            create fighterfocus.make
            create projectile.make_from_string ("")


           setup_cursor := 1
           data.force ([10,10,0,1,0,1,1,1,70,5], data.count+1)  -- weapon default
           data.force ([50,0,1,0,0,0,1,0,0,0], data.count+1)  -- armour
           data.force ([10,60,0,2,1,12,8,2,0,0], data.count+1) -- engine
           flag := "weaponstate"
           projloc.wipe_out  -- Reset proj for new game
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
           g_thresh := g_threshold
           f_thresh := f_threshold
           c_thresh := c_threshold
           i_thresh := i_threshold
           p_thresh := p_threshold
        end

      canseenby(start_row:INTEGER;start_col:INTEGER;end_row:INTEGER;end_col:INTEGER;vision:INTEGER):BOOLEAN  -- from current location of enemy to fighter of both vision
         do
         	if num_steps(start_row,start_col,end_row,end_col) > vision  then       -- depend on diffrent vision
         		Result := false
            else
            	Result := true
         	end
         end

      hasenemyin(enemystartrow:INTEGER;enemystartcol:INTEGER;enemyendrow:INTEGER;enemyendcol:INTEGER):BOOLEAN
        local
         	crow,ccol,c1,c2,c_step : INTEGER
         do
	          crow := enemystartrow
	          ccol := enemystartcol
	         	if enemyendrow < crow then  -- vertical case so row diff and col is same
	         		c_step := -1
	            else
	            	c_step := 1
	         	end
	            from
                   c1 := crow
	            until
                   (c1 = enemyendrow) or (Result)
	            loop
	            	 crow := crow + c_step
                     across
                       enemydata is edata
                     loop
                     	if (edata.spawn_row = crow) and (edata.spawn_col = ccol) and (not Result) and edata.dead = false then
                     		Result := true
	            			collide_enemyloc := [crow,ccol]
                     	end

                     end

                    c1 := c1 + c_step
	            end

	            if not Result then
	            	if ccol > enemyendcol then  -- vertical case so row same and col is diff
	            		c_step := -1
	                else
	                	c_step := 1
	            	end
	            	from
	            		c2 := ccol
	            	until
	            		(c2 = enemyendcol) or (Result)
	            	loop
	            		ccol := ccol + c_step
	            		across
	            		  enemydata is edata
	            		loop
	            			if (edata.spawn_row = crow) and (edata.spawn_col = ccol) and (not Result) and edata.dead = false  then
	                     		Result := true
		            			collide_enemyloc := [crow,ccol]
                     	    end
	            		end

	            		c2 := c2 + c_step

	            	end
	            end
        end


      enemy_spawn
         local
         	random : RANDOM_GENERATOR_ACCESS
			enemyspawncol,enemyfirstrow:INTEGER
			seenbyfighter : BOOLEAN
			canseefighter : BOOLEAN
         do
             enemyfirstrow := random.rchoose (1,r)
             enemyspawncol := random.rchoose (1,100)
             if (enemyspawncol >= 1) and (enemyspawncol <= (g_thresh-1)) then
                  --enemydata.force ([100,1,1,5,0,15,15,0,4,4,0,2,4,enemyid,"G","<",enemyfirstrow,col], enemydata.count+1)
                  seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,enemyfirstrow,col,tolvision)
         	   	  canseefighter := canseenby(enemyfirstrow,col,shiploc.last.trow,shiploc.last.tcol,5)
                  enemydata.extend ([100,100,1,1,5,0,15,15,0,4,4,0,2,4,enemyid,"G","<",enemyfirstrow,col,canseefighter,seenbyfighter,false,true])
                  enemyput(enemyfirstrow,enemyspawncol,"G",enemyid)
                  enemyid := enemyid + 1
                  --enemydata_cursor := enemydata_cursor + 1
                  --enemydata.forth
                  enemyloc.extend ([enemyfirstrow,col])
                  enemyloc.forth

             elseif (enemyspawncol >= g_thresh) and (enemyspawncol <= (f_thresh-1)) then
                  --enemydata.force ([150,5,10,10,100,20,50,10,3,6,6,3,1,enemyid,"F","<",enemyfirstrow,col], enemydata.count+1)
                  seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,enemyfirstrow,col,tolvision)
         	   	  canseefighter := canseenby(enemyfirstrow,col,shiploc.last.trow,shiploc.last.tcol,10)
                  enemydata.extend ([150,150,5,10,10,100,20,50,10,3,6,6,3,1,enemyid,"F","<",enemyfirstrow,col,canseefighter,seenbyfighter,false,true])
                  enemyput(enemyfirstrow,enemyspawncol,"F",enemyid)
                  enemyid := enemyid + 1
                  --enemydata_cursor := enemydata_cursor + 1
                  --enemydata.forth
                  enemyloc.extend ([enemyfirstrow,col])
                  enemyloc.forth

             elseif (enemyspawncol >= f_thresh) and (enemyspawncol <= (c_thresh-1)) then
             	  --enemydata.force ([200,10,15,15,0,0,0,0,0,0,2,2,1,enemyid,"C","<",enemyfirstrow,col], enemydata.count+1)
             	  seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,enemyfirstrow,col,tolvision)
         	   	  canseefighter := canseenby(enemyfirstrow,col,shiploc.last.trow,shiploc.last.tcol,15)
             	  enemydata.extend ([200,200,10,15,15,0,0,0,0,0,0,2,2,1,enemyid,"C","<",enemyfirstrow,col,canseefighter,seenbyfighter,false,true])
             	  enemyput(enemyfirstrow,enemyspawncol,"C",enemyid)
                  enemyid := enemyid + 1
                  --enemydata_cursor := enemydata_cursor + 1
                  --enemydata.forth
                  enemyloc.extend ([enemyfirstrow,col])
                  enemyloc.forth

             elseif (enemyspawncol >= c_thresh) and (enemyspawncol <= (i_thresh-1)) then
             	  --enemydata.force ([50,0,0,5,0,0,0,0,0,0,0,3,3,enemyid,"I","<",enemyfirstrow,col], enemydata.count+1)
             	  seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,enemyfirstrow,col,tolvision)
         	   	  canseefighter := canseenby(enemyfirstrow,col,shiploc.last.trow,shiploc.last.tcol,5)
             	  enemydata.extend ([50,50,0,0,5,0,0,0,0,0,0,0,3,3,enemyid,"I","<",enemyfirstrow,col,canseefighter,seenbyfighter,false,true])
             	  enemyput(enemyfirstrow,enemyspawncol,"I",enemyid)
                  enemyid := enemyid + 1
                  --enemydata_cursor := enemydata_cursor + 1
                  --enemydata.forth
                  enemyloc.extend ([enemyfirstrow,col])
                  enemyloc.forth

             elseif (enemyspawncol >= i_thresh) and (enemyspawncol <= (p_thresh-1)) then
             	  --enemydata.force ([300,0,0,5,0,0,70,0,0,2,0,2,1,enemyid,"P","<",enemyfirstrow,col], enemydata.count+1)
             	  seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,enemyfirstrow,col,tolvision)
         	   	  canseefighter := canseenby(enemyfirstrow,col,shiploc.last.trow,shiploc.last.tcol,5)
             	  enemydata.extend ([300,300,0,0,5,0,0,70,0,0,2,0,2,1,enemyid,"P","<",enemyfirstrow,col,canseefighter,seenbyfighter,false,true])
             	  enemyput(enemyfirstrow,enemyspawncol,"P",enemyid)
                  enemyid := enemyid + 1
                  --enemydata_cursor := enemydata_cursor + 1
                  --enemydata.forth
                  enemyloc.extend ([enemyfirstrow,col])
                  enemyloc.forth

             end
         end

      remainenergyfunc(call : STRING) : INTEGER
         do

         	if call ~ "fire" then
         		if weapon_name ~ "Rocket" then
         			if (remainhealth + tolregenh) <= tolhealth  then  -- enter this just for energy regen
	                     Result := remainhealth + tolregenh
	                else
	                     Result := tolhealth
	                end
	            else
	            	if (remainenergy+tolregene) <= tolenergy then
                        Result := remainenergy + tolregene
                    else
                        Result := tolenergy
                    end
         		end
            else
            	if call ~ "special" and power_name ~ "Overcharge (up to 50 health): Gain 2*health spent energy, can go over max energy. Energy regen will not be in effect if over cap." then
            		if (remainhealth + tolregenh) <= tolhealth then
                     Result := remainhealth + tolregenh
                    else
                     Result := tolhealth
                    end
                else
                	if (remainenergy+tolregene) <= tolenergy then
                       Result := remainenergy + tolregene
                    else
                       Result := tolenergy
                    end
            	end
         	end

         end

      updateenemy(prem:STRING)
         local
         	ine,in : INTEGER
         	scc : SCOREHELPER
         	premtemp,normaltemp,starfighteraction,tt, testspawnproj : STRING
         	te : BOOLEAN
         	seenbyfighter,canseefighter : BOOLEAN
            ploc : TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER]
         	--edata : TUPLE[health :INTEGER;tolhealth:INTEGER;regen:INTEGER;armour:INTEGER;vision:INTEGER;preemprojdamage:INTEGER;notseenprojdamage:INTEGER;seenprojdamage:INTEGER;preemprojmove:INTEGER;notseenprojmove:INTEGER;seenprojmove:INTEGER;preemenemymove:INTEGER;notseenenemymove:INTEGER;seenenemymove:INTEGER;id:INTEGER;sign:STRING;projsign:STRING;spawn_row:INTEGER;spawn_col:INTEGER;canseefighter:BOOLEAN;seenbyfighter:BOOLEAN]
         do
         	ine := 1
         	update_allproj(prem) -- update all proj first either enemy fire or not fire
            -- REMOVE ENEMY HERE AFTER DIE
            if prem ~ "pass" and in_game = true then
            	if (remainhealth + 2*tolregenh) <= tolhealth then
                     remainhealth := remainhealth + 2*tolregenh
                else
                     remainhealth := tolhealth
                end
                if (remainenergy + 2*tolregene) <= tolenergy then
                    remainenergy := remainenergy + 2*tolregene
                else
                    remainenergy := tolenergy
                end
            end
            if (prem ~ "move" or prem ~ "fire" or prem ~ "specialmove" or prem ~ "special" or prem ~"specialhealth" or prem ~"specialenergy") and in_game = true  then
            	if prem ~ "specialhealth" then
            		if remainhealth <= tolhealth then  -- regen health if remain health < tolhealth
            			if (remainhealth + tolregenh) <= tolhealth  then  -- enter this just for energy regen
	                     remainhealth := remainhealth + tolregenh
	                    else
	                     remainhealth := tolhealth
	                    end
            		end
                else
                    if remainhealth < tolhealth then
	            		if (remainhealth + tolregenh) <= tolhealth  then  -- enter this just for energy regen
		                     remainhealth := remainhealth + tolregenh
		                else
		                     remainhealth := tolhealth
		                end
		            end
            	end
                if prem ~ "specialenergy" then
                	if remainenergy <= tolenergy then
                		if (remainenergy+tolregene) <= tolenergy then
	                       remainenergy := remainenergy + tolregene
	                   else
	                       remainenergy := tolenergy
	                   end
                	end
                else
                	if remainenergy < tolenergy then
	                	if (remainenergy+tolregene) <= tolenergy then
		                   remainenergy := remainenergy + tolregene
		                else
		                   remainenergy := tolenergy
		                end
		            end
                end

            end
            if prem ~ "specialmove" then   -- put S at its spwan location
            	array.put ("_", shiploc.last.trow, shiploc.last.tcol)
			    array.put ("S", (r/2).ceiling, 1)
			    shiploc.extend ([(r/2).ceiling,1])  -- extend the ship loc which is used by fire command as well
			    shiploc.forth
            end

            if prem ~ "pass" and in_game = true  then
            	   starfighteraction := "    The Starfighter(id:0) passes at location ["
                                      if attached keyval.item (shiploc.last.trow) as t then
										 starfighteraction.append (t.to_string_8)
									  end
										 starfighteraction.append (",")
									  if attached (shiploc.last.tcol) as t1 then
										 starfighteraction.append (t1.out)
									  end
									     starfighteraction.append ("], doubling regen rate.")
                                    fighteraction.extend (starfighteraction)
            end

            if prem ~ "fire"  and in_game = true then
               if shiploc.count /= 0 then
                        -- for standard fire
                  if weapon_name ~ "Standard" then
                  	    if shiploc.last.tcol+1 <= col then
                  	     if array[shiploc.last.trow, (shiploc.last.tcol+1)] /~ "?"  then
                  	    	array.put ("*", shiploc.last.trow, (shiploc.last.tcol+1))
                  	     end
		                    projloc.extend([shiploc.last.trow,shiploc.last.tcol+1,idp,"*",5,70,"s"]) -- adding * first then enemy < spawn
                  	    end
		                idp := idp - 1
		                starfighteraction := "    The Starfighter(id:0) fires at location ["
                                    if attached keyval.item (projloc.last.prow) as t then
									   starfighteraction.append (t.to_string_8)
									end
									   starfighteraction.append (",")
									if attached (projloc.last.pcol-1) as t1 then
									   starfighteraction.append (t1.out)
									end
									starfighteraction.append ("].")
								    starfighteraction.append ("%N")
			             	        starfighteraction.append ("      A friendly projectile(id:"+projloc.last.id.out+") spawns at location ")
			             	        starfighteraction.append ("[")
					                if attached keyval.item (projloc.last.prow) as t then
					            	     starfighteraction.append (t.to_string_8)
					                end
								    --Result.append (keyval.item (tuple_loc.prow))
								    starfighteraction.append (",")
								    starfighteraction.append ((projloc.last.pcol).out)  -- -1 ?
								    starfighteraction.append ("].")
								fighteraction.extend (starfighteraction)

								    if enemyatinitialspawnprojf(projloc.last.prow,projloc.last.pcol) then

								    end
				  elseif weapon_name ~ "Spread" then

				  	      starfighteraction := "    The Starfighter(id:0) fires at location ["
                                    if attached keyval.item (shiploc.last.trow) as t then
									   starfighteraction.append (t.to_string_8)
									end
									   starfighteraction.append (",")
									if attached (shiploc.last.tcol) as t1 then
									   starfighteraction.append (t1.out)
									end
									starfighteraction.append ("].")
								 fighteraction.extend (starfighteraction)

								    if (shiploc.last.trow-1) > 0 and shiploc.last.tcol+1 <= col then
								      if array[shiploc.last.trow-1, (shiploc.last.tcol+1)] /~ "?"  then
								    	array.put ("*", shiploc.last.trow-1, (shiploc.last.tcol+1))
								      end
					                    projloc.extend([shiploc.last.trow-1,shiploc.last.tcol+1,idp,"*",1,50,"dup"]) -- adding * first then enemy < spawn
					                    idp := idp - 1
					             	        starfighteraction :=  ("      A friendly projectile(id:"+projloc.last.id.out+") spawns at location ")
					             	        starfighteraction.append ("[")
							                if attached keyval.item (projloc.last.prow) as t then
							            	     starfighteraction.append (t.to_string_8)
							                end
										    --Result.append (keyval.item (tuple_loc.prow))
										    starfighteraction.append (",")
										    starfighteraction.append ((projloc.last.pcol).out)  -- -1 ?
										    starfighteraction.append ("].")
										fighteraction.extend (starfighteraction)
										if enemyatinitialspawnprojf(projloc.last.prow,projloc.last.pcol) then

								        end
									else
										starfighteraction :=  ("      A friendly projectile(id:"+idp.out+") spawns at location out of board.")
										fighteraction.extend (starfighteraction)
										idp := idp - 1
								    end


								    if (shiploc.last.tcol+1) <= col then
								      if array[shiploc.last.trow, (shiploc.last.tcol+1)] /~ "?"  then
								    	array.put ("*", shiploc.last.trow, (shiploc.last.tcol+1))
								      end
		                                projloc.extend([shiploc.last.trow,shiploc.last.tcol+1,idp,"*",1,50,"s"]) -- adding * first then enemy < spawn
		                                idp := idp - 1
				                            starfighteraction :=  ("      A friendly projectile(id:"+projloc.last.id.out+") spawns at location ")
					             	        starfighteraction.append ("[")
							                if attached keyval.item (projloc.last.prow) as t then
							            	     starfighteraction.append (t.to_string_8)
							                end
										    --Result.append (keyval.item (tuple_loc.prow))
										    starfighteraction.append (",")
										    starfighteraction.append ((projloc.last.pcol).out)  -- -1 ?
										    starfighteraction.append ("].")
										fighteraction.extend (starfighteraction)
										 if enemyatinitialspawnprojf(projloc.last.prow,projloc.last.pcol) then

								         end
									else
										starfighteraction :=  ("      A friendly projectile(id:"+idp.out+") spawns at location out of board.")
										fighteraction.extend (starfighteraction)
										idp := idp - 1
								    end


								    if (shiploc.last.trow+1) > 0 and shiploc.last.tcol+1 <= col then
								      if array[shiploc.last.trow+1, (shiploc.last.tcol+1)] /~ "?"  then
								    	array.put ("*", shiploc.last.trow+1, (shiploc.last.tcol+1))
								      end
					                    projloc.extend([shiploc.last.trow+1,shiploc.last.tcol+1,idp,"*",1,50,"ddown"]) -- adding * first then enemy < spawn
					                    idp := idp - 1
					             	        starfighteraction :=  ("      A friendly projectile(id:"+projloc.last.id.out+") spawns at location ")
					             	        starfighteraction.append ("[")
							                if attached keyval.item (projloc.last.prow) as t then
							            	     starfighteraction.append (t.to_string_8)
							                end
										    --Result.append (keyval.item (tuple_loc.prow))
										    starfighteraction.append (",")
										    starfighteraction.append ((projloc.last.pcol).out)  -- -1 ?
										    starfighteraction.append ("].")
										fighteraction.extend (starfighteraction)
										 if enemyatinitialspawnprojf(projloc.last.prow,projloc.last.pcol) then

								         end
									else
										starfighteraction :=  ("      A friendly projectile(id:"+idp.out+") spawns at location out of board.")
										fighteraction.extend (starfighteraction)
										idp := idp - 1
								    end

				  elseif weapon_name ~ "Rocket" then
				  	        starfighteraction := "    The Starfighter(id:0) fires at location ["
                                    if attached keyval.item (shiploc.last.trow) as t then
									   starfighteraction.append (t.to_string_8)
									end
									   starfighteraction.append (",")
									if attached (shiploc.last.tcol) as t1 then
									   starfighteraction.append (t1.out)
									end
									starfighteraction.append ("].")
								 fighteraction.extend (starfighteraction)

						            if (shiploc.last.tcol-1) > 0 and shiploc.last.trow-1 > 0 then
						              if array[shiploc.last.trow-1, (shiploc.last.tcol-1)] /~ "?"  then
								    	array.put ("*", shiploc.last.trow-1, (shiploc.last.tcol-1))
								      end
		                                projloc.extend([shiploc.last.trow-1, shiploc.last.tcol-1,idp,"*",1,100,"s"]) -- adding * first then enemy < spawn
		                                idp := idp - 1
				                            starfighteraction :=  ("      A friendly projectile(id:"+projloc.last.id.out+") spawns at location ")
					             	        starfighteraction.append ("[")
							                if attached keyval.item (projloc.last.prow) as t then
							            	     starfighteraction.append (t.to_string_8)
							                end
										    --Result.append (keyval.item (tuple_loc.prow))
										    starfighteraction.append (",")
										    starfighteraction.append ((projloc.last.pcol).out)  -- -1 ?
										    starfighteraction.append ("].")
										fighteraction.extend (starfighteraction)
										 if enemyatinitialspawnprojf(projloc.last.prow,projloc.last.pcol) then -- check collide at spawn

								         end
									else
				                        starfighteraction :=  ("      A friendly projectile(id:"+idp.out+") spawns at location out of board.")
										fighteraction.extend (starfighteraction)
										idp := idp - 1
								    end


								    if (shiploc.last.tcol-1) > 0 and shiploc.last.trow+1 <= r then
								      if array[shiploc.last.trow+1, (shiploc.last.tcol-1)] /~ "?"  then
								    	array.put ("*", shiploc.last.trow+1, (shiploc.last.tcol-1))
								      end
		                                projloc.extend([shiploc.last.trow+1, shiploc.last.tcol-1,idp,"*",1,100,"s"]) -- adding * first then enemy < spawn
		                                idp := idp - 1
				                            starfighteraction :=  ("      A friendly projectile(id:"+projloc.last.id.out+") spawns at location ")
					             	        starfighteraction.append ("[")
							                if attached keyval.item (projloc.last.prow) as t then
							            	     starfighteraction.append (t.to_string_8)
							                end
										    --Result.append (keyval.item (tuple_loc.prow))
										    starfighteraction.append (",")
										    starfighteraction.append ((projloc.last.pcol).out)  -- -1 ?
										    starfighteraction.append ("].")
										fighteraction.extend (starfighteraction)
										  if enemyatinitialspawnprojf(projloc.last.prow,projloc.last.pcol) then

								          end
									else
										starfighteraction :=  ("      A friendly projectile(id:"+idp.out+") spawns at location out of board.")
										fighteraction.extend (starfighteraction)
										idp := idp - 1
								    end
	              elseif weapon_name ~ "Snipe" then
	              	  if shiploc.last.tcol+1 <= col then
                  	     if array[shiploc.last.trow, (shiploc.last.tcol+1)] /~ "?"  then
                  	    	array.put ("*", shiploc.last.trow, (shiploc.last.tcol+1))
                  	     end
		                    projloc.extend([shiploc.last.trow,shiploc.last.tcol+1,idp,"*",8,1000,"s"]) -- adding * first then enemy < spawn
                  	    end
		                idp := idp - 1
		                starfighteraction := "    The Starfighter(id:0) fires at location ["
                                    if attached keyval.item (projloc.last.prow) as t then
									   starfighteraction.append (t.to_string_8)
									end
									   starfighteraction.append (",")
									if attached (projloc.last.pcol-1) as t1 then
									   starfighteraction.append (t1.out)
									end
									starfighteraction.append ("].")
								    starfighteraction.append ("%N")
			             	        starfighteraction.append ("      A friendly projectile(id:"+projloc.last.id.out+") spawns at location ")
			             	        starfighteraction.append ("[")
					                if attached keyval.item (projloc.last.prow) as t then
					            	     starfighteraction.append (t.to_string_8)
					                end
								    --Result.append (keyval.item (tuple_loc.prow))
								    starfighteraction.append (",")
								    starfighteraction.append ((projloc.last.pcol).out)  -- -1 ?
								    starfighteraction.append ("].")
								fighteraction.extend (starfighteraction)
								   if enemyatinitialspawnprojf(projloc.last.prow,projloc.last.pcol) then

								   end
				  elseif weapon_name ~ "Splitter" then
				  	     if shiploc.last.tcol+1 <= col then
	                  	     if array[shiploc.last.trow, (shiploc.last.tcol+1)] /~ "?"  then
	                  	    	array.put ("*", shiploc.last.trow, (shiploc.last.tcol+1))
	                  	     end
			                    projloc.extend([shiploc.last.trow,shiploc.last.tcol+1,idp,"*",0,150,"s"]) -- adding * first then enemy < spawn
                  	     end
		                idp := idp - 1
		                starfighteraction := "    The Starfighter(id:0) fires at location ["
                                    if attached keyval.item (projloc.last.prow) as t then
									   starfighteraction.append (t.to_string_8)
									end
									   starfighteraction.append (",")
									if attached (projloc.last.pcol-1) as t1 then
									   starfighteraction.append (t1.out)
									end
									starfighteraction.append ("].")
								    starfighteraction.append ("%N")
			             	        starfighteraction.append ("      A friendly projectile(id:"+projloc.last.id.out+") spawns at location ")
			             	        starfighteraction.append ("[")
					                if attached keyval.item (projloc.last.prow) as t then
					            	     starfighteraction.append (t.to_string_8)
					                end
								    --Result.append (keyval.item (tuple_loc.prow))
								    starfighteraction.append (",")
								    starfighteraction.append ((projloc.last.pcol).out)  -- -1 ?
								    starfighteraction.append ("].")
								fighteraction.extend (starfighteraction)

					   if projfspawnatprojf(projloc.last.prow,projloc.last.pcol) then
                            starfighteraction := "      The projectile collides with friendly projectile(id:"+projfspawnatprojfid.out+") at location ["
					                if attached keyval.item (projloc.last.prow) as t then
					            	     starfighteraction.append (t.to_string_8)
					                end
								    --Result.append (keyval.item (tuple_loc.prow))
								    starfighteraction.append (",")
								    starfighteraction.append ((projloc.last.pcol).out)  -- -1 ?
								    starfighteraction.append ("], combining damage.")
						    fighteraction.extend (starfighteraction)
					   end

					   if enemyatinitialspawnprojf(projloc.last.prow,projloc.last.pcol) then

					   end
                  end

		       end
            end
         	if prem ~ "move"  and in_game = true then    -- move star fighter first
         		starfighteraction := "    The Starfighter(id:0) moves: ["    -- move to enemy update
	                              if attached keyval.item (shiploc.last.trow) as t then
								      starfighteraction.append (t.to_string_8)
								  end
								      starfighteraction.append (",")
							      if attached (shiploc.last.tcol) as t1 then
									  starfighteraction.append (t1.out+"] -> [")
								  end
								  if attached keyval.item (movefighterrow) as t2 then
								      starfighteraction.append (t2.to_string_8)
								  end
								      starfighteraction.append (",")
							      if attached (movefightercol) as t3 then
									  starfighteraction.append (t3.out+"]")
								  end
				         fighteraction.extend (starfighteraction)
				    fightercollideproj(movefighterrow,movefightercol)   -- fighter move and collide and remove proj and enemy
				    if remainhealth <= 0 then
				    	remainhealth := 0
				    	fightermovecollide.colr := collide_loc.colr
				    	fightermovecollide.colc := collide_loc.colc
				    	tt := ("      The Starfighter at location [")
				    	    if attached keyval.item (collide_loc.colr) as t2 then
								 tt.append (t2.to_string_8)
							end
							     tt.append (",")
							if attached (collide_loc.colc) as t3 then
							     tt.append (t3.out+"] has been destroyed.")
							end
						fighteraction.extend (tt)

						starfighteraction := "    The Starfighter(id:0) moves: ["    -- update first action as per collision
	                              if attached keyval.item (shiploc.last.trow) as t then
								      starfighteraction.append (t.to_string_8)
								  end
								      starfighteraction.append (",")
							      if attached (shiploc.last.tcol) as t1 then
									  starfighteraction.append (t1.out+"] -> [")
								  end
								  if attached keyval.item (collide_loc.colr) as t2 then
								      starfighteraction.append (t2.to_string_8)
								  end
								      starfighteraction.append (",")
							      if attached (collide_loc.colc) as t3 then
									  starfighteraction.append (t3.out+"]")
								  end
						fighteraction[1] := starfighteraction

						array.put ("_", shiploc.last.trow, shiploc.last.tcol)
				        array.put ("X", collide_loc.colr, collide_loc.colc)
				        shiploc.extend ([collide_loc.colr,collide_loc.colc])  -- extend the ship loc which is used by fire command as well
			            shiploc.forth
			            in_game := false   -- reset
			            selected := "not started"
	                    --debug_flag := false
	                end

				    fightercollideenemy(movefighterrow,movefightercol)
                    if remainhealth <= 0 and in_game = true then
				    	remainhealth := 0
				    	fightermovecollide.colr := collide_locenemy.colr
				    	fightermovecollide.colc := collide_locenemy.colc
				    	tt := ("      The Starfighter at location [")
				    	    if attached keyval.item (collide_locenemy.colr) as t2 then
								 tt.append (t2.to_string_8)
							end
							     tt.append (",")
							if attached (collide_locenemy.colc) as t3 then
							     tt.append (t3.out+"] has been destroyed.")
							end
						fighteraction.extend (tt)

						starfighteraction := "    The Starfighter(id:0) moves: ["    -- update first action as per collision
	                              if attached keyval.item (shiploc.last.trow) as t then
								      starfighteraction.append (t.to_string_8)
								  end
								      starfighteraction.append (",")
							      if attached (shiploc.last.tcol) as t1 then
									  starfighteraction.append (t1.out+"] -> [")
								  end
								  if attached keyval.item (collide_locenemy.colr) as t2 then
								      starfighteraction.append (t2.to_string_8)
								  end
								      starfighteraction.append (",")
							      if attached (collide_locenemy.colc) as t3 then
									  starfighteraction.append (t3.out+"]")
								  end
						fighteraction[1] := starfighteraction

						array.put ("_", shiploc.last.trow, shiploc.last.tcol)
				        array.put ("X", collide_locenemy.colr, collide_locenemy.colc)  -- update the display exist feature
				        shiploc.extend ([collide_locenemy.colr,collide_locenemy.colc])  -- extend the ship loc which is used by fire command as well
			            shiploc.forth
			            in_game := false   -- reset
			            selected := "not started"
	                    --debug_flag := false
	                elseif in_game = true then
	                	array.put ("_", shiploc.last.trow, shiploc.last.tcol)
			            array.put ("S", movefighterrow, movefightercol)
			            shiploc.extend ([movefighterrow,movefightercol])  -- extend the ship loc which is used by fire command as well
			            shiploc.forth
				    end
         	end
            if prem ~ "specialhealth" then
            	remainhealth := remainhealth + 50
		        remainenergy := remainenergy - 50
            end
            if prem ~ "specialenergy" then
            	          if remainhealth <= 50 then
            	          	 starfighteraction := "    The Starfighter(id:0) uses special, gaining "+((remainhealth-1)*2).out+" energy at the expense of "+(remainhealth-1).out+" health."
						     fighteraction.extend (starfighteraction)
                          	 remainenergy := remainenergy + 2 * (remainhealth-1)
                          	 remainhealth := 1
                          elseif remainhealth > 50 then
                          	 starfighteraction := "    The Starfighter(id:0) uses special, gaining "+((50)*2).out+" energy at the expense of 50 health."
						     fighteraction.extend (starfighteraction)
                          	 remainenergy := remainenergy + 2 * 50
                          	 remainhealth := remainhealth - 50
                          end
            end
         	if prem ~ "special" and in_game = true then
         	       if power_name ~ "Deploy Drones (100 energy): Clear all projectiles." then
		         		starfighteraction := "    The Starfighter(id:0) uses special, clearing projectiles with drones."
						fighteraction.extend (starfighteraction)
		                remainenergy := remainenergy - 100
		                from
		                	in := 1
		                until
		                	in > projloc.count
		                loop
		                	ploc := projloc[in]
							starfighteraction := ("      A projectile(id:"+ploc.id.out+") at location [")
							if attached keyval.item (ploc.prow) as t then
							 starfighteraction.append (t.to_string_8)
							end
							starfighteraction.append(",")
							starfighteraction.append(ploc.pcol.out+"] has been neutralized.")
							fighteraction.extend (starfighteraction)

							if array[ploc.prow, ploc.pcol] /~ "?" then
							   array.put ("_", ploc.prow, ploc.pcol)
							end
							projloc.go_i_th(in)   -- remove this proj, fproj
						    projloc.remove
							in := in - 1

		                	in := in + 1
		                end
		           elseif power_name ~ "Orbital Strike (100 energy): Deal 100 damage to all enemies, affected by armour." then
		           	    starfighteraction := "    The Starfighter(id:0) uses special, unleashing a wave of energy."
						fighteraction.extend (starfighteraction)
		                remainenergy := remainenergy - 100
		                across
		                  enemydata	 is edata
		                loop
                            starfighteraction := ""
	                          if edata.sign ~ "G" then
	              	  	  	  	starfighteraction.append("      A Grunt(id:"+edata.id.out+") at location [")
	              	  	  	  elseif edata.sign ~ "I" then
	              	  	  	  	starfighteraction.append("      A Interceptor(id:"+edata.id.out+") at location [")
	              	  	  	  elseif edata.sign ~ "F" then
	              	  	  	  	starfighteraction.append("      A Fighter(id:"+edata.id.out+") at location [")
	              	  	  	  elseif edata.sign ~ "C" then
	              	  	  	  	starfighteraction.append("      A Carrier(id:"+edata.id.out+") at location [")
	              	  	  	  elseif edata.sign ~ "P" then
	              	  	  	  	starfighteraction.append("      A Pylon(id:"+edata.id.out+") at location [")
	              	  	  	  end
	              	  	  	    if attached keyval.item (edata.spawn_row) as t then
								 starfighteraction.append (t.to_string_8)
								end
								starfighteraction.append(",")
								starfighteraction.append(edata.spawn_col.out+"] takes "+(100-edata.armour).out+" damage.")
								fighteraction.extend (starfighteraction)

	              	  	  	  edata.health := edata.health - (100-edata.armour)
	              	  	  	  if edata.health <= 0 then
                                  starfighteraction := ""
                                  if edata.sign ~ "G" then
		              	  	  	  	starfighteraction.append("      The Grunt at location [")
		              	  	  	  elseif edata.sign ~ "I" then
		              	  	  	  	starfighteraction.append("      The Interceptor at location [")
		              	  	  	  elseif edata.sign ~ "F" then
		              	  	  	  	starfighteraction.append("      The Fighter at location [")
		              	  	  	  elseif edata.sign ~ "C" then
		              	  	  	  	starfighteraction.append("      The Carrier at location [")
		              	  	  	  elseif edata.sign ~ "P" then
		              	  	  	  	starfighteraction.append("      The Pylon at location [")
		              	  	  	  end
		              	  	  	    if attached keyval.item (edata.spawn_row) as t then
									 starfighteraction.append (t.to_string_8)
									end
									starfighteraction.append(",")
									starfighteraction.append(edata.spawn_col.out+"] has been destroyed.")
									fighteraction.extend (starfighteraction)

									edata.dead := true
									scoreupdate(edata.sign)  -- SCORE
									edata.health := 0
									if array[edata.spawn_row, edata.spawn_col] /~ "?" then
									   array.put ("_", edata.spawn_row, edata.spawn_col)
								    end

	              	  	  	  end
		                end

		           end
         	end

            if in_game = true then
            	    -- regen of enemy
            	    across
            	      	enemydata is edata
            	    loop
                        if (edata.health + edata.regen) <= edata.tolhealth then
		                     edata.health := edata.health + edata.regen
		                else
		                     edata.health := edata.tolhealth
		                end
            	    end
            	    -- prem actions
            	    premactions(prem)
            	    -- actual enemy move
		            across
		         	   	enemydata is edata  -- for all enemy do premetive if turn not end then not seen
		         	loop
		         	if in_game = true then    -- check in game
			         	   normaltemp := ""
			         	   premtemp := ""
			               te := false
			               seenbyfighter := false
			               canseefighter := false
			               testspawnproj := ""
			         	if edata.sign ~ "G" and edata.dead = false and edata.health > 0 then
			         	   if array[edata.spawn_row,edata.spawn_col ] /~ "?"  then
			         	   	 array.put ("_", edata.spawn_row,edata.spawn_col )
			         	   end
			         	   	 if canseenby(edata.spawn_row,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,edata.vision)   then -- on see or not
                                   if not projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove) then
					                    normaltemp := "    A Grunt(id:"+edata.id.out+")"
					                         if edata.spawn_row = edata.spawn_row and edata.spawn_col = edata.spawn_col-edata.seenenemymove then
			                     	           normaltemp.append (" stays at: [")
			                     	           if attached keyval.item (edata.spawn_row) as t2 then
													 normaltemp.append (t2.to_string_8)
												end
												     normaltemp.append (",")
												if attached (edata.spawn_col) as t3 then
												     normaltemp.append (t3.out+"]")
												end
			                     	         else
							                        normaltemp.append(" moves: [")
							                        if attached keyval.item (edata.spawn_row) as t then
														 normaltemp.append (t.to_string_8)
													 end
													     normaltemp.append (",")
													if attached (edata.spawn_col) as t1 then
														 normaltemp.append (t1.out+"] -> ")
													end
							                        if edata.spawn_col-edata.seenenemymove > 0 or hasfighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove) then
							                        	normaltemp.append ("[")
														if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col-edata.seenenemymove) as t3 then
														     normaltemp.append (t3.out+"]")
														end
													else
														normaltemp.append ("out of board")
														--edata.dead := true
														edata.health := 0
							                        end
							                 end
					                    premprint[ine].normal.extend (normaltemp)
			                            --premprint.put_i_th([premprint[ine].prem,premprint[ine].normal],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove,ine,"normalaction")
			                            te := enemycollideprojf(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove,edata.health,ine,"normal") -- check collide
			                            if te and edata.health >= 0 then   -->=  as both are destroyed so put _
			                              if array[enemycollideprojfrow, enemycollideprojfcol ] /~ "?"  then
			                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol) -- _ at starfighter proj
			                              end
			                            end

			                            if edata.health > 0 then


				                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove,ine,"normal")  -- check collide
				                            if te and in_game = false then
				                              if array[enemycollideprojfrow, enemycollideprojfcol ] /~ "?"  then
				                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
				                              end
				                            end
				                        end
					--         	   	 	array.put ("<", edata.spawn_row, edata.spawn_col-4)
					--         	   	 	enemydata.put_i_th ([100,1,1,5,0,15,15,0,4,4,0,2,4,enemyid,"G","<",edata.spawn_row,edata.spawn_col], in)
					                    if ((edata.spawn_col-edata.seenenemymove)> 0) and edata.health > 0  then
					                    	if array[edata.spawn_row,edata.spawn_col-edata.seenenemymove] /~ "?"  then -- for fog of war
					         	   	 	       array.put ("G", edata.spawn_row, edata.spawn_col-edata.seenenemymove)
					         	   	 	    end
					                    end
			                                if edata.health > 0  then
							         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"G","<",edata.spawn_row,edata.spawn_col-edata.seenenemymove,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
							         	   	 	if edata.spawn_col-1 > 0 and (not enemyatspawnproje(edata.spawn_row,edata.spawn_col-1)) then
				               	      	          if array[ edata.spawn_row, edata.spawn_col-1] /~ "?"  then
						         	   	 		      array.put ("<", edata.spawn_row, edata.spawn_col-1)
						         	   	 		  end
						         	   	 		projloc.extend ([edata.spawn_row,edata.spawn_col-1,idp,"G",4,15,"s"])  -- must put number of damage ect
							         	   	 	end

							         	   	 	if edata.spawn_col-1 >= 0 then
							         	   	 		--normaltemp.append("%N")
							         	   	 		if edata.spawn_col-1 = 0 then
                                                       normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location out of board.")
												       idp := idp - 1  -- after idp is assigned
							         	   	 		else
								         	   	 		normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location [")
									         	   	 	    if attached keyval.item (edata.spawn_row) as t then
																 normaltemp.append (t.to_string_8)
															end
															     normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																 normaltemp.append (t1.out+"].")
															end
													   idp := idp - 1  -- after idp is assigned
												   end
                                                   premprint[ine].normal.extend (normaltemp)
							         	   	 	end

							         	   	 	if fighteratspawnproje(edata.spawn_row,edata.spawn_col-1,ine,"normal") then

                                                    projloc.go_i_th (projloc.count)
                                                    projloc.remove
							         	   	 	end

							         	   	 	if enemyatspawnproje(edata.spawn_row,edata.spawn_col-1) then
							         	   	 		normaltemp := "      The projectile collides with "
							         	   	 		if enemydata[enemyatspawnprojenumber].sign ~ "G" then
							         	   	 			normaltemp.append ("Grunt(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "I" then
							         	   	 			normaltemp.append ("Interceptor(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "F" then
							         	   	 			normaltemp.append ("Fighter(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "P" then
							         	   	 			normaltemp.append ("Pylon(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		end
							         	   	 		if attached keyval.item (edata.spawn_row) as t then
												        normaltemp.append (t.to_string_8)
													end
														normaltemp.append (",")
													if attached (edata.spawn_col-1) as t1 then
														normaltemp.append (t1.out+"], healing 15 damage.")
													end
													premprint[ine].normal.extend (normaltemp)
													if enemydata[enemyatspawnprojenumber].health + 15 <= enemydata[enemyatspawnprojenumber].tolhealth then
														enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].health + 15
													else
														enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].tolhealth
													end
							         	   	 	end

                                                testspawnproj := projfatspawnproj(edata.spawn_row,edata.spawn_col-1,ine)
                                                if testspawnproj ~ "epd" or testspawnproj ~ "fpd" then
                                                	        normaltemp := "      The projectile collides with friendly projectile(id:"+projfatspawnprojid.out+") at location ["
                                                            if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], negating damage.")
															end
															premprint[ine].normal.extend (normaltemp)

															if testspawnproj ~ "epd" then
																if array[edata.spawn_row, edata.spawn_col-1] /~ "?" then
																  array.put ("*", edata.spawn_row, edata.spawn_col-1)
																end
																projloc.go_i_th (projloc.count)
																projloc.remove
															end
                                                end

							         	   	 	if projeatspawnproj(edata.spawn_row,edata.spawn_col-1,ine) then
                                                            normaltemp := "      The projectile collides with enemy projectile(id:"+projeatspawnprojid.out+") at location ["
                                                            if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], combining damage.")
															end
															premprint[ine].normal.extend (normaltemp)
									         	end

							         	    end
							       elseif projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove) then
							       	        normaltemp := "    A Grunt(id:"+edata.id.out+")"
							       	        if edata.spawn_row = edata.spawn_row and edata.spawn_col = projenemycollidecol + 1 then
			                     	           normaltemp.append (" stays at: [")
			                     	           if attached keyval.item (edata.spawn_row) as t2 then
													 normaltemp.append (t2.to_string_8)
												end
												     normaltemp.append (",")
												if attached (edata.spawn_col) as t3 then
												     normaltemp.append (t3.out+"]")
												end
			                     	         else
									       	        normaltemp.append(" moves: [")
							                        if attached keyval.item (edata.spawn_row) as t then
														 normaltemp.append (t.to_string_8)
													 end
													     normaltemp.append (",")
													if attached (edata.spawn_col) as t1 then
														 normaltemp.append (t1.out+"] -> ")
													end
							                        if projenemycollidecol + 1 > 0 or hasfighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1) then
							                        	normaltemp.append ("[")
														if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (projenemycollidecol + 1) as t3 then
														     normaltemp.append (t3.out+"]")
														end
													else
														normaltemp.append ("out of board")
														--edata.dead := true
														edata.health := 0
							                        end
							                end
						                    premprint[ine].normal.extend (normaltemp)
				                            --premprint.put_i_th([premprint[ine].prem,premprint[ine].normal],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normalaction")
				                            te := enemycollideprojf(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,edata.health,ine,"normal") -- check collide
				                            if te and edata.health >= 0 then
				                              if array[enemycollideprojfrow, enemycollideprojfcol ] /~ "?"  then
				                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol) -- _ at starfighter proj
				                              end
				                            end
				                            if edata.health > 0 then

					                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normal")  -- check collide
					                            if te and in_game = false then
					                              if array[enemycollideprojfrow, enemycollideprojfcol ] /~ "?"  then
					                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
					                              end
					                            end
					                        end
						--         	   	 	array.put ("<", edata.spawn_row, edata.spawn_col-4)
						--         	   	 	enemydata.put_i_th ([100,1,1,5,0,15,15,0,4,4,0,2,4,enemyid,"G","<",edata.spawn_row,edata.spawn_col], in)
						                    if ((projenemycollidecol + 1)> 0) and edata.health > 0  then
						                    	if array[edata.spawn_row,projenemycollidecol + 1] /~ "?"  then -- for fog of war
						         	   	 	       array.put ("G", edata.spawn_row, projenemycollidecol + 1)
						         	   	 	    end
						                    end
				                                if edata.health > 0  then
								         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"G","<",edata.spawn_row,projenemycollidecol + 1,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
									         	   	if edata.spawn_col-1 > 0 and (not enemyatspawnproje(edata.spawn_row,edata.spawn_col-1)) then
					               	      	          if array[ edata.spawn_row, edata.spawn_col-1] /~ "?"  then
							         	   	 		      array.put ("<", edata.spawn_row, edata.spawn_col-1)
							         	   	 		  end
							         	   	 		projloc.extend ([edata.spawn_row,edata.spawn_col-1,idp,"G",4,15,"s"])  -- must put number of damage ect
								         	   	 	end

								         	   	 	if edata.spawn_col-1 >= 0 then
								         	   	 		--normaltemp.append("%N")
								         	   	 		if edata.spawn_col-1 = 0 then
	                                                       normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location out of board.")
													       idp := idp - 1  -- after idp is assigned
								         	   	 		else
									         	   	 		normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location [")
										         	   	 	    if attached keyval.item (edata.spawn_row) as t then
																	 normaltemp.append (t.to_string_8)
																end
																     normaltemp.append (",")
																if attached (edata.spawn_col-1) as t1 then
																	 normaltemp.append (t1.out+"].")
																end
														   idp := idp - 1  -- after idp is assigned
													   end
                                                       premprint[ine].normal.extend (normaltemp)
								         	   	 	end

								         	   	 	if fighteratspawnproje(edata.spawn_row,edata.spawn_col-1,ine,"normal") then

	                                                    projloc.go_i_th (projloc.count)
	                                                    projloc.remove
							         	   	 	    end

								         	   	 	if enemyatspawnproje(edata.spawn_row,edata.spawn_col-1) then
								         	   	 		normaltemp := "      The projectile collides with "
								         	   	 		if enemydata[enemyatspawnprojenumber].sign ~ "G" then
								         	   	 			normaltemp.append ("Grunt(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
								         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "I" then
								         	   	 			normaltemp.append ("Interceptor(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
								         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "F" then
								         	   	 			normaltemp.append ("Fighter(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
								         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "P" then
								         	   	 			normaltemp.append ("Pylon(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
								         	   	 		end
								         	   	 		if attached keyval.item (edata.spawn_row) as t then
													        normaltemp.append (t.to_string_8)
														end
															normaltemp.append (",")
														if attached (edata.spawn_col-1) as t1 then
															normaltemp.append (t1.out+"], healing 15 damage.")
														end
														premprint[ine].normal.extend (normaltemp)
														if enemydata[enemyatspawnprojenumber].health + 15 <= enemydata[enemyatspawnprojenumber].tolhealth then
															enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].health + 15
														else
															enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].tolhealth
														end
								         	   	 	end

								         	   	 	testspawnproj := projfatspawnproj(edata.spawn_row,edata.spawn_col-1,ine)
                                                if testspawnproj ~ "epd" or testspawnproj ~ "fpd" then
                                                	        normaltemp := "      The projectile collides with friendly projectile(id:"+projfatspawnprojid.out+") at location ["
                                                            if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], negating damage.")
															end
															premprint[ine].normal.extend (normaltemp)

															if testspawnproj ~ "epd" then
																if array[edata.spawn_row, edata.spawn_col-1] /~ "?" then
																  array.put ("*", edata.spawn_row, edata.spawn_col-1)
																end
																projloc.go_i_th (projloc.count)
																projloc.remove
															end
                                                end

								         	   	 	   if projeatspawnproj(edata.spawn_row,edata.spawn_col-1,ine) then
                                                            normaltemp := "      The projectile collides with enemy projectile(id:"+projeatspawnprojid.out+") at location ["
                                                            if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], combining damage.")
															end
															premprint[ine].normal.extend (normaltemp)
									         	   	 	end

								         	    end
							       end
			         	   	 elseif (not canseenby(edata.spawn_row,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,edata.vision))   then
			         	   	 	    if not projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove) then
					                    normaltemp := "    A Grunt(id:"+edata.id.out+")"
					                    if edata.spawn_row = edata.spawn_row and edata.spawn_col = edata.spawn_col-edata.notseenenemymove then
			                     	           normaltemp.append (" stays at: [")
			                     	           if attached keyval.item (edata.spawn_row) as t2 then
													 normaltemp.append (t2.to_string_8)
												end
												     normaltemp.append (",")
												if attached (edata.spawn_col) as t3 then
												     normaltemp.append (t3.out+"]")
												end
			                     	    else
						                         normaltemp.append(" moves: [")
						                        if attached keyval.item (edata.spawn_row) as t then
													 normaltemp.append (t.to_string_8)
												 end
												     normaltemp.append (",")
												if attached (edata.spawn_col) as t1 then
													 normaltemp.append (t1.out+"] -> ")
												end
												if edata.spawn_col-edata.notseenenemymove > 0 or hasfighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove) then
													normaltemp.append("[")
													if attached keyval.item (edata.spawn_row) as t2 then
														 normaltemp.append (t2.to_string_8)
													end
													     normaltemp.append (",")
													if attached (edata.spawn_col-edata.notseenenemymove) as t3 then
													     normaltemp.append (t3.out+"]")
													end
												else
													normaltemp.append ("out of board")
													--edata.dead := true
													edata.health := 0
												end
								        end
			                            premprint[ine].normal.extend (normaltemp)
			                            --premprint.put_i_th([premtempll,normaltempll],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove,ine,"normalaction")
			                            te := enemycollideprojf(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove,edata.health,ine,"normal") -- check collide
			                            if te and edata.health >= 0 then
			                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
			                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol)
			                              end
			                            end
			                            if edata.health > 0 then

				                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove,ine,"normal")  -- check collide
				                            if te and in_game = false then
				                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
				                            end
				                        end
					--         	   	 	array.put ("<", edata.spawn_row, edata.spawn_col-4)
					--         	   	 	enemydata.put_i_th ([100,1,1,5,0,15,15,0,4,4,0,2,4,enemyid,"G","<",edata.spawn_row,edata.spawn_col,edata.spawn_row,edata.spawn_col-4], in)
					                    if ((edata.spawn_col-edata.notseenenemymove) > 0) and edata.health > 0  then
					                      if array[edata.spawn_row, edata.spawn_col-edata.notseenenemymove] /~ "?"  then
					                    	array.put ("G", edata.spawn_row, edata.spawn_col-edata.notseenenemymove)
					                      end
					                    end
			                                 if edata.health > 0 then
							         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"G","<",edata.spawn_row, edata.spawn_col-edata.notseenenemymove,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
							         	   	 	--update_allproj
							         	   	 	if edata.spawn_col-1 > 0 and (not enemyatspawnproje(edata.spawn_row,edata.spawn_col-1)) then
				               	      	          if array[ edata.spawn_row, edata.spawn_col-1] /~ "?"  then
						         	   	 		      array.put ("<", edata.spawn_row, edata.spawn_col-1)
						         	   	 		  end
						         	   	 		projloc.extend ([edata.spawn_row,edata.spawn_col-1,idp,"G",4,15,"s"])  -- must put number of damage ect
							         	   	 	end

							         	   	 	if edata.spawn_col-1 >= 0 then
							         	   	 		--normaltemp.append("%N")
							         	   	 		if edata.spawn_col-1 = 0 then
                                                       normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location out of board.")
												       idp := idp - 1  -- after idp is assigned
							         	   	 		else
								         	   	 		normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location [")
									         	   	 	    if attached keyval.item (edata.spawn_row) as t then
																 normaltemp.append (t.to_string_8)
															end
															     normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																 normaltemp.append (t1.out+"].")
															end
													   idp := idp - 1  -- after idp is assigned
												    end
                                                   premprint[ine].normal.extend (normaltemp)
							         	   	 	end

							         	   	 	if enemyatspawnproje(edata.spawn_row,edata.spawn_col-1) then
							         	   	 		normaltemp := "      The projectile collides with "
							         	   	 		if enemydata[enemyatspawnprojenumber].sign ~ "G" then
							         	   	 			normaltemp.append ("Grunt(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "I" then
							         	   	 			normaltemp.append ("Interceptor(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "F" then
							         	   	 			normaltemp.append ("Fighter(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "P" then
							         	   	 			normaltemp.append ("Pylon(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		end
							         	   	 		if attached keyval.item (edata.spawn_row) as t then
												        normaltemp.append (t.to_string_8)
													end
														normaltemp.append (",")
													if attached (edata.spawn_col-1) as t1 then
														normaltemp.append (t1.out+"], healing 15 damage.")
													end
													premprint[ine].normal.extend (normaltemp)
													if enemydata[enemyatspawnprojenumber].health + 15 <= enemydata[enemyatspawnprojenumber].tolhealth then
														enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].health + 15
													else
														enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].tolhealth
													end
							         	   	 	end

                                                if fighteratspawnproje(edata.spawn_row,edata.spawn_col-1,ine,"normal") then

	                                                    projloc.go_i_th (projloc.count)
	                                                    projloc.remove
							         	   	 	end

							         	   	 	testspawnproj := projfatspawnproj(edata.spawn_row,edata.spawn_col-1,ine)
                                                if testspawnproj ~ "epd" or testspawnproj ~ "fpd" then
                                                	        normaltemp := "      The projectile collides with friendly projectile(id:"+projfatspawnprojid.out+") at location ["
                                                            if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], negating damage.")
															end
															premprint[ine].normal.extend (normaltemp)

															if testspawnproj ~ "epd" then
																if array[edata.spawn_row, edata.spawn_col-1] /~ "?" then
																  array.put ("*", edata.spawn_row, edata.spawn_col-1)
																end
																projloc.go_i_th (projloc.count)
																projloc.remove
															end
                                                end

							         	   	 	  if projeatspawnproj(edata.spawn_row,edata.spawn_col-1,ine) then
                                                            normaltemp := "      The projectile collides with enemy projectile(id:"+projeatspawnprojid.out+") at location ["
                                                            if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], combining damage.")
															end
															premprint[ine].normal.extend (normaltemp)
									         	  end

							         	   	 end
							        elseif projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove) then
							        	    normaltemp := "    A Grunt(id:"+edata.id.out+")"
							        	    if edata.spawn_row = edata.spawn_row and edata.spawn_col = projenemycollidecol + 1 then
			                     	           normaltemp.append (" stays at: [")
			                     	           if attached keyval.item (edata.spawn_row) as t2 then
													 normaltemp.append (t2.to_string_8)
												end
												     normaltemp.append (",")
												if attached (edata.spawn_col) as t3 then
												     normaltemp.append (t3.out+"]")
												end
			                     	        else
								        	    normaltemp.append(" moves: [")
						                        if attached keyval.item (edata.spawn_row) as t then
													 normaltemp.append (t.to_string_8)
												 end
												     normaltemp.append (",")
												if attached (edata.spawn_col) as t1 then
													 normaltemp.append (t1.out+"] -> ")
												end
												if projenemycollidecol + 1 > 0 or hasfighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1) then
													normaltemp.append("[")
													if attached keyval.item (edata.spawn_row) as t2 then
														 normaltemp.append (t2.to_string_8)
													end
													     normaltemp.append (",")
													if attached (projenemycollidecol + 1) as t3 then
													     normaltemp.append (t3.out+"]")
													end
												else
													normaltemp.append ("out of board")
													--edata.dead := true
													edata.health := 0
												end
										   end
			                            premprint[ine].normal.extend (normaltemp)
			                            --premprint.put_i_th([premtempll,normaltempll],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normalaction")
			                            te := enemycollideprojf(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,edata.health,ine,"normal") -- check collide
			                            if te and edata.health >= 0 then
			                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
			                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol)
			                              end
			                            end
			                            if edata.health > 0 then

				                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normal")  -- check collide
				                            if te and in_game = false then
				                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
				                            end
				                        end
					--         	   	 	array.put ("<", edata.spawn_row, edata.spawn_col-4)
					--         	   	 	enemydata.put_i_th ([100,1,1,5,0,15,15,0,4,4,0,2,4,enemyid,"G","<",edata.spawn_row,edata.spawn_col,edata.spawn_row,edata.spawn_col-4], in)
					                    if ((projenemycollidecol + 1) > 0) and edata.health > 0  then
					                      if array[edata.spawn_row, projenemycollidecol + 1] /~ "?"  then
					                    	array.put ("G", edata.spawn_row, projenemycollidecol + 1)
					                      end
					                    end
			                               if edata.health > 0  then
							         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"G","<",edata.spawn_row, projenemycollidecol + 1,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
							         	   	 	--update_allproj
							         	   	 	if edata.spawn_col-1 > 0 and (not enemyatspawnproje(edata.spawn_row,edata.spawn_col-1)) then
				               	      	          if array[ edata.spawn_row, edata.spawn_col-1] /~ "?"  then
						         	   	 		      array.put ("<", edata.spawn_row, edata.spawn_col-1)
						         	   	 		  end
						         	   	 		projloc.extend ([edata.spawn_row,edata.spawn_col-1,idp,"G",4,15,"s"])  -- must put number of damage ect
							         	   	 	end

							         	   	 	if edata.spawn_col-1 >= 0 then
							         	   	 		--normaltemp.append("%N")
							         	   	 		if edata.spawn_col-1 = 0 then
                                                       normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location out of board.")
												       idp := idp - 1  -- after idp is assigned
							         	   	 		else
								         	   	 		normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location [")
									         	   	 	    if attached keyval.item (edata.spawn_row) as t then
																 normaltemp.append (t.to_string_8)
															end
															     normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																 normaltemp.append (t1.out+"].")
															end
													   idp := idp - 1  -- after idp is assigned
												     end
                                                   premprint[ine].normal.extend (normaltemp)
							         	   	 	end

							         	   	 	if enemyatspawnproje(edata.spawn_row,edata.spawn_col-1) then
							         	   	 		normaltemp := "      The projectile collides with "
							         	   	 		if enemydata[enemyatspawnprojenumber].sign ~ "G" then
							         	   	 			normaltemp.append ("Grunt(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "I" then
							         	   	 			normaltemp.append ("Interceptor(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "F" then
							         	   	 			normaltemp.append ("Fighter(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "P" then
							         	   	 			normaltemp.append ("Pylon(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		end
							         	   	 		if attached keyval.item (edata.spawn_row) as t then
												        normaltemp.append (t.to_string_8)
													end
														normaltemp.append (",")
													if attached (edata.spawn_col-1) as t1 then
														normaltemp.append (t1.out+"], healing 15 damage.")
													end
													premprint[ine].normal.extend (normaltemp)
													if enemydata[enemyatspawnprojenumber].health + 15 <= enemydata[enemyatspawnprojenumber].tolhealth then
														enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].health + 15
													else
														enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].tolhealth
													end
							         	   	 	end

							         	   	 	if fighteratspawnproje(edata.spawn_row,edata.spawn_col-1,ine,"normal") then

	                                                    projloc.go_i_th (projloc.count)
	                                                    projloc.remove
							         	   	 	end

							         	   	 	testspawnproj := projfatspawnproj(edata.spawn_row,edata.spawn_col-1,ine)
                                                if testspawnproj ~ "epd" or testspawnproj ~ "fpd" then
                                                	        normaltemp := "      The projectile collides with friendly projectile(id:"+projfatspawnprojid.out+") at location ["
                                                            if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], negating damage.")
															end
															premprint[ine].normal.extend (normaltemp)

															if testspawnproj ~ "epd" then
																if array[edata.spawn_row, edata.spawn_col-1] /~ "?" then
																  array.put ("*", edata.spawn_row, edata.spawn_col-1)
																end
																projloc.go_i_th (projloc.count)
																projloc.remove
															end
                                                end

							         	   	 	       if projeatspawnproj(edata.spawn_row,edata.spawn_col-1,ine) then
                                                            normaltemp := "      The projectile collides with enemy projectile(id:"+projeatspawnprojid.out+") at location ["
                                                            if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], combining damage.")
															end
															premprint[ine].normal.extend (normaltemp)
									         	   	 	end

							         	   end
							        end
			         	   	 end
			         	elseif edata.sign ~ "I" and edata.turn = true and edata.dead = false and edata.health > 0 then

			                     if not (prem ~ "fire") then -- end after prem
			                         if canseenby(edata.spawn_row,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,edata.vision)  then -- on see or not
			                              if not projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove)  then
									         	normaltemp := "    A Interceptor(id:"+edata.id.out+")"
									         	if edata.spawn_row = edata.spawn_row and edata.spawn_col = edata.spawn_col-edata.seenenemymove then
					                     	           normaltemp.append (" stays at: [")
					                     	           if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t3 then
														     normaltemp.append (t3.out+"]")
														end
			                     	            else
											         	normaltemp.append(" moves: [")
								                        if attached keyval.item (edata.spawn_row) as t then
															 normaltemp.append (t.to_string_8)
														 end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t1 then
															 normaltemp.append (t1.out+"] -> ")
														end
														if edata.spawn_col-edata.seenenemymove > 0 or hasfighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove) then
															normaltemp.append("[")
															if attached keyval.item (edata.spawn_row) as t2 then
																 normaltemp.append (t2.to_string_8)
															end
															     normaltemp.append (",")
															if attached (edata.spawn_col-edata.seenenemymove) as t3 then
															     normaltemp.append (t3.out+"]")
															end
														else
															normaltemp.append ("out of board")
															--edata.dead := true
															edata.health := 0
														end
											    end
											    premprint[ine].normal.extend (normaltemp)
						                        --premprint.put_i_th([premtempll,normaltempll],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove,ine,"normalaction")
						                        te := enemycollideprojf(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove,edata.health,ine,"normal") -- check collide
					                            if te and edata.health >= 0 then
					                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
					                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol)
					                              end
					                            end
					                            if edata.health > 0 then

						                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove,ine,"normal")  -- check collide
						                            if te and in_game = false then
						                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
						                            end
						                        end
						                        if ((edata.spawn_col-edata.seenenemymove)> 0) and edata.health > 0 then
						                         if array[edata.spawn_row, edata.spawn_col-edata.seenenemymove] /~ "?"  then
						                           array.put ("I", edata.spawn_row, edata.spawn_col-edata.seenenemymove)
						                         end
						                        end
						                      if (edata.health  > 0) then
							         	   	 	--seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,edata.spawn_row,edata.spawn_col-edata.seenenemymove,tolvision)
				         	                    --canseefighter := canseenby(edata.spawn_row,edata.spawn_col-edata.seenenemymove,shiploc.last.trow,shiploc.last.tcol,edata.vision)
							         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"I","<",edata.spawn_row,edata.spawn_col-edata.seenenemymove,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
							         	   	  end
							         	  elseif projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove) then
                                              normaltemp := "    A Interceptor(id:"+edata.id.out+")"
                                                if edata.spawn_row = edata.spawn_row and edata.spawn_col = projenemycollidecol + 1 then
					                     	           normaltemp.append (" stays at: [")
					                     	           if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t3 then
														     normaltemp.append (t3.out+"]")
														end
			                     	            else
		                                                normaltemp.append(" moves: [")
								                        if attached keyval.item (edata.spawn_row) as t then
															 normaltemp.append (t.to_string_8)
														 end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t1 then
															 normaltemp.append (t1.out+"] -> ")
														end
														if projenemycollidecol + 1 > 0 or hasfighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1) then
															normaltemp.append("[")
															if attached keyval.item (edata.spawn_row) as t2 then
																 normaltemp.append (t2.to_string_8)
															end
															     normaltemp.append (",")
															if attached (projenemycollidecol + 1) as t3 then
															     normaltemp.append (t3.out+"]")
															end
														else
															normaltemp.append ("out of board")
															--edata.dead := true
															edata.health := 0
														end
												  end
											    premprint[ine].normal.extend (normaltemp)
						                        --premprint.put_i_th([premtempll,normaltempll],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normalaction")
						                        te := enemycollideprojf(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,edata.health,ine,"normal") -- check collide
					                            if te and edata.health >= 0 then
					                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
					                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol)
					                              end
					                            end
					                            if edata.health > 0 then

						                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normal")  -- check collide
						                            if te and in_game = false then
						                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
						                            end
						                        end
						                        if ((projenemycollidecol + 1)> 0) and edata.health > 0  then
						                          if array[edata.spawn_row, projenemycollidecol + 1] /~ "?"  then
						                           array.put ("I", edata.spawn_row, projenemycollidecol + 1)
						                          end
						                        end
						                      if edata.health > 0  then
							         	   	 	--seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,edata.spawn_row,edata.spawn_col-edata.seenenemymove,tolvision)
				         	                    --canseefighter := canseenby(edata.spawn_row,edata.spawn_col-edata.seenenemymove,shiploc.last.trow,shiploc.last.tcol,edata.vision)
							         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"I","<",edata.spawn_row,projenemycollidecol + 1,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
							         	   	  end
							         	  end
			         	   	         elseif (not canseenby(edata.spawn_row,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,edata.vision)) then
                                           if not projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove)  then
								         	   	normaltemp := "    A Interceptor(id:"+edata.id.out+")"
								         	   	if edata.spawn_row = edata.spawn_row and edata.spawn_col = edata.spawn_col-edata.notseenenemymove then
					                     	           normaltemp.append (" stays at: [")
					                     	           if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t3 then
														     normaltemp.append (t3.out+"]")
														end
			                     	            else
									         	   	normaltemp.append(" moves: [")
							                        if attached keyval.item (edata.spawn_row) as t then
														 normaltemp.append (t.to_string_8)
													 end
													     normaltemp.append (",")
													if attached (edata.spawn_col) as t1 then
														 normaltemp.append (t1.out+"] -> ")
													end
													if edata.spawn_col-edata.notseenenemymove > 0 or hasfighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove) then
														normaltemp.append("[")
														if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col-edata.notseenenemymove) as t3 then
														     normaltemp.append (t3.out+"]")
														end
													else
														normaltemp.append ("out of board")
														edata.health := 0
														--edata.dead := true
													end
											    end
											    premprint[ine].normal.extend (normaltemp)
						                        --premprint.put_i_th([premtempll,normaltempll],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove,ine,"normalaction")
						                        te := enemycollideprojf(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove,edata.health,ine,"normal") -- check collide
					                            if te and edata.health >= 0 then
					                              if array[ enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
					                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol)
					                              end
					                            end
					                            if edata.health > 0 then

						                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove,ine,"normal")  -- check collide
						                            if te and in_game = false then
						                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
						                            end
						                        end
						                        if ((edata.spawn_col-edata.notseenenemymove) > 0) and edata.health > 0  then
						                          if array[edata.spawn_row, edata.spawn_col-edata.notseenenemymove] /~ "?"  then
						                        	array.put ("I", edata.spawn_row, edata.spawn_col-edata.notseenenemymove)
						                          end
						                        end
		                                      if edata.health > 0  then
								         	   	--seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,edata.spawn_row,edata.spawn_col-edata.notseenenemymove,tolvision)
				         	                    --canseefighter := canseenby(edata.spawn_row,edata.spawn_col-edata.notseenenemymove,shiploc.last.trow,shiploc.last.tcol,edata.vision)
								         	    enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"I","<",edata.spawn_row, edata.spawn_col-edata.notseenenemymove,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
								         	  end
								           elseif projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove) then
                                               normaltemp := "    A Interceptor(id:"+edata.id.out+")"
                                               if edata.spawn_row = edata.spawn_row and edata.spawn_col = projenemycollidecol + 1 then
					                     	           normaltemp.append (" stays at: [")
					                     	           if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t3 then
														     normaltemp.append (t3.out+"]")
														end
			                     	            else
	                                                normaltemp.append(" moves: [")
							                        if attached keyval.item (edata.spawn_row) as t then
														 normaltemp.append (t.to_string_8)
													 end
													     normaltemp.append (",")
													if attached (edata.spawn_col) as t1 then
														 normaltemp.append (t1.out+"] -> ")
													end
													if  projenemycollidecol + 1 > 0 or hasfighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1) then
														normaltemp.append("[")
														if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached ( projenemycollidecol + 1) as t3 then
														     normaltemp.append (t3.out+"]")
														end
													else
														normaltemp.append ("out of board")
														--edata.dead := true
														edata.health := 0
													end
											    end
											    premprint[ine].normal.extend (normaltemp)
						                        --premprint.put_i_th([premtempll,normaltempll],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normalaction")
						                        te := enemycollideprojf(edata.spawn_row,edata.spawn_col, projenemycollidecol + 1,edata.health,ine,"normal") -- check collide
					                            if te and edata.health >= 0 then
					                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
					                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol)
					                              end
					                            end
					                            if edata.health > 0 then

						                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col, projenemycollidecol + 1,ine,"normal")  -- check collide
						                            if te and in_game = false then
						                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
						                            end
						                        end
						                        if ((projenemycollidecol + 1) > 0) and edata.health > 0  then
						                          if array[ edata.spawn_row,  projenemycollidecol + 1] /~ "?"  then
						                        	array.put ("I", edata.spawn_row,  projenemycollidecol + 1)
						                          end
						                        end
		                                      if edata.health > 0 then
								         	   	--seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,edata.spawn_row,edata.spawn_col-edata.notseenenemymove,tolvision)
				         	                    --canseefighter := canseenby(edata.spawn_row,edata.spawn_col-edata.notseenenemymove,shiploc.last.trow,shiploc.last.tcol,edata.vision)
								         	    enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"I","<",edata.spawn_row,  projenemycollidecol + 1,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
								         	  end
								         end
			         	   	         end
			                     end
			            elseif edata.sign ~ "F"  and edata.dead = false and edata.health > 0 then
                                 if prem /~ "pass" then
                                 	  if array[edata.spawn_row,edata.spawn_col] /~ "?"  then
                                         array.put ("_", edata.spawn_row,edata.spawn_col )
                                      end
						         	   	 if canseenby(edata.spawn_row,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,edata.vision)   then -- on see or not
                                            if not projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove) then
							                    normaltemp := "    A Fighter(id:"+edata.id.out+")"
							                    if edata.spawn_row = edata.spawn_row and edata.spawn_col = edata.spawn_col-edata.seenenemymove then
					                     	           normaltemp.append (" stays at: [")
					                     	           if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t3 then
														     normaltemp.append (t3.out+"]")
														end
			                     	            else
								                        normaltemp.append(" moves: [")
								                        if attached keyval.item (edata.spawn_row) as t then
															 normaltemp.append (t.to_string_8)
														 end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t1 then
															 normaltemp.append (t1.out+"] -> ")
														end
								                        if edata.spawn_col-edata.seenenemymove > 0 or hasfighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove) then
								                        	normaltemp.append ("[")
															if attached keyval.item (edata.spawn_row) as t2 then
																 normaltemp.append (t2.to_string_8)
															end
															     normaltemp.append (",")
															if attached (edata.spawn_col-edata.seenenemymove) as t3 then
															     normaltemp.append (t3.out+"]")
															end
														else
															normaltemp.append ("out of board")
															edata.health := 0
														    --edata.dead := true
								                        end
								                end
							                    premprint[ine].normal.extend (normaltemp)
					                            --premprint.put_i_th([premprint[ine].prem,premprint[ine].normal],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove,ine,"normalaction")
					                            te := enemycollideprojf(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove,edata.health,ine,"normal") -- check collide
					                            if te and edata.health >= 0 then
					                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
					                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol) -- _ at starfighter proj
					                              end
					                            end
					                            if edata.health > 0 then

						                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove,ine,"normal")  -- check collide
						                            if te and in_game = false then
						                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
						                            end
                                                end
							                    if ((edata.spawn_col-edata.seenenemymove)> 0) and edata.health > 0 then
							                    	if array[edata.spawn_row,edata.spawn_col-edata.seenenemymove] /~ "?"  then -- for fog of war
							         	   	 	       array.put ("F", edata.spawn_row, edata.spawn_col-edata.seenenemymove)
							         	   	 	    end
							                    end
					                                if edata.health > 0 then
									         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"F","<",edata.spawn_row,edata.spawn_col-edata.seenenemymove,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
									         	   	 	if edata.spawn_col-1 > 0 and (not enemyatspawnproje(edata.spawn_row,edata.spawn_col-1)) then
						               	      	          if array[ edata.spawn_row, edata.spawn_col-1] /~ "?"  then
								         	   	 		      array.put ("<", edata.spawn_row, edata.spawn_col-1)
								         	   	 		  end
								         	   	 		projloc.extend ([edata.spawn_row,edata.spawn_col-1,idp,"G",6,50,"s"])  -- must put number of damage ect
									         	   	 	end

									         	   	 	if edata.spawn_col-1 >= 0 then
									         	   	 		--normaltemp.append("%N")
									         	   	 		if edata.spawn_col-1 = 0 then
		                                                       normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location out of board.")
														       idp := idp - 1  -- after idp is assigned
									         	   	 		else
										         	   	 		normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location [")
											         	   	 	    if attached keyval.item (edata.spawn_row) as t then
																		 normaltemp.append (t.to_string_8)
																	end
																	     normaltemp.append (",")
																	if attached (edata.spawn_col-1) as t1 then
																		 normaltemp.append (t1.out+"].")
																	end
															     idp := idp - 1  -- after idp is assigned
														     end
		                                                   premprint[ine].normal.extend (normaltemp)
									         	   	 	end

									         	   	 	if enemyatspawnproje(edata.spawn_row,edata.spawn_col-1) then
									         	   	 		normaltemp := "      The projectile collides with "
									         	   	 		if enemydata[enemyatspawnprojenumber].sign ~ "G" then
									         	   	 			normaltemp.append ("Grunt(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "I" then
									         	   	 			normaltemp.append ("Interceptor(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "F" then
									         	   	 			normaltemp.append ("Fighter(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "P" then
									         	   	 			normaltemp.append ("Pylon(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		end
									         	   	 		if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], healing 50 damage.")
															end
															premprint[ine].normal.extend (normaltemp)
															if enemydata[enemyatspawnprojenumber].health + 50 <= enemydata[enemyatspawnprojenumber].tolhealth then
																enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].health + 50
															else
																enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].tolhealth
															end
									         	   	 	end

									         	   	 	if fighteratspawnproje(edata.spawn_row,edata.spawn_col-1,ine,"normal") then

	                                                    projloc.go_i_th (projloc.count)
	                                                    projloc.remove
									         	   	 	end

									         	   	 	testspawnproj := projfatspawnproj(edata.spawn_row,edata.spawn_col-1,ine)
		                                                if testspawnproj ~ "epd" or testspawnproj ~ "fpd" then
		                                                	        normaltemp := "      The projectile collides with friendly projectile(id:"+projfatspawnprojid.out+") at location ["
		                                                            if attached keyval.item (edata.spawn_row) as t then
																        normaltemp.append (t.to_string_8)
																	end
																		normaltemp.append (",")
																	if attached (edata.spawn_col-1) as t1 then
																		normaltemp.append (t1.out+"], negating damage.")
																	end
																	premprint[ine].normal.extend (normaltemp)

																	if testspawnproj ~ "epd" then
																		if array[edata.spawn_row, edata.spawn_col-1] /~ "?" then
																		  array.put ("*", edata.spawn_row, edata.spawn_col-1)
																		end
																		projloc.go_i_th (projloc.count)
																		projloc.remove
																	end
		                                                end

									         	   	 	if projeatspawnproj(edata.spawn_row,edata.spawn_col-1,ine) then
                                                            normaltemp := "      The projectile collides with enemy projectile(id:"+projeatspawnprojid.out+") at location ["
                                                            if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], combining damage.")
															end
															premprint[ine].normal.extend (normaltemp)
									         	   	 	end

									         	    end
									        elseif projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove) then  -- if collided enenmy enemy
									         	    normaltemp := "    A Fighter(id:"+edata.id.out+")"
									         	if edata.spawn_row = edata.spawn_row and edata.spawn_col = projenemycollidecol + 1 then
					                     	           normaltemp.append (" stays at: [")
					                     	           if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t3 then
														     normaltemp.append (t3.out+"]")
														end
			                     	            else
										         	    normaltemp.append(" moves: [")
								                        if attached keyval.item (edata.spawn_row) as t then
															 normaltemp.append (t.to_string_8)
														 end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t1 then
															 normaltemp.append (t1.out+"] -> ")
														end
								                        if projenemycollidecol + 1 > 0 or hasfighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1) then
								                        	normaltemp.append ("[")
															if attached keyval.item (edata.spawn_row) as t2 then
																 normaltemp.append (t2.to_string_8)
															end
															     normaltemp.append (",")
															if attached (projenemycollidecol + 1) as t3 then
															     normaltemp.append (t3.out+"]")
															end
														else
															normaltemp.append ("out of board")
															edata.health := 0
														    --edata.dead := true
								                        end
								                end
							                    premprint[ine].normal.extend (normaltemp)
					                            --premprint.put_i_th([premprint[ine].prem,premprint[ine].normal],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normalaction")
					                            te := enemycollideprojf(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,edata.health,ine,"normal") -- check collide
					                            if te and edata.health >= 0 then
					                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
					                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol) -- _ at starfighter proj
					                              end
					                            end
					                            if edata.health > 0 then

						                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normal")  -- check collide
						                            if te and in_game = false then
						                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
						                            end
                                                end

							                    if ((projenemycollidecol + 1)> 0) and edata.health > 0  then
							                    	if array[edata.spawn_row,projenemycollidecol + 1] /~ "?"  then -- for fog of war
							         	   	 	       array.put ("F", edata.spawn_row, projenemycollidecol + 1)
							         	   	 	    end
							                    end
					                                if edata.health > 0  then
									         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"F","<",edata.spawn_row,projenemycollidecol + 1,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
									         	   	 	if edata.spawn_col-1 > 0 and (not enemyatspawnproje(edata.spawn_row,edata.spawn_col-1)) then
						               	      	          if array[ edata.spawn_row, edata.spawn_col-1] /~ "?"  then
								         	   	 		      array.put ("<", edata.spawn_row, edata.spawn_col-1)
								         	   	 		  end
								         	   	 		projloc.extend ([edata.spawn_row,edata.spawn_col-1,idp,"G",6,50,"s"])  -- must put number of damage ect
									         	   	 	end

									         	   	 	if edata.spawn_col-1 >= 0 then
									         	   	 		--normaltemp.append("%N")
									         	   	 		if edata.spawn_col-1 = 0 then
		                                                       normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location out of board.")
														       idp := idp - 1  -- after idp is assigned
									         	   	 		else
										         	   	 		normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location [")
											         	   	 	    if attached keyval.item (edata.spawn_row) as t then
																		 normaltemp.append (t.to_string_8)
																	end
																	     normaltemp.append (",")
																	if attached (edata.spawn_col-1) as t1 then
																		 normaltemp.append (t1.out+"].")
																	end
															   idp := idp - 1  -- after idp is assigned
														     end
		                                                   premprint[ine].normal.extend (normaltemp)
									         	   	 	end

									         	   	 	if enemyatspawnproje(edata.spawn_row,edata.spawn_col-1) then
									         	   	 		normaltemp := "      The projectile collides with "
									         	   	 		if enemydata[enemyatspawnprojenumber].sign ~ "G" then
									         	   	 			normaltemp.append ("Grunt(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "I" then
									         	   	 			normaltemp.append ("Interceptor(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "F" then
									         	   	 			normaltemp.append ("Fighter(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "P" then
									         	   	 			normaltemp.append ("Pylon(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		end
									         	   	 		if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], healing 50 damage.")
															end
															premprint[ine].normal.extend (normaltemp)
															if enemydata[enemyatspawnprojenumber].health + 50 <= enemydata[enemyatspawnprojenumber].tolhealth then
																enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].health + 50
															else
																enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].tolhealth
															end
									         	   	 	end

									         	   	 	if fighteratspawnproje(edata.spawn_row,edata.spawn_col-1,ine,"normal") then

	                                                    projloc.go_i_th (projloc.count)
	                                                    projloc.remove
									         	   	 	end

									         	   	 	testspawnproj := projfatspawnproj(edata.spawn_row,edata.spawn_col-1,ine)
		                                                if testspawnproj ~ "epd" or testspawnproj ~ "fpd" then
		                                                	        normaltemp := "      The projectile collides with friendly projectile(id:"+projfatspawnprojid.out+") at location ["
		                                                            if attached keyval.item (edata.spawn_row) as t then
																        normaltemp.append (t.to_string_8)
																	end
																		normaltemp.append (",")
																	if attached (edata.spawn_col-1) as t1 then
																		normaltemp.append (t1.out+"], negating damage.")
																	end
																	premprint[ine].normal.extend (normaltemp)

																	if testspawnproj ~ "epd" then
																		if array[edata.spawn_row, edata.spawn_col-1] /~ "?" then
																		  array.put ("*", edata.spawn_row, edata.spawn_col-1)
																		end
																		projloc.go_i_th (projloc.count)
																		projloc.remove
																	end
		                                                end

									         	   	 	if projeatspawnproj(edata.spawn_row,edata.spawn_col-1,ine) then
                                                            normaltemp := "      The projectile collides with enemy projectile(id:"+projeatspawnprojid.out+") at location ["
                                                            if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], combining damage.")
															end
															premprint[ine].normal.extend (normaltemp)
									         	   	 	end

									         	    end
									        end
						         	   	 elseif (not canseenby(edata.spawn_row,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,edata.vision))   then
						         	   	 	 if not projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove) then
							                    normaltemp := "    A Fighter(id:"+edata.id.out+")"
							                    if edata.spawn_row = edata.spawn_row and edata.spawn_col = edata.spawn_col-edata.notseenenemymove then
					                     	           normaltemp.append (" stays at: [")
					                     	           if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t3 then
														     normaltemp.append (t3.out+"]")
														end
			                     	            else
								                        normaltemp.append(" moves: [")
								                        if attached keyval.item (edata.spawn_row) as t then
															 normaltemp.append (t.to_string_8)
														 end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t1 then
															 normaltemp.append (t1.out+"] -> ")
														end
														if edata.spawn_col-edata.notseenenemymove > 0 or hasfighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove) then
															normaltemp.append("[")
															if attached keyval.item (edata.spawn_row) as t2 then
																 normaltemp.append (t2.to_string_8)
															end
															     normaltemp.append (",")
															if attached (edata.spawn_col-edata.notseenenemymove) as t3 then
															     normaltemp.append (t3.out+"]")
															end
														else
															normaltemp.append ("out of board")
															edata.health := 0
														    --edata.dead := true
														end
											    end
					                            premprint[ine].normal.extend (normaltemp)
					                            --premprint.put_i_th([premtempll,normaltempll],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove,ine,"normalaction")
					                            te := enemycollideprojf(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove,edata.health,ine,"normal") -- check collide
					                            if te and edata.health >= 0 then
					                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
					                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol)
					                              end
					                            end
					                            if edata.health > 0 then

						                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove,ine,"normal")  -- check collide
						                            if te and in_game = false then
						                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
						                            end
						                        end
							--         	   	 	array.put ("<", edata.spawn_row, edata.spawn_col-4)
							--         	   	 	enemydata.put_i_th ([100,1,1,5,0,15,15,0,4,4,0,2,4,enemyid,"G","<",edata.spawn_row,edata.spawn_col,edata.spawn_row,edata.spawn_col-4], in)
							                    if ((edata.spawn_col-edata.notseenenemymove) > 0) and edata.health > 0  then
							                      if array[edata.spawn_row, edata.spawn_col-edata.notseenenemymove] /~ "?"  then
							                    	array.put ("F", edata.spawn_row, edata.spawn_col-edata.notseenenemymove)
							                      end
							                    end
					                                 if edata.health > 0  then
									         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"F","<",edata.spawn_row, edata.spawn_col-edata.notseenenemymove,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
									         	   	 	--update_allproj
									         	   	 	if edata.spawn_col-1 > 0 and (not enemyatspawnproje(edata.spawn_row,edata.spawn_col-1)) then
						               	      	          if array[ edata.spawn_row, edata.spawn_col-1] /~ "?"  then
								         	   	 		      array.put ("<", edata.spawn_row, edata.spawn_col-1)
								         	   	 		  end
								         	   	 		projloc.extend ([edata.spawn_row,edata.spawn_col-1,idp,"G",3,20,"s"])  -- must put number of damage ect
									         	   	 	end

									         	   	 	if edata.spawn_col-1 >= 0 then
									         	   	 		--normaltemp.append("%N")
									         	   	 		if edata.spawn_col-1 = 0 then
		                                                       normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location out of board.")
														       idp := idp - 1  -- after idp is assigned
									         	   	 		else
										         	   	 		normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location [")
											         	   	 	    if attached keyval.item (edata.spawn_row) as t then
																		 normaltemp.append (t.to_string_8)
																	end
																	     normaltemp.append (",")
																	if attached (edata.spawn_col-1) as t1 then
																		 normaltemp.append (t1.out+"].")
																	end
															   idp := idp - 1  -- after idp is assigned
														     end
		                                                   premprint[ine].normal.extend (normaltemp)
									         	   	 	end

									         	   	 	if enemyatspawnproje(edata.spawn_row,edata.spawn_col-1) then
									         	   	 		normaltemp := "      The projectile collides with "
									         	   	 		if enemydata[enemyatspawnprojenumber].sign ~ "G" then
									         	   	 			normaltemp.append ("Grunt(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "I" then
									         	   	 			normaltemp.append ("Interceptor(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "F" then
									         	   	 			normaltemp.append ("Fighter(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "P" then
									         	   	 			normaltemp.append ("Pylon(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		end
									         	   	 		if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], healing 20 damage.")
															end
															premprint[ine].normal.extend (normaltemp)
															if enemydata[enemyatspawnprojenumber].health + 20 <= enemydata[enemyatspawnprojenumber].tolhealth then
																enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].health + 20
															else
																enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].tolhealth
															end
									         	   	 	end

									         	   	 	if fighteratspawnproje(edata.spawn_row,edata.spawn_col-1,ine,"normal") then

	                                                    projloc.go_i_th (projloc.count)
	                                                    projloc.remove
									         	   	 	end

									         	   	 	testspawnproj := projfatspawnproj(edata.spawn_row,edata.spawn_col-1,ine)
		                                                if testspawnproj ~ "epd" or testspawnproj ~ "fpd" then
		                                                	        normaltemp := "      The projectile collides with friendly projectile(id:"+projfatspawnprojid.out+") at location ["
		                                                            if attached keyval.item (edata.spawn_row) as t then
																        normaltemp.append (t.to_string_8)
																	end
																		normaltemp.append (",")
																	if attached (edata.spawn_col-1) as t1 then
																		normaltemp.append (t1.out+"], negating damage.")
																	end
																	premprint[ine].normal.extend (normaltemp)

																	if testspawnproj ~ "epd" then
																		if array[edata.spawn_row, edata.spawn_col-1] /~ "?" then
																		  array.put ("*", edata.spawn_row, edata.spawn_col-1)
																		end
																		projloc.go_i_th (projloc.count)
																		projloc.remove
																	end
		                                                end

									         	   	 	if projeatspawnproj(edata.spawn_row,edata.spawn_col-1,ine) then
                                                            normaltemp := "      The projectile collides with enemy projectile(id:"+projeatspawnprojid.out+") at location ["
                                                            if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], combining damage.")
															end
															premprint[ine].normal.extend (normaltemp)
									         	   	 	end

									         	   	 end
									        elseif projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove) then
									        	    normaltemp := "    A Fighter(id:"+edata.id.out+")"
									        	if edata.spawn_row = edata.spawn_row and edata.spawn_col = projenemycollidecol + 1 then
					                     	           normaltemp.append (" stays at: [")
					                     	           if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t3 then
														     normaltemp.append (t3.out+"]")
														end
			                     	            else
										        	    normaltemp.append(" moves: [")
								                        if attached keyval.item (edata.spawn_row) as t then
															 normaltemp.append (t.to_string_8)
														 end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t1 then
															 normaltemp.append (t1.out+"] -> ")
														end
														if projenemycollidecol + 1 > 0 or hasfighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1) then
															normaltemp.append("[")
															if attached keyval.item (edata.spawn_row) as t2 then
																 normaltemp.append (t2.to_string_8)
															end
															     normaltemp.append (",")
															if attached (projenemycollidecol + 1) as t3 then
															     normaltemp.append (t3.out+"]")
															end
														else
															normaltemp.append ("out of board")
															edata.health := 0
														    --edata.dead := true
														end
											    end
					                            premprint[ine].normal.extend (normaltemp)
					                            --premprint.put_i_th([premtempll,normaltempll],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normalaction")
					                            te := enemycollideprojf(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,edata.health,ine,"normal") -- check collide
					                            if te and edata.health >= 0 then
					                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
					                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol)
					                              end
					                            end
					                            if edata.health > 0 then

						                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normal")  -- check collide
						                            if te and in_game = false then
						                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
						                            end
						                        end
							--         	   	 	array.put ("<", edata.spawn_row, edata.spawn_col-4)
							--         	   	 	enemydata.put_i_th ([100,1,1,5,0,15,15,0,4,4,0,2,4,enemyid,"G","<",edata.spawn_row,edata.spawn_col,edata.spawn_row,edata.spawn_col-4], in)
							                    if ((projenemycollidecol + 1) > 0) and edata.health > 0  then
							                      if array[edata.spawn_row, projenemycollidecol + 1] /~ "?"  then
							                    	array.put ("F", edata.spawn_row, projenemycollidecol + 1)
							                      end
							                    end
					                                 if edata.health > 0  then
									         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"F","<",edata.spawn_row, projenemycollidecol + 1,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
									         	   	 	--update_allproj
									         	   	 	if edata.spawn_col-1 > 0 and (not enemyatspawnproje(edata.spawn_row,edata.spawn_col-1)) then
						               	      	          if array[ edata.spawn_row, edata.spawn_col-1] /~ "?"  then
								         	   	 		      array.put ("<", edata.spawn_row, edata.spawn_col-1)
								         	   	 		  end
								         	   	 		projloc.extend ([edata.spawn_row,edata.spawn_col-1,idp,"G",3,20,"s"])  -- must put number of damage ect
									         	   	 	end

									         	   	 	if edata.spawn_col-1 >= 0 then
									         	   	 		--normaltemp.append("%N")
									         	   	 		if edata.spawn_col-1 = 0 then
		                                                       normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location out of board.")
														       idp := idp - 1  -- after idp is assigned
									         	   	 		else
										         	   	 		normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location [")
											         	   	 	    if attached keyval.item (edata.spawn_row) as t then
																		 normaltemp.append (t.to_string_8)
																	end
																	     normaltemp.append (",")
																	if attached (edata.spawn_col-1) as t1 then
																		 normaltemp.append (t1.out+"].")
																	end
															   idp := idp - 1  -- after idp is assigned
														     end
		                                                   premprint[ine].normal.extend (normaltemp)
									         	   	 	end

									         	   	 	if enemyatspawnproje(edata.spawn_row,edata.spawn_col-1) then
									         	   	 		normaltemp := "      The projectile collides with "
									         	   	 		if enemydata[enemyatspawnprojenumber].sign ~ "G" then
									         	   	 			normaltemp.append ("Grunt(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "I" then
									         	   	 			normaltemp.append ("Interceptor(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "F" then
									         	   	 			normaltemp.append ("Fighter(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "P" then
									         	   	 			normaltemp.append ("Pylon(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		end
									         	   	 		if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], healing 20 damage.")
															end
															premprint[ine].normal.extend (normaltemp)
															if enemydata[enemyatspawnprojenumber].health + 20 <= enemydata[enemyatspawnprojenumber].tolhealth then
																enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].health + 20
															else
																enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].tolhealth
															end
									         	   	 	end

									         	   	 	if fighteratspawnproje(edata.spawn_row,edata.spawn_col-1,ine,"normal") then

	                                                    projloc.go_i_th (projloc.count)
	                                                    projloc.remove
									         	   	 	end

									         	   	 	testspawnproj := projfatspawnproj(edata.spawn_row,edata.spawn_col-1,ine)
		                                                if testspawnproj ~ "epd" or testspawnproj ~ "fpd" then
		                                                	        normaltemp := "      The projectile collides with friendly projectile(id:"+projfatspawnprojid.out+") at location ["
		                                                            if attached keyval.item (edata.spawn_row) as t then
																        normaltemp.append (t.to_string_8)
																	end
																		normaltemp.append (",")
																	if attached (edata.spawn_col-1) as t1 then
																		normaltemp.append (t1.out+"], negating damage.")
																	end
																	premprint[ine].normal.extend (normaltemp)

																	if testspawnproj ~ "epd" then
																		if array[edata.spawn_row, edata.spawn_col-1] /~ "?" then
																		  array.put ("*", edata.spawn_row, edata.spawn_col-1)
																		end
																		projloc.go_i_th (projloc.count)
																		projloc.remove
																	end
		                                                end

									         	   	 	if projeatspawnproj(edata.spawn_row,edata.spawn_col-1,ine) then
                                                            normaltemp := "      The projectile collides with enemy projectile(id:"+projeatspawnprojid.out+") at location ["
                                                            if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], combining damage.")
															end
															premprint[ine].normal.extend (normaltemp)
									         	   	 	end
									         	   	 end
									        end
						         	   	 end
                                 end
                        elseif edata.sign ~ "C" and edata.dead = false and edata.health > 0 then
                        	if prem /~ "pass" then
                        	  if array[edata.spawn_row,edata.spawn_col] /~ "?"  then
                        	    array.put ("_", edata.spawn_row,edata.spawn_col )
                        	  end
                                 if canseenby(edata.spawn_row,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,edata.vision)   then -- on see or not
                                            if not projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove) then
							                    normaltemp := "    A Carrier(id:"+edata.id.out+")"
							                    if edata.spawn_row = edata.spawn_row and edata.spawn_col = edata.spawn_col-edata.seenenemymove then
					                     	           normaltemp.append (" stays at: [")
					                     	           if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t3 then
														     normaltemp.append (t3.out+"]")
														end
			                     	            else
								                        normaltemp.append(" moves: [")
								                        if attached keyval.item (edata.spawn_row) as t then
															 normaltemp.append (t.to_string_8)
														 end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t1 then
															 normaltemp.append (t1.out+"] -> ")
														end
								                        if edata.spawn_col-edata.seenenemymove > 0 or hasfighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove) then
								                        	normaltemp.append ("[")
															if attached keyval.item (edata.spawn_row) as t2 then
																 normaltemp.append (t2.to_string_8)
															end
															     normaltemp.append (",")
															if attached (edata.spawn_col-edata.seenenemymove) as t3 then
															     normaltemp.append (t3.out+"]")
															end
														else
															normaltemp.append ("out of board")
															edata.health := 0
														    --edata.dead := true
								                        end
								                end
							                    premprint[ine].normal.extend (normaltemp)
					                            --premprint.put_i_th([premprint[ine].prem,premprint[ine].normal],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove,ine,"normalaction")
					                            te := enemycollideprojf(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove,edata.health,ine,"normal") -- check collide
					                            if te and edata.health >= 0 then
					                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
					                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol) -- _ at starfighter proj
					                              end
					                            end
					                            if edata.health > 0 then

						                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove,ine,"normal")  -- check collide
						                            if te and in_game = false then
						                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
						                            end
						                        end

							                    if ((edata.spawn_col-edata.seenenemymove)> 0) and edata.health > 0  then
							                    	if array[edata.spawn_row,edata.spawn_col-edata.seenenemymove] /~ "?"  then -- for fog of war
							         	   	 	       array.put ("C", edata.spawn_row, edata.spawn_col-edata.seenenemymove)
							         	   	 	    end
							                    end
					                                if edata.health > 0  then
									         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"C","<",edata.spawn_row,edata.spawn_col-edata.seenenemymove,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
											         	   	if (not enemyatspawnproje(edata.spawn_row,edata.spawn_col-1)) then
							                                	if (edata.spawn_col-1) > 0  then  -- change thisssss col to collidecol
							                                		-- spawn I at top
							                                		seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,edata.spawn_row,edata.spawn_col-1,tolvision)
													         	   	canseefighter := canseenby(edata.spawn_row,edata.spawn_col-1,shiploc.last.trow,shiploc.last.tcol,5)
													             	enemydata.extend ([50,50,0,0,5,0,0,0,0,0,0,0,3,3,enemyid,"I","<",edata.spawn_row,edata.spawn_col-1,canseefighter,seenbyfighter,false,true])
		                                                            if array[edata.spawn_row, edata.spawn_col-1] /~ "?"  then
		                                                              array.put ("I", edata.spawn_row, edata.spawn_col-1)
		                                                            end
		                                                            enemydata[enemydata.count].turn := false  -- dont use .last as cursor is not upgrading
							                                    end

							                                    normaltemp := ("      A Interceptor(id:"+enemyid.out+") spawns at location [")
												         	   	 		if (edata.spawn_col-1) > 0  then
													         	   	 	    if attached keyval.item (edata.spawn_row) as t then
																				 normaltemp.append (t.to_string_8)
																			end
																			     normaltemp.append (",")
																			if attached (edata.spawn_col-1) as t1 then
																				 normaltemp.append (t1.out+"].")
																			end
																		else
																			premtemp.append("out of board")
																		end
												         	   	   premprint[ine].normal.extend (normaltemp)
												         	   enemyid := enemyid + 1
						                                    end

									         	    end
									        elseif projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove) then  -- if collided enenmy enemy
									         	    normaltemp := "    A Carrier(id:"+edata.id.out+")"
									         	if edata.spawn_row = edata.spawn_row and edata.spawn_col = projenemycollidecol + 1 then
					                     	           normaltemp.append (" stays at: [")
					                     	           if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t3 then
														     normaltemp.append (t3.out+"]")
														end
			                     	            else
										         	    normaltemp.append(" moves: [")
								                        if attached keyval.item (edata.spawn_row) as t then
															 normaltemp.append (t.to_string_8)
														 end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t1 then
															 normaltemp.append (t1.out+"] -> ")
														end
								                        if projenemycollidecol + 1 > 0 or hasfighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1) then
								                        	normaltemp.append ("[")
															if attached keyval.item (edata.spawn_row) as t2 then
																 normaltemp.append (t2.to_string_8)
															end
															     normaltemp.append (",")
															if attached (projenemycollidecol + 1) as t3 then
															     normaltemp.append (t3.out+"]")
															end
														else
															normaltemp.append ("out of board")
															edata.health := 0
														    --edata.dead := true
								                        end
								                end
							                    premprint[ine].normal.extend (normaltemp)
					                            --premprint.put_i_th([premprint[ine].prem,premprint[ine].normal],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normalaction")
					                            te := enemycollideprojf(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,edata.health,ine,"normal") -- check collide
					                            if te and edata.health >= 0 then
					                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
					                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol) -- _ at starfighter proj
					                              end
					                            end
					                            if edata.health > 0 then

						                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normal")  -- check collide
						                            if te and in_game = false then
						                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
						                            end
						                        end

							                    if ((projenemycollidecol + 1)> 0) and edata.health > 0  then
							                    	if array[edata.spawn_row,projenemycollidecol + 1] /~ "?"  then -- for fog of war
							         	   	 	       array.put ("C", edata.spawn_row, projenemycollidecol + 1)
							         	   	 	    end
							                    end
					                                if edata.health > 0  then
									         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"C","<",edata.spawn_row,projenemycollidecol + 1,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
									         	   	 	    if (not enemyatspawnproje(edata.spawn_row,edata.spawn_col-1)) then
							                                    if (edata.spawn_col-1) > 0  then  -- change thisssss col to collidecol
							                                		-- spawn I at top
							                                		seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,edata.spawn_row,edata.spawn_col-1,tolvision)
													         	   	canseefighter := canseenby(edata.spawn_row,edata.spawn_col-1,shiploc.last.trow,shiploc.last.tcol,5)
													             	enemydata.extend ([50,50,0,0,5,0,0,0,0,0,0,0,3,3,enemyid,"I","<",edata.spawn_row,edata.spawn_col-1,canseefighter,seenbyfighter,false,true])
		                                                            if array[edata.spawn_row, edata.spawn_col-1] /~ "?"  then
		                                                              array.put ("I", edata.spawn_row, edata.spawn_col-1)
		                                                            end
		                                                            enemydata[enemydata.count].turn := false  -- dont use .last as cursor is not upgrading
							                                    end

							                                    normaltemp := ("      A Interceptor(id:"+enemyid.out+") spawns at location [")
												         	   	 		if (edata.spawn_col-1) > 0  then
													         	   	 	    if attached keyval.item (edata.spawn_row) as t then
																				 normaltemp.append (t.to_string_8)
																			end
																			     normaltemp.append (",")
																			if attached (edata.spawn_col-1) as t1 then
																				 normaltemp.append (t1.out+"].")
																			end
																		else
																			normaltemp.append("out of board")
																		end
																	   premprint[ine].normal.extend (normaltemp)
												         	   enemyid := enemyid + 1
						                                    end
									         	    end
									        end

                                 elseif (not canseenby(edata.spawn_row,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,edata.vision)) then
                                            if not projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove) then
							                    normaltemp := "    A Carrier(id:"+edata.id.out+")"
							                    if edata.spawn_row = edata.spawn_row and edata.spawn_col = edata.spawn_col-edata.notseenenemymove then
					                     	           normaltemp.append (" stays at: [")
					                     	           if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t3 then
														     normaltemp.append (t3.out+"]")
														end
			                     	            else
								                        normaltemp.append(" moves: [")
								                        if attached keyval.item (edata.spawn_row) as t then
															 normaltemp.append (t.to_string_8)
														 end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t1 then
															 normaltemp.append (t1.out+"] -> ")
														end
														if edata.spawn_col-edata.notseenenemymove > 0 or hasfighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove) then
															normaltemp.append("[")
															if attached keyval.item (edata.spawn_row) as t2 then
																 normaltemp.append (t2.to_string_8)
															end
															     normaltemp.append (",")
															if attached (edata.spawn_col-edata.notseenenemymove) as t3 then
															     normaltemp.append (t3.out+"]")
															end
														else
															normaltemp.append ("out of board")
															edata.health := 0
														    --edata.dead := true
														end
											    end
					                            premprint[ine].normal.extend (normaltemp)
					                            --premprint.put_i_th([premtempll,normaltempll],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove,ine,"normalaction")
					                            te := enemycollideprojf(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove,edata.health,ine,"normal") -- check collide
					                            if te and edata.health >= 0 then
					                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
					                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol)
					                              end
					                            end
					                            if edata.health > 0 then

						                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove,ine,"normal")  -- check collide
						                            if te and in_game = false then
						                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
						                            end
						                        end
							--         	   	 	array.put ("<", edata.spawn_row, edata.spawn_col-4)
							--         	   	 	enemydata.put_i_th ([100,1,1,5,0,15,15,0,4,4,0,2,4,enemyid,"G","<",edata.spawn_row,edata.spawn_col,edata.spawn_row,edata.spawn_col-4], in)
							                    if ((edata.spawn_col-edata.notseenenemymove) > 0) and edata.health > 0  then
							                      if array[edata.spawn_row, edata.spawn_col-edata.notseenenemymove] /~ "?"  then
							                    	array.put ("C", edata.spawn_row, edata.spawn_col-edata.notseenenemymove)
							                      end
							                    end
					                                 if edata.health > 0  then
									         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"C","<",edata.spawn_row, edata.spawn_col-edata.notseenenemymove,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)

									         	   	 end
									        elseif projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove) then
									        	    normaltemp := "    A Carrier(id:"+edata.id.out+")"
									        	if edata.spawn_row = edata.spawn_row and edata.spawn_col = projenemycollidecol + 1 then
					                     	           normaltemp.append (" stays at: [")
					                     	           if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t3 then
														     normaltemp.append (t3.out+"]")
														end
			                     	            else
										        	    normaltemp.append(" moves: [")
								                        if attached keyval.item (edata.spawn_row) as t then
															 normaltemp.append (t.to_string_8)
														 end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t1 then
															 normaltemp.append (t1.out+"] -> ")
														end
														if projenemycollidecol + 1 > 0 or hasfighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1) then
															normaltemp.append("[")
															if attached keyval.item (edata.spawn_row) as t2 then
																 normaltemp.append (t2.to_string_8)
															end
															     normaltemp.append (",")
															if attached (projenemycollidecol + 1) as t3 then
															     normaltemp.append (t3.out+"]")
															end
														else
															normaltemp.append ("out of board")
															edata.health := 0
														    --edata.dead := true
														end
											    end
					                            premprint[ine].normal.extend (normaltemp)
					                            --premprint.put_i_th([premtempll,normaltempll],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normalaction")
					                            te := enemycollideprojf(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,edata.health,ine,"normal") -- check collide
					                            if te and edata.health >= 0 then
					                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
					                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol)
					                              end
					                            end
					                            if edata.health > 0 then

						                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normal")  -- check collide
						                            if te and in_game = false then
						                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
						                            end
						                        end
							--         	   	 	array.put ("<", edata.spawn_row, edata.spawn_col-4)
							--         	   	 	enemydata.put_i_th ([100,1,1,5,0,15,15,0,4,4,0,2,4,enemyid,"G","<",edata.spawn_row,edata.spawn_col,edata.spawn_row,edata.spawn_col-4], in)
							                    if ((projenemycollidecol + 1) > 0) and edata.health > 0 then
							                      if array[edata.spawn_row, projenemycollidecol + 1] /~ "?"  then
							                    	array.put ("C", edata.spawn_row, projenemycollidecol + 1)
							                      end
							                    end
					                                 if edata.health > 0  then
									         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"C","<",edata.spawn_row, projenemycollidecol + 1,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)

									         	   	 end
									        end
                                 end
                            end
                        elseif edata.sign ~ "P" and edata.dead = false and edata.health > 0 then
                        	     if canseenby(edata.spawn_row,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,edata.vision) then
                        	                if not projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove) then
							                    normaltemp := "    A Pylon(id:"+edata.id.out+")"
							                    if edata.spawn_row = edata.spawn_row and edata.spawn_col = edata.spawn_col-edata.seenenemymove then
					                     	           normaltemp.append (" stays at: [")
					                     	           if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t3 then
														     normaltemp.append (t3.out+"]")
														end
			                     	            else
							                        normaltemp.append(" moves: [")
							                        if attached keyval.item (edata.spawn_row) as t then
														 normaltemp.append (t.to_string_8)
													 end
													     normaltemp.append (",")
													if attached (edata.spawn_col) as t1 then
														 normaltemp.append (t1.out+"] -> ")
													end
							                        if edata.spawn_col-edata.seenenemymove > 0 or hasfighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove) then
							                        	normaltemp.append ("[")
														if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col-edata.seenenemymove) as t3 then
														     normaltemp.append (t3.out+"]")
														end
													else
														normaltemp.append ("out of board")
														edata.health := 0
													    --edata.dead := true
							                        end
							                    end
							                    premprint[ine].normal.extend (normaltemp)
					                            --premprint.put_i_th([premprint[ine].prem,premprint[ine].normal],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove,ine,"normalaction")
					                            te := enemycollideprojf(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove,edata.health,ine,"normal") -- check collide
					                            if te and edata.health >= 0 then
					                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
					                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol) -- _ at starfighter proj
					                              end
					                            end
					                            if edata.health > 0 then

						                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove,ine,"normal")  -- check collide
						                            if te and in_game = false then
						                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
						                            end
						                        end

							                    if ((edata.spawn_col-edata.seenenemymove)> 0) and edata.health > 0  then
							                    	if array[edata.spawn_row,edata.spawn_col-edata.seenenemymove] /~ "?"  then -- for fog of war
							         	   	 	       array.put ("P", edata.spawn_row, edata.spawn_col-edata.seenenemymove)
							         	   	 	    end
							                    end
					                                if edata.health > 0 then
									         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"P","<",edata.spawn_row,edata.spawn_col-edata.seenenemymove,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
									         	   	 	if edata.spawn_col-1 > 0 and (not enemyatspawnproje(edata.spawn_row,edata.spawn_col-1)) then
						               	      	          if array[ edata.spawn_row, edata.spawn_col-1] /~ "?"  then
								         	   	 		      array.put ("<", edata.spawn_row, edata.spawn_col-1)
								         	   	 		  end
								         	   	 		projloc.extend ([edata.spawn_row,edata.spawn_col-1,idp,"G",2,70,"s"])  -- must put number of damage ect
									         	   	 	end

									         	   	 	if edata.spawn_col-1 >= 0 then
									         	   	 		--normaltemp.append("%N")
									         	   	 		if edata.spawn_col-1 = 0 then
		                                                       normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location out of board.")
														       idp := idp - 1  -- after idp is assigned
									         	   	 		else
										         	   	 		normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location [")
											         	   	 	    if attached keyval.item (edata.spawn_row) as t then
																		 normaltemp.append (t.to_string_8)
																	end
																	     normaltemp.append (",")
																	if attached (edata.spawn_col-1) as t1 then
																		 normaltemp.append (t1.out+"].")
																	end
															   idp := idp - 1  -- after idp is assigned
														     end
		                                                   premprint[ine].normal.extend (normaltemp)
									         	   	 	end

									         	   	 	if enemyatspawnproje(edata.spawn_row,edata.spawn_col-1) then
									         	   	 		normaltemp := "      The projectile collides with "
									         	   	 		if enemydata[enemyatspawnprojenumber].sign ~ "G" then
									         	   	 			normaltemp.append ("Grunt(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "I" then
									         	   	 			normaltemp.append ("Interceptor(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "F" then
									         	   	 			normaltemp.append ("Fighter(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "P" then
									         	   	 			normaltemp.append ("Pylon(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		end
									         	   	 		if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], healing 70 damage.")
															end
															premprint[ine].normal.extend (normaltemp)
															if enemydata[enemyatspawnprojenumber].health + 70 <= enemydata[enemyatspawnprojenumber].tolhealth then
																enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].health + 70
															else
																enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].tolhealth
															end
									         	   	 	end

									         	   	 	if fighteratspawnproje(edata.spawn_row,edata.spawn_col-1,ine,"normal") then

	                                                    projloc.go_i_th (projloc.count)
	                                                    projloc.remove
									         	   	 	end

									         	   	 	testspawnproj := projfatspawnproj(edata.spawn_row,edata.spawn_col-1,ine)
		                                                if testspawnproj ~ "epd" or testspawnproj ~ "fpd" then
		                                                	        normaltemp := "      The projectile collides with friendly projectile(id:"+projfatspawnprojid.out+") at location ["
		                                                            if attached keyval.item (edata.spawn_row) as t then
																        normaltemp.append (t.to_string_8)
																	end
																		normaltemp.append (",")
																	if attached (edata.spawn_col-1) as t1 then
																		normaltemp.append (t1.out+"], negating damage.")
																	end
																	premprint[ine].normal.extend (normaltemp)

																	if testspawnproj ~ "epd" then
																		if array[edata.spawn_row, edata.spawn_col-1] /~ "?" then
																		  array.put ("*", edata.spawn_row, edata.spawn_col-1)
																		end
																		projloc.go_i_th (projloc.count)
																		projloc.remove
																	end
		                                                end

									         	   	 	if projeatspawnproj(edata.spawn_row,edata.spawn_col-1,ine) then
                                                            normaltemp := "      The projectile collides with enemy projectile(id:"+projeatspawnprojid.out+") at location ["
                                                            if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], combining damage.")
															end
															premprint[ine].normal.extend (normaltemp)
									         	   	 	end

									         	    end
									        elseif projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.seenenemymove) then  -- if collided enenmy enemy
									         	    normaltemp := "    A Pylon(id:"+edata.id.out+")"
									         	if edata.spawn_row = edata.spawn_row and edata.spawn_col = projenemycollidecol + 1 then
					                     	           normaltemp.append (" stays at: [")
					                     	           if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t3 then
														     normaltemp.append (t3.out+"]")
														end
			                     	            else
										         	    normaltemp.append(" moves: [")
								                        if attached keyval.item (edata.spawn_row) as t then
															 normaltemp.append (t.to_string_8)
														 end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t1 then
															 normaltemp.append (t1.out+"] -> ")
														end
								                        if projenemycollidecol + 1 > 0 or hasfighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1) then
								                        	normaltemp.append ("[")
															if attached keyval.item (edata.spawn_row) as t2 then
																 normaltemp.append (t2.to_string_8)
															end
															     normaltemp.append (",")
															if attached (projenemycollidecol + 1) as t3 then
															     normaltemp.append (t3.out+"]")
															end
														else
															normaltemp.append ("out of board")
															edata.health := 0
														    --edata.dead := true
								                        end
								                end
							                    premprint[ine].normal.extend (normaltemp)
					                            --premprint.put_i_th([premprint[ine].prem,premprint[ine].normal],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normalaction")
					                            te := enemycollideprojf(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,edata.health,ine,"normal") -- check collide
					                            if te and edata.health >= 0 then
					                               if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
					                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol) -- _ at starfighter proj
					                               end
					                            end
					                            if edata.health > 0 then

						                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normal")  -- check collide
						                            if te and in_game = false then
						                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
						                            end
						                        end

							                    if ((projenemycollidecol + 1)> 0) and edata.health > 0  then
							                    	if array[edata.spawn_row,projenemycollidecol + 1] /~ "?"  then -- for fog of war
							         	   	 	       array.put ("P", edata.spawn_row, projenemycollidecol + 1)
							         	   	 	    end
							                    end
					                                if edata.health > 0  then
									         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"P","<",edata.spawn_row,projenemycollidecol + 1,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
									         	   	 	if edata.spawn_col-1 > 0 and (not enemyatspawnproje(edata.spawn_row,edata.spawn_col-1)) then
						               	      	          if array[ edata.spawn_row, edata.spawn_col-1] /~ "?"  then
								         	   	 		      array.put ("<", edata.spawn_row, edata.spawn_col-1)
								         	   	 		  end
								         	   	 		projloc.extend ([edata.spawn_row,edata.spawn_col-1,idp,"G",2,70,"s"])  -- must put number of damage ect
									         	   	 	end

									         	   	 	if edata.spawn_col-1 >= 0 then
									         	   	 		--normaltemp.append("%N")
									         	   	 		if edata.spawn_col-1 = 0 then
		                                                       normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location out of board.")
														       idp := idp - 1  -- after idp is assigned
									         	   	 		else
										         	   	 		normaltemp := ("      A enemy projectile(id:"+idp.out+") spawns at location [")
											         	   	 	    if attached keyval.item (edata.spawn_row) as t then
																		 normaltemp.append (t.to_string_8)
																	end
																	     normaltemp.append (",")
																	if attached (edata.spawn_col-1) as t1 then
																		 normaltemp.append (t1.out+"].")
																	end
															   idp := idp - 1  -- after idp is assigned
														     end
		                                                   premprint[ine].normal.extend (normaltemp)
									         	   	 	end

									         	   	 	if enemyatspawnproje(edata.spawn_row,edata.spawn_col-1) then
									         	   	 		normaltemp := "      The projectile collides with "
									         	   	 		if enemydata[enemyatspawnprojenumber].sign ~ "G" then
									         	   	 			normaltemp.append ("Grunt(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "I" then
									         	   	 			normaltemp.append ("Interceptor(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "F" then
									         	   	 			normaltemp.append ("Fighter(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "P" then
									         	   	 			normaltemp.append ("Pylon(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
									         	   	 		end
									         	   	 		if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], healing 70 damage.")
															end
															premprint[ine].normal.extend (normaltemp)
															if enemydata[enemyatspawnprojenumber].health + 70 <= enemydata[enemyatspawnprojenumber].tolhealth then
																enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].health + 70
															else
																enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].tolhealth
															end
									         	   	 	end

									         	   	 	if fighteratspawnproje(edata.spawn_row,edata.spawn_col-1,ine,"normal") then

	                                                    projloc.go_i_th (projloc.count)
	                                                    projloc.remove
									         	   	 	end

									         	   	 	testspawnproj := projfatspawnproj(edata.spawn_row,edata.spawn_col-1,ine)
		                                                if testspawnproj ~ "epd" or testspawnproj ~ "fpd" then
		                                                	        normaltemp := "      The projectile collides with friendly projectile(id:"+projfatspawnprojid.out+") at location ["
		                                                            if attached keyval.item (edata.spawn_row) as t then
																        normaltemp.append (t.to_string_8)
																	end
																		normaltemp.append (",")
																	if attached (edata.spawn_col-1) as t1 then
																		normaltemp.append (t1.out+"], negating damage.")
																	end
																	premprint[ine].normal.extend (normaltemp)

																	if testspawnproj ~ "epd" then
																		if array[edata.spawn_row, edata.spawn_col-1] /~ "?" then
																		  array.put ("*", edata.spawn_row, edata.spawn_col-1)
																		end
																		projloc.go_i_th (projloc.count)
																		projloc.remove
																	end
		                                                end

									         	   	 	if projeatspawnproj(edata.spawn_row,edata.spawn_col-1,ine) then
                                                            normaltemp := "      The projectile collides with enemy projectile(id:"+projeatspawnprojid.out+") at location ["
                                                            if attached keyval.item (edata.spawn_row) as t then
														        normaltemp.append (t.to_string_8)
															end
																normaltemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																normaltemp.append (t1.out+"], combining damage.")
															end
															premprint[ine].normal.extend (normaltemp)
									         	   	 	end

									         	    end
									        end
                        	     elseif (not canseenby(edata.spawn_row,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,edata.vision))  then
                        	     	         if not projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove) then
							                    normaltemp := "    A Pylon(id:"+edata.id.out+")"
							                    if edata.spawn_row = edata.spawn_row and edata.spawn_col = edata.spawn_col-edata.notseenenemymove then
					                     	           normaltemp.append (" stays at: [")
					                     	           if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t3 then
														     normaltemp.append (t3.out+"]")
														end
			                     	            else
								                        normaltemp.append(" moves: [")
								                        if attached keyval.item (edata.spawn_row) as t then
															 normaltemp.append (t.to_string_8)
														 end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t1 then
															 normaltemp.append (t1.out+"] -> ")
														end
														if edata.spawn_col-edata.notseenenemymove > 0 or hasfighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove) then
															normaltemp.append("[")
															if attached keyval.item (edata.spawn_row) as t2 then
																 normaltemp.append (t2.to_string_8)
															end
															     normaltemp.append (",")
															if attached (edata.spawn_col-edata.notseenenemymove) as t3 then
															     normaltemp.append (t3.out+"]")
															end
														else
															normaltemp.append ("out of board")
															edata.health := 0
														    --edata.dead := true
														end
											    end
					                            premprint[ine].normal.extend (normaltemp)
					                            --premprint.put_i_th([premtempll,normaltempll],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove,ine,"normalaction")
					                            te := enemycollideprojf(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove,edata.health,ine,"normal") -- check collide
					                            if te and edata.health >= 0 then
					                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
					                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol)
					                              end
					                            end
					                            if edata.health > 0 then

						                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove,ine,"normal")  -- check collide
						                            if te and in_game = false then
						                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
						                            end
						                        end
							--         	   	 	array.put ("<", edata.spawn_row, edata.spawn_col-4)
							--         	   	 	enemydata.put_i_th ([100,1,1,5,0,15,15,0,4,4,0,2,4,enemyid,"G","<",edata.spawn_row,edata.spawn_col,edata.spawn_row,edata.spawn_col-4], in)
							                    if ((edata.spawn_col-edata.notseenenemymove) > 0) and edata.health > 0  then
							                      if array[edata.spawn_row, edata.spawn_col-edata.notseenenemymove] /~ "?"  then
							                    	array.put ("P", edata.spawn_row, edata.spawn_col-edata.notseenenemymove)
							                      end
							                    end
					                                 if edata.health > 0  then
									         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"P","<",edata.spawn_row, edata.spawn_col-edata.notseenenemymove,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
                                                        -- increse others and itself 10 health if < tolhealth within the vision
                                                        incvisionhealth(edata.spawn_row,edata.spawn_col,ine)
									         	   	 end
									        elseif projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-edata.notseenenemymove) then
									        	    normaltemp := "    A Pylon(id:"+edata.id.out+")"
									        	if edata.spawn_row = edata.spawn_row and edata.spawn_col = projenemycollidecol + 1 then
					                     	           normaltemp.append (" stays at: [")
					                     	           if attached keyval.item (edata.spawn_row) as t2 then
															 normaltemp.append (t2.to_string_8)
														end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t3 then
														     normaltemp.append (t3.out+"]")
														end
			                     	            else
										        	    normaltemp.append(" moves: [")
								                        if attached keyval.item (edata.spawn_row) as t then
															 normaltemp.append (t.to_string_8)
														 end
														     normaltemp.append (",")
														if attached (edata.spawn_col) as t1 then
															 normaltemp.append (t1.out+"] -> ")
														end
														if projenemycollidecol + 1 > 0 or hasfighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1) then
															normaltemp.append("[")
															if attached keyval.item (edata.spawn_row) as t2 then
																 normaltemp.append (t2.to_string_8)
															end
															     normaltemp.append (",")
															if attached (projenemycollidecol + 1) as t3 then
															     normaltemp.append (t3.out+"]")
															end
														else
															normaltemp.append ("out of board")
															edata.health := 0
														    --edata.dead := true
														end
											    end
					                            premprint[ine].normal.extend (normaltemp)
					                            --premprint.put_i_th([premtempll,normaltempll],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normalaction")
					                            te := enemycollideprojf(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,edata.health,ine,"normal") -- check collide
					                            if te and edata.health >= 0 then
					                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
					                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol)
					                              end
					                            end
					                            if edata.health > 0 then

						                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"normal")  -- check collide
						                            if te and in_game = false then
						                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
						                            end
						                        end
							--         	   	 	array.put ("<", edata.spawn_row, edata.spawn_col-4)
							--         	   	 	enemydata.put_i_th ([100,1,1,5,0,15,15,0,4,4,0,2,4,enemyid,"G","<",edata.spawn_row,edata.spawn_col,edata.spawn_row,edata.spawn_col-4], in)
							                    if ((projenemycollidecol + 1) > 0) and edata.health > 0 then
							                      if array[edata.spawn_row, projenemycollidecol + 1] /~ "?"  then
							                    	array.put ("P", edata.spawn_row, projenemycollidecol + 1)
							                      end
							                    end
					                                 if edata.health > 0 then
									         	   	 	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"P","<",edata.spawn_row, projenemycollidecol + 1,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
                                                        incvisionhealth(edata.spawn_row,projenemycollidecol + 1,ine)
									         	   	 end
									        end
                        	     end
			         	end

					    ine := ine + 1
				    end
		         	end

--		         	from
--		         	  ine := 1
--		         	until
--		         	  ine > enemydata.count
--		         	loop
--		         	   if enemydata[ine].dead then
--                            if enemydata[ine].sign ~ "G" then
--	            	    	   score := score + 2
--	            	    	elseif enemydata[ine].sign ~ "F" then
--	            	    	   score := score + 3
--	            	    	elseif enemydata[ine].sign ~ "I" then
--	            	    		score := score + 1
--	            	        elseif enemydata[ine].sign ~ "C" then
--	            	    		score := score + 3
--	            	        elseif enemydata[ine].sign ~ "P" then
--	            	    		score := score + 1
--	            	    	end
--		         	   end
--		         	   ine := ine + 1
--		         	end

		         	from            -- remove if out of board , if health 0 then remove after/in updateallproj
		         	  ine := 1
		         	until
		         	  ine > enemydata.count
		         	loop
		         	    enemydata[ine].turn := true     -- make turn true at the end of command call/move of all enemy
		         		if enemydata[ine].spawn_col < 1 or enemydata[ine].dead or enemydata[ine].health <=0 then
		         			enemydata.go_i_th(ine)
				            enemydata.remove
				            ine := ine - 1
		         		end
		         		ine := ine + 1
		         	end

		         	-- vision update
		         	enemyfightervisionupdate
		    end
         end

      enemyput(efirstrow:INTEGER;espawncol:INTEGER;sign:STRING;id:INTEGER)   -- first 2 spawn are at 1,c
         local
         	deadenemy :BOOLEAN
         do
         	--updateenemy
         	--if enemydata.count = 1 then -- called 1 as pass will just move the existing enemy

         	   if in_game = true then
--         	     if array[ efirstrow, col] /~ "?"  then
--         	       array.put (sign, efirstrow, col)
--         	     end
	         	   if sign ~ "G" then
	         	   	  enemyspawn := "    A Grunt(id:"+id.out+") spawns at location ["
	         	   	        if attached keyval.item (efirstrow) as t then
								 enemyspawn.append (t.to_string_8)
							end
							     enemyspawn.append (",")

								 enemyspawn.append (col.out+"].")

                       deadenemy := projfatenemyspawn(efirstrow,col)
                       if in_game = true and deadenemy = false then
                       	   fighteratenemyspawn(efirstrow,col)
                       end
					   if array[ efirstrow, col] /~ "?" and deadenemy = false and in_game = true  then
         	               array.put (sign, efirstrow, col)
         	           end


				   elseif sign ~ "I" then
				   	  enemyspawn := "    A Interceptor(id:"+id.out+") spawns at location ["
	         	   	        if attached keyval.item (efirstrow) as t then
								 enemyspawn.append (t.to_string_8)
							end
							     enemyspawn.append (",")

								 enemyspawn.append (col.out+"].")

					      deadenemy := projfatenemyspawn(efirstrow,col)
                          if in_game = true and deadenemy = false then
                       	     fighteratenemyspawn(efirstrow,col)
                          end

					      if array[ efirstrow, col] /~ "?" and deadenemy = false and in_game = true then
         	                array.put (sign, efirstrow, col)
         	              end
				    elseif sign ~ "F" then
				  	  enemyspawn := "    A Fighter(id:"+id.out+") spawns at location ["
	         	   	        if attached keyval.item (efirstrow) as t then
								 enemyspawn.append (t.to_string_8)
							end
							     enemyspawn.append (",")

								 enemyspawn.append (col.out+"].")

                            deadenemy := projfatenemyspawn(efirstrow,col)
                            if in_game = true and deadenemy = false then
                       	       fighteratenemyspawn(efirstrow,col)
                            end

					        if array[ efirstrow, col] /~ "?" and deadenemy = false and in_game = true then
         	                    array.put (sign, efirstrow, col)
         	                end
				   elseif sign ~ "C" then
				 	  enemyspawn := "    A Carrier(id:"+id.out+") spawns at location ["
	         	   	        if attached keyval.item (efirstrow) as t then
								 enemyspawn.append (t.to_string_8)
							end
							     enemyspawn.append (",")

								 enemyspawn.append (col.out+"].")

						    deadenemy := projfatenemyspawn(efirstrow,col)
                            if in_game = true and deadenemy = false then
                       	       fighteratenemyspawn(efirstrow,col)
                            end

						    if array[ efirstrow, col] /~ "?" and deadenemy = false and in_game = true then
         	                   array.put (sign, efirstrow, col)
         	                end
				   elseif sign ~ "P" then
					 enemyspawn := "    A Pylon(id:"+id.out+") spawns at location ["
	         	   	        if attached keyval.item (efirstrow) as t then
								 enemyspawn.append (t.to_string_8)
							end
							     enemyspawn.append (",")

								 enemyspawn.append (col.out+"].")

							deadenemy := projfatenemyspawn(efirstrow,col)
                            if in_game = true and deadenemy = false then
                       	        fighteratenemyspawn(efirstrow,col)
                            end
					        if array[ efirstrow, col] /~ "?" and deadenemy = false and in_game = true then
         	                   array.put (sign, efirstrow, col)
         	                end

	         	   end
         	   end
         end

         premactions(prem:STRING)
           local
           	 ine : INTEGER
           	 normaltemp , premtemp,testspawnproj : STRING
           	 normaltempll,premtempll : LINKED_LIST[STRING]
             te,seenbyfighter,canseefighter : BOOLEAN
           do
           	  ine := 1
              across
              	enemydata is edata
              loop
                 normaltemp := ""
			     premtemp := ""
			     testspawnproj := ""
			     seenbyfighter := false
			     canseefighter := false
			     create normaltempll.make   -- remove these 3
			     create premtempll.make
			     premprint.extend([premtempll,normaltempll])

                 if edata.sign ~ "G" and edata.dead = false and in_game = true then

                 	if prem ~ "pass" then
			         	 premtemp := "    A Grunt(id:"+edata.id.out+") gains 10 total health."
			         	 premtempll.extend(premtemp)
			         	 normaltempll.extend ("")
			         	 premprint.put_i_th([premtempll,normaltempll],ine)
			         	 enemydata.put_i_th ([edata.health+10,edata.tolhealth+10,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"G","<",edata.spawn_row,edata.spawn_col,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
			       elseif prem ~ "specialmove" or prem ~ "special" or prem ~ "specialhealth" or prem ~ "specialenergy" then
			         	 premtemp := "    A Grunt(id:"+edata.id.out+") gains 20 total health."
			         	 premtempll.extend(premtemp)
			         	 normaltempll.extend ("")
			             premprint.put_i_th([premtempll,normaltempll],ine)
			             enemydata.put_i_th ([edata.health+20,edata.tolhealth+20,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"G","<",edata.spawn_row,edata.spawn_col,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
			       end

                 elseif edata.sign ~ "I" and edata.dead = false and in_game = true   then
                 	    --array.put ("_", edata.spawn_row,edata.spawn_col )
                 	    if hasenemyin(edata.spawn_row,edata.spawn_col,shiploc.last.trow,edata.spawn_col) and (prem ~ "fire") then
                 	      if array[ edata.spawn_row,edata.spawn_col] /~ "?"  then
                 	    	array.put ("_", edata.spawn_row,edata.spawn_col )
                 	      end
			                     	if edata.spawn_row > shiploc.last.trow then  -- to put I beside the enemy
			                     	    premtemp := "    A Interceptor(id:"+edata.id.out+")"
			                     	    if edata.spawn_row = collide_enemyloc.colr+1 and edata.spawn_col = edata.spawn_col then
			                     	           premtemp.append (" stays at: [")
			                     	           if attached keyval.item (edata.spawn_row) as t2 then
													 premtemp.append (t2.to_string_8)
												end
												     premtemp.append (",")
												if attached (edata.spawn_col) as t3 then
												     premtemp.append (t3.out+"]")
												end
			                     	    else
			                     	    	    premtemp.append (" moves: [")
						                        if attached keyval.item (edata.spawn_row) as t then
													 premtemp.append (t.to_string_8)
												 end
												     premtemp.append (",")
												if attached (edata.spawn_col) as t1 then
													 premtemp.append (t1.out+"] -> [")
												end
												if attached keyval.item (collide_enemyloc.colr+1) as t2 then
													 premtemp.append (t2.to_string_8)
												end
												     premtemp.append (",")
												if attached (edata.spawn_col) as t3 then
												     premtemp.append (t3.out+"]")
												end
			                     	    end

										premtempll.extend (premtemp)
										normaltempll.extend (normaltemp)
				                        premprint.put_i_th([premtempll,normaltempll],ine)

				                        verticlecollideprojf(edata.spawn_row,edata.spawn_col,collide_enemyloc.colr+1,ine)    -- this ***

				                        if edata.dead = false then
				                          if array[ collide_enemyloc.colr+1,edata.spawn_col] /~ "?"  then
			                     		    array.put ("I", collide_enemyloc.colr+1,edata.spawn_col)
			                     		  end
			                     		--seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,collide_enemyloc.colr+1,edata.spawn_col,tolvision)
			         	                --canseefighter := canseenby(collide_enemyloc.colr+1,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,edata.vision)
			                     		enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"I","<",collide_enemyloc.colr+1,edata.spawn_col,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
                                        end
			                        else
			                            premtemp := "    A Interceptor(id:"+edata.id.out+")"

			                            if edata.spawn_row = collide_enemyloc.colr-1 and edata.spawn_col = edata.spawn_col then
			                     	           premtemp.append (" stays at: [")
			                     	           if attached keyval.item (edata.spawn_row) as t2 then
													 premtemp.append (t2.to_string_8)
												end
												     premtemp.append (",")
												if attached (edata.spawn_col) as t3 then
												     premtemp.append (t3.out+"]")
												end
			                     	    else
					                            premtemp.append(" moves: [")
						                        if attached keyval.item (edata.spawn_row) as t then
													 premtemp.append (t.to_string_8)
												 end
												     premtemp.append (",")
												if attached (edata.spawn_col) as t1 then
													 premtemp.append (t1.out+"] -> [")
												end
												if attached keyval.item (collide_enemyloc.colr-1) as t2 then
													 premtemp.append (t2.to_string_8)
												end
												     premtemp.append (",")
												if attached (edata.spawn_col) as t3 then
												     premtemp.append (t3.out+"]")
												end
									    end
										premtempll.extend (premtemp)
										normaltempll.extend (normaltemp)
				                        premprint.put_i_th([premtempll,normaltempll],ine)

				                        verticlecollideprojf(edata.spawn_row,edata.spawn_col,collide_enemyloc.colr-1,ine)
				                        if edata.dead = false then
				                          if array[ collide_enemyloc.colr-1,edata.spawn_col] /~ "?"  then
			                        	   array.put ("I", collide_enemyloc.colr-1,edata.spawn_col)
			                        	  end
			                        	--seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,collide_enemyloc.colr-1,edata.spawn_col,tolvision)
			         	                --canseefighter := canseenby(collide_enemyloc.colr-1,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,edata.vision)
			                        	enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"I","<",collide_enemyloc.colr-1,edata.spawn_col,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
                                        end
			                     	end
			             elseif (not hasenemyin(edata.spawn_row,edata.spawn_col,shiploc.last.trow,edata.spawn_col)) and (prem ~ "fire") then

                               if array[ edata.spawn_row,edata.spawn_col] /~ "?"  then
                 	    	       array.put ("_", edata.spawn_row,edata.spawn_col )
                 	           end
			                            premtemp := "    A Interceptor(id:"+edata.id.out+")"
			                            if edata.spawn_row = shiploc.last.trow and edata.spawn_col = edata.spawn_col then
			                     	           premtemp.append (" stays at: [")
			                     	           if attached keyval.item (edata.spawn_row) as t2 then
													 premtemp.append (t2.to_string_8)
												end
												     premtemp.append (",")
												if attached (edata.spawn_col) as t3 then
												     premtemp.append (t3.out+"]")
												end
			                     	    else
					                            premtemp.append(" moves: [")
						                        if attached keyval.item (edata.spawn_row) as t then
													 premtemp.append (t.to_string_8)
												 end
												     premtemp.append (",")
												if attached (edata.spawn_col) as t1 then
													 premtemp.append (t1.out+"] -> [")
												end
												if attached keyval.item (shiploc.last.trow) as t2 then
													 premtemp.append (t2.to_string_8)
												end
												     premtemp.append (",")
												if attached (edata.spawn_col) as t3 then
												     premtemp.append (t3.out+"]")
												end
									    end
										premtempll.extend (premtemp)
										normaltempll.extend (normaltemp)
				                        premprint.put_i_th([premtempll,normaltempll],ine)

				                        verticlecollideprojf(edata.spawn_row,edata.spawn_col,shiploc.last.trow,ine)

				                        if edata.dead = false then
				                        	verticlecollidefighter(edata.spawn_row,edata.spawn_col,ine)
				                        end

				                       if edata.dead = false then
				                         if array[ shiploc.last.trow,edata.spawn_col] /~ "?"  then
			                     	      array.put ("I", shiploc.last.trow,edata.spawn_col)     -- if no one in between direct and only row change
			                     	     end
			                     	   --seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,shiploc.last.trow,edata.spawn_col,tolvision)
			         	               --canseefighter := canseenby(shiploc.last.trow,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,edata.vision)
			                     	   enemydata.put_i_th ([edata.health,edata.tolhealth,edata.regen,edata.armour,edata.vision,edata.preemprojdamage,edata.notseenprojdamage,edata.seenprojdamage,edata.preemprojmove,edata.notseenprojmove,edata.seenprojmove,edata.preemenemymove,edata.notseenenemymove,edata.seenenemymove,edata.id,"I","<",shiploc.last.trow,edata.spawn_col,edata.canseefighter,edata.seenbyfighter,edata.dead,edata.turn], ine)
			                           end
			             end

                 elseif edata.sign ~ "F" and edata.dead = false and in_game = true  then
                             if array[ edata.spawn_row,edata.spawn_col] /~ "?"  then
                                array.put ("_", edata.spawn_row,edata.spawn_col )
                             end
			               	      if prem ~ "pass" then
			               	      	  if projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-6) then   --projenemycollide used for enemy-enemycollide
			               	      	  	 premtemp := "    A Fighter(id:"+edata.id.out+")"
			               	      	  	 if edata.spawn_row = edata.spawn_row and edata.spawn_col = projenemycollidecol + 1 then
			                     	           premtemp.append (" stays at: [")
			                     	           if attached keyval.item (edata.spawn_row) as t2 then
													 premtemp.append (t2.to_string_8)
												end
												     premtemp.append (",")
												if attached (edata.spawn_col) as t3 then
												     premtemp.append (t3.out+"]")
												end
			                     	     else
					               	      	  	 premtemp.append(" moves: [")
							                        if attached keyval.item (edata.spawn_row) as t then
														 premtemp.append (t.to_string_8)
													 end
													     premtemp.append (",")
													if attached (edata.spawn_col) as t1 then
														 premtemp.append (t1.out+"] -> ")
													end
													if projenemycollidecol + 1 > 0 or hasfighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1) then
														premtemp.append("[")
														if attached keyval.item (edata.spawn_row) as t2 then
															 premtemp.append (t2.to_string_8)
														end
														     premtemp.append (",")
														if attached (projenemycollidecol + 1) as t3 then
														     premtemp.append (t3.out+"]")
														end
													else
														premtemp.append ("out of board")
														edata.health := 0
														--edata.dead := true
													end
                                          end
										    normaltempll.extend ("")
										    premtempll.extend (premtemp)
					                        premprint.put_i_th([premtempll,normaltempll],ine)

enemycollideproje(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"premaction")
					                        te := enemycollideprojf(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,edata.health,ine,"prem") -- check collide, projenemycollidecol + 1 is final col
				                            if te and edata.health >= 0  then
				                              if array[  enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
				                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol) -- _ at starfighter proj
				                              end
				                            end
				                            if edata.health > 0 then

					                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"prem")  -- check collide
					                            if te and in_game = false then
					                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
					                            end
                                            end
					                        if ((projenemycollidecol + 1) > 0) and (edata.health > 0 ) then
			                    	            if array[edata.spawn_row,projenemycollidecol + 1] /~ "?"  then -- for fog of war
			         	   	 	                     array.put ("F", edata.spawn_row, projenemycollidecol + 1)
			         	   	 	                end
			                                end

                                            if (edata.health > 0 ) then
				               	      	        edata.spawn_col := projenemycollidecol + 1 -- 1 col to right
				               	      	        if edata.spawn_col-1 > 0 and (not enemyatspawnproje(edata.spawn_row,edata.spawn_col-1)) then
				               	      	          if array[ edata.spawn_row, edata.spawn_col-1] /~ "?"  then
						         	   	 		      array.put ("<", edata.spawn_row, edata.spawn_col-1)
						         	   	 		  end
						         	   	 		projloc.extend ([edata.spawn_row,edata.spawn_col-1,idp,"G",10,100,"s"])  -- must put number of damage ect
							         	   	 	end

							         	   	 	if edata.spawn_col-1 >= 0 then
							         	   	 		--normaltemp.append("%N")
							         	   	 		if edata.spawn_col-1 = 0 then
                                                       premtemp := ("      A enemy projectile(id:"+idp.out+") spawns at location out of board.")
												       idp := idp - 1  -- after idp is assigned
							         	   	 		else
								         	   	 		premtemp := ("      A enemy projectile(id:"+idp.out+") spawns at location [")
									         	   	 	    if attached keyval.item (edata.spawn_row) as t then
																 premtemp.append (t.to_string_8)
															end
															     premtemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																 premtemp.append (t1.out+"].")
															end
													    idp := idp - 1  -- after idp is assigned
												     end
												   premtempll.extend (premtemp)
							         	   	 	end
							         	   	 	premprint.put_i_th([premtempll,normaltempll],ine)

							         	   	 	if enemyatspawnproje(edata.spawn_row,edata.spawn_col-1) then
							         	   	 		premtemp := "      The projectile collides with "
							         	   	 		if enemydata[enemyatspawnprojenumber].sign ~ "G" then
							         	   	 			premtemp.append ("Grunt(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "I" then
							         	   	 			premtemp.append ("Interceptor(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "F" then
							         	   	 			premtemp.append ("Fighter(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "P" then
							         	   	 			premtemp.append ("Pylon(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		end
							         	   	 		if attached keyval.item (edata.spawn_row) as t then
												        premtemp.append (t.to_string_8)
													end
														premtemp.append (",")
													if attached (edata.spawn_col-1) as t1 then
														premtemp.append (t1.out+"], healing 100 damage.")
													end
													premtempll.extend (premtemp)
													premprint.put_i_th([premtempll,normaltempll],ine)
													if enemydata[enemyatspawnprojenumber].health + 100 <= enemydata[enemyatspawnprojenumber].tolhealth then
														enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].health + 100
													else
														enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].tolhealth
													end
							         	   	 	end

							         	   	 	        if fighteratspawnproje(edata.spawn_row,edata.spawn_col-1,ine,"prem") then

		                                                    projloc.go_i_th (projloc.count)
		                                                    projloc.remove
									         	   	 	end

									         	   	 	testspawnproj := projfatspawnproj(edata.spawn_row,edata.spawn_col-1,ine)
		                                                if testspawnproj ~ "epd" or testspawnproj ~ "fpd" then
		                                                	        premtemp := "      The projectile collides with friendly projectile(id:"+projfatspawnprojid.out+") at location ["
		                                                            if attached keyval.item (edata.spawn_row) as t then
																        premtemp.append (t.to_string_8)
																	end
																		premtemp.append (",")
																	if attached (edata.spawn_col-1) as t1 then
																		premtemp.append (t1.out+"], negating damage.")
																	end
																	premtempll.extend (premtemp)
												                    premprint.put_i_th([premtempll,normaltempll],ine)

																	if testspawnproj ~ "epd" then
																		if array[edata.spawn_row, edata.spawn_col-1] /~ "?" then
																		  array.put ("*", edata.spawn_row, edata.spawn_col-1)
																		end
																		projloc.go_i_th (projloc.count)
																		projloc.remove
																	end
		                                                end

							         	   	 	if projeatspawnproj(edata.spawn_row,edata.spawn_col-1,ine) then
                                                            premtemp := "      The projectile collides with enemy projectile(id:"+projeatspawnprojid.out+") at location ["
                                                            if attached keyval.item (edata.spawn_row) as t then
														        premtemp.append (t.to_string_8)
															end
																premtemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																premtemp.append (t1.out+"], combining damage.")
															end
											          premtempll.extend (premtemp)
												      premprint.put_i_th([premtempll,normaltempll],ine)
									         	end

					         	   	 	    end
			               	      	  elseif not projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-6)  then
			               	      	  	 premtemp := "    A Fighter(id:"+edata.id.out+")"
			               	      	  	 if edata.spawn_row = edata.spawn_row and edata.spawn_col = edata.spawn_col - 6 then
			                     	           premtemp.append (" stays at: [")
			                     	           if attached keyval.item (edata.spawn_row) as t2 then
													 premtemp.append (t2.to_string_8)
												end
												     premtemp.append (",")
												if attached (edata.spawn_col) as t3 then
												     premtemp.append (t3.out+"]")
												end
			                     	     else
					               	      	  	 premtemp.append (" moves: [")
							                        if attached keyval.item (edata.spawn_row) as t then
														 premtemp.append (t.to_string_8)
													 end
													     premtemp.append (",")
													if attached (edata.spawn_col) as t1 then
														 premtemp.append (t1.out+"] -> ")
													end
													if edata.spawn_col - 6 > 0 or hasfighter(edata.spawn_row,edata.spawn_col,edata.spawn_col - 6) then
														premtemp.append("[")
														if attached keyval.item (edata.spawn_row) as t2 then
															 premtemp.append (t2.to_string_8)
														end
														     premtemp.append (",")
														if attached (edata.spawn_col - 6) as t3 then
														     premtemp.append (t3.out+"]")
														end
													else
														premtemp.append ("out of board")
														edata.health := 0
														--edata.dead := true
													end
										 end
										    normaltempll.extend ("")
										    premtempll.extend (premtemp)
					                        premprint.put_i_th([premtempll,normaltempll],ine)

enemycollideproje(edata.spawn_row,edata.spawn_col,edata.spawn_col - 6,ine,"premaction")
					                        te := enemycollideprojf(edata.spawn_row,edata.spawn_col,edata.spawn_col - 6,edata.health,ine,"prem") -- check collide
				                            if te and edata.health >= 0 then
				                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
				                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol) -- _ at starfighter proj
				                              end
				                            end
				                            if edata.health > 0 then

					                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,edata.spawn_col - 6,ine,"prem")  -- check collide
					                            if te and in_game = false then
					                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
					                            end
					                        end

					                        if ((edata.spawn_col - 6) > 0) and (edata.health > 0 ) then
			                    	            if array[edata.spawn_row,(edata.spawn_col - 6)] /~ "?"  then -- for fog of war
			         	   	 	                     array.put ("F", edata.spawn_row, edata.spawn_col - 6)
			         	   	 	                end
			                                end

			                              if (edata.health > 0 ) then

			                                edata.spawn_col := edata.spawn_col - 6  -- move
			               	      	  	        if edata.spawn_col-1 > 0 and (not enemyatspawnproje(edata.spawn_row,edata.spawn_col-1)) then
			               	      	  	         if array[ edata.spawn_row, edata.spawn_col-1] /~ "?"  then
						         	   	 		   array.put ("<", edata.spawn_row, edata.spawn_col-1)
						         	   	 		 end
						         	   	 		projloc.extend ([edata.spawn_row,edata.spawn_col-1,idp,"G",10,100,"s"])  -- must put number of damage ect
							         	   	 	end

							         	   	 	if edata.spawn_col-1 >= 0 then
							         	   	 		--normaltemp.append("%N")
							         	   	 		if edata.spawn_col-1 = 0 then
                                                       premtemp := ("      A enemy projectile(id:"+idp.out+") spawns at location out of board.")
												       idp := idp - 1  -- after idp is assigned
							         	   	 		else
								         	   	 		premtemp := ("      A enemy projectile(id:"+idp.out+") spawns at location [")
									         	   	 	    if attached keyval.item (edata.spawn_row) as t then
																 premtemp.append (t.to_string_8)
															end
															     premtemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																 premtemp.append (t1.out+"].")
															end
													   idp := idp - 1  -- after idp is assigned
												   end
												   premtempll.extend (premtemp)
							         	   	 	end
							         	   	 	premprint.put_i_th([premtempll,normaltempll],ine)

							         	   	 	if enemyatspawnproje(edata.spawn_row,edata.spawn_col-1) then  -- if at spawn
							         	   	 		premtemp := "      The projectile collides with "
							         	   	 		if enemydata[enemyatspawnprojenumber].sign ~ "G" then
							         	   	 			premtemp.append ("Grunt(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "I" then
							         	   	 			premtemp.append ("Interceptor(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		elseif enemydata[enemyatspawnprojenumber].sign ~ "F" then
							         	   	 			premtemp.append ("Fighter(id:"+enemydata[enemyatspawnprojenumber].id.out+") at location [")
							         	   	 		end
							         	   	 		if attached keyval.item (edata.spawn_row) as t then
												        premtemp.append (t.to_string_8)
													end
														premtemp.append (",")
													if attached (edata.spawn_col-1) as t1 then
														premtemp.append (t1.out+"], healing 100 damage.")
													end
													premtempll.extend (premtemp)
													premprint.put_i_th([premtempll,normaltempll],ine)

													if enemydata[enemyatspawnprojenumber].health + 100 <= enemydata[enemyatspawnprojenumber].tolhealth then
														enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].health + 100
													else
														enemydata[enemyatspawnprojenumber].health := enemydata[enemyatspawnprojenumber].tolhealth
													end

							         	   	 	end

							         	   	 	       if fighteratspawnproje(edata.spawn_row,edata.spawn_col-1,ine,"prem") then

		                                                    projloc.go_i_th (projloc.count)
		                                                    projloc.remove
									         	   	 	end

									         	   	 	testspawnproj := projfatspawnproj(edata.spawn_row,edata.spawn_col-1,ine)
		                                                if testspawnproj ~ "epd" or testspawnproj ~ "fpd" then
		                                                	        premtemp := "      The projectile collides with friendly projectile(id:"+projfatspawnprojid.out+") at location ["
		                                                            if attached keyval.item (edata.spawn_row) as t then
																        premtemp.append (t.to_string_8)
																	end
																		premtemp.append (",")
																	if attached (edata.spawn_col-1) as t1 then
																		premtemp.append (t1.out+"], negating damage.")
																	end
																	premtempll.extend (premtemp)
												                    premprint.put_i_th([premtempll,normaltempll],ine)

																	if testspawnproj ~ "epd" then
																		if array[edata.spawn_row, edata.spawn_col-1] /~ "?" then
																		  array.put ("*", edata.spawn_row, edata.spawn_col-1)
																		end
																		projloc.go_i_th (projloc.count)
																		projloc.remove
																	end
		                                                end

							         	   	 	if projeatspawnproj(edata.spawn_row,edata.spawn_col-1,ine) then
                                                            premtemp := "      The projectile collides with enemy projectile(id:"+projeatspawnprojid.out+") at location ["
                                                            if attached keyval.item (edata.spawn_row) as t then
														        premtemp.append (t.to_string_8)
															end
																premtemp.append (",")
															if attached (edata.spawn_col-1) as t1 then
																premtemp.append (t1.out+"], combining damage.")
															end
															premtempll.extend (premtemp)
															premprint.put_i_th([premtempll,normaltempll],ine)
									         	end
							         	  end
			               	      	  end

			               	      else
			               	      	  if prem ~ "fire" then
			               	      	     edata.armour := edata.armour + 1
			               	      	     premtemp := "    A Fighter(id:"+edata.id.out+") gains 1 armour."
			               	      	     premtempll.extend (premtemp)
										 premprint.put_i_th([premtempll,normaltempll],ine)
			               	      	  end

			               	      end
			     elseif edata.sign ~ "C" and edata.dead = false and in_game = true  then
			     	    if prem ~ "pass" then
                              if projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-2) then     -- projenemycollide used to check if any enemy is way
                                     premtemp := "    A Carrier(id:"+edata.id.out+")"
                                             if edata.spawn_row = edata.spawn_row and edata.spawn_col = projenemycollidecol + 1 then
			                     	           premtemp.append (" stays at: [")
			                     	           if attached keyval.item (edata.spawn_row) as t2 then
													 premtemp.append (t2.to_string_8)
												end
												     premtemp.append (",")
												if attached (edata.spawn_col) as t3 then
												     premtemp.append (t3.out+"]")
												end
			                     	         else
		                                            premtemp.append (" moves: [")
							                        if attached keyval.item (edata.spawn_row) as t then
														 premtemp.append (t.to_string_8)
													 end
													     premtemp.append (",")
													if attached (edata.spawn_col) as t1 then
														 premtemp.append (t1.out+"] -> ")
													end
													if projenemycollidecol + 1 > 0 or hasfighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1) then
														premtemp.append("[")
														if attached keyval.item (edata.spawn_row) as t2 then
															 premtemp.append (t2.to_string_8)
														end
														     premtemp.append (",")
														if attached (projenemycollidecol + 1) as t3 then
														     premtemp.append (t3.out+"]")
														end
													else
														premtemp.append ("out of board")
														edata.health := 0
														--edata.dead := true
													end
                                            end
										    normaltempll.extend ("")
										    premtempll.extend (premtemp)
					                        premprint.put_i_th([premtempll,normaltempll],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"premaction")
					                        te := enemycollideprojf(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,edata.health,ine,"prem") -- check collide
				                            if te and edata.health >= 0 then
				                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
				                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol) -- _ at starfighter proj
				                              end
				                            end
				                            if edata.health > 0 then

					                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,projenemycollidecol + 1,ine,"prem")  -- check collide
					                            if te and in_game = false then
					                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
					                            end
                                            end
					                        if ((projenemycollidecol + 1) > 0) and (edata.health > 0 ) then
			                    	            if array[edata.spawn_row,projenemycollidecol + 1] /~ "?"  then -- for fog of war
			         	   	 	                     array.put ("C", edata.spawn_row, projenemycollidecol + 1)
			         	   	 	                end
			                                end

			                                if (edata.health > 0 ) then
			                                	edata.spawn_col := projenemycollidecol + 1 -- 1 col to right
			                                	    if (not enemyatspawnproje(edata.spawn_row-1,edata.spawn_col)) then
					                                	if (edata.spawn_row-1) > 0  then  -- change thisssss col to collidecol
					                                		-- spawn I at top
					                                		seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,edata.spawn_row-1,edata.spawn_col,tolvision)
											         	   	canseefighter := canseenby(edata.spawn_row-1,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,5)
											             	enemydata.extend ([50,50,0,0,5,0,0,0,0,0,0,0,3,3,enemyid,"I","<",edata.spawn_row-1,edata.spawn_col,canseefighter,seenbyfighter,false,true])
                                                            if array[ edata.spawn_row-1, edata.spawn_col] /~ "?"  then
                                                               array.put ("I", edata.spawn_row-1, edata.spawn_col)
                                                            end
                                                            enemydata[enemydata.count].turn := false  -- dont use .last as cursor is not upgrading
					                                    end

					                                    premtemp := ("      A Interceptor(id:"+enemyid.out+") spawns at location [")
										         	   	 		if (edata.spawn_row-1) > 0  then
											         	   	 	    if attached keyval.item (edata.spawn_row-1) as t then
																		 premtemp.append (t.to_string_8)
																	end
																	     premtemp.append (",")
																	if attached (edata.spawn_col) as t1 then
																		 premtemp.append (t1.out+"].")
																	end
																else
																	premtemp.append("out of board")
																end
															   premtempll.extend (premtemp)
										         	   	   premprint.put_i_th([premtempll,normaltempll],ine)
										         	       projatenemyspawn(edata.spawn_row-1,edata.spawn_col,ine)   -- proj at enemy spawn
										         	   enemyid := enemyid + 1
				                                    end

				                                    if (not enemyatspawnproje(edata.spawn_row+1,edata.spawn_col)) then
					                                    if edata.spawn_row+1 <= r  then
					                                		-- spawn I at bottom
					                                		seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,edata.spawn_row+1,edata.spawn_col,tolvision)
											         	   	canseefighter := canseenby(edata.spawn_row+1,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,5)
											             	enemydata.extend ([50,50,0,0,5,0,0,0,0,0,0,0,3,3,enemyid,"I","<",edata.spawn_row+1,edata.spawn_col,canseefighter,seenbyfighter,false,true])
                                                            if array[ edata.spawn_row+1, edata.spawn_col] /~ "?"  then
                                                                array.put ("I", edata.spawn_row+1, edata.spawn_col)
                                                            end
                                                            enemydata[enemydata.count].turn := false  -- dont use .last as cursor is not upgrading
					                                    end
					                                     premtemp := ("      A Interceptor(id:"+enemyid.out+") spawns at location [")
										         	   	 		if edata.spawn_row+1 <= r then
											         	   	 	    if attached keyval.item (edata.spawn_row+1) as t then
																		 premtemp.append (t.to_string_8)
																	end
																	     premtemp.append (",")
																	if attached (edata.spawn_col) as t1 then
																		 premtemp.append (t1.out+"].")
																	end
																else
																	premtemp.append("out of board")
																end
															   premtempll.extend (premtemp)
										         	   	   premprint.put_i_th([premtempll,normaltempll],ine)
										         	   	   projatenemyspawn(edata.spawn_row+1,edata.spawn_col,ine)
										         	   	 enemyid := enemyid + 1
					                                end
			                                end
                              elseif (not projenemycollide(edata.spawn_row,edata.spawn_col,edata.spawn_col-2)) then

                                            premtemp := "    A Carrier(id:"+edata.id.out+")"
                                             if edata.spawn_row = edata.spawn_row and edata.spawn_col = edata.spawn_col-2 then
			                     	           premtemp.append (" stays at: [")
			                     	           if attached keyval.item (edata.spawn_row) as t2 then
													 premtemp.append (t2.to_string_8)
												end
												     premtemp.append (",")
												if attached (edata.spawn_col) as t3 then
												     premtemp.append (t3.out+"]")
												end
			                     	         else
		                                            premtemp.append (" moves: [")
							                        if attached keyval.item (edata.spawn_row) as t then
														 premtemp.append (t.to_string_8)
													 end
													     premtemp.append (",")
													if attached (edata.spawn_col) as t1 then
														 premtemp.append (t1.out+"] -> ")
													end
													if edata.spawn_col-2 > 0 or hasfighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-2) then
														premtemp.append("[")
														if attached keyval.item (edata.spawn_row) as t2 then
															 premtemp.append (t2.to_string_8)
														end
														     premtemp.append (",")
														if attached (edata.spawn_col-2) as t3 then
														     premtemp.append (t3.out+"]")
														end
													else
														premtemp.append ("out of board")
														edata.health := 0
														--edata.dead := true
													end
                                              end
										    normaltempll.extend ("")
										    premtempll.extend (premtemp)
					                        premprint.put_i_th([premtempll,normaltempll],ine)
enemycollideproje(edata.spawn_row,edata.spawn_col,edata.spawn_col-2,ine,"premaction")
					                        te := enemycollideprojf(edata.spawn_row,edata.spawn_col,edata.spawn_col-2,edata.health,ine,"prem") -- check collide
				                            if te and edata.health >= 0 then
				                              if array[enemycollideprojfrow, enemycollideprojfcol] /~ "?"  then
				                              	array.put ("_", enemycollideprojfrow, enemycollideprojfcol) -- _ at starfighter proj
				                              end
				                            end
				                            if edata.health > 0 then

					                            te := enemycollidefighter(edata.spawn_row,edata.spawn_col,edata.spawn_col-2,ine,"prem")  -- check collide
					                            if te and in_game = false then
					                            	array.put ("X", enemycollideprojfrow, enemycollideprojfcol)
					                            end
					                        end

					                        if ((edata.spawn_col-2) > 0) and (edata.health > 0) then
			                    	            if array[edata.spawn_row,edata.spawn_col-2] /~ "?"  then -- for fog of war
			         	   	 	                     array.put ("C", edata.spawn_row, edata.spawn_col-2)
			         	   	 	                end
			                                end

                                            if (edata.health > 0) then
			                                	edata.spawn_col := edata.spawn_col-2 -- 1 col to right
			                                	    if (not enemyatspawnproje(edata.spawn_row-1,edata.spawn_col)) then
					                                	if (edata.spawn_row-1) > 0  then  -- change thisssss col to collidecol
					                                		-- spawn I at top
					                                		seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,edata.spawn_row-1,edata.spawn_col,tolvision)
											         	   	canseefighter := canseenby(edata.spawn_row-1,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,5)
											             	enemydata.extend ([50,50,0,0,5,0,0,0,0,0,0,0,3,3,enemyid,"I","<",edata.spawn_row-1,edata.spawn_col,canseefighter,seenbyfighter,false,true])
                                                            if array[edata.spawn_row-1, edata.spawn_col] /~ "?"  then
                                                               array.put ("I", edata.spawn_row-1, edata.spawn_col)
                                                            end
                                                            enemydata[enemydata.count].turn := false
					                                    end
					                                    premtemp := ("      A Interceptor(id:"+enemyid.out+") spawns at location [")
										         	   	 		if (edata.spawn_row-1) > 0  then
											         	   	 	    if attached keyval.item (edata.spawn_row-1) as t then
																		 premtemp.append (t.to_string_8)
																	end
																	     premtemp.append (",")
																	if attached (edata.spawn_col) as t1 then
																		 premtemp.append (t1.out+"].")
																	end
																else
																	premtemp.append("out of board")
																end
															   premtempll.extend (premtemp)
										         	   	   premprint.put_i_th([premtempll,normaltempll],ine)
										         	   	   projatenemyspawn(edata.spawn_row-1,edata.spawn_col,ine)  -- check spawn
										         	   	enemyid := enemyid + 1
				                                    end

				                                    if (not enemyatspawnproje(edata.spawn_row+1,edata.spawn_col)) then
					                                    if edata.spawn_row+1 <= r  then
					                                		-- spawn I at bottom
					                                		seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,edata.spawn_row+1,edata.spawn_col,tolvision)
											         	   	canseefighter := canseenby(edata.spawn_row+1,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,5)
											             	enemydata.extend ([50,50,0,0,5,0,0,0,0,0,0,0,3,3,enemyid,"I","<",edata.spawn_row+1,edata.spawn_col,canseefighter,seenbyfighter,false,true])
                                                            if array[edata.spawn_row+1, edata.spawn_col] /~ "?"  then
                                                                array.put ("I", edata.spawn_row+1, edata.spawn_col)
                                                            end
                                                            enemydata[enemydata.count].turn := false
					                                    end
					                                     premtemp := ("      A Interceptor(id:"+enemyid.out+") spawns at location [")
										         	   	 		if edata.spawn_row+1 <= r then
											         	   	 	    if attached keyval.item (edata.spawn_row+1) as t then
																		 premtemp.append (t.to_string_8)
																	end
																	     premtemp.append (",")
																	if attached (edata.spawn_col) as t1 then
																		 premtemp.append (t1.out+"].")
																	end
																else
																	premtemp.append("out of board")
																end
															   premtempll.extend (premtemp)
										         	   	   premprint.put_i_th([premtempll,normaltempll],ine)
										         	   	   projatenemyspawn(edata.spawn_row+1,edata.spawn_col,ine)
										         	   	enemyid := enemyid + 1
					                                end
			                                end
                              end
			     	    else
			     	    	if prem ~ "specialmove" or prem ~ "special" or prem ~ "specialhealth" or prem ~ "specialenergy" then
			     	    		edata.regen := edata.regen + 10
			     	    	end
			     	    end
                 end
              	 ine := ine + 1
              end

--                    from            -- remove if out of board , if health 0 then remove after/in updateallproj
--		         	  ine := 1
--		         	until
--		         	  ine > enemydata.count
--		         	loop
--		         	    enemydata[ine].turn := true     -- make turn true at the end of command call/move of all enemy
--		         		if  enemydata[ine].dead or enemydata[ine].health <=0 then
--		         			enemydata.go_i_th(ine)
--				            enemydata.remove
--				            ine := ine - 1
--		         		end
--		         		ine := ine + 1
--		         	end
           end

         enemyfightervisionupdate
           local
           	 seenbyfighter,canseefighter : BOOLEAN
           do
	           	across
	           	  enemydata	 is edata
	           	loop
                  seenbyfighter := canseenby(shiploc.last.trow,shiploc.last.tcol,edata.spawn_row,edata.spawn_col,tolvision)
			      canseefighter := canseenby(edata.spawn_row,edata.spawn_col,shiploc.last.trow,shiploc.last.tcol,edata.vision)
			      edata.canseefighter := canseefighter
			      edata.seenbyfighter := seenbyfighter
	           	end
           end
--      enemyfire
--         do
--         	across
--         	   enemydata is edata
--         	loop
--         	  if edata.sign ~ "G" then
--	               if edata.enemyprojrow = 0 and edata.enemyprojcol = 0 then
--	                  array.put ("<",edata.spawn_row , edata.spawn_col-1)
--	               end
--	          end
--         	end
--         end

      move(mrow: INTEGER_32 ; mcol: INTEGER_32;ls_flag:STRING)
         local
        	step_row : INTEGER
        	step_col : INTEGER
        	steps,lastrow,lastcol : INTEGER
        do
        	movefighterrow := mrow
        	movefightercol := mcol
        	lastrow := shiploc.last.trow
        	lastcol := shiploc.last.tcol
            if shiploc.count /= 0 then
            	    selected := "in game"
		        	i2 := 0
		           if ( mrow /= 0 and mcol /= 0 and shiploc.count /=0 ) then

				       if false then   -- collide_pass
	                	  array.put ("_", collide_loc_pass.colr,collide_loc_pass.colc)
					      array.put ("X",shiploc.last.trow ,shiploc.last.tcol)
                          flag := "collidepass"
	            	      i := i+1
		                  in_game := false   -- reset
		                  selected := "not started"
                          debug_flag := false
		               elseif false then  -- collide(mrow,mcol)
		               	  array.put ("_", shiploc.last.trow, shiploc.last.tcol)
			           	  array.put ("X", collide_loc.colr, collide_loc.colc)
                          flag := "collide"
	            	      i := i+1
		                  in_game := false   -- reset
		                  selected := "not started"
                          debug_flag := false
                       end
--                       if (remainhealth + tolregenh) <= tolhealth then
--                            remainhealth := remainhealth + tolregenh
--                       else
--                            remainhealth := tolhealth
--                       end
                       fighter_vision(mrow,mcol)
                       if ls_flag ~ "specialmove" then
			           	    updateenemy("specialmove")
			           else
			           	  	updateenemy("move")
			           	  	i := i+1
			           end
                       if in_game = false then
                          displayexist
                          if ls_flag ~ "specialmove" then
							remainenergy := remainenergy - 50
					      else
							remainenergy := remainenergy - num_steps (lastrow, lastcol, fightermovecollide.colr, fightermovecollide.colc) * tolmovecost  -- till final move collide place when fighter move
						  end
                          flag := "play0"
		               else
                          if ls_flag ~ "specialmove" then
                          	remainenergy := remainenergy - 50
                          else
                          	remainenergy := remainenergy - num_steps(lastrow,lastcol,mrow,mcol)*tolmovecost
                          end
--                              starfighteraction := "    The Starfighter(id:0) moves: ["    -- move to enemy update
--	                              if attached keyval.item (shiploc.last.trow) as t then
--								      starfighteraction.append (t.to_string_8)
--								  end
--								      starfighteraction.append (",")
--							      if attached (shiploc.last.tcol) as t1 then
--									  starfighteraction.append (t1.out+"] -> [")
--								  end
--								  if attached keyval.item (mrow) as t2 then
--								      starfighteraction.append (t2.to_string_8)
--								  end
--								      starfighteraction.append (",")
--							      if attached (mcol) as t3 then
--									  starfighteraction.append (t3.out+"]")
--								  end
--			              array.put ("_", shiploc.last.trow, shiploc.last.tcol)
--			           	  array.put ("S", mrow, mcol)
--			           	  shiploc.extend ([mrow,mcol])  -- extend the ship loc which is used by fire command as well
--			           	  shiploc.forth
--			           	  if ls_flag ~ "special" then
--			           	    updateenemy("special")
--			           	  else
--			           	  	updateenemy("move")
--			           	  	i := i+1
--			           	  end

			              enemy_spawn   -- spwan enemy
                          flag := "play0"
		              end
		           end
		    end
         end

         displayexist
          do
             across
               projloc  is mloc
             loop
             	 if mloc.sign ~ "*" then
             	   if array[mloc.prow , mloc.pcol] /~ "?"  then
             	 	 array.put ("*",mloc.prow , mloc.pcol)
             	   end
             	 else
             	   if array[mloc.prow , mloc.pcol] /~ "?"  then
             	 	array.put ("<",mloc.prow , mloc.pcol)
             	   end
             	 end

             end
             across
               enemydata  is edata
             loop
               if array[edata.spawn_row, edata.spawn_col] /~ "?"  then
                 array.put (edata.sign, edata.spawn_row, edata.spawn_col)
               end
             end
             if array[shiploc.last.trow,shiploc.last.tcol] ~ "X" then
             	array.put ("X",shiploc.last.trow,shiploc.last.tcol)
             elseif array[collide_loc.colr,collide_loc.colr] ~ "X" then
                array.put ("X",shiploc.last.trow,shiploc.last.tcol)
             end

          end


         scoreupdate(enemyname :STRING)  -- SCORE
            local
            	tt : SCORE_BUCKET
            	isadded : BOOLEAN
            do
                create tt.make (enemyname)
                across
                  fighterfocus	is foc
                loop
                	if foc.isfocus and foc.remain_capacity /= 0 and not isadded then
                		isadded := true
                		foc.insert(tt)

                	end
                end

                if not isadded then
                	fighterfocus.extend (tt)
                end

                score := 0

                across
                   fighterfocus	 is foc
                loop
                   score := score + foc.tolpoints
                end
            end

         update_allproj(premup:STRING)    -- move projectile
         local
         	in : INTEGER
         	temptup : attached TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER]
         	movloc : TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER;direction:STRING]
         	enemyprojaction, projeprojf : STRING
         	ls_check : BOOLEAN
         do
         	    update_fighterproj(premup)  -- fighter proj update first
                projeprojf := ""
         	    from
         	      in := 1
         	    until
         	      in > projloc.count or in_game = false
             	loop
                    movloc := projloc[in]
                    enemyprojaction := ""
                    ls_check := false

	             	if movloc.sign ~ "G" then
	             		 projeprojf := projecollideprojf(movloc.prow,movloc.pcol,movloc.pcol-movloc.incby,in) -- save evaluted value
	             	     if projecollideproje(movloc.prow,movloc.pcol,movloc.pcol-movloc.incby,in) then  -- proj proj collide
                             projloc.go_i_th(projecollideprojenumber)
		             		 projloc.remove
		             		 in := in - 1

		             		 if movloc.pcol-movloc.incby <= 0 then
		             		 	projloc.go_i_th(in)
		             		    projloc.remove
		             		    in := in - 1
		             		 end

	             		 elseif projeprojf ~ "epd" or projeprojf ~ "fpd" then
                             -- projecollideprojfrow := ploc.prow
             		         -- projecollideprojfcol := ploc.pcol
             		         if projeprojf ~ "epd" then
	             		         if (movloc.pcol <= col) and (movloc.pcol >= 1) then
	             		           if array[movloc.prow, movloc.pcol] /~ "?"  then
			             			  array.put ("_",movloc.prow, movloc.pcol)      -- need to put _ at old location
			             		   end
			             		 end
			             		 projloc.go_i_th(in)
			             		 projloc.remove
			             		 in := in - 1
			                 end

	             		 elseif projfightercollide(movloc.prow,movloc.pcol,movloc.pcol-movloc.incby) then
                             --projfightercolliderow
                              if (movloc.pcol <= col) and (movloc.pcol >= 1) then
                                if array[movloc.prow, movloc.pcol] /~ "?"  then
		             			   array.put ("_", movloc.prow, movloc.pcol)      -- need to remove this proj
		             			end
		             		  end
		             		  projloc.go_i_th(in)
		             		  projloc.remove
		             		  in := in - 1
		             		  remainhealth := remainhealth - (movloc.damage-tolarmour).abs

                            	-- projenemycollideid is for enemy id who collided can check for star fighter as well
                            	enemyprojaction.append("    A enemy projectile(id:"+movloc.id.out+") moves: [")
	                                     if attached keyval.item (movloc.prow) as t then
					            	       enemyprojaction.append (t.to_string_8)
					                     end
								         --Result.append (keyval.item (tuple_loc.prow))
								         enemyprojaction.append (",")
								         enemyprojaction.append ((movloc.pcol).out)
								         enemyprojaction.append ("]")
								         enemyprojaction.append (" -> ")
								         --if (movloc.pcol-movloc.incby > 0) then
				                             enemyprojaction.append ("[")
				                             if attached keyval.item (movloc.prow) as t then
						            	       enemyprojaction.append (t.to_string_8)
						                     end
				                             --Result.append (keyval.item (tuple_loc.prow))
									         enemyprojaction.append (",")
									         enemyprojaction.append ((projfightercollidecol).out)  -- to 1 step behind so not add fix inc
									         enemyprojaction.append ("]")
									     --end
						        enemyprojaction.append("%N")
                            	enemyprojaction.append("      The projectile collides with Starfighter(id:0) at location [")
                            	if attached keyval.item (movloc.prow) as t then
					            	  enemyprojaction.append (t.to_string_8)
					            end
								--Result.append (keyval.item (tuple_loc.prow))
								enemyprojaction.append (",")
								enemyprojaction.append ((projfightercollidecol).out)
								enemyprojaction.append ("], dealing "+(movloc.damage-tolarmour).out+" damage.")
								if remainhealth <= 0 then
									remainhealth := 0
									array.put ("X", shiploc.last.trow, shiploc.last.tcol)
						            in_game := false   -- reset
						            selected := "not started"
						            fightermovecollide.colr := shiploc.last.trow
				    	            fightermovecollide.colc := shiploc.last.tcol
				                    --debug_flag := false
				                    enemyprojaction.append ("%N")
				                    enemyprojaction.append("      The Starfighter at location [")
	                            	if attached keyval.item (shiploc.last.trow) as t then
						            	  enemyprojaction.append (t.to_string_8)
						            end
									--Result.append (keyval.item (tuple_loc.prow))
									enemyprojaction.append (",")
									enemyprojaction.append ((shiploc.last.tcol).out)
									enemyprojaction.append ("] has been destroyed.")
								end
								eprojaction.extend (enemyprojaction)

	             	     elseif projenemycollide(movloc.prow,movloc.pcol,movloc.pcol-movloc.incby) then  -- if enemy in between of enemyproj
                            if (movloc.pcol <= col) and (movloc.pcol >= 1) then
                              if array[movloc.prow, movloc.pcol] /~ "?"  then
		             			array.put ("_", movloc.prow, movloc.pcol)      -- need to remove this proj
		             		  end
		             		end
		             		projloc.go_i_th(in)
		             		projloc.remove
		             		in := in - 1
		             		--if in > 0 then
		             			if enemydata[projenemycollidenumber].health + movloc.damage > enemydata[projenemycollidenumber].tolhealth then -- health inc
			             			enemydata[projenemycollidenumber].health := enemydata[projenemycollidenumber].health
			             	    else
			             	    	enemydata[projenemycollidenumber].health := enemydata[projenemycollidenumber].health + movloc.damage
			             		end
		             		--end

                            --if projenemycollidesign ~ "G" then
                            	-- projenemycollideid is for enemy id who collided can check for star fighter as well
                            	enemyprojaction.append("    A enemy projectile(id:"+movloc.id.out+") moves: [")
	                                     if attached keyval.item (movloc.prow) as t then
					            	       enemyprojaction.append (t.to_string_8)
					                     end
								         --Result.append (keyval.item (tuple_loc.prow))
								         enemyprojaction.append (",")
								         enemyprojaction.append ((movloc.pcol).out)
								         enemyprojaction.append ("]")
								         enemyprojaction.append (" -> ")
								         --if (movloc.pcol-movloc.incby > 0) then
				                             enemyprojaction.append ("[")
				                             if attached keyval.item (movloc.prow) as t then
						            	       enemyprojaction.append (t.to_string_8)
						                     end
				                             --Result.append (keyval.item (tuple_loc.prow))
									         enemyprojaction.append (",")
									         enemyprojaction.append ((projenemycollidecol).out)  -- to 1 step behind so not add fix inc
									         enemyprojaction.append ("]")
									     --end
						        enemyprojaction.append("%N")
						        if projenemycollidesign ~ "G" then
						        	enemyprojaction.append("      The projectile collides with Grunt(id:"+projenemycollideid.out+") at location [")
						        elseif projenemycollidesign ~ "I" then
						            enemyprojaction.append("      The projectile collides with Interceptor(id:"+projenemycollideid.out+") at location [")
						        elseif projenemycollidesign ~ "F" then
						            enemyprojaction.append("      The projectile collides with Fighter(id:"+projenemycollideid.out+") at location [")
						        elseif projenemycollidesign ~ "C" then
						        	enemyprojaction.append("      The projectile collides with Carrier(id:"+projenemycollideid.out+") at location [")
						        elseif projenemycollidesign ~ "P" then
						        	enemyprojaction.append("      The projectile collides with Pylon(id:"+projenemycollideid.out+") at location [")
						        end

                            	if attached keyval.item (movloc.prow) as t then
					            	  enemyprojaction.append (t.to_string_8)
					            end
								--Result.append (keyval.item (tuple_loc.prow))
								enemyprojaction.append (",")
								enemyprojaction.append ((projenemycollidecol).out)
								enemyprojaction.append ("], healing "+movloc.damage.out+" damage.")
								eprojaction.extend (enemyprojaction)
                            --end

	             	     else

		             		if (movloc.pcol <= col) and (movloc.pcol >= 1) then
		             		  if array[ movloc.prow, movloc.pcol] /~ "?"  then
		             			array.put ("_", movloc.prow, movloc.pcol)
		             		  end
		             		end
	                        if movloc.pcol-movloc.incby > 0 then
	                          if array[ movloc.prow, movloc.pcol-movloc.incby] /~ "?"  then
	                        	array.put ("<", movloc.prow, movloc.pcol-movloc.incby)
	                          end
	                        end
	                        enemyprojaction.append("    A enemy projectile(id:"+movloc.id.out+") moves: [")
	                                     if attached keyval.item (movloc.prow) as t then
					            	       enemyprojaction.append (t.to_string_8)
					                     end
								         --Result.append (keyval.item (tuple_loc.prow))
								         enemyprojaction.append (",")
								         enemyprojaction.append ((movloc.pcol).out)
								         enemyprojaction.append ("]")
								         enemyprojaction.append (" -> ")
								         if (movloc.pcol-movloc.incby > 0) then
				                             enemyprojaction.append ("[")
				                             if attached keyval.item (movloc.prow) as t then
						            	       enemyprojaction.append (t.to_string_8)
						                     end
				                             --Result.append (keyval.item (tuple_loc.prow))
									         enemyprojaction.append (",")
									         enemyprojaction.append ((movloc.pcol-movloc.incby).out)  -- to 1 step behind so not add fix inc
									         enemyprojaction.append ("]")
									         projloc.put_i_th ([movloc.prow,(movloc.pcol-movloc.incby),movloc.id,movloc.sign,movloc.incby,movloc.damage,movloc.direction], in)
									         -- here as out of board proj is written back to projloc
									     else
									     	 enemyprojaction.append ("out of board")
									     	 projloc.go_i_th(in)   -- remove this proj
							                 projloc.remove
							                 in := in - 1
									     end
						    eprojaction.extend (enemyprojaction)
	                     end
	             	end
             		in := in + 1
             	end
         end

      update_fighterproj(premup:STRING)
      -- projloc.put not movlov.inc := 2*movlov.inc
         local
         	in, messagecount : INTEGER
         	movloc : TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER;direction:STRING]
         	fighterprojaction,ls_string, ls_string1: STRING
         	ls_check, removed : BOOLEAN
         do
         	messagecount := 0
                from
         	      in := 1
         	    until
         	      in > projloc.count or in_game = false
             	loop
                    movloc := projloc[in]
                    fighterprojaction := ""
                    ls_check := false
                    ls_string := ""
                    ls_string1 := ""
                    removed := false
             		if movloc.sign ~ "*" then

		             	        if (projloc[in].pcol) <= col then

		             	            if weapon_name ~ "Splitter" then
		             	            	     fighterprojaction.append("    A friendly projectile(id:"+projloc[in].id.out+") stays at: ")
						                     fighterprojaction.append ("[")
						                     if attached keyval.item (projloc[in].prow) as t then
						            	       fighterprojaction.append (t.to_string_8)
						                     end
									         --Result.append (keyval.item (tuple_loc.prow))
									         fighterprojaction.append (",")
									         fighterprojaction.append ((projloc[in].pcol).out) -- to go 1 step behind
									         fighterprojaction.append ("]")

		             	            else
		             	          	         fighterprojaction.append("    A friendly projectile(id:"+projloc[in].id.out+") moves: ")
						                     fighterprojaction.append ("[")
						                     if attached keyval.item (projloc[in].prow) as t then
						            	       fighterprojaction.append (t.to_string_8)
						                     end
									         --Result.append (keyval.item (tuple_loc.prow))
									         fighterprojaction.append (",")
									         fighterprojaction.append ((projloc[in].pcol).out) -- to go 1 step behind
									         fighterprojaction.append ("]")
									         fighterprojaction.append (" -> ")
									         if not projfoutofboard(projloc[in].prow,projloc[in].pcol,movloc.incby,in) or booleanprojfcollideenemy(movloc.prow,movloc.pcol+movloc.incby,in) then
					                             fighterprojaction.append ("[")
					                             if weapon_name ~ "Spread" then
					                             	if movloc.direction ~ "ddown" then
					                             		if attached keyval.item (projloc[in].prow+1) as t then
							            	                fighterprojaction.append (t.to_string_8)
							                            end
							                        elseif movloc.direction ~ "dup" then
							                        	if attached keyval.item (projloc[in].prow-1) as t then
							            	                fighterprojaction.append (t.to_string_8)
							                            end
							                        elseif movloc.pcol + movloc.incby <= col then
							                        	if attached keyval.item (projloc[in].prow) as t then
							            	                  fighterprojaction.append (t.to_string_8)
							                            end
					                             	end
					                             else
					                             	if attached keyval.item (projloc[in].prow) as t then
							            	            fighterprojaction.append (t.to_string_8)
							                        end
					                             end

					                             --Result.append (keyval.item (tuple_loc.prow))
										         fighterprojaction.append (",")
										         fighterprojaction.append ((projloc[in].pcol+movloc.incby).out)  -- to 1 step behind so not add fix inc
										         fighterprojaction.append ("]")
										         --Result.append ("%N    ")
										     else
										     	 fighterprojaction.append ("out of board")
										     	 --Result.append ("%N    ")
										     	 array.put("_",movloc.prow,movloc.pcol)
										     	 projloc.go_i_th(in)   -- remove this proj
								                 projloc.remove
								                 in := in - 1
                                                 removed := true
										     end
									end
							        friendlyprojaction.extend (fighterprojaction) -- add to array
                                    messagecount := messagecount + 1
						        end
						           if weapon_name ~ "Snipe" and removed = false then
                                        if projatspawnprojf(movloc.prow,movloc.pcol+movloc.incby,in) then  -- collide by proj
                                            fighterprojaction := ""
					                        fighterprojaction := "      The projectile collides with enemy projectile(id:"+projatspawnprojfid.out+") at location["
					                        if attached keyval.item (projatspawnprojfrow) as t then
													      fighterprojaction.append (t.to_string_8)
													  end
													      fighterprojaction.append (",")
												      if attached (projatspawnprojfcol) as t1 then
														  fighterprojaction.append (t1.out+"]"+", negating damage.")
													  end
											friendlyprojaction.extend (fighterprojaction)
                                        end
                                        if enemyatspwanprojf(movloc.prow,movloc.pcol+movloc.incby,in) then  -- collide by enemy
                                        	projloc.go_i_th(in)   -- remove this proj
								            projloc.remove
								            in := in - 1
								            if array[ movloc.prow, movloc.pcol+movloc.incby] /~ "?" then
								            	array.put ("_", movloc.prow, movloc.pcol+movloc.incby)
								            end
								        else
								        	if array[movloc.prow, movloc.pcol] /~ "?"  then
						             				array.put ("_", movloc.prow, movloc.pcol)
						             		end
						             		if array[movloc.prow, movloc.pcol+movloc.incby] /~ "?" then
						             			  	array.put ("*", movloc.prow, movloc.pcol+movloc.incby)
						             		end
						             		if in > 0  then
						             			 projloc.put_i_th ([movloc.prow,(movloc.pcol+movloc.incby),movloc.id,movloc.sign,movloc.incby,movloc.damage,movloc.direction], in)
						             		end

                                        end
						           elseif removed = false then

								        if in > 0 then

								        	ls_string := projfcollideproje(movloc.prow,movloc.pcol,movloc.pcol+movloc.incby,movloc.id,movloc.damage,in,messagecount)  -- fighter proj collide by ene
                                            if ls_string ~ "epd" and projfcollideprojeenemyid < in then
										           in := in - 1
                                            end

									        if (ls_string /~ "fpd" or ls_string /~ "fepd") and movloc.damage > 0 then
									          ls_string1 := projfcollideenemy(movloc.prow,movloc.pcol+movloc.incby,in,messagecount)  -- collide check
									        end
								        end

								        if (ls_string) ~ "fepd" or ls_string ~ "fpd" or movloc.damage <= 0 or ls_string1 ~ "fpd" then
		                                    projloc.go_i_th(in)   -- remove this proj
										    projloc.remove
										    in := in - 1
										    if (movloc.pcol <= col) and (movloc.pcol >= 1) then
										      if array[ movloc.prow, movloc.pcol] /~ "?"  then
												array.put ("_", movloc.prow, movloc.pcol)
											  end
						             		end
						             		ls_check := true
								        end

		                                if ls_check = false then
						             		if (movloc.pcol <= col) and (movloc.pcol >= 1) and (movloc.prow <= r and movloc.prow >= 1) then -- also for row in spread
												--array.put ("_", movloc.prow, movloc.pcol)
						             		end
						             		if movloc.pcol + movloc.incby <= col  and (weapon_name ~ "Standard" or weapon_name ~ "Rocket" or weapon_name ~ "Splitter") then  -- For Standard
						             			  if array[movloc.prow, movloc.pcol] /~ "?"  then
						             				array.put ("_", movloc.prow, movloc.pcol)
						             			  end
						             			  if array[movloc.prow, movloc.pcol+movloc.incby] /~ "?" then
						             			  	array.put ("*", movloc.prow, movloc.pcol+movloc.incby)
						             			  end

						             				if in > 0 then
								             	       if weapon_name ~ "Rocket" then
								             				 projloc.put_i_th ([movloc.prow,(movloc.pcol+movloc.incby),movloc.id,movloc.sign,2*movloc.incby,movloc.damage,movloc.direction], in)
								             				 --movloc.incby := 2 * movloc.incby
								             		   else
								             				 projloc.put_i_th ([movloc.prow,(movloc.pcol+movloc.incby),movloc.id,movloc.sign,movloc.incby,movloc.damage,movloc.direction], in)
								             	       end
								             	    end
						             	    elseif weapon_name ~ "Spread" then  -- will have to change
						             	           if movloc.direction ~ "ddown" and movloc.pcol + movloc.incby <= col and (movloc.prow + movloc.incby <= r)  then
						             	           	  if array[ movloc.prow, movloc.pcol] /~ "?" then
						             	           	     array.put ("_", movloc.prow, movloc.pcol)
						             	           	  end
						             	           	  if array[movloc.prow + movloc.incby , movloc.pcol+movloc.incby] /~ "?" then
						             	           	     array.put ("*", movloc.prow + movloc.incby , movloc.pcol+movloc.incby)
						             	           	  end
						             	           	  if in > 0 then
									             	       projloc.put_i_th ([movloc.prow + movloc.incby,(movloc.pcol+movloc.incby),movloc.id,movloc.sign,movloc.incby,movloc.damage,movloc.direction], in)

								             	      end
								             	   elseif movloc.direction ~ "dup" and (movloc.pcol + movloc.incby <= col) and (movloc.prow - movloc.incby >= 1) then
								             	        if array[movloc.prow, movloc.pcol] /~ "?" then
								             	          array.put ("_", movloc.prow, movloc.pcol)
								             	        end
								             	        if array[movloc.prow - movloc.incby , movloc.pcol+movloc.incby] /~ "?" then
								             	          array.put ("*", movloc.prow - movloc.incby , movloc.pcol+movloc.incby)
								             	        end
						             	           	  if in > 0 then
									             	       projloc.put_i_th ([movloc.prow - movloc.incby,(movloc.pcol+movloc.incby),movloc.id,movloc.sign,movloc.incby,movloc.damage,movloc.direction], in)

								             	      end
						             	           elseif movloc.pcol + movloc.incby <= col then
						             	           	   if array[ movloc.prow, movloc.pcol] /~ "?" then
						             	                  array.put ("_", movloc.prow, movloc.pcol)
						             	               end
						             	               if array[movloc.prow, movloc.pcol+movloc.incby] /~ "?" then
						             	                  array.put ("*", movloc.prow, movloc.pcol+movloc.incby)
						             	               end
						             	              if in > 0 then
									             	       projloc.put_i_th ([movloc.prow,(movloc.pcol+movloc.incby),movloc.id,movloc.sign,movloc.incby,movloc.damage,movloc.direction], in)

								             	      end
						             	           end
						             		end

						               end
						           end
	             	end
             		in := in + 1
             	end
         end

      hasfighter(row13:INTEGER;colstart13:INTEGER;colend13:INTEGER):BOOLEAN
         do
         	if shiploc.last.trow = row13 then
         		if shiploc.last.tcol <= colstart13 and shiploc.last.tcol >= colend13 then
         			Result := true
         		end
         	end
         end

      enemyatinitialspawnprojf(row15:INTEGER;col15:INTEGER):BOOLEAN
         local
         	tt : STRING
         do
         	  across
              	enemydata is edata
              loop
              	  if edata.spawn_row = row15 and edata.dead = false then
              	  	  if edata.spawn_col = col15 then


              	  	  	  tt := ""
              	  	  	  if edata.sign ~ "G" then
              	  	  	  	 tt.append("      The projectile collides with Grunt(id:"+edata.id.out+") at location [")
              	  	  	  elseif edata.sign ~ "I" then
              	  	  	  	tt.append ("      The projectile collides with Interceptor(id:"+edata.id.out+") at location [")
              	  	  	  elseif edata.sign ~ "F" then
              	  	  	  	tt.append ("      The projectile collides with Fighter(id:"+edata.id.out+") at location [")
              	  	  	  elseif edata.sign ~ "C" then
              	  	  	  	tt.append ("      The projectile collides with Carrier(id:"+edata.id.out+") at location [")
              	  	  	  elseif edata.sign ~ "P" then
              	  	  	  	tt.append ("      The projectile collides with Pylon(id:"+edata.id.out+") at location [")
              	  	  	  end
                                  if attached keyval.item (edata.spawn_row) as t then
								      tt.append (t.to_string_8)
								  end
								      tt.append (",")
							      if attached (edata.spawn_col) as t1 then
									  tt.append (t1.out+"]"+", dealing "+(projloc[projloc.count].damage-edata.armour).out+" damage.")
								  end
						  fighteraction.extend (tt)
						  edata.health := edata.health - (projloc[projloc.count].damage-edata.armour)
						     if edata.health <= 0 then
		                          edata.dead := true -- enemy dead
		              	  	  	  scoreupdate(edata.sign)  -- SCORE
		              	  	  	  edata.health := 0
		              	  	  	  if array[edata.spawn_row,edata.spawn_col] /~ "?" then
		              	  	  	  	array.put("_",edata.spawn_row,edata.spawn_col)
		              	  	  	  end
								  tt := ""
								  if edata.sign ~ "G" then
		              	  	  	  	 tt.append("      The Grunt at location [")
		              	  	  	  elseif edata.sign ~ "I" then
		              	  	  	  	tt.append ("      The Interceptor at location [")
		              	  	  	  elseif edata.sign ~ "F" then
		              	  	  	  	tt.append ("      The Fighter at location [")
		              	  	  	  elseif edata.sign ~ "C" then
		              	  	  	  	tt.append ("      The Carrier at location [")
		              	  	  	  elseif edata.sign ~ "P" then
		              	  	  	  	tt.append ("      The Pylon at location [")
		              	  	  	  end
		              	  	  	  if attached keyval.item (edata.spawn_row) as t then
										      tt.append (t.to_string_8)
										  end
										      tt.append (",")
									      if attached (edata.spawn_col) as t1 then
											  tt.append (t1.out+"]"+" has been destroyed.")
										  end
								  fighteraction.extend (tt)
                             end

                          projloc.go_i_th (projloc.count)
                          projloc.remove
              	  	  	  Result := true
              	  	  end
              	  end
              end
         end

      projfspawnatprojf(row11:INTEGER;col11:INTEGER):BOOLEAN
         local
         	in : INTEGER
            ploc : TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER]
            tt : STRING
         do
         	from
         	  in := 1
         	until
         	  in > projloc.count
         	loop
         		ploc := projloc[in]
         		if ploc.id /= projloc[projloc.count].id and ploc.sign ~ "*" then
         			if row11 = ploc.prow then
         				if col11 = ploc.pcol then
         					Result := true
         					projfspawnatprojfid := ploc.id
         					projloc[projloc.count].damage := projloc[projloc.count].damage + ploc.damage
         					projloc.go_i_th(in)   -- remove this proj
				            projloc.remove
					        in := in - 1
         				end
         			end
         		end

         	   in := in + 1
         	end
         end

      projeatspawnproj(row3:INTEGER;col3:INTEGER;number:INTEGER) : BOOLEAN
         local
         	in : INTEGER
            ploc : TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER]
            tt : STRING
         do
         	from
         	  in := 1
         	until
         	  in > projloc.count
         	loop
         	    ploc := projloc[in]
         	    if ploc.id /= projloc[projloc.count].id and ploc.sign ~ "G"  then
                     if row3 = ploc.prow then
                     	 if col3 = ploc.pcol then
                     	 	 Result := true
                     	 	 projloc[projloc.count].damage := projloc[projloc.count].damage + ploc.damage
                     	 	 projeatspawnprojid := ploc.id
                     	 	 projloc.go_i_th(in)   -- remove this proj
				             projloc.remove
					         in := in - 1
                     	 end
                     end
         	    end

         	    in := in + 1
         	end
         end

      projfatspawnproj(row8:INTEGER;col8:INTEGER;number:INTEGER) : STRING
         local
         	in, save : INTEGER
            ploc : TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER]
            tt : STRING
         do
         	Result := ""
         	save := 0
         	from
         	  in := 1
         	until
         	  in > projloc.count
         	loop
         	    ploc := projloc[in]
         	    if ploc.id /= projloc[projloc.count].id and ploc.sign ~ "*"  then
                     if row8 = ploc.prow then
                     	 if col8 = ploc.pcol then
                     	 	 --Result := true
                     	 	 save := projloc[projloc.count].damage
                     	 	 projloc[projloc.count].damage := projloc[projloc.count].damage - ploc.damage
                     	 	 projfatspawnprojid := ploc.id
                     	 	 if projloc[projloc.count].damage <= 0 then
                     	 	 	Result := "epd"
                     	 	 	ploc.damage := ploc.damage - save
                     	 	 elseif projloc[projloc.count].damage > 0 then
                     	 	 	Result := "fpd"
                     	 	 	projloc.go_i_th(in)   -- remove this proj
				                projloc.remove
					            in := in - 1
                     	 	 end
                     	 end
                     end
         	    end

         	    in := in + 1
         	end
         end

      enemyatspwanprojf(rowfinal2:INTEGER;colfinal2:INTEGER;number:INTEGER) : BOOLEAN -- remove projf if enemy collided
         local
         	tt : STRING
         do
              across
              	enemydata is edata
              loop
              	  if edata.spawn_row = rowfinal2 then
              	  	  if edata.spawn_col = colfinal2 then
              	  	  	  edata.dead := true -- enemy dead

              	  	  	  scoreupdate(edata.sign)  -- SCORE

              	  	  	  edata.health := 0
              	  	  	  if array[edata.spawn_row,edata.spawn_col] /~ "?" then
              	  	  	  	array.put("_",edata.spawn_row,edata.spawn_col)
              	  	  	  end
              	  	  	  tt := ""
              	  	  	  if edata.sign ~ "G" then
              	  	  	  	 tt.append("      The projectile collides with Grunt(id:"+edata.id.out+") at location [")
              	  	  	  elseif edata.sign ~ "I" then
              	  	  	  	tt.append ("      The projectile collides with Interceptor(id:"+edata.id.out+") at location [")
              	  	  	  elseif edata.sign ~ "F" then
              	  	  	  	tt.append ("      The projectile collides with Fighter(id:"+edata.id.out+") at location [")
              	  	  	  elseif edata.sign ~ "C" then
              	  	  	  	tt.append ("      The projectile collides with Carrier(id:"+edata.id.out+") at location [")
              	  	  	  elseif edata.sign ~ "P" then
              	  	  	  	tt.append ("      The projectile collides with Pylon(id:"+edata.id.out+") at location [")
              	  	  	  end
                                  if attached keyval.item (edata.spawn_row) as t then
								      tt.append (t.to_string_8)
								  end
								      tt.append (",")
							      if attached (edata.spawn_col) as t1 then
									  tt.append (t1.out+"]"+", dealing "+(projloc[number].damage-edata.armour).out+" damage.")
								  end
						  friendlyprojaction.extend (tt)

						  tt := ""
						  if edata.sign ~ "G" then
              	  	  	  	 tt.append("      The Grunt at location [")
              	  	  	  elseif edata.sign ~ "I" then
              	  	  	  	tt.append ("      The Interceptor at location [")
              	  	  	  elseif edata.sign ~ "F" then
              	  	  	  	tt.append ("      The Fighter at location [")
              	  	  	  elseif edata.sign ~ "C" then
              	  	  	  	tt.append ("      The Carrier at location [")
              	  	  	  elseif edata.sign ~ "P" then
              	  	  	  	tt.append ("      The Pylon at location [")
              	  	  	  end
              	  	  	  if attached keyval.item (edata.spawn_row) as t then
								      tt.append (t.to_string_8)
								  end
								      tt.append (",")
							      if attached (edata.spawn_col) as t1 then
									  tt.append (t1.out+"]"+" has been destroyed.")
								  end
						  friendlyprojaction.extend (tt)

              	  	  	  Result := true
              	  	  end
              	  end
              end
         end

      projatspawnprojf(rowfinal:INTEGER;colfinal:INTEGER;number:INTEGER ) : BOOLEAN
         local
         	in : INTEGER
            ploc : TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER]
            tt : STRING
         do
         	from
         		in := 1
         	until
         		in > projloc.count
         	loop
         		ploc := projloc[in]
         		if ploc.prow = rowfinal and ploc.id /= projloc[number].id then
         			if ploc.pcol = colfinal then

         				projatspawnprojfid := ploc.id
         				projatspawnprojfrow := ploc.prow
         				projatspawnprojfcol := ploc.pcol
         				Result := true

						if array[ploc.prow , ploc.pcol] /~ "?" then
							array.put ("_",ploc.prow , ploc.pcol)
						end
					    projloc[number].damage := projloc[number].damage - ploc.damage
         				projloc.go_i_th(in)   -- remove this proj
				        projloc.remove
					    in := in - 1
         			end
         		end

         		in := in + 1
         	end
         end

      projfoutofboard(prow:INTEGER;pcol:INTEGER;inc_by:INTEGER;number:INTEGER) : BOOLEAN
         do
                  if pcol + inc_by > col  and (weapon_name ~ "Standard" or weapon_name ~ "Snipe" or weapon_name ~ "Rocket" or weapon_name ~ "Splitter") then  -- For Standard
                         Result := true
				  elseif weapon_name ~ "Spread" then  -- will have to change
				        if projloc[number].direction ~ "ddown" and (pcol + inc_by > col or prow + inc_by > r or prow + inc_by < 1) then
                             Result := true
						elseif projloc[number].direction ~ "dup" and (pcol + inc_by > col or prow + inc_by > r or prow - inc_by < 1) then
                             Result := true
				        elseif pcol + inc_by > col then
                             Result := true
				        end
				  end
         end

      incvisionhealth(row6:INTEGER;col6:INTEGER;number:INTEGER)
         local
         	tt : STRING
         do
              across
              	enemydata is edata
              loop
              	  if canseenby(enemydata[number].spawn_row,enemydata[number].spawn_col,edata.spawn_row,edata.spawn_col,enemydata[number].vision) then
                      if (edata.health + 10) <= edata.tolhealth then
	                     edata.health := edata.health + 10
	                  else
	                     edata.health := edata.tolhealth
	                  end
	                  tt := ""
	                    if edata.sign ~ "I" then
             				tt := "      The Pylon heals Interceptor(id:"+edata.id.out+") at location ["
             			elseif edata.sign ~ "G" then
             				tt := "      The Pylon heals Grunt(id:"+edata.id.out+") at location ["
             			elseif edata.sign ~ "F" then
             				tt := "      The Pylon heals Fighter(id:"+edata.id.out+") at location ["
             			elseif edata.sign ~ "C" then
             				tt := "      The Pylon heals Carrier(id:"+edata.id.out+") at location ["
             			elseif edata.sign ~ "P" then
             				tt := "      The Pylon heals Pylon(id:"+edata.id.out+") at location ["
             			end
             			if attached keyval.item (edata.spawn_row) as t then
								      tt.append (t.to_string_8)
								  end
								      tt.append (",")
							      if attached (edata.spawn_col) as t1 then
									  tt.append (t1.out+"] for 10 damage.")
								  end
             		    premprint[number].normal.extend (tt)

              	  end
              end
         end


      projecollideproje(rowstart5:INTEGER;colstart5:INTEGER;colend5:INTEGER;number:INTEGER) : BOOLEAN
         local
          in : INTEGER
          ploc : TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER]
          tt,enemyprojaction : STRING
          anyenemy : BOOLEAN
         do
            anyenemy := false
         	from
         	  in := 1
         	until
         	  in > projloc.count
         	loop
         	    ploc := projloc[in]

         	    across
         	      enemydata	is edata
         	    loop
         	    	if edata.spawn_row = rowstart5 then
         	    		if edata.spawn_col < colstart5 and edata.spawn_col > colend5 then
                            anyenemy := true
         	    		end
         	    	end
         	    end

         	    if ploc.prow = rowstart5 and ploc.id /= projloc[number].id and ploc.sign ~ "G" and anyenemy = false then
                    if ploc.pcol < colstart5 and ploc.pcol > colend5  then
                        Result := true
                        enemyprojaction := ("    A enemy projectile(id:"+projloc[number].id.out+") moves: [")
	                                     if attached keyval.item (rowstart5) as t then
					            	       enemyprojaction.append (t.to_string_8)
					                     end
								         --Result.append (keyval.item (tuple_loc.prow))
								         enemyprojaction.append (",")
								         enemyprojaction.append ((colstart5).out)
								         enemyprojaction.append ("]")
								         enemyprojaction.append (" -> ")
								         if (rowstart5-projloc[number].incby > 0) then
				                             enemyprojaction.append ("[")
				                             if attached keyval.item (rowstart5) as t then
						            	       enemyprojaction.append (t.to_string_8)
						                     end
				                             --Result.append (keyval.item (tuple_loc.prow))
									         enemyprojaction.append (",")
									         enemyprojaction.append ((colend5).out)  -- to 1 step behind so not add fix inc
									         enemyprojaction.append ("]")
									         projloc.put_i_th ([rowstart5,(colend5),projloc[number].id,projloc[number].sign,projloc[number].incby,projloc[number].damage,projloc[number].direction], number)
									         -- here as out of board proj is written back to projloc
									    else
									    	 enemyprojaction.append ("out of board")
									    end
						    eprojaction.extend (enemyprojaction)

                         enemyprojaction := "      The projectile collides with enemy projectile(id:"+ploc.id.out+") at location ["
                         if attached keyval.item (ploc.prow) as t then
						            	       enemyprojaction.append (t.to_string_8)
						                     end
				                             --Result.append (keyval.item (tuple_loc.prow))
									         enemyprojaction.append (",")
									         enemyprojaction.append ((ploc.pcol).out)  -- to 1 step behind so not add fix inc
									         enemyprojaction.append ("], combining damage.")

                         eprojaction.extend (enemyprojaction)


                        projloc[number].damage := projloc[number].damage + ploc.damage
                        projecollideprojenumber := in
--                        projloc.go_i_th(in)   -- remove this proj
--						projloc.remove
--						in := in - 1
                    end
         	    end
         	    in := in + 1
         	end
         end

      fighteratenemyspawn(row5:INTEGER;col5:INTEGER)
         local
           t4 : INTEGER
         do
         	if shiploc.last.trow = row5 then
         		if shiploc.last.tcol = col5 then
	         		t4 := remainhealth - enemydata[enemydata.count].health

	         			   --	"The <enemy name> collides with Starfighter(id:0) at location [X,Y], trading <enemy current health> damage."

	         			    enemyspawn.append ("%N")
	             			if enemydata[enemydata.count].sign ~ "I" then
	             				enemyspawn.append("      The Interceptor collides with Starfighter(id:0) at location [")
	             			elseif enemydata[enemydata.count].sign ~ "G" then
	             				enemyspawn.append("      The Grunt collides with Starfighter(id:0) at location [")
	             			elseif enemydata[enemydata.count].sign ~ "F" then
	             				enemyspawn.append("      The Fighter collides with Starfighter(id:0) at location [")
	             			elseif enemydata[enemydata.count].sign ~ "C" then
	             				enemyspawn.append("      The Carrier collides with Starfighter(id:0) at location [")
	             		    elseif enemydata[enemydata.count].sign ~ "P" then
	             				enemyspawn.append("      The Interceptor collides with Starfighter(id:0) at location [")
	             			end
	             			          if attached keyval.item (shiploc.last.trow) as t then
									      enemyspawn.append (t.to_string_8)
									  end
									      enemyspawn.append (",")
								      if attached (shiploc.last.tcol) as t1 then
										  enemyspawn.append (t1.out+"]"+", taking "+(enemydata[enemydata.count].health).out+" damage.")
									  end

							enemydata[enemydata.count].health := 0
							enemydata[enemydata.count].dead := true
							scoreupdate(enemydata[enemydata.count].sign)  -- SCORE
						   enemyspawn.append ("%N")
		                   if enemydata[enemydata.count].sign ~ "G" then
		                   	    enemyspawn.append("      The Grunt at location [")
		                   elseif enemydata[enemydata.count].sign ~ "F" then
		                   	    enemyspawn.append("      The Fighter at location [")
		                   elseif enemydata[enemydata.count].sign ~ "I" then
		                   	    enemyspawn.append("      The Interceptor at location [")
		                   elseif enemydata[enemydata.count].sign ~ "C" then
		                   	    enemyspawn.append("      The Carrier at location [")
		                   elseif enemydata[enemydata.count].sign ~ "P" then
		                   	    enemyspawn.append("      The Pylon at location [")
		                   end
						                  if attached keyval.item (shiploc.last.trow) as t then
										      enemyspawn.append (t.to_string_8)
										  end
										      enemyspawn.append (",")
									      if attached (shiploc.last.tcol) as t1 then
											  enemyspawn.append (t1.out+"] has been destroyed.")
										  end

--					    	if enemydata[enemydata.count].sign ~ "G" then
--	            	    	   score := score + 2
--	            	    	elseif enemydata[enemydata.count].sign ~ "F" then
--	            	    	   score := score + 3
--	            	    	elseif enemydata[enemydata.count].sign ~ "I" then
--	            	    		score := score + 1
--	            	        elseif enemydata[enemydata.count].sign ~ "C" then
--	            	    		score := score + 3
--	            	        elseif enemydata[enemydata.count].sign ~ "P" then
--	            	    		score := score + 1
--	            	    	end

		             		remainhealth := remainhealth - enemydata[enemydata.count].health
		             		if remainhealth <= 0 then
		             			enemyspawn.append ("%N")
		                   	    enemyspawn.append("      The Starfighter at location [")

						                  if attached keyval.item (shiploc.last.trow) as t then
										      enemyspawn.append (t.to_string_8)
										  end
										      enemyspawn.append (",")
									      if attached (shiploc.last.tcol) as t1 then
											  enemyspawn.append (t1.out+"] has been destroyed.")
										  end
		             			remainhealth := 0 -- Starfighter dead
			                    in_game := false
			                    selected := "not started"
			                    fightermovecollide.colr := row5
				    	        fightermovecollide.colc := col5
		             			if array[row5, col5] /~ "?" then
		             			   array.put ("X", row5, col5)
		             		    end
		             		end
                          enemydata.go_i_th(enemydata.count)  -- remove at end
		             	  enemydata.remove

         		end
         	end
         end

      projfatenemyspawn(row5:INTEGER;col5:INTEGER) : BOOLEAN
         local
          in : INTEGER
          ploc : TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER]
          tt : STRING
         do
         	from
         	  in := 1
         	until
         	  in > projloc.count
         	loop
         	    ploc := projloc[in]
         		if ploc.prow = row5 and ploc.sign ~ "*" then
             		if ploc.pcol = col5 then
             			enemyspawn.append ("%N")
             			if enemydata[enemydata.count].sign ~ "I" then
             				enemyspawn.append("      The Interceptor collides with friendly projectile(id:"+ploc.id.out+") at location [")
             			elseif enemydata[enemydata.count].sign ~ "G" then
             				enemyspawn.append("      The Grunt collides with friendly projectile(id:"+ploc.id.out+") at location [")
             			elseif enemydata[enemydata.count].sign ~ "F" then
             				enemyspawn.append("      The Fighter collides with friendly projectile(id:"+ploc.id.out+") at location [")
             			elseif enemydata[enemydata.count].sign ~ "C" then
             				enemyspawn.append("      The Carrier collides with friendly projectile(id:"+ploc.id.out+") at location [")
             		    elseif enemydata[enemydata.count].sign ~ "P" then
             				enemyspawn.append("      The Pylon collides with friendly projectile(id:"+ploc.id.out+") at location [")
             			end
             			if attached keyval.item (ploc.prow) as t then
								      enemyspawn.append (t.to_string_8)
								  end
								      enemyspawn.append (",")
							      if attached (ploc.pcol) as t1 then
									  enemyspawn.append (t1.out+"]"+", taking "+(ploc.damage-enemydata[enemydata.count].armour).out+" damage.")
								  end

						enemydata[enemydata.count].health := enemydata[enemydata.count].health - (ploc.damage-enemydata[enemydata.count].armour)

					    if enemydata[enemydata.count].health <= 0 then

					       enemyspawn.append ("%N")
		                   if enemydata[enemydata.count].sign ~ "G" then
		                   	    enemyspawn.append("      The Grunt at location [")
		                   elseif enemydata[enemydata.count].sign ~ "F" then
		                   	    enemyspawn.append("      The Fighter at location [")
		                   elseif enemydata[enemydata.count].sign ~ "I" then
		                   	    enemyspawn.append("      The Interceptor at location [")
		                   elseif enemydata[enemydata.count].sign ~ "C" then
		                   	    enemyspawn.append("      The Carrier at location [")
		                   elseif enemydata[enemydata.count].sign ~ "P" then
		                   	    enemyspawn.append("      The Pylon at location [")
		                   end
						   if attached keyval.item (ploc.prow) as t then
										      enemyspawn.append (t.to_string_8)
										  end
										      enemyspawn.append (",")
									      if attached (ploc.pcol) as t1 then
											  enemyspawn.append (t1.out+"] has been destroyed.")
										  end

--					    	if enemydata[enemydata.count].sign ~ "G" then
--	            	    	   score := score + 2
--	            	    	elseif enemydata[enemydata.count].sign ~ "F" then
--	            	    	   score := score + 3
--	            	    	elseif enemydata[enemydata.count].sign ~ "I" then
--	            	    		score := score + 1
--	            	        elseif enemydata[enemydata.count].sign ~ "C" then
--	            	    		score := score + 3
--	            	        elseif enemydata[enemydata.count].sign ~ "P" then
--	            	    		score := score + 1
--	            	    	end
                            enemydata[enemydata.count].health := 0
                            enemydata[enemydata.count].dead := true
                            scoreupdate(enemydata[enemydata.count].sign)  -- SCORE
                            Result := true
	            	    	enemydata.go_i_th(enemydata.count)
		             		enemydata.remove
		             		if array[row5, col5] /~ "?" then
		             			array.put ("_", row5, col5)
		             		end

					    end

             			projloc.go_i_th(in)   -- remove this proj
						projloc.remove
						in := in - 1
             		end
             	end
             	in := in + 1
         	end
         end

      projatenemyspawn(row5:INTEGER;col5:INTEGER;number:INTEGER)
         local
          in : INTEGER
          ploc : TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER]
          tt : STRING
         do
         	from
         	  in := 1
         	until
         	  in > projloc.count
         	loop
         	    ploc := projloc[in]
         		if ploc.prow = row5 and ploc.sign ~ "G" then
             		if ploc.pcol = col5 then
             			tt := ""
             			if enemydata[enemydata.count].sign ~ "I" then
             				tt := "      The Interceptor collides with enemy projectile(id:"+ploc.id.out+") at location ["
             			elseif enemydata[enemydata.count].sign ~ "G" then
             				tt := "      The Grunt collides with enemy projectile(id:"+ploc.id.out+") at location ["
             			elseif enemydata[enemydata.count].sign ~ "F" then
             				tt := "      The Fighter collides with enemy projectile(id:"+ploc.id.out+") at location ["
             			elseif enemydata[enemydata.count].sign ~ "C" then
             				tt := "      The Carrier collides with enemy projectile(id:"+ploc.id.out+") at location ["
             			end
             			if attached keyval.item (ploc.prow) as t then
								      tt.append (t.to_string_8)
								  end
								      tt.append (",")
							      if attached (ploc.pcol) as t1 then
									  tt.append (t1.out+"]"+", healing "+ploc.damage.out+" damage.")
								  end
				        premprint[number].prem.extend (tt)
                        if (enemydata[enemydata.count].health + ploc.damage) <= enemydata[enemydata.count].tolhealth then
                               enemydata[enemydata.count].health := enemydata[enemydata.count].health + ploc.damage
                        else
                              enemydata[enemydata.count].health := enemydata[enemydata.count].tolhealth
                        end

             			projloc.go_i_th(in)   -- remove this proj
						projloc.remove
						in := in - 1
             		end
             	end
             	in := in + 1
         	end
         end

      fighteratspawnproje(row12:INTEGER;col12:INTEGER;number:INTEGER;call :STRING): BOOLEAN
         local
         	scc : SCOREHELPER
         	tt12 : STRING
         do
              if shiploc.last.trow = row12 and in_game = true then
                  if shiploc.last.tcol = col12 then
                 	  Result := true
                 	   tt12 := "      The projectile collides with Starfighter(id:0) at location ["
                                                    if attached keyval.item (row12) as t then
												        tt12.append (t.to_string_8)
													end
														tt12.append (",")
													if attached (col12) as t1 then
														tt12.append (t1.out+"], dealing "+(projloc[projloc.count].damage-tolarmour).out+" damage.")
													end
					   if call ~ "prem" then
						      premprint[number].prem.extend (tt12)
					   elseif call ~ "normal" then
						   	  premprint[number].normal.extend (tt12)
					   end

                 	  remainhealth := remainhealth - (projloc[projloc.count].damage-tolarmour)

                 	  array.put ("S", row12, col12)

                 	  if remainhealth <= 0 then
                 	  	tt12 := "      The Starfighter at location ["
						   if attached keyval.item (row12) as t then
										      tt12.append (t.to_string_8)
										  end
										      tt12.append (",")
									      if attached (col12) as t1 then
											  tt12.append (t1.out+"] has been destroyed.")
										  end
						   if call ~ "prem" then
						      premprint[number].prem.extend (tt12)
						   elseif call ~ "normal" then
						   	  premprint[number].normal.extend (tt12)
						   end
                 	  	remainhealth := 0 -- Starfighter dead
	                    in_game := false
	                    selected := "not started"
	                    fightermovecollide.colr := row12
				    	fightermovecollide.colc := col12
                 	  	array.put ("X", row12, col12)
                 	  end
                  end
             end
         end

      enemyatspawnproje(row4:INTEGER ; col4 :INTEGER ) : BOOLEAN
         local
         	in : INTEGER
         do
         	 in := 1
             Result := false
             across
             	enemydata is edata
             loop
             	if edata.spawn_row = row4 and edata.health > 0 and in_game = true then
             		if edata.spawn_col = col4 then
             			Result := true
             			enemyatspawnprojenumber := in
             		end
             	end
             	in := in + 1
             end
         end

      enemycollidefighter(row3:INTEGER;colstart3:INTEGER;colend3:INTEGER;number:INTEGER;call:STRING): BOOLEAN  -- enemy move and collide fighter
         local
         t4 : INTEGER
         add : STRING
         do
             Result := false -- fighter not destroyed
         	 if shiploc.last.trow = row3 then
         	 	t4 := remainhealth - enemydata[number].health
         	 	if (shiploc.last.tcol >= colend3) and (shiploc.last.tcol <= colstart3) and t4 > 0  then
                   -- enemy remove but not S
                   Result := false
                   enemydata[number].dead := true
                   scoreupdate(enemydata[number].sign)  -- SCORE
                   enemycollideprojfrow := shiploc.last.trow
	         	   enemycollideprojfcol := shiploc.last.tcol
                   --premprint[number].normal := ""          -- can do full reset of norml string as there is no fighter proj in between enemy and fighter
                   add := ""
                   if enemydata[number].sign ~ "G" then
                   	   add.append ("    A Grunt(id:"+enemydata[number].id.out+") moves: [")
                   elseif enemydata[number].sign ~ "I" then
                   	   add.append ("    A Interceptor(id:"+enemydata[number].id.out+") moves: [")
                   elseif enemydata[number].sign ~ "F" then
                   	   add.append ("    A Fighter(id:"+enemydata[number].id.out+") moves: [")
                   elseif enemydata[number].sign ~ "C" then
                   	   add.append ("    A Carrier(id:"+enemydata[number].id.out+") moves: [")
                   elseif enemydata[number].sign ~ "P" then
                   	   add.append ("    A Pylon(id:"+enemydata[number].id.out+") moves: [")
                   end
                   if attached keyval.item (row3) as t then
								      add.append (t.to_string_8)
								  end
								      add.append (",")
							      if attached (colstart3) as t1 then
									  add.append (t1.out+"] -> [")
								  end
								  if attached keyval.item (shiploc.last.trow) as t2 then
								      add.append (t2.to_string_8)
								  end
								      add.append (",")
							      if attached (shiploc.last.tcol) as t3 then
									  add.append (t3.out+"]")
								  end

				               if call ~ "prem" then
							   	  premprint[number].prem[1] := add
							   elseif call ~ "normal" then
							   	  premprint[number].normal[1] := add
							   end

                   add := ""
                   if enemydata[number].sign ~ "G" then
                   	   add.append ("      The Grunt collides with Starfighter(id:0) at location [")
                   elseif enemydata[number].sign ~ "I" then
                   	   add.append ("      The Interceptor collides with Starfighter(id:0) at location [")
                   elseif enemydata[number].sign ~ "F" then
                   	   add.append ("      The Fighter collides with Starfighter(id:0) at location [")
                   elseif enemydata[number].sign ~ "C" then
                   	   add.append ("      The Carrier collides with Starfighter(id:0) at location [")
                   elseif enemydata[number].sign ~ "P" then
                   	   add.append ("      The Pylon collides with Starfighter(id:0) at location [")
                   end
                   if attached keyval.item (shiploc.last.trow) as t then
								      add.append (t.to_string_8)
								  end
								      add.append (",")
							      if attached (shiploc.last.tcol) as t1 then
									  add.append (t1.out+"]"+", trading "+enemydata[number].health.out+" damage.")
								  end

				               if call ~ "prem" then
							   	 premprint[number].prem.extend (add)
							   elseif call ~ "normal" then
							   	  premprint[number].normal.extend (add)
							   end


                   add := ""
                   if enemydata[number].sign ~ "G" then
                   	    add := "      The Grunt at location ["
                   elseif enemydata[number].sign ~ "F" then
                   	    add := "      The Fighter at location ["
                   elseif enemydata[number].sign ~ "I" then
                   	    add := "      The Interceptor at location ["
                   elseif enemydata[number].sign ~ "C" then
                   	    add := "      The Carrier at location ["
                   elseif enemydata[number].sign ~ "P" then
                   	    add := "      The Pylon at location ["
                   end
				   if attached keyval.item (shiploc.last.trow) as t then
								      add.append (t.to_string_8)
								  end
								      add.append (",")
							      if attached (shiploc.last.tcol) as t1 then
									  add.append (t1.out+"] has been destroyed.")
								  end

                               if call ~ "prem" then
							   	 premprint[number].prem.extend (add)
							   elseif call ~ "normal" then
							   	  premprint[number].normal.extend (add)
							   end

                   remainhealth := remainhealth - enemydata[number].health
				   enemydata[number].health := enemydata[number].health - remainhealth  -- used to skip rest of turn
				   enemydata[number].health := 0
                elseif (shiploc.last.tcol >= colend3) and (shiploc.last.tcol <= colstart3) and t4 <= 0 then

                	-- remove both
                	enemydata[number].dead := true
                	scoreupdate(enemydata[number].sign)  -- SCORE
                	remainhealth := 0 -- Starfighter dead
                    Result := true
                    in_game := false
                    selected := "not started"
                	enemycollideprojfrow := shiploc.last.trow
	         	    enemycollideprojfcol := shiploc.last.tcol
	         	    fightermovecollide.colr := enemycollideprojfrow  -- to set the final collide location for move cost
	         	    fightermovecollide.colc := enemycollideprojfcol

	         	    add := ""
                   if enemydata[number].sign ~ "G" then
                   	   add.append ("    A Grunt(id:"+enemydata[number].id.out+") moves: [")
                   elseif enemydata[number].sign ~ "I" then
                   	   add.append ("    A Interceptor(id:"+enemydata[number].id.out+") moves: [")
                   elseif enemydata[number].sign ~ "F" then
                   	   add.append ("    A Fighter(id:"+enemydata[number].id.out+") moves: [")
                   elseif enemydata[number].sign ~ "C" then
                   	   add.append ("    A Carrier(id:"+enemydata[number].id.out+") moves: [")
                   elseif enemydata[number].sign ~ "P" then
                   	   add.append ("    A Pylon(id:"+enemydata[number].id.out+") moves: [")
                   end
                   if attached keyval.item (row3) as t then
								      add.append (t.to_string_8)
								  end
								      add.append (",")
							      if attached (colstart3) as t1 then
									  add.append (t1.out+"] -> [")
								  end
								  if attached keyval.item (shiploc.last.trow) as t2 then
								      add.append (t2.to_string_8)
								  end
								      add.append (",")
							      if attached (shiploc.last.tcol) as t3 then
									  add.append (t3.out+"]")
								  end
                               if call ~ "prem" then
							   	 premprint[number].prem[1] := add
							   elseif call ~ "normal" then
							   	  premprint[number].normal[1] := add
							   end


                   add := ""
                   if enemydata[number].sign ~ "G" then
                   	   add.append ("      The Grunt collides with Starfighter(id:0) at location [")
                   elseif enemydata[number].sign ~ "I" then
                   	   add.append ("      The Interceptor collides with Starfighter(id:0) at location [")
                   elseif enemydata[number].sign ~ "F" then
                   	   add.append ("      The Fighter collides with Starfighter(id:0) at location [")
                   elseif enemydata[number].sign ~ "C" then
                   	   add.append ("      The Carrier collides with Starfighter(id:0) at location [")
                   elseif enemydata[number].sign ~ "P" then
                   	   add.append ("      The Pylon collides with Starfighter(id:0) at location [")
                   end
                   if attached keyval.item (shiploc.last.trow) as t then
								      add.append (t.to_string_8)
								  end
								      add.append (",")
							      if attached (shiploc.last.tcol) as t1 then
									  add.append (t1.out+"]"+", trading "+enemydata[number].health.out+" damage.")
								  end

								  if call ~ "prem" then
							   	      premprint[number].prem.extend (add)
							      elseif call ~ "normal" then
							   	      premprint[number].normal.extend (add)
							      end

                   add := ""
                   if enemydata[number].sign ~ "G" then
                   	    add := "      The Grunt at location ["
                   elseif enemydata[number].sign ~ "F" then
                   	    add := "      The Fighter at location ["
                   elseif enemydata[number].sign ~ "I" then
                   	    add := "      The Interceptor at location ["
                   elseif enemydata[number].sign ~ "C" then
                   	    add := "      The Carrier at location ["
                   elseif enemydata[number].sign ~ "P" then
                   	    add := "      The Pylon at location ["
                   end
				   if attached keyval.item (shiploc.last.trow) as t then
								      add.append (t.to_string_8)
								  end
								      add.append (",")
							      if attached (shiploc.last.tcol) as t1 then
									  add.append (t1.out+"] has been destroyed.")
								  end

                               if call ~ "prem" then
							   	 premprint[number].prem.extend (add)
							   elseif call ~ "normal" then
							   	  premprint[number].normal.extend (add)
							  end


                   add := "      The Starfighter at location ["
				   if attached keyval.item (shiploc.last.trow) as t then
								      add.append (t.to_string_8)
								  end
								      add.append (",")
							      if attached (shiploc.last.tcol) as t1 then
									  add.append (t1.out+"] has been destroyed.")
								  end

				               if call ~ "prem" then
							   	 premprint[number].prem.extend (add)
							   elseif call ~ "normal" then
							   	  premprint[number].normal.extend (add)
							   end

                   enemydata[number].health := 0  -- as destroyed
                end
         	 end

         end

      enemycollideproje(row4:INTEGER;colstart4:INTEGER;colend4:INTEGER;number:INTEGER;call:STRING)
         local
         	in: INTEGER
         	ploc : TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER]
         	add : STRING
         do
            from
         	  in := 1
         	until
         	  in > projloc.count
         	loop
         	    ploc := projloc[in]
             	if ploc.sign ~ "G" then
             		if ploc.prow = row4 then
             			if ploc.pcol <= colstart4 and ploc.pcol >= colend4 then
                             add := ""
                               if enemydata[number].sign ~ "G" then
                               	   add :=  ("      The Grunt collides with enemy projectile(id:"+ploc.id.out+") at location [")
                               elseif enemydata[number].sign ~ "I" then
                               	   add :=  ("      The Interceptor collides with enemy projectile(id:"+ploc.id.out+") at location [")
                               elseif enemydata[number].sign ~ "F" then
                               	   add :=  ("      The Fighter collides with enemy projectile(id:"+ploc.id.out+") at location [")
                               elseif enemydata[number].sign ~ "C" then
                               	   add :=  ("      The Carrier collides with enemy projectile(id:"+ploc.id.out+") at location [")
                               elseif enemydata[number].sign ~ "P" then
                               	   add :=  ("      The Pylon collides with enemy projectile(id:"+ploc.id.out+") at location [")

                               end

                               if attached keyval.item (ploc.prow) as t2 then
								 add.append (t2.to_string_8)
								end
								     add.append (",")
								if attached (ploc.pcol) as t3 then
								     add.append (t3.out+"], healing "+(ploc.damage).out+" damage.")
								end

								if array[ploc.prow , ploc.pcol] /~ "?" then   -- put in array
								 array.put ("_",ploc.prow , ploc.pcol)
								end

							   if call ~ "premaction" then
							   	  premprint[number].prem.extend (add)
							   elseif call ~ "normalaction" then
							   	  premprint[number].normal.extend (add)
							   end

                               if (enemydata[number].health + ploc.damage) <= enemydata[number].tolhealth then
	                                enemydata[number].health := enemydata[number].health + ploc.damage
	                           else
	                                enemydata[number].health := enemydata[number].tolhealth
	                           end

							   projloc.go_i_th(in)   -- remove this proj
							   projloc.remove
							   in := in - 1
             			end
             		end
             	end

             	in := in + 1
            end
         end

      enemycollideprojf(row3:INTEGER;colstart3:INTEGER;colend3:INTEGER;damage:INTEGER;number:INTEGER;call:STRING) : BOOLEAN
         local
         	in,t4 : INTEGER
         	ploc : TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER]
         	add : STRING
         do

         	from
         	  in := 1
         	until
         	  in > projloc.count
         	loop
         	    t4 := 0
         	    ploc := projloc[in]
         	    if ploc.sign ~ "*" then
	         	       if ploc.prow = row3 then
	         	       	   t4 := enemydata[number].health - ploc.damage
	         	       	   if (ploc.pcol >= colend3) and (ploc.pcol <= colstart3) and t4 > 0  then
	         	       	   	   enemycollideprojfrow := ploc.prow
	         	       	   	   enemycollideprojfcol := ploc.pcol
	         	       	   	   enemydata[number].health := enemydata[number].health - (ploc.damage-enemydata[number].armour).abs
                               --premprint[number].normal.append ("%N")
                               add := ""
                               if enemydata[number].sign ~ "G" then
                               	   add :=  ("      The Grunt collides with friendly projectile(id:"+ploc.id.out+") at location [")
                               elseif enemydata[number].sign ~ "I" then
                               	   add :=  ("      The Interceptor collides with friendly projectile(id:"+ploc.id.out+") at location [")
                               elseif enemydata[number].sign ~ "F" then
                               	   add :=  ("      The Fighter collides with friendly projectile(id:"+ploc.id.out+") at location [")
                               elseif enemydata[number].sign ~ "C" then
                               	   add :=  ("      The Carrier collides with friendly projectile(id:"+ploc.id.out+") at location [")
                               elseif enemydata[number].sign ~ "P" then
                               	   add :=  ("      The Pylon collides with friendly projectile(id:"+ploc.id.out+") at location [")

                               end

                               if attached keyval.item (ploc.prow) as t2 then
								 add.append (t2.to_string_8)
								end
								     add.append (",")
								if attached (ploc.pcol) as t3 then
								     add.append (t3.out+"], taking "+(ploc.damage-enemydata[number].armour).out+" damage.")
								end
--							   if call ~ "prem" then
--							      premprint[number].prem.extend (add)
--							   elseif call ~ "normal"  then
							   	  premprint[number].normal.extend (add)
							   --end

							   Result := true
                               projloc.go_i_th(in)   -- remove this proj
							   projloc.remove
							   in := in - 1
--						   elseif (ploc.pcol >= colend3) and (ploc.pcol <= colstart3) and t4 = 0 then
--						   	   enemydata[number].dead := true
--						   	   enemydata[number].health := 0
--						   	   enemycollideprojfrow := ploc.prow
--	         	       	   	   enemycollideprojfcol := ploc.pcol
--						   	   Result := true
--						   	   projloc.go_i_th(in)   -- remove this proj
--							   projloc.remove
--							   in := in - 1
						   elseif (ploc.pcol >= colend3) and (ploc.pcol <= colstart3) and t4 <= 0 then

						   	   add := ""
						   	   if enemydata[number].sign ~ "G" then
                               	   add :=  ("    A Grunt(id:"+enemydata[number].id.out+")")
                               elseif enemydata[number].sign ~ "I" then
                               	   add :=  ("    A Interceptor(id:"+enemydata[number].id.out+")")
                               elseif enemydata[number].sign ~ "F" then
                               	   add :=  ("    A Fighter(id:"+enemydata[number].id.out+")")
                               elseif enemydata[number].sign ~ "C" then
                               	   add :=  ("    A Carrier(id:"+enemydata[number].id.out+")")
                               elseif enemydata[number].sign ~ "P" then
                               	   add :=  ("    A Pylon(id:"+enemydata[number].id.out+")")
                               end
                                                if enemydata[number].spawn_row = ploc.prow and enemydata[number].spawn_col = ploc.pcol then
					                     	           add.append (" stays at: [")
					                     	           if attached keyval.item (enemydata[number].spawn_row) as t2 then
															 add.append (t2.to_string_8)
														end
														     add.append (",")
														if attached (enemydata[number].spawn_col) as t3 then
														     add.append (t3.out+"]")
														end
			                     	            else
		                                                add.append(" moves: [")
								                        if attached keyval.item (enemydata[number].spawn_row) as t then
															 add.append (t.to_string_8)
														 end
														     add.append (",")
														if attached (enemydata[number].spawn_col) as t1 then
															 add.append (t1.out+"] -> ")
														end
														if ploc.pcol > 0 then
															add.append("[")
															if attached keyval.item (ploc.prow) as t2 then
																 add.append (t2.to_string_8)
															end
															     add.append (",")
															if attached (ploc.pcol) as t3 then
															     add.append (t3.out+"]")
															end
														else
															add.append ("out of board")
															--edata.dead := true
															enemydata[number].health := 0
														end
												  end
--												if call ~ "prem" then
--											      premprint[number].prem[1] := (add)
--											   elseif call ~ "normal"  then
											   	  premprint[number].normal[1] := (add)
											   --end


						   	   add := ""
                               if enemydata[number].sign ~ "G" then
                               	   add :=  ("      The Grunt collides with friendly projectile(id:"+ploc.id.out+") at location [")
                               elseif enemydata[number].sign ~ "I" then
                               	   add :=  ("      The Interceptor collides with friendly projectile(id:"+ploc.id.out+") at location [")
                               elseif enemydata[number].sign ~ "F" then
                               	   add :=  ("      The Fighter collides with friendly projectile(id:"+ploc.id.out+") at location [")
                               elseif enemydata[number].sign ~ "C" then
                               	   add :=  ("      The Carrier collides with friendly projectile(id:"+ploc.id.out+") at location [")
                               elseif enemydata[number].sign ~ "P" then
                               	   add :=  ("      The Pylon collides with friendly projectile(id:"+ploc.id.out+") at location [")
                               end
                               enemycollideprojfrow := ploc.prow
	         	       	   	   enemycollideprojfcol := ploc.pcol

                               if attached keyval.item (ploc.prow) as t2 then
								 add.append (t2.to_string_8)
								end
								     add.append (",")
								if attached (ploc.pcol) as t3 then
								     add.append (t3.out+"], taking "+(ploc.damage-enemydata[number].armour).out+" damage.")
								end
--							   if call ~ "prem" then
--							      premprint[number].prem.extend (add)
--							   elseif call ~ "normal"  then
							   	  premprint[number].normal.extend (add)
							   --end

							   add := ""
                               if enemydata[number].sign ~ "G" then
                               	   add :=  ("      The Grunt at location [")
                               elseif enemydata[number].sign ~ "I" then
                               	   add :=  ("      The Interceptor at location [")
                               elseif enemydata[number].sign ~ "F" then
                               	   add :=  ("      The Fighter at location [")
                               elseif enemydata[number].sign ~ "C" then
                               	   add :=  ("      The Fighter at location [")
                               elseif enemydata[number].sign ~ "P" then
                               	   add :=  ("      The Fighter at location [")
                               end

                               if attached keyval.item (ploc.prow) as t2 then
								 add.append (t2.to_string_8)
								end
								     add.append (",")
								if attached (ploc.pcol) as t3 then
								     add.append (t3.out+"] has been destroyed.")
								end
--							   if call ~ "prem" then
--							      premprint[number].prem.extend (add)
--							   elseif call ~ "normal"  then
							   	  premprint[number].normal.extend (add)
							   --end

						   	   enemydata[number].dead := true
						   	   scoreupdate(enemydata[number].sign)  -- SCORE
						   	   enemydata[number].health := 0
						   	   Result := true
						   	   projloc[in].damage := projloc[in].damage - enemydata[number].health
						   	   projloc.go_i_th(in)   -- remove this proj
							   projloc.remove
							   in := in - 1
	         	    	   end
	         	       end
         	    end
         	    in := in + 1
         	end
         end

       booleanprojfcollideenemy(mrow13:INTEGER;mcol13:INTEGER;number:INTEGER) : BOOLEAN   -- this is fighter proj move and collide by enemy
         local
         	crow,ccol,c1,c2,c_step : INTEGER
         	b3 : BOOLEAN
         	removeid,incrr : INTEGER
         	starfighteraction,fighterprojaction : STRING
         	edata : TUPLE[health :INTEGER;tolhealth:INTEGER;regen:INTEGER;armour:INTEGER;vision:INTEGER;preemprojdamage:INTEGER;notseenprojdamage:INTEGER;seenprojdamage:INTEGER;preemprojmove:INTEGER;notseenprojmove:INTEGER;seenprojmove:INTEGER;preemenemymove:INTEGER;notseenenemymove:INTEGER;seenenemymove:INTEGER;id:INTEGER;sign:STRING;projsign:STRING;spawn_row:INTEGER;spawn_col:INTEGER;canseefighter:BOOLEAN;seenbyfighter:BOOLEAN;dead:BOOLEAN;turn:BOOLEAN]
         do
            crow := projloc[number].prow
            ccol := projloc[number].pcol
            b3 := false
            incrr := 1
            Result := false
            fighterprojaction := ""
            c_step := (mcol13 - ccol).abs
	            from
                   c1 := 1
	            until
                   (c1) > c_step
	            loop
	            	 ccol := ccol + 1
	            	 if weapon_name ~ "Spread" then     -- actual diagnal movement
	            	 	if projloc[number].direction ~ "dup" then
	            	 		crow := crow - 1
	            	    elseif projloc[number].direction ~ "ddown" then
	            	    	crow := crow + 1
	            	 	end
	            	 end
                     --across
                       --projloc is ploc
                     from
                     	incrr := 1
                     until
                     	incrr > enemydata.count
                     loop
                     	edata := enemydata[incrr]
                     	if (edata.spawn_row = crow) and (edata.spawn_col = ccol) and Result /~ true then

                     	    Result := true

                     	end
                        incrr := incrr + 1
                     end

                    c1 := c1 + 1
	            end


         end


       projfcollideenemy(mrow2:INTEGER;mcol2:INTEGER;number:INTEGER;messagenum:INTEGER) : STRING   -- this is fighter proj move and collide by enemy
         local
         	crow,ccol,c1,c2,c_step,checkh : INTEGER
         	b3 : BOOLEAN
         	removeid,incrr : INTEGER
         	starfighteraction,fighterprojaction : STRING
         	edata : TUPLE[health :INTEGER;tolhealth:INTEGER;regen:INTEGER;armour:INTEGER;vision:INTEGER;preemprojdamage:INTEGER;notseenprojdamage:INTEGER;seenprojdamage:INTEGER;preemprojmove:INTEGER;notseenprojmove:INTEGER;seenprojmove:INTEGER;preemenemymove:INTEGER;notseenenemymove:INTEGER;seenenemymove:INTEGER;id:INTEGER;sign:STRING;projsign:STRING;spawn_row:INTEGER;spawn_col:INTEGER;canseefighter:BOOLEAN;seenbyfighter:BOOLEAN;dead:BOOLEAN;turn:BOOLEAN]
         do
            crow := projloc[number].prow
            ccol := projloc[number].pcol
            b3 := false
            incrr := 1
            Result := ""
            fighterprojaction := ""
            c_step := (mcol2 - ccol).abs
	            from
                   c1 := 1
	            until
                   (c1) > c_step
	            loop
	            	 ccol := ccol + 1
	            	 if weapon_name ~ "Spread" then     -- actual diagnal movement
	            	 	if projloc[number].direction ~ "dup" then
	            	 		crow := crow - 1
	            	    elseif projloc[number].direction ~ "ddown" then
	            	    	crow := crow + 1
	            	 	end
	            	 end
                     --across
                       --projloc is ploc
                     from
                     	incrr := 1
                     until
                     	incrr > enemydata.count
                     loop
                     	edata := enemydata[incrr]
                     	checkh := edata.health - (projloc[number].damage - edata.armour).abs
                     	if (edata.spawn_row = crow) and (edata.spawn_col = ccol) and checkh > 0 and Result ~ "" then

                     	    Result := "fpd" -- remove at main class
                            if (projloc[number].pcol) <= col then
		             	          	fighterprojaction := ("    A friendly projectile(id:"+projloc[number].id.out+") moves: ")
						                     fighterprojaction.append ("[")
						                     if attached keyval.item (projloc[number].prow) as t then
						            	       fighterprojaction.append (t.to_string_8)
						                     end
									         --Result.append (keyval.item (tuple_loc.prow))
									         fighterprojaction.append (",")
									         fighterprojaction.append ((projloc[number].pcol).out) -- to go 1 step behind
									         fighterprojaction.append ("]")
									         fighterprojaction.append (" -> ")

					                             fighterprojaction.append ("[")
					                             if attached keyval.item (edata.spawn_row) as t then
							            	       fighterprojaction.append (t.to_string_8)
							                     end
					                             --Result.append (keyval.item (tuple_loc.prow))
										         fighterprojaction.append (",")
										         fighterprojaction.append ((edata.spawn_col).out)  -- to 1 step behind so not add fix inc
										         fighterprojaction.append ("]")
										         --Result.append ("%N    ")

							        friendlyprojaction[messagenum] :=  (fighterprojaction) -- add to array
						     end

						    fighterprojaction := ("      The projectile collides with ")
	            			if edata.sign ~ "G" then
	            				fighterprojaction.append ("Grunt(id:"+edata.id.out+") at location [")
	            			elseif edata.sign ~ "I" then
	            				fighterprojaction.append ("Interceptor(id:"+edata.id.out+") at location [")
	            		    elseif edata.sign ~ "F" then
	            				fighterprojaction.append ("Fighter(id:"+edata.id.out+") at location [")
	            		    elseif edata.sign ~ "C" then
	            				fighterprojaction.append ("Carrier(id:"+edata.id.out+") at location [")
	            		    elseif edata.sign ~ "P" then
	            				fighterprojaction.append ("Pylon(id:"+edata.id.out+") at location [")
	            			end
	            			if attached keyval.item (edata.spawn_row) as t2 then
								 fighterprojaction.append (t2.to_string_8)
							end
							     fighterprojaction.append (",")
							if attached (edata.spawn_col) as t3 then
							     fighterprojaction.append (t3.out+"], dealing "+(projloc[number].damage - edata.armour).out+" damage.")
							end

						    friendlyprojaction.extend (fighterprojaction)
						    edata.health := edata.health - (projloc[number].damage - edata.armour).abs
						    projloc[number].damage := projloc[number].damage - edata.health
                     		--b3 := true
	            			projfcollideprojerow := edata.spawn_row
	            			projfcollideprojecol := edata.spawn_col

	            	    elseif (edata.spawn_row = crow) and (edata.spawn_col = ccol) and checkh <= 0 and Result ~ "" then
	            	    	Result := "fpd"

	            	    	-- SCORE
--	            	    	if edata.sign ~ "G" then
--	            	    	   score := score + 2
--	            	    	elseif edata.sign ~ "F" then
--	            	    	   score := score + 3
--	            	    	elseif edata.sign ~ "I" then
--	            	    		score := score + 1
--	            	        elseif edata.sign ~ "C" then
--	            	    		score := score + 3
--	            	        elseif edata.sign ~ "P" then
--	            	    		score := score + 1
--	            	    	end

	            	    	enemydata.go_i_th(incrr)
		             		enemydata.remove
		             		incrr := incrr - 1
		             	    projfcollideprojerow := edata.spawn_row
	            			projfcollideprojecol := edata.spawn_col
	            			if array[edata.spawn_row, edata.spawn_col] /~ "?" then
	            			    array.put ("_", edata.spawn_row, edata.spawn_col)
	            			end
		             		if (projloc[number].pcol) <= col then
		             	          	fighterprojaction := ("    A friendly projectile(id:"+projloc[number].id.out+") moves: ")
						                     fighterprojaction.append ("[")
						                     if attached keyval.item (projloc[number].prow) as t then
						            	       fighterprojaction.append (t.to_string_8)
						                     end
									         --Result.append (keyval.item (tuple_loc.prow))
									         fighterprojaction.append (",")
									         fighterprojaction.append ((projloc[number].pcol).out) -- to go 1 step behind
									         fighterprojaction.append ("]")
									         fighterprojaction.append (" -> ")

					                             fighterprojaction.append ("[")
					                             if attached keyval.item (edata.spawn_row) as t then
							            	       fighterprojaction.append (t.to_string_8)
							                     end
					                             --Result.append (keyval.item (tuple_loc.prow))
										         fighterprojaction.append (",")
										         fighterprojaction.append ((edata.spawn_col).out)  -- to 1 step behind so not add fix inc
										         fighterprojaction.append ("]")
										         --Result.append ("%N    ")

							        friendlyprojaction[messagenum] :=  (fighterprojaction) -- add to array
						     end

						    fighterprojaction := ("      The projectile collides with ")
	            			if edata.sign ~ "G" then
	            				fighterprojaction.append ("Grunt(id:"+edata.id.out+") at location [")
	            			elseif edata.sign ~ "I" then
	            				fighterprojaction.append ("Interceptor(id:"+edata.id.out+") at location [")
	            		    elseif edata.sign ~ "F" then
	            				fighterprojaction.append ("Fighter(id:"+edata.id.out+") at location [")
	            		    elseif edata.sign ~ "C" then
	            				fighterprojaction.append ("Carrier(id:"+edata.id.out+") at location [")
	            		    elseif edata.sign ~ "P" then
	            				fighterprojaction.append ("Pylon(id:"+edata.id.out+") at location [")
	            			end
	            			if attached keyval.item (edata.spawn_row) as t2 then
								 fighterprojaction.append (t2.to_string_8)
							end
							     fighterprojaction.append (",")
							if attached (edata.spawn_col) as t3 then
							     fighterprojaction.append (t3.out+"], dealing "+(projloc[number].damage - edata.armour.abs).out+" damage.")
							end

						    friendlyprojaction.extend (fighterprojaction)

						    fighterprojaction := ""
						    if edata.sign ~ "G" then
						    	fighterprojaction := "      The Grunt at location ["
						    elseif edata.sign ~ "I" then
						    	fighterprojaction := "      The Interceptor at location ["
						    elseif edata.sign ~ "F" then
						    	fighterprojaction := "      The Fighter at location ["
						    elseif edata.sign ~ "C" then
						    	fighterprojaction := "      The Carrier at location ["
						    elseif edata.sign ~ "P" then
						    	fighterprojaction := "      The Pylon at location ["
						    end
						    if attached keyval.item (edata.spawn_row) as t2 then
								 fighterprojaction.append (t2.to_string_8)
							end
							     fighterprojaction.append (",")
							if attached (edata.spawn_col) as t3 then
							     fighterprojaction.append (t3.out+"] has been destroyed.")
							end
							edata.dead := true
							scoreupdate(edata.sign)  -- SCORE
							edata.health := 0
                            friendlyprojaction.extend (fighterprojaction)
                            projloc[number].damage := projloc[number].damage - edata.health
                     	end
                        incrr := incrr + 1
                     end

                    c1 := c1 + 1
	            end


         end

      projecollideprojf(row3:INTEGER;colstart3:INTEGER;colend3:INTEGER;number:INTEGER) : STRING
         local
         enemyprojaction : STRING
         in,t4 : INTEGER
         ploc : TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER]
         do
         	Result := ""
             from
             	in := 1
             until
             	in > projloc.count
             loop
             	ploc := projloc[in]
             	if ploc.prow = row3 and ploc.id /= projloc[number].id and ploc.sign ~ "*" then  -- ploc fproj
             		 t4 := ploc.damage - projloc[number].damage
             		 if (colend3 <= ploc.pcol) and (ploc.pcol <= colstart3) and t4 > 0 then
             		      Result := "epd"
             		      projecollideprojfrow := ploc.prow
             		      projecollideprojfcol := ploc.pcol
                          enemyprojaction := "    A enemy projectile(id:"+ projloc[number].id.out +") moves: ["
                                        if attached keyval.item (projloc[number].prow) as t then
					            	       enemyprojaction.append (t.to_string_8)
					                     end
								         --Result.append (keyval.item (tuple_loc.prow))
								         enemyprojaction.append (",")
								         enemyprojaction.append ((projloc[number].pcol).out)
								         enemyprojaction.append ("]")
								         enemyprojaction.append (" -> ")
								         if (colstart3-projloc[number].incby > 0) then
				                             enemyprojaction.append ("[")
				                             if attached keyval.item (ploc.prow) as t then
						            	       enemyprojaction.append (t.to_string_8)
						                     end
				                             --Result.append (keyval.item (tuple_loc.prow))
									         enemyprojaction.append (",")
									         enemyprojaction.append ((ploc.pcol).out)  -- to 1 step behind so not add fix inc
									         enemyprojaction.append ("]")
									     else
									     	 enemyprojaction.append ("out of board") -- removed in main
									     end
									 eprojaction.extend (enemyprojaction)

                            	enemyprojaction := ("      The projectile collides with friendly projectile(id:"+ploc.id.out+") at location [")
                            	if attached keyval.item (ploc.prow) as t then
					            	  enemyprojaction.append (t.to_string_8)
					            end
								--Result.append (keyval.item (tuple_loc.prow))
								enemyprojaction.append (",")
								enemyprojaction.append ((ploc.pcol).out)
								enemyprojaction.append ("], negating damage.")
							 eprojaction.extend (enemyprojaction)
             		      ploc.damage := ploc.damage - projloc[number].damage
             		 elseif (colend3 <= ploc.pcol) and (ploc.pcol <= colstart3) and t4 = 0 then
             		 	  Result := "epd"
             		 	  projecollideprojfrow := ploc.prow
             		      projecollideprojfcol := ploc.pcol
					      if array[ploc.prow, ploc.pcol] /~ "?" then
					         array.put ("_", ploc.prow, ploc.pcol)
					      end
             		 	  ploc.damage := ploc.damage - projloc[number].damage
             		 elseif (colend3 <= ploc.pcol) and (ploc.pcol <= colstart3) and t4 < 0 then
             		 	  Result := "fpd"
             		 	  projecollideprojfrow := ploc.prow
             		      projecollideprojfcol := ploc.pcol
                          projloc.go_i_th(in)   -- remove this proj, fproj
						  projloc.remove
					      in := in - 1
					       if array[ploc.prow, ploc.pcol] /~ "?" then
					           array.put ("_", ploc.prow, ploc.pcol)
					       end

					      enemyprojaction := "    A enemy projectile(id:"+ projloc[number].id.out +") moves: ["
                                        if attached keyval.item (projloc[number].prow) as t then
					            	       enemyprojaction.append (t.to_string_8)
					                     end
								         --Result.append (keyval.item (tuple_loc.prow))
								         enemyprojaction.append (",")
								         enemyprojaction.append ((projloc[number].pcol).out)
								         enemyprojaction.append ("]")
								         enemyprojaction.append (" -> ")
								         if ((colstart3-projloc[number].incby > 0)) then
				                             enemyprojaction.append ("[")
				                             if attached keyval.item (ploc.prow) as t then
						            	       enemyprojaction.append (t.to_string_8)
						                     end
				                             --Result.append (keyval.item (tuple_loc.prow))
									         enemyprojaction.append (",")
									         enemyprojaction.append ((colend3).out)  -- to 1 step behind so not add fix inc
									         enemyprojaction.append ("]")
									     else
									     	 enemyprojaction.append ("out of board")
									     end
									 eprojaction.extend (enemyprojaction)

                            	enemyprojaction := ("      The projectile collides with friendly projectile(id:"+ploc.id.out+") at location [")
                            	if attached keyval.item (ploc.prow) as t then
					            	  enemyprojaction.append (t.to_string_8)
					            end
								--Result.append (keyval.item (tuple_loc.prow))
								enemyprojaction.append (",")
								enemyprojaction.append ((ploc.pcol).out)
								enemyprojaction.append ("], negating damage.")
							 eprojaction.extend (enemyprojaction)

             		      projloc[number].damage := projloc[number].damage - ploc.damage
             		      projloc[number].prow := ploc.prow
             		      projloc[number].pcol := colend3
             		      if array[ploc.prow, colend3] /~ "?" then
             		      	 array.put ("<", ploc.prow, colend3)
             		      end
             		 end
                end
                in := in + 1
             end
         end

      verticlecollidefighter(enemy_row1:INTEGER;enemy_col1:INTEGER;number:INTEGER)
         local
         	add : STRING
         do
         	 if enemy_col1 = shiploc.last.tcol then

         	 	  enemydata[number].dead := true
         	 	  scoreupdate(enemydata[number].sign)  -- SCORE
                  add := ""
                   if enemydata[number].sign ~ "G" then
                   	   add.append ("    A Grunt(id:"+enemydata[number].id.out+") moves: [")
                   elseif enemydata[number].sign ~ "I" then
                   	   add.append ("    A Interceptor(id:"+enemydata[number].id.out+") moves: [")
                   elseif enemydata[number].sign ~ "F" then
                   	   add.append ("    A Fighter(id:"+enemydata[number].id.out+") moves: [")
                   elseif enemydata[number].sign ~ "C" then
                   	   add.append ("    A Carrier(id:"+enemydata[number].id.out+") moves: [")
                   elseif enemydata[number].sign ~ "P" then
                   	   add.append ("    A Pylon(id:"+enemydata[number].id.out+") moves: [")
                   end
                   if attached keyval.item (enemy_row1) as t then
								      add.append (t.to_string_8)
								  end
								      add.append (",")
							      if attached (enemy_col1) as t1 then
									  add.append (t1.out+"] -> [")
								  end
								  if attached keyval.item (shiploc.last.trow) as t2 then
								      add.append (t2.to_string_8)
								  end
								      add.append (",")
							      if attached (shiploc.last.tcol) as t3 then
									  add.append (t3.out+"]")
								  end
                   premprint[number].prem[1] := add

                   add := ""
                   if enemydata[number].sign ~ "G" then
                   	   add.append ("      The Grunt collides with Starfighter(id:0) at location [")
                   elseif enemydata[number].sign ~ "I" then
                   	   add.append ("      The Interceptor collides with Starfighter(id:0) at location [")
                   elseif enemydata[number].sign ~ "F" then
                   	   add.append ("      The Fighter collides with Starfighter(id:0) at location [")
                   elseif enemydata[number].sign ~ "C" then
                   	   add.append ("      The Carrier collides with Starfighter(id:0) at location [")
                   elseif enemydata[number].sign ~ "P" then
                   	   add.append ("      The Pylon collides with Starfighter(id:0) at location [")
                   end
                   if attached keyval.item (shiploc.last.trow) as t then
								      add.append (t.to_string_8)
								  end
								      add.append (",")
							      if attached (shiploc.last.tcol) as t1 then
									  add.append (t1.out+"]"+", trading "+enemydata[number].health.out+" damage.")
								  end
				   premprint[number].prem.extend (add)

				   add := ""
                   if enemydata[number].sign ~ "G" then
                   	    add := "      The Grunt at location ["
                   elseif enemydata[number].sign ~ "F" then
                   	    add := "      The Fighter at location ["
                   elseif enemydata[number].sign ~ "I" then
                   	    add := "      The Interceptor at location ["
                   elseif enemydata[number].sign ~ "C" then
                   	    add := "      The Carrier at location ["
                   elseif enemydata[number].sign ~ "P" then
                   	    add := "      The Pylon at location ["
                   end
				   if attached keyval.item (shiploc.last.trow) as t then
								      add.append (t.to_string_8)
								  end
								      add.append (",")
							      if attached (shiploc.last.tcol) as t1 then
									  add.append (t1.out+"] has been destroyed.")
								  end
                   premprint[number].prem.extend (add)

                   enemydata[number].health := 0

                   remainhealth := remainhealth - enemydata[number].health

                   if remainhealth <= 0 then
                   	  remainhealth := 0 -- Starfighter dead
			          in_game := false
			          selected := "not started"
			          fightermovecollide.colr := shiploc.last.trow  -- to set the final collide location for move cost
	         	      fightermovecollide.colc := shiploc.last.tcol
		              if array[shiploc.last.trow, shiploc.last.tcol] /~ "?" then
		             	 array.put ("X", shiploc.last.trow, shiploc.last.tcol)
		              end
                   	   add := "      The Starfighter at location ["
					   if attached keyval.item (shiploc.last.trow) as t then
									      add.append (t.to_string_8)
									  end
									      add.append (",")
								      if attached (shiploc.last.tcol) as t1 then
										  add.append (t1.out+"] has been destroyed.")
									  end
					   premprint[number].prem.extend (add)
                   end

         	 end
         end

      verticlecollideprojf(rowstart:INTEGER;ls_col:INTEGER;rowend:INTEGER;ine:INTEGER)
         local
         	ploc : TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER]
         	in,t4 : INTEGER
         	tt,add : STRING
         	crow,ccol,c1,c2,c_step : INTEGER
         do
         	crow := rowstart
            ccol := ls_col
            in := 1
            c_step := (rowend - rowstart).abs
	            from
                   c1 := 1
	            until
                   (c1) > c_step
	            loop

	            	if rowend > crow then
	            	 		crow := crow + 1
	                elseif rowend < crow then
	            	 		crow := crow - 1
	            	end
	            	--crow := crow + 1

		         	from
		         		in := 1
		         	until
		         		in > projloc.count
		         	loop
		         		ploc := projloc[in]
		         		if ploc.pcol = ls_col then
		         			 t4 := (enemydata[ine].health - ploc.damage)
		                     if (ploc.prow = crow) and (ploc.pcol = ccol) and t4 > 0 then
		                     	--fpd
		                     	tt := ""
		             			if enemydata[ine].sign ~ "I" then
		             				tt := "      The Interceptor collides with friendly projectile(id:"+ploc.id.out+") at location ["
		             			elseif enemydata[ine].sign ~ "G" then
		             				tt := "      The Grunt collides with friendly projectile(id:"+ploc.id.out+") at location ["
		             			elseif enemydata[ine].sign ~ "F" then
		             				tt := "      The Fighter collides with friendly projectile(id:"+ploc.id.out+") at location ["
		             			elseif enemydata[ine].sign ~ "C" then
		             				tt := "      The Carrier collides with friendly projectile(id:"+ploc.id.out+") at location ["
		             			elseif enemydata[ine].sign ~ "P" then
		             				tt := "      The Pylon collides with friendly projectile(id:"+ploc.id.out+") at location ["
		             			end
		             			if attached keyval.item (ploc.prow) as t then
										      tt.append (t.to_string_8)
										  end
										      tt.append (",")
									      if attached (ploc.pcol) as t1 then
											  tt.append (t1.out+"]"+", taking "+ploc.damage.out+" damage.")
										  end
						        premprint[ine].prem.extend (tt)
		                        enemydata[ine].health := enemydata[ine].health - (ploc.damage-enemydata[ine].armour)
		                        projloc.go_i_th(in)   -- remove this proj
								projloc.remove
								in := in - 1
								if array[ploc.prow,ploc.pcol] /~ "?" then
								     array.put ("_",ploc.prow,ploc.pcol)
								end
							  elseif (ploc.prow = crow) and (ploc.pcol = ccol) and t4 <= 0 then
							  	-- enemy dead and fpd

							  	add := ""
				                   if enemydata[ine].sign ~ "G" then
				                   	   add.append ("    A Grunt(id:"+enemydata[ine].id.out+") moves: [")
				                   elseif enemydata[ine].sign ~ "I" then
				                   	   add.append ("    A Interceptor(id:"+enemydata[ine].id.out+") moves: [")
				                   elseif enemydata[ine].sign ~ "F" then
				                   	   add.append ("    A Fighter(id:"+enemydata[ine].id.out+") moves: [")
				                   elseif enemydata[ine].sign ~ "C" then
				                   	   add.append ("    A Carrier(id:"+enemydata[ine].id.out+") moves: [")
				                   elseif enemydata[ine].sign ~ "P" then
				                   	   add.append ("    A Pylon(id:"+enemydata[ine].id.out+") moves: [")
				                   end
				                   if attached keyval.item (rowstart) as t then
												      add.append (t.to_string_8)
												  end
												      add.append (",")
											      if attached (ls_col) as t1 then
													  add.append (t1.out+"] -> [")
												  end
												  if attached keyval.item (rowend) as t2 then
												      add.append (t2.to_string_8)
												  end
												      add.append (",")
											      if attached (ls_col) as t3 then
													  add.append (t3.out+"]")
												  end
				                   premprint[ine].prem[1] := add

							  	tt := ""
		             			if enemydata[ine].sign ~ "I" then
		             				tt := "      The Interceptor collides with friendly projectile(id:"+ploc.id.out+") at location ["
		             			elseif enemydata[ine].sign ~ "G" then
		             				tt := "      The Grunt collides with friendly projectile(id:"+ploc.id.out+") at location ["
		             			elseif enemydata[ine].sign ~ "F" then
		             				tt := "      The Fighter collides with friendly projectile(id:"+ploc.id.out+") at location ["
		             			elseif enemydata[ine].sign ~ "C" then
		             				tt := "      The Carrier collides with friendly projectile(id:"+ploc.id.out+") at location ["
		             			elseif enemydata[ine].sign ~ "P" then
		             				tt := "      The Pylon collides with friendly projectile(id:"+ploc.id.out+") at location ["
		             			end
		             			if attached keyval.item (ploc.prow) as t then
										      tt.append (t.to_string_8)
										  end
										      tt.append (",")
									      if attached (ploc.pcol) as t1 then
											  tt.append (t1.out+"]"+", taking "+ploc.damage.out+" damage.")
										  end
						        premprint[ine].prem.extend (tt)

						        add := ""
		             			if enemydata[ine].sign ~ "I" then
		             				add := "      The Interceptor at location ["
		             			elseif enemydata[ine].sign ~ "G" then
		             				add := "      The Grunt at location ["
		             			elseif enemydata[ine].sign ~ "F" then
		             				add := "      The Fighter at location ["
		             			elseif enemydata[ine].sign ~ "C" then
		             				add := "      The Carrier at location ["
		             		    elseif enemydata[ine].sign ~ "P" then
		             		    	add := "      The Pylon at location ["
		             			end

								   if attached keyval.item (ploc.prow) as t then
												      add.append (t.to_string_8)
												  end
												      add.append (",")
											      if attached (ploc.pcol) as t1 then
													  add.append (t1.out+"] has been destroyed.")
												  end
								   premprint[ine].prem.extend (add)


		                        enemydata[ine].health := enemydata[ine].health - (ploc.damage-enemydata[ine].armour)
		                        projloc.go_i_th(in)   -- remove this proj
								projloc.remove
								enemydata[ine].dead := true
								scoreupdate(enemydata[ine].sign)  -- SCORE
								in := in - 1
								if array[ploc.prow,ploc.pcol] /~ "?" then
								   array.put ("_",ploc.prow,ploc.pcol)
								end
								if array[enemydata[ine].spawn_row,enemydata[ine].spawn_col] /~ "?" then
		                           array.put ("_",enemydata[ine].spawn_row,enemydata[ine].spawn_col)
		                        end
		                     end
		         		end
		         		in := in + 1
		         	end
		          c1 := c1 + 1
	           end
         end

      projfcollideproje(row3:INTEGER;colstart3:INTEGER;colend3:INTEGER;id:INTEGER;damage:INTEGER;number:INTEGER;messagenum:INTEGER): STRING     -- fighter proj moves and colli
         local
         	crow,ccol,c1,c2,c_step : INTEGER
         	in,fighterprojdamage,t4 : INTEGER
         	ploc : TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER]
         	fighterprojaction : STRING
         do
         	fighterprojdamage := damage
            crow := projloc[number].prow
            ccol := projloc[number].pcol
            in := 1
            Result := ""
            c_step := (colend3 - ccol).abs
	            from
                   c1 := 1
	            until
                   (c1) > c_step
	            loop
	            	 ccol := ccol + 1
	            	 if weapon_name ~ "Spread" then     -- actual diagnal movement
	            	 	if projloc[number].direction ~ "dup" then
	            	 		crow := crow - 1
	            	    elseif projloc[number].direction ~ "ddown" then
	            	    	crow := crow + 1
	            	 	end
	            	 end
                     --across
                       --projloc is ploc
                     from
		             	in := 1
		             until
		             	in > projloc.count
		             loop
		             	ploc := projloc[in]
		             	if ploc.id /= id and ploc.sign ~ "G" then
		             		t4 := fighterprojdamage-ploc.damage
		             		if (ploc.prow = crow) and (ploc.pcol = ccol) and t4 > 0 then  -- as fighter proj moves right
		                        projfcollideprojerow := ploc.prow
		                        projfcollideprojecol := ploc.pcol
		                        if array[ploc.prow, ploc.pcol] /~ "?" then
		                             array.put ("_", ploc.prow, ploc.pcol)  -- erarse as well
		                        end
		                        projfcollideprojeid := ploc.id
		                        fighterprojaction := "      The projectile collides with enemy projectile(id:"+ploc.id.out+") at location ["
		                        if attached keyval.item (ploc.prow) as t2 then
										 fighterprojaction.append (t2.to_string_8)
									end
									     fighterprojaction.append (",")
									if attached (ploc.pcol) as t3 then
									     fighterprojaction.append (t3.out+"], negating damage.")
									end
									friendlyprojaction.extend (fighterprojaction) -- add to array
									fighterprojdamage := fighterprojdamage-ploc.damage
									projloc[number].damage := projloc[number].damage - ploc.damage
									projfcollideprojeenemyid := in
									projloc.go_i_th(in)   -- remove this proj
									projloc.remove
									in := in - 1
		                        Result := "epd" -- enemyprojdestroyed
		                    elseif (ploc.prow = crow) and (ploc.pcol = ccol) and t4 = 0 then
		                    	projfcollideprojerow := ploc.prow
		                        projfcollideprojecol := ploc.pcol
		                        if array[ploc.prow, ploc.pcol] /~ "?" then
		                           array.put ("_", ploc.prow, ploc.pcol)
		                        end
		                    	projfcollideprojeid := ploc.id

--		                    	if (projloc[number].pcol) <= col then
--		             	          	fighterprojaction := ("    A friendly projectile(id:"+projloc[number].id.out+") moves: ")
--						                     fighterprojaction.append ("[")
--						                     if attached keyval.item (projloc[number].prow) as t then
--						            	       fighterprojaction.append (t.to_string_8)
--						                     end
--									         Result.append (keyval.item (tuple_loc.prow))
--									         fighterprojaction.append (",")
--									         fighterprojaction.append ((projloc[number].pcol).out) -- to go 1 step behind
--									         fighterprojaction.append ("]")
--									         fighterprojaction.append (" -> ")

--					                             fighterprojaction.append ("[")
--					                             if attached keyval.item (ploc.prow) as t then
--							            	       fighterprojaction.append (t.to_string_8)
--							                     end
--					                             Result.append (keyval.item (tuple_loc.prow))
--										         fighterprojaction.append (",")
--										         fighterprojaction.append ((ploc.pcol).out)  -- to 1 step behind so not add fix inc
--										         fighterprojaction.append ("]")
--										         Result.append ("%N    ")

--							        friendlyprojaction[messagenum] :=  (fighterprojaction) -- add to array
--						        end

		                    	fighterprojaction := "      The projectile collides with enemy projectile(id:"+ploc.id.out+") at location ["
		                            if attached keyval.item (ploc.prow) as t2 then
										 fighterprojaction.append (t2.to_string_8)
									end
									     fighterprojaction.append (",")
									if attached (ploc.pcol) as t3 then
									     fighterprojaction.append (t3.out+"], negating damage.")
									end
									friendlyprojaction.extend (fighterprojaction) -- add to array
									fighterprojdamage := fighterprojdamage-ploc.damage
									projloc[number].damage := projloc[number].damage - ploc.damage
							        projloc.go_i_th(in)   -- remove this proj
									projloc.remove
									in := in - 1
		                    	Result := "fepd"
		                    elseif (ploc.prow = crow) and (ploc.pcol = ccol) and t4 < 0 then
		                        projfcollideprojerow := ploc.prow
		                        projfcollideprojecol := ploc.pcol
		                    	projfcollideprojeid := ploc.id

		                    	if (projloc[number].pcol) <= col then
		             	          	fighterprojaction := ("    A friendly projectile(id:"+projloc[number].id.out+") moves: ")
						                     fighterprojaction.append ("[")
						                     if attached keyval.item (projloc[number].prow) as t then
						            	       fighterprojaction.append (t.to_string_8)
						                     end
									         --Result.append (keyval.item (tuple_loc.prow))
									         fighterprojaction.append (",")
									         fighterprojaction.append ((projloc[number].pcol).out) -- to go 1 step behind
									         fighterprojaction.append ("]")
									         fighterprojaction.append (" -> ")

					                             fighterprojaction.append ("[")
					                             if attached keyval.item (ploc.prow) as t then
							            	       fighterprojaction.append (t.to_string_8)
							                     end
					                             --Result.append (keyval.item (tuple_loc.prow))
										         fighterprojaction.append (",")
										         fighterprojaction.append ((ploc.pcol).out)  -- to 1 step behind so not add fix inc
										         fighterprojaction.append ("]")
										         --Result.append ("%N    ")

							        friendlyprojaction[messagenum] :=  (fighterprojaction) -- add to array
						        end

		                    	fighterprojaction := "      The projectile collides with enemy projectile(id:"+ploc.id.out+") at location ["
		                            if attached keyval.item (ploc.prow) as t2 then
										 fighterprojaction.append (t2.to_string_8)
									end
									     fighterprojaction.append (",")
									if attached (ploc.pcol) as t3 then
									     fighterprojaction.append (t3.out+"], negating damage.")
									end
									friendlyprojaction.extend (fighterprojaction) -- add to array
									fighterprojdamage := fighterprojdamage-ploc.damage
									ploc.damage := ploc.damage - projloc[number].damage
									projloc[number].damage := 0
		                    	Result := "fpd" -- the fihter proj distroyed
		             		end
		             	end

		             	in := in + 1
		             end

                    c1 := c1 + 1
	            end
         end

      projfcollideprojetemp(row3:INTEGER;colstart3:INTEGER;colend3:INTEGER;id:INTEGER;damage:INTEGER;number:INTEGER): STRING     -- fighter proj moves and collide  MYYYYYYY
         local
         	in,fighterprojdamage,t4 : INTEGER
         	ploc : TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER]
         	fighterprojaction : STRING
         do
         	 fighterprojdamage := damage
         	 fighterprojaction := ""
         	 Result := ""
             from
             	in := 1
             until
             	in > projloc.count
             loop
             	ploc := projloc[in]
             	if ploc.prow = row3 and ploc.id /= id then
             		t4 := fighterprojdamage-ploc.damage
             		if (colstart3 <= ploc.pcol) and (ploc.pcol <= colend3) and t4 > 0 then  -- as fighter proj moves right
                        projfcollideprojerow := ploc.prow
                        projfcollideprojecol := ploc.pcol
                        array.put ("_", ploc.prow, ploc.pcol)  -- erarse as well
                        projfcollideprojeid := ploc.id
                        fighterprojaction := "      The projectile collides with enemy projectile(id:"+ploc.id.out+") at location ["
                        if attached keyval.item (ploc.prow) as t2 then
								 fighterprojaction.append (t2.to_string_8)
							end
							     fighterprojaction.append (",")
							if attached (ploc.pcol) as t3 then
							     fighterprojaction.append (t3.out+"], negating damage.")
							end
							friendlyprojaction.extend (fighterprojaction) -- add to array
							fighterprojdamage := fighterprojdamage-ploc.damage
							projloc[number].damage := projloc[number].damage - ploc.damage
							projloc.go_i_th(in)   -- remove this proj
							projloc.remove
							in := in - 1
                        Result := "epd" -- enemyprojdestroyed
                    elseif (colstart3 <= ploc.pcol) and (ploc.pcol <= colend3) and t4 = 0 then
                    	projfcollideprojerow := ploc.prow
                        projfcollideprojecol := ploc.pcol
                        array.put ("_", ploc.prow, ploc.pcol)
                    	projfcollideprojeid := ploc.id
                    	fighterprojaction := "      The projectile collides with enemy projectile(id:"+ploc.id.out+") at location ["
                            if attached keyval.item (ploc.prow) as t2 then
								 fighterprojaction.append (t2.to_string_8)
							end
							     fighterprojaction.append (",")
							if attached (ploc.pcol) as t3 then
							     fighterprojaction.append (t3.out+"], negating damage.")
							end
							friendlyprojaction.extend (fighterprojaction) -- add to array
							fighterprojdamage := fighterprojdamage-ploc.damage
							projloc[number].damage := projloc[number].damage - ploc.damage
					        projloc.go_i_th(in)   -- remove this proj
							projloc.remove
							in := in - 1
                    	Result := "fepd"
                    elseif (colstart3 <= ploc.pcol) and (ploc.pcol <= colend3) and t4 < 0 then
                        projfcollideprojerow := ploc.prow
                        projfcollideprojecol := ploc.pcol
                    	projfcollideprojeid := ploc.id
                    	fighterprojaction := "      The projectile collides with enemy projectile(id:"+ploc.id.out+") at location ["
                            if attached keyval.item (ploc.prow) as t2 then
								 fighterprojaction.append (t2.to_string_8)
							end
							     fighterprojaction.append (",")
							if attached (ploc.pcol) as t3 then
							     fighterprojaction.append (t3.out+"], negating damage.")
							end
							friendlyprojaction.extend (fighterprojaction) -- add to array
							fighterprojdamage := fighterprojdamage-ploc.damage
							projloc[number].damage := projloc[number].damage - ploc.damage
                    	Result := "fpd" -- the fihter proj distroyed
             		end
             	end

             	in := in + 1
             end
         end

      projfightercollide(row2:INTEGER;colstart2:INTEGER;colend2:INTEGER):BOOLEAN     -- enemyproj move and collide by fighter
         do
         	 if shiploc.last.trow = row2 then
	         	if (shiploc.last.tcol <= colstart2) and (shiploc.last.tcol >= colend2) then
	         		projfightercolliderow := shiploc.last.trow
                    projfightercollidecol := shiploc.last.tcol
                    Result := true
	         	end
	         end
         end

      projenemycollide(row1:INTEGER;colstart:INTEGER;colend:INTEGER):BOOLEAN   -- check if any in between for horizontal moving projectiles
         local
         	c1,ine : INTEGER
         do
         	 ine := 1
         	 projenemycollidecol := 0
             across
             	enemydata is edata
             loop
             	  if (edata.spawn_row = row1 ) and edata.dead = false then
		              if (edata.spawn_col < colstart) and (edata.spawn_col >= colend) then
		              	 if projenemycollidecol <= edata.spawn_col then
	                          projenemycolliderow := edata.spawn_row
	                          projenemycollidecol := edata.spawn_col
	                          projenemycollideid := edata.id
	                          projenemycollidenumber := ine
	                          projenemycollidesign := edata.sign
	                          Result := true
	                     end
		              end
                  end
                  ine := ine + 1
             end
         end

      fightercollideenemy(mrow2: INTEGER ; mcol2: INTEGER)
         local
         	crow,ccol,c1,c2,c_step : INTEGER
         	b3 : BOOLEAN
         	removeid,incrr : INTEGER
         	starfighteraction : STRING
         	edata : TUPLE[health :INTEGER;tolhealth:INTEGER;regen:INTEGER;armour:INTEGER;vision:INTEGER;preemprojdamage:INTEGER;notseenprojdamage:INTEGER;seenprojdamage:INTEGER;preemprojmove:INTEGER;notseenprojmove:INTEGER;seenprojmove:INTEGER;preemenemymove:INTEGER;notseenenemymove:INTEGER;seenenemymove:INTEGER;id:INTEGER;sign:STRING;projsign:STRING;spawn_row:INTEGER;spawn_col:INTEGER;canseefighter:BOOLEAN;seenbyfighter:BOOLEAN;dead:BOOLEAN;turn:BOOLEAN]
         do
            crow := shiploc.last.trow
            ccol := shiploc.last.tcol
            b3 := false
            incrr := 1
         	if mrow2 < crow then  -- vertical case so row diff and col is same
         		c_step := -1
            else
            	c_step := 1
         	end
	            from
                   c1 := crow
	            until
                   (c1 = mrow2)
	            loop
	            	 crow := crow + c_step
                     --across
                       --projloc is ploc
                     from
                     	incrr := 1
                     until
                     	incrr > enemydata.count
                     loop
                     	edata := enemydata[incrr]
                     	if (edata.spawn_row = crow) and (edata.spawn_col = ccol) and remainhealth >= 0 then
                     		--b3 := true
	            			collide_locenemy := [crow,ccol]
	            			if array[crow, ccol] /~ "?" then
	            			  array.put ("_", crow, ccol)
	            			end
	            			--starfighteraction.append ("%N")
	            			starfighteraction := ("      The Starfighter collides with ")
	            			if edata.sign ~ "G" then
	            				starfighteraction.append ("Grunt(id:"+edata.id.out+") at location [")
	            			elseif edata.sign ~ "I" then
	            				starfighteraction.append ("Interceptor(id:"+edata.id.out+") at location [")
	            			elseif edata.sign ~ "F" then
	            				starfighteraction.append ("Fighter(id:"+edata.id.out+") at location [")
	            			elseif edata.sign ~ "C" then
	            				starfighteraction.append ("Carrier(id:"+edata.id.out+") at location [")
	            		    elseif edata.sign ~ "P" then
	            				starfighteraction.append ("Pylon(id:"+edata.id.out+") at location [")
	            			end
	            			if attached keyval.item (edata.spawn_row) as t2 then
								 starfighteraction.append (t2.to_string_8)
							end
							     starfighteraction.append (",")
							if attached (edata.spawn_col) as t3 then
							     starfighteraction.append (t3.out+"], trading "+(edata.health).out+" damage.")
							end
							if edata.sign ~ "G" then
							   starfighteraction.append ("%N")
							   starfighteraction.append ("      The Grunt at location [")
							elseif edata.sign ~ "I" then
							   starfighteraction.append ("%N")
							   starfighteraction.append ("      The Interceptor at location [")
							elseif edata.sign ~ "F" then
							   starfighteraction.append ("%N")
							   starfighteraction.append ("      The Fighter at location [")
							elseif edata.sign ~ "C" then
							   starfighteraction.append ("%N")
							   starfighteraction.append ("      The Carrier at location [")
							elseif edata.sign ~ "P" then
							   starfighteraction.append ("%N")
							   starfighteraction.append ("      The Pylon at location [")
							end
							if attached keyval.item (edata.spawn_row) as t2 then
								 starfighteraction.append (t2.to_string_8)
							end
							     starfighteraction.append (",")
							if attached (edata.spawn_col) as t3 then
							     starfighteraction.append (t3.out+"] has been destroyed.")
							end
							fighteraction.extend (starfighteraction)

--							if edata.sign ~ "G" then
--	            	    	   score := score + 2
--	            	    	elseif edata.sign ~ "F" then
--	            	    	   score := score + 3
--	            	    	elseif edata.sign ~ "I" then
--	            	    		score := score + 1
--	            	        elseif edata.sign ~ "C" then
--	            	    		score := score + 3
--	            	        elseif edata.sign ~ "P" then
--	            	    		score := score + 1
--	            	    	end
                            scoreupdate(edata.sign) -- SCORE
                            remainhealth := remainhealth - (edata.health)
							enemydata.go_i_th(incrr)
		             		enemydata.remove
		             		incrr := incrr - 1
                     	end
                        incrr := incrr + 1
                     end

                    c1 := c1 + c_step
	            end

	            --if not b3 then
	            	if ccol > mcol2 then  -- vertical case so row same and col is diff
	            		c_step := -1
	                else
	                	c_step := 1
	            	end
	            	from
	            		c2 := ccol
	            	until
	            		(c2 = mcol2)
	            	loop
	            		ccol := ccol + c_step
	            		from
                     	incrr := 1
                        until
                     	incrr > enemydata.count
	            		loop
	            			edata := enemydata[incrr]
	            			if (edata.spawn_row = crow) and (edata.spawn_col = ccol) and remainhealth >= 0 then  -- to get the collide loc
	                     		--b3 := true
		            			collide_locenemy := [crow,ccol]
		            			if array[crow, ccol] /~ "?" then
		            			   array.put ("_", crow, ccol)
		            			end
		            			--starfighteraction.append ("%N")
		            			starfighteraction := ("      The Starfighter collides with ")
		            			if edata.sign ~ "G" then
		            				starfighteraction.append ("Grunt(id:"+edata.id.out+") at location [")
		            			elseif edata.sign ~ "I" then
		            				starfighteraction.append ("Interceptor(id:"+edata.id.out+") at location [")
		            			elseif edata.sign ~ "F" then
		            				starfighteraction.append ("Fighter(id:"+edata.id.out+") at location [")
		            			elseif edata.sign ~ "C" then
		            				starfighteraction.append ("Carrier(id:"+edata.id.out+") at location [")
		            		    elseif edata.sign ~ "P" then
		            				starfighteraction.append ("Pylon(id:"+edata.id.out+") at location [")
		            			end
		            			if attached keyval.item (edata.spawn_row) as t2 then
									 starfighteraction.append (t2.to_string_8)
								end
								     starfighteraction.append (",")
								if attached (edata.spawn_col) as t3 then
								     starfighteraction.append (t3.out+"], trading "+(edata.health).out+" damage.")
								end
								if edata.sign ~ "G" then
								   starfighteraction.append ("%N")
								   starfighteraction.append ("      The Grunt at location [")
								elseif edata.sign ~ "I" then
								   starfighteraction.append ("%N")
								   starfighteraction.append ("      The Interceptor at location [")
								elseif edata.sign ~ "F" then
								   starfighteraction.append ("%N")
								   starfighteraction.append ("      The Fighter at location [")
								elseif edata.sign ~ "C" then
								   starfighteraction.append ("%N")
								   starfighteraction.append ("      The Carrier at location [")
								elseif edata.sign ~ "P" then
								   starfighteraction.append ("%N")
								   starfighteraction.append ("      The Pylon at location [")
								end
								if attached keyval.item (edata.spawn_row) as t2 then
									 starfighteraction.append (t2.to_string_8)
								end
								     starfighteraction.append (",")
								if attached (edata.spawn_col) as t3 then
								     starfighteraction.append (t3.out+"] has been destroyed.")
								end
								fighteraction.extend (starfighteraction)
	                            remainhealth := remainhealth - (edata.health)

--	                            if edata.sign ~ "G" then
--		            	    	   score := score + 2
--		            	    	elseif edata.sign ~ "F" then
--		            	    	   score := score + 3
--		            	    	elseif edata.sign ~ "I" then
--		            	    		score := score + 1
--		            	        elseif edata.sign ~ "C" then
--		            	    		score := score + 3
--		            	        elseif edata.sign ~ "P" then
--		            	    		score := score + 1
--		            	    	end
                                scoreupdate(edata.sign)
								enemydata.go_i_th(incrr)
			             		enemydata.remove
			             		incrr := incrr - 1
                     	    end
                     	    incrr := incrr + 1
	            		end

	            		c2 := c2 + c_step

	            	end
	            --end

         end

      fightercollideproj(mrow: INTEGER ; mcol: INTEGER)
         local
         	crow,ccol,c1,c2,c_step : INTEGER
         	b3 : BOOLEAN
         	removeid,incrr : INTEGER
         	ploc1 : TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER]
         	starfighteraction : STRING
         do
            crow := shiploc.last.trow
            ccol := shiploc.last.tcol
            b3 := false
            incrr := 1
         	if mrow < crow then  -- vertical case so row diff and col is same
         		c_step := -1
            else
            	c_step := 1
         	end
	            from
                   c1 := crow
	            until
                   (c1 = mrow)
	            loop
	            	 crow := crow + c_step
                     --across
                       --projloc is ploc
                     from
                     	incrr := 1
                     until
                     	incrr > projloc.count
                     loop
                     	ploc1 := projloc[incrr]
                     	if (ploc1.prow = crow) and (ploc1.pcol = ccol) and remainhealth >= 0 then
                     		--b3 := true
	            			collide_loc := [crow,ccol]
	            			if array[crow, ccol] /~ "?" then
	            			   array.put ("_", crow, ccol)
	            			end
	            			--starfighteraction.append ("%N")
	            			if ploc1.sign ~ "*" then
	            				starfighteraction := ("      The Starfighter collides with friendly projectile(id:"+ploc1.id.out+") at location [")
	            			else
	            				starfighteraction := ("      The Starfighter collides with enemy projectile(id:"+ploc1.id.out+") at location [")
	            			end

	            			if attached keyval.item (ploc1.prow) as t2 then
								 starfighteraction.append (t2.to_string_8)
							end
							     starfighteraction.append (",")
							if attached (ploc1.pcol) as t3 then
							     starfighteraction.append (t3.out+"], taking "+(ploc1.damage-tolarmour).out+" damage.")
							end
							fighteraction.extend (starfighteraction)
                            remainhealth := remainhealth - (ploc1.damage-tolarmour)
							projloc.go_i_th(incrr)
		             		projloc.remove
		             		incrr := incrr - 1
		               elseif (ploc1.prow = crow) and (ploc1.pcol = ccol) and remainhealth < 0 then
		               	    projloc[incrr].damage := projloc[incrr].damage - remainhealth

                     	end
                        incrr := incrr + 1
                     end

                    c1 := c1 + c_step
	            end

	            --if not b3 then
	            	if ccol > mcol then  -- vertical case so row same and col is diff
	            		c_step := -1
	                else
	                	c_step := 1
	            	end
	            	from
	            		c2 := ccol
	            	until
	            		(c2 = mcol)
	            	loop
	            		ccol := ccol + c_step
	            		from
                     	incrr := 1
                        until
                     	incrr > projloc.count
	            		loop
	            			ploc1 := projloc[incrr]
	            			if (ploc1.prow = crow) and (ploc1.pcol = ccol) and remainhealth >= 0 then  -- to get the collide loc
	                     		--b3 := true
		            			collide_loc := [crow,ccol]
		            			if array[crow, ccol] /~ "?" then
		            			   array.put ("_", crow, ccol)
		            			end
		            			--starfighteraction.append ("%N")
		            			if ploc1.sign ~ "*" then
		            				starfighteraction := ("      The Starfighter collides with friendly projectile(id:"+ploc1.id.out+") at location [")
		            			else
		            				starfighteraction := ("      The Starfighter collides with enemy projectile(id:"+ploc1.id.out+") at location [")
		            			end
		            			if attached keyval.item (ploc1.prow) as t2 then
									 starfighteraction.append (t2.to_string_8)
								end
								     starfighteraction.append (",")
								if attached (ploc1.pcol) as t3 then
								     starfighteraction.append (t3.out+"], taking "+(ploc1.damage-tolarmour).out+" damage.")
								end
								fighteraction.extend (starfighteraction)
	                            remainhealth := remainhealth - (ploc1.damage-tolarmour)
								projloc.go_i_th(incrr)
			             		projloc.remove
			             		incrr := incrr - 1
			                elseif (ploc1.prow = crow) and (ploc1.pcol = ccol) and remainhealth < 0 then
			                	projloc[incrr].damage := projloc[incrr].damage - remainhealth
                     	    end
                     	    incrr := incrr + 1
	            		end

	            		c2 := c2 + c_step

	            	end
	            --end

         end

      fire
         local
           starfighteraction : STRING
         do
	        if in_game then
	          selected := "in game"
	          if not (shiploc.count = 0) then
	          	 if projloc.count = 0 then
                    i2 := 0
                    fighter_vision(shiploc.last.trow,shiploc.last.tcol) -- screen udate for debug check
                    array.put ("S", shiploc.last.trow, shiploc.last.tcol)
                    updateenemy("fire")
                    if in_game = false  then
			                  displayexist   -- existing things back afer refresh
			                  flag := "play0"
			                  if weapon_name ~ "Rocket" then
		            	        remainhealth := remainhealth - tolprojcost
		            	      else
		            	    	remainenergy := remainenergy - tolprojcost
		            	      end
		       	    else
	            	    i := i+1
	            	    fighterfirecount := fighterfirecount + 1
	            	    if weapon_name ~ "Rocket" then
		            	        remainhealth := remainhealth - tolprojcost
		            	else
		            	    	remainenergy := remainenergy - tolprojcost
		            	end
				        enemy_spawn   -- spwan enemy
	                    flag := "play0"
	                end
	             else
	             	i2 := 0
	             	fighter_vision(shiploc.last.trow,shiploc.last.tcol) -- screen udate for debug check
                    array.put ("S", shiploc.last.trow, shiploc.last.tcol)
	                updateenemy("fire")
	                if in_game = false  then
			                  displayexist   -- existing things back afer refresh
			                  flag := "play0"
			                  if weapon_name ~ "Rocket" then
		            	        remainhealth := remainhealth - tolprojcost
		            	      else
		            	    	remainenergy := remainenergy - tolprojcost
		            	      end
		       	    else
		                if false then  -- collide_pass
		                	  array.put ("_", collide_loc_pass.colr,collide_loc_pass.colc)
						      array.put ("X",shiploc.last.trow ,shiploc.last.tcol)
	                          flag := "collidepass"
		            	      i := i+1
			                  in_game := false   -- reset
		                else
		            	    i := i+1
		            	    fighterfirecount := fighterfirecount + 1
		            	    if weapon_name ~ "Rocket" then
		            	        remainhealth := remainhealth - tolprojcost
		            	    else
		            	    	remainenergy := remainenergy - tolprojcost
		            	    end

				            enemy_spawn   -- spwan enemy
	                        flag := "play0"
	                    end
	                end
	          	 end
	          end
	        else
	        	flag := "noplay"
	        end
        end

      pass
         local
         	starfighteraction : STRING
         do
	          if in_game then
	          	  selected := "in game"
		       	  i2 := 0
			       	  if shiploc.count /=0 then

					       if false then  -- collide_pass
					       	  --array.put ("_", collide_loc.colr , (projloc.last.pcol-fix_project_mov))
				       	  	  array.put ("_", collide_loc_pass.colr,collide_loc_pass.colc)
						      array.put ("X",shiploc.last.trow ,shiploc.last.tcol)
	                          flag := "collidepass"
					          i := i + 1
			                  in_game := false   -- reset
			                  debug_flag := false
			               end
--			               if (remainhealth + 2*tolregenh) <= tolhealth then
--                                remainhealth := remainhealth + 2*tolregenh
--                           else
--                               	remainhealth := tolhealth
--                           end
                           fighter_vision(shiploc.last.trow,shiploc.last.tcol) -- screen udate for debug check
                           array.put ("S", shiploc.last.trow, shiploc.last.tcol)
                           updateenemy("pass")
			               if in_game = false  then
			                  displayexist   -- existing things back afer refresh
			                  flag := "play0"

		       	           else
--                               if (remainenergy + 2*tolregene) <= tolenergy then
--                                    remainenergy := remainenergy + 2*tolregene
--                               else
--                               	    remainenergy := tolenergy
--                               end
--                               if (remainhealth + 2*tolregenh) <= tolhealth then
--                                  remainhealth := remainhealth + 2*tolregenh
--                               else
--                                  remainhealth := tolhealth
--                               end
--                                      starfighteraction := "    The Starfighter(id:0) passes at location ["
--                                      if attached keyval.item (shiploc.last.trow) as t then
--										 starfighteraction.append (t.to_string_8)
--									  end
--										 starfighteraction.append (",")
--									  if attached (shiploc.last.tcol) as t1 then
--										 starfighteraction.append (t1.out)
--									  end
--									     starfighteraction.append ("], doubling regen rate.")
--                                    fighteraction.extend (starfighteraction)
			            	   i := i+1
			            	   enemy_spawn   -- spwan enemy
	                           flag := "play0"
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
	            			if ((shiploc.last.tcol <= ploc.pcol ) and (shiploc.last.tcol >= (ploc.pcol-fix_project_mov))) then      -- Specific for standard fire
	                            Result := true
	                            collide_loc_pass := [ploc.prow,ploc.pcol]  -- use this
	            			end
		            	end
	                end
        end

       converttruefalse(b1 : BOOLEAN;b2: BOOLEAN):TUPLE[csf:STRING;sbf:STRING]
         do
            create Result
            if b1 = false and b2 = false then
            	Result.csf := "F"
            	Result.sbf := "F"
            elseif b1 = false and b2 = true then
            	Result.csf := "F"
            	Result.sbf := "T"
            elseif b1 = true and b2 = false then
            	Result.csf := "T"
            	Result.sbf := "F"
            elseif b1 = true and b2 = true then
            	Result.csf := "T"
            	Result.sbf := "T"
            end
         end

       special
         local
         	starfighteraction : STRING
         do
         	i2 := 0
         	-- check for collision at spawn location
         	if power_name /~ "Recall (50 energy): Teleport back to spawn." then
         		fighter_vision(shiploc.last.trow,shiploc.last.tcol) -- screen udate for debug check
         		array.put ("S", shiploc.last.trow, shiploc.last.tcol)
         	end

         	if power_name ~ "Recall (50 energy): Teleport back to spawn." then
               move((r/2).ceiling,1,"specialmove")
         	   starfighteraction := "    The Starfighter(id:0) uses special, teleporting to: ["
         	    if attached keyval.item ((r/2).ceiling) as t then
					 starfighteraction.append (t.to_string_8)
				end
				starfighteraction.append(",")
				starfighteraction.append("1]")
				fighteraction.extend (starfighteraction)
			elseif power_name ~ "Repair (50 energy): Gain 50 health, can go over max health. Health regen will not be in effect if over cap." then
		           	      updateenemy("specialhealth")
		           	      starfighteraction := "    The Starfighter(id:0) uses special, gaining 50 health."
						  fighteraction.extend (starfighteraction)
		    elseif power_name ~ "Overcharge (up to 50 health): Gain 2*health spent energy, can go over max energy. Energy regen will not be in effect if over cap." then
                          updateenemy("specialenergy")

			else
                updateenemy("special")

			end
			i := i + 1
			if power_name /~ "Recall (50 energy): Teleport back to spawn."  then
				enemy_spawn
			end

         	flag := "play0"
         end

       debug_mode
         do
         	if debug_flag = false then
         		if in_game then
         			i2 := i2 + 1
         		end
                debug_flag := true
                flag := "debug"
            elseif debug_flag =  true then
            	if in_game then
         			i2 := i2 + 1
         		end
                debug_flag := false
                flag := "notdebug"
         	end
         end

       abort
         do

         	create s.make_empty
			i := 0
			i2 := 0
			setup_mode := false
			setup_cursor := 0
			--flag := ""
			in_game := false
			--debug_flag := false

--			weapon_name := "Standard"
--			armour_name := "None"
--			engine_name := "Standard"
--			power_name := "Recall (50 energy): Teleport back to spawn."
			selected := ""
			projenemycollidesign := ""
			enemyspawn := ""
			projecollideprojenumber := 0
--			tolhealth := 0
--			tolenergy := 0
--			tolregenh := 0
--			tolregene := 0
--			tolarmour := 0
--			tolvision := 0
--			tolmove := 0
--			tolmovecost := 0
			tolprojdamage := 0
			tolprojcost := 0
			score := 0
			remainhealth := 0
			remainenergy := 0
			fix_project_mov := 0
			idp := -1
			enemydata_cursor := 0
			projenemycolliderow := 0
			projenemycollidecol := 0
			projenemycollideid := 0
			enemyid := 1
			fighterfirecount := 0
			movefighterrow := 0
			movefightercol := 0
			enemyatspawnprojenumber := 0
			projfightercolliderow := 0
			projfightercollidecol := 0
			projfcollideprojeid := 0
			projfcollideprojerow := 0
			projfcollideprojecol := 0
			enemycollideprojfrow := 0
			enemycollideprojfcol := 0
			projecollideprojfrow := 0
			projecollideprojfcol := 0
			projfcollideprojeenemyid := 0
			projeatspawnprojid := 0
			projatspawnprojfid := 0
			projatspawnprojfrow := 0
			projatspawnprojfcol := 0
			projfatspawnprojid := 0
			projfspawnatprojfid := 0
			--create data.make_empty
			create enemydata.make
			create {LINKED_LIST[TUPLE[trow:INTEGER;tcol:INTEGER]]} shiploc.make
			create {LINKED_LIST[TUPLE[trow:INTEGER;tcol:INTEGER]]} enemyloc.make
			create {LINKED_LIST[TUPLE[prow:INTEGER;pcol:INTEGER;id:INTEGER;sign:STRING;incby:INTEGER;damage:INTEGER;direction:STRING]]} projloc.make
			create fighteraction.make
			create premprint.make
			--create premprint1.make
			create eprojaction.make
			create friendlyprojaction.make
			create collide_loc
			create collide_locenemy
			create collide_enemyloc
            create collide_loc_pass
            create fightermovecollide
            create array.make_filled("",0,0)
            create keyval.make(10)
            create fighterfocus.make
            create projectile.make_from_string ("")

            flag := "abort"
         end

     change_selected(sel : STRING)
        do
           selected := sel
        end
     change_setup_mode_flag(fs : BOOLEAN)
        do
           setup_mode := fs
        end
     change_in_game(g : BOOLEAN)
        do
           in_game := g
        end
     change_flag(f : STRING)
        do
           flag := f
        end
     change_setup_cursor(in : INTEGER)
        do
           setup_cursor := in
        end
     change_tolhealth(i11 : INTEGER)
        do
           tolhealth := i11
        end
     change_tolenergy(i12 : INTEGER)
        do
           tolenergy := i12
        end
     change_tolregenh(i13 : INTEGER)
        do
           tolregenh := i13
        end
     change_tolregene(i14 : INTEGER)
        do
           tolregene := i14
        end
     change_tolarmour(i15 : INTEGER)
        do
           tolarmour := i15
        end
     change_tolvision(i16 : INTEGER)
        do
           tolvision := i16
        end
     change_tolmove(i17 : INTEGER)
        do
           tolmove := i17
        end
     change_tolmovecost(i18 : INTEGER)
        do
           tolmovecost := i18
        end
     change_tolprojdamage(i19 : INTEGER)
        do
           tolprojdamage := i19
        end
     change_tolprojcost(i110 : INTEGER)
        do
           tolprojcost := i110
        end
     change_weapon_name(sel1 : STRING)
        do
        	weapon_name := sel1
        end
     change_armour_name(sel2 : STRING)
        do
        	armour_name := sel2
        end
     change_engine_name(sel3 : STRING)
        do
        	engine_name := sel3
        end
     change_power_name(sel4 : STRING)
        do
        	power_name := sel4
        end
     change_i2(int : INTEGER)
        do
        	i2 := int
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
                     	if inc_row <= array.height and inc_col <= array.width then
                    		Result.append(array.item (inc_row, inc_col))  -- the elements here
                    	end
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
	out : STRING
	    local
	    	in:INTEGER
	    	truefalsetuple : TUPLE[csf:STRING;sbf:STRING]
		do
			create Result.make_from_string ("  ")
			if flag ~ "weaponstate" then
				--create Result.make_from_string ("  ")
				if debug_flag = true then
				    Result.append("state:weapon setup, debug, ok")
				else
					Result.append("state:weapon setup, normal, ok")
				end
				Result.append("%N")
                Result.append("  1:Standard (A single projectile is fired in front)")
                Result.append("%N")
                Result.append("    Health:10, Energy:10, Regen:0/1, Armour:0, Vision:1, Move:1, Move Cost:1,")
                Result.append("%N")
                Result.append("    Projectile Damage:70, Projectile Cost:5 (energy)")
                Result.append("%N")
                Result.append("  2:Spread (Three projectiles are fired in front, two going diagonal)")
                Result.append("%N")
                Result.append("    Health:0, Energy:60, Regen:0/2, Armour:1, Vision:0, Move:0, Move Cost:2,")
                Result.append("%N")
                Result.append("    Projectile Damage:50, Projectile Cost:10 (energy)")
                Result.append("%N")
                Result.append("  3:Snipe (Fast and high damage projectile, but only travels via teleporting)")
                Result.append("%N")
                Result.append("    Health:0, Energy:100, Regen:0/5, Armour:0, Vision:10, Move:3, Move Cost:0,")
                Result.append("%N")
                Result.append("    Projectile Damage:1000, Projectile Cost:20 (energy)")
                Result.append("%N")
                Result.append("  4:Rocket (Two projectiles appear behind to the sides of the Starfighter and accelerates)")
                Result.append("%N")
                Result.append("    Health:10, Energy:0, Regen:10/0, Armour:2, Vision:2, Move:0, Move Cost:3,")
                Result.append("%N")
                Result.append("    Projectile Damage:100, Projectile Cost:10 (health)")
                Result.append("%N")
                Result.append("  5:Splitter (A single mine projectile is placed in front of the Starfighter)")
                Result.append("%N")
                Result.append("    Health:0, Energy:100, Regen:0/10, Armour:0, Vision:0, Move:0, Move Cost:5,")
                Result.append("%N")
                Result.append("    Projectile Damage:150, Projectile Cost:70 (energy)")
                Result.append("%N")
                Result.append("  Weapon Selected:")
                Result.append(weapon_name)
                flag.replace_blank  -- reset the flag
            elseif flag ~ "armourstate" then
            	--create Result.make_from_string ("  ")
            	if debug_flag = true then
				    Result.append("state:armour setup, debug, ok")
				else
					Result.append("state:armour setup, normal, ok")
				end
				Result.append("%N")
                Result.append("  1:None")
                Result.append("%N")
                Result.append("    Health:50, Energy:0, Regen:1/0, Armour:0, Vision:0, Move:1, Move Cost:0")
                Result.append("%N")
                Result.append("  2:Light")
                Result.append("%N")
                Result.append("    Health:75, Energy:0, Regen:2/0, Armour:3, Vision:0, Move:0, Move Cost:1")
                Result.append("%N")
                Result.append("  3:Medium")
                Result.append("%N")
                Result.append("    Health:100, Energy:0, Regen:3/0, Armour:5, Vision:0, Move:0, Move Cost:3")
                Result.append("%N")
                Result.append("  4:Heavy")
                Result.append("%N")
                Result.append("    Health:200, Energy:0, Regen:4/0, Armour:10, Vision:0, Move:-1, Move Cost:5")
                Result.append("%N")
                Result.append("  Armour Selected:")
                Result.append(armour_name)
                flag.replace_blank  -- reset the flag
            elseif flag ~ "enginestate" then
            	--create Result.make_from_string ("  ")
            	if debug_flag = true then
				    Result.append("state:engine setup, debug, ok")
				else
					Result.append("state:engine setup, normal, ok")
				end
				Result.append("%N")
                Result.append("  1:Standard")
                Result.append("%N")
                Result.append("    Health:10, Energy:60, Regen:0/2, Armour:1, Vision:12, Move:8, Move Cost:2")
                Result.append("%N")
                Result.append("  2:Light")
                Result.append("%N")
                Result.append("    Health:0, Energy:30, Regen:0/1, Armour:0, Vision:15, Move:10, Move Cost:1")
                Result.append("%N")
                Result.append("  3:Armoured")
                Result.append("%N")
                Result.append("    Health:50, Energy:100, Regen:0/3, Armour:3, Vision:6, Move:4, Move Cost:5")
                Result.append("%N")
                Result.append("  Engine Selected:")
                Result.append(engine_name)
                flag.replace_blank  -- reset the flag
            elseif flag ~ "powerstate" then
            	--create Result.make_from_string ("  ")
            	if debug_flag = true then
				    Result.append("state:power setup, debug, ok")
				else
					Result.append("state:power setup, normal, ok")
				end
				Result.append("%N")
                Result.append("  1:Recall (50 energy): Teleport back to spawn.")
                Result.append("%N")
                Result.append("  2:Repair (50 energy): Gain 50 health, can go over max health. Health regen will not be in effect if over cap.")
                Result.append("%N")
                Result.append("  3:Overcharge (up to 50 health): Gain 2*health spent energy, can go over max energy. Energy regen will not be in effect if over cap.")
                Result.append("%N")
                Result.append("  4:Deploy Drones (100 energy): Clear all projectiles.")
                Result.append("%N")
                Result.append("  5:Orbital Strike (100 energy): Deal 100 damage to all enemies, affected by armour.")
                Result.append("%N")
                Result.append("  Power Selected:")
                Result.append(power_name)
                flag.replace_blank  -- reset the flag
            elseif flag ~ "summary" then
                --create Result.make_from_string ("  ")
                if debug_flag = true then
				    Result.append("state:setup summary, debug, ok")
				else
				    Result.append("state:setup summary, normal, ok")
				end
				Result.append("%N")
				Result.append("  Weapon Selected:"+weapon_name)
				Result.append("%N")
                Result.append("  Armour Selected:"+armour_name)
                Result.append("%N")
                Result.append("  Engine Selected:"+engine_name)
                Result.append("%N")
                Result.append("  Power Selected:"+power_name)
                flag.replace_blank  -- reset the flag
            elseif flag ~ "play0" then
                if in_game then
                   Result.append ("state:in game(")
	               Result.append (i.out)
	               Result.append (".0)")
	            else
	               Result.append ("state:not started")
	            end
	            if debug_flag then
	               Result.append (", debug, ok")
	            else
	               Result.append (", normal, ok")
	            end
	            Result.append ("%N")
	            Result.append ("  Starfighter:")
	            Result.append ("%N")
	            Result.append ("    [0,S]->health:")
	            Result.append (remainhealth.out)
	            Result.append ("/")
	            Result.append (tolhealth.out)
	            Result.append (", energy:")
	            Result.append (remainenergy.out)
	            Result.append ("/")
	            Result.append (tolenergy.out)
	            Result.append (", Regen:")
	            Result.append (tolregenh.out)
	            Result.append ("/")
	            Result.append (tolregene.out)
	            Result.append (", Armour:")
	            Result.append (tolarmour.out)
	            Result.append (", Vision:")
	            Result.append (tolvision.out)
	            Result.append (", Move:")
	            Result.append (tolmove.out)
	            Result.append (", Move Cost:")
	            Result.append (tolmovecost.out)
	            Result.append (", location:[")
--	              if in_game = false then -- if coolide happen when fighter moved
--	                if attached keyval.item (fightermovecollide.colr) as t then
--				         Result.append (t.to_string_8)
--				    end
--		                 Result.append (",")
--		            if attached (fightermovecollide.colc) as t1 then
--				         Result.append (t1.out)
--				    end
--	              else
	              	if attached keyval.item (shiploc.last.trow) as t then
				         Result.append (t.to_string_8)
				    end
		                 Result.append (",")
		            if attached (shiploc.last.tcol) as t1 then
				         Result.append (t1.out)
				    end
--	              end

	            Result.append ("]")
	            Result.append ("%N")
	            Result.append ("      Projectile Pattern:")
	            Result.append (weapon_name)
	            Result.append (", Projectile Damage:")
	            Result.append (tolprojdamage.out)
	            Result.append (", Projectile Cost:")
	            Result.append (tolprojcost.out)
	            if weapon_name ~ "Rocket" then
	                Result.append (" (health)")
	            else
	            	Result.append (" (energy)")
	            end

	            Result.append ("%N")
	            Result.append ("      Power:")
	            Result.append (power_name)
	            Result.append ("%N")
	            Result.append ("      score:")
	            Result.append (score.out)
	                if debug_flag then
                         Result.append ("%N")
			             Result.append ("  Enemy:")
			                  across
			                  	enemydata is edata
			                  loop
			                  	 Result.append ("%N")
			                  	 truefalsetuple := converttruefalse(edata.canseefighter,edata.seenbyfighter)
                                 Result.append ("    ["+edata.id.out+","+edata.sign+"]->health:"+edata.health.out+"/"+edata.tolhealth.out+", Regen:"+edata.regen.out+", Armour:"+edata.armour.out+", Vision:"+edata.vision.out+", seen_by_Starfighter:"+truefalsetuple.sbf+", can_see_Starfighter:"+truefalsetuple.csf+", location:[")
                                        if attached keyval.item (edata.spawn_row) as t then
					            	       Result.append (t.to_string_8)
					                    end
					                    Result.append(",")
					                    Result.append(edata.spawn_col.out+"]")
			                  end
			                  Result.append ("%N")
			             Result.append ("  Projectile:")
			              if projloc.count /= 0  then
                             across
                             	projloc is tuple_loc
                             loop
                                if tuple_loc.pcol <= col then
                                    if tuple_loc.sign ~ "*" and  tuple_loc.pcol > 0  then
                                    	Result.append ("%N")
                                    	Result.append ("    ["+tuple_loc.id.out+","+tuple_loc.sign+"]->damage:"+tuple_loc.damage.out+", move:"+tuple_loc.incby.out+", location:[")
                                    	if attached keyval.item (tuple_loc.prow) as t then
					            	       Result.append (t.to_string_8)
					                    end
					                    Result.append(",")
					                    Result.append(tuple_loc.pcol.out+"]")
					                elseif tuple_loc.pcol > 0 then
					                	Result.append ("%N")
					                	Result.append ("    ["+tuple_loc.id.out+","+"<"+"]->damage:"+tuple_loc.damage.out+", move:"+tuple_loc.incby.out+", location:[")
                                    	if attached keyval.item (tuple_loc.prow) as t then
					            	       Result.append (t.to_string_8)
					                    end
					                    Result.append(",")
					                    Result.append(tuple_loc.pcol.out+"]")
                                    end
                                end
                             end
                          end

			             Result.append ("%N")
			             Result.append ("  Friendly Projectile Action:")

			                 across
                             	friendlyprojaction is ea
                             loop
                                	Result.append("%N")
                                	Result.append(ea)
                             end
--			              if projloc.count /=0  then
--			                --Result.append ("%N    ")
--			                in := 1  -- just a counter
--				        	across
--				        		projloc is tuple_loc
--				        	loop
--							    if (in >= 1 and in < projloc.count and (tuple_loc.sign ~ "*") and (fighterfirecount >= 1)) then
--							         if (tuple_loc.pcol-fix_project_mov) <= col then
--                                         Result.append ("%N")
--								    	 Result.append("    A friendly projectile(id:"+tuple_loc.id.out+") moves: ")
--					                     Result.append ("[")
--					                     if attached keyval.item (tuple_loc.prow) as t then
--					            	       Result.append (t.to_string_8)
--					                     end
--								         --Result.append (keyval.item (tuple_loc.prow))
--								         Result.append (",")
--								         Result.append ((tuple_loc.pcol-fix_project_mov).out) -- to go 1 step behind
--								         Result.append ("]")
--								         Result.append (" -> ")
--								         if (tuple_loc.pcol <= col) then
--				                             Result.append ("[")
--				                             if attached keyval.item (tuple_loc.prow) as t then
--						            	       Result.append (t.to_string_8)
--						                     end
--				                             --Result.append (keyval.item (tuple_loc.prow))
--									         Result.append (",")
--									         Result.append ((tuple_loc.pcol).out)  -- to 1 step behind so not add fix inc
--									         Result.append ("]")
--									         --Result.append ("%N    ")
--									     else
--									     	 Result.append ("out of board")
--									     	 --Result.append ("%N    ")
--									     end

--								     end

--				        		end
--				        		in := in + 1
--				        	end
--				          end
			             Result.append ("%N")
			             Result.append ("  Enemy Projectile Action:")
			                across
                             	eprojaction is ea
                             loop
                                	Result.append("%N")
                                	Result.append(ea)
                             end
			             Result.append ("%N")
			             Result.append ("  Starfighter Action:")

--			             if starfighteraction /~ "" then
--			                Result.append ("%N")
--			             	Result.append (starfighteraction)
--                            starfighteraction := ""
                            across
                              fighteraction	 is fa
                            loop
                            	Result.append ("%N")
			             	    Result.append (fa)
                            end
			             --end
			             Result.append ("%N")
			             Result.append ("  Enemy Action:")
                             across
                             	premprint is ls_print
                             loop
                             	across
                             	  ls_print.prem is lsp
                             	loop
                             		if lsp /~ "" then
                                	  Result.append("%N")
                                	  Result.append(lsp)
                                    end
                             	end
                             end
                             across
                             	premprint is ls_print
                             loop
                             	across
                             	  ls_print.normal is lsn
                             	loop
                             		if lsn /~ "" then
                                	  Result.append("%N")
                                	  Result.append(lsn)
                                   end
                             	end

                             end

			             Result.append ("%N")
			             Result.append ("  Natural Enemy Spawn:")
			               if enemyspawn /~ "" then
			               	Result.append ("%N")
			                Result.append (enemyspawn)
			                enemyspawn := "" -- reset
			               end
	                end
	            Result.append ("%N")
				Result.append ("      ")
				Result.append (entire_grid)
				if in_game = false  then
					Result.append ("%N")
					Result.append ("  The game is over. Better luck next time!")
				end
                flag.replace_blank  -- reset the flag
                create eprojaction.make
                create friendlyprojaction.make
                --enemyspawn.replace_blank
                enemyspawn := "" -- reset
                create fighteraction.make
                create premprint.make
            elseif flag ~ "debug" then
                Result.append ("state:")
                if in_game = false and setup_mode = false then
                	Result.append ("not started")
                else
                	Result.append (selected)
                end
                if in_game then
                	 --Result.append ("in game")
                     Result.append ("(")
	                 Result.append (i.out)
	                 Result.append (".")
	                 Result.append (i2.out+")")
                end
	            Result.append (", debug, ok")
	            Result.append ("%N")
	            Result.append ("  In debug mode.")
	            flag.replace_blank  -- reset the flag
	        elseif flag ~ "notdebug" then
	        	Result.append ("state:")
                if in_game = false and setup_mode = false then
                	Result.append ("not started")
                else
                	Result.append (selected)
                end
                if in_game then
                	 --Result.append ("in game")
                     Result.append ("(")
	                 Result.append (i.out)
	                 Result.append (".")
	                 Result.append (i2.out+")")
                end
	            Result.append (", normal, ok")
	            Result.append ("%N")
	            Result.append ("  Not in debug mode.")
	            flag.replace_blank  -- reset the flag
	        elseif flag ~ "nogameabort" then
	        	Result.append ("state:")
                if in_game = false and setup_mode = false then
                	Result.append ("not started")
                else
                	Result.append (selected)
                end
                if debug_flag = true then
				    Result.append(", debug, error")
				else
				    Result.append(", normal, error")
				end
	        	    Result.append ("%N")
	        	    Result.append ("  Command can only be used in setup mode or in game.")
                flag.replace_blank  -- reset the flag
	        elseif flag ~ "nogame" then
	        	Result.append ("state:")
                if in_game = false and setup_mode = false then
                	Result.append ("not started")
                else
                	Result.append (selected)
                end
                if debug_flag = true then
				    Result.append(", debug, error")
				else
				    Result.append(", normal, error")
				end
	        	    Result.append ("%N")
	        	    Result.append ("  Command can only be used in game.")
	        	flag.replace_blank  -- reset the flag
	        elseif flag ~ "abort" then
	        	Result.append ("state:")
                if in_game = false and setup_mode = false then
                	Result.append ("not started")
                else
                	Result.append (selected)
                end
                if debug_flag = true then
				    Result.append(", debug, ok")
				else
				    Result.append(", normal, ok")
				end
	        	    Result.append ("%N")
	        	    Result.append ("  Exited from game.")
	        	flag.replace_blank  -- reset the flag
	        elseif flag ~ "notsetup" then
	        	Result.append ("state:")
                if in_game = false and setup_mode = false then
                	Result.append ("not started")
                else
                	Result.append (selected)
                end
                if in_game then
                	 --Result.append ("in game")
                     Result.append ("(")
	                 Result.append (i.out)
	                 Result.append (".")
	                 Result.append (i2.out+")")
                end
                if debug_flag = true then
				    Result.append(", debug, error")
				else
				    Result.append(", normal, error")
				end
				Result.append("%N")
	        	Result.append ("  Command can only be used in setup mode.")
	        	flag.replace_blank  -- reset the flag
	        elseif flag ~ "notsetupselect" then
	        	Result.append ("state:")
                if in_game = false and setup_mode = false then
                	Result.append ("not started")
                else
                	Result.append (selected)
                end
                if in_game then
                	 --Result.append ("in game")
                     Result.append ("(")
	                 Result.append (i.out)
	                 Result.append (".")
	                 Result.append (i2.out+")")
                end
                if debug_flag = true then
				    Result.append(", debug, error")
				else
				    Result.append(", normal, error")
				end
				Result.append("%N")
	        	Result.append("  Command can only be used in setup mode (excluding summary in setup).")
	        	flag.replace_blank  -- reset the flag
	        elseif flag ~ "outofselect" then
	        	Result.append ("state:")
                if in_game = false and setup_mode = false then
                	Result.append ("not started")
                else
                	Result.append (selected)
                end
                if in_game then
                	 --Result.append ("in game")
                     Result.append ("(")
	                 Result.append (i.out)
	                 Result.append (".")
	                 Result.append (i2.out+")")
                end
                if debug_flag = true then
				    Result.append(", debug, error")
				else
				    Result.append(", normal, error")
				end
				Result.append("%N")
	        	Result.append("  Menu option selected out of range.")
	        	flag.replace_blank  -- reset the flag
	        elseif flag ~ "moveout" then
	        	Result.append ("state:")
                if in_game = false and setup_mode = false then
                	Result.append ("not started")
                else
                	Result.append (selected)
                end
                if in_game then
                	 --Result.append ("in game")
                     Result.append ("(")
	                 Result.append (i.out)
	                 Result.append (".")
	                 Result.append (i2.out+")")
                end
                if debug_flag = true then
				    Result.append(", debug, error")
				else
				    Result.append(", normal, error")
				end
	        	    Result.append ("%N")
	        	    Result.append ("  Cannot move outside of board.")
	        	flag.replace_blank  -- reset the flag
	        elseif flag ~ "alreadythere" then
	        	Result.append ("state:")
                if in_game = false and setup_mode = false then
                	Result.append ("not started")
                else
                	Result.append (selected)
                end
                if in_game then
                	 --Result.append ("in game")
                     Result.append ("(")
	                 Result.append (i.out)
	                 Result.append (".")
	                 Result.append (i2.out+")")
                end
                if debug_flag = true then
				    Result.append(", debug, error")
				else
				    Result.append(", normal, error")
				end
	        	    Result.append ("%N")
	        	    Result.append ("  Already there.")
	        	    flag.replace_blank  -- reset the flag
	        elseif flag ~ "moresteps" then
	        	Result.append ("state:")
                if in_game = false and setup_mode = false then
                	Result.append ("not started")
                else
                	Result.append (selected)
                end
                if in_game then
                	 --Result.append ("in game")
                     Result.append ("(")
	                 Result.append (i.out)
	                 Result.append (".")
	                 Result.append (i2.out+")")
                end
                if debug_flag = true then
				    Result.append(", debug, error")
				else
				    Result.append(", normal, error")
				end
	        	    Result.append ("%N")
	        	    Result.append ("  Out of movement range.")
	        	    flag.replace_blank  -- reset the flag
	        elseif flag ~ "lessresource" then
	        	    Result.append ("state:")
                if in_game = false and setup_mode = false then
                	Result.append ("not started")
                else
                	Result.append (selected)
                end
                if in_game then
                	 --Result.append ("in game")
                     Result.append ("(")
	                 Result.append (i.out)
	                 Result.append (".")
	                 Result.append (i2.out+")")
                end
                if debug_flag = true then
				    Result.append(", debug, error")
				else
				    Result.append(", normal, error")
				end
	        	    Result.append ("%N")
	        	    Result.append ("  Not enough resources to move.")
	        	    flag.replace_blank  -- reset the flag
	        elseif flag ~ "lessresourcefire" then
	        	Result.append ("state:")
                if in_game = false and setup_mode = false then
                	Result.append ("not started")
                else
                	Result.append (selected)
                end
                if in_game then
                	 --Result.append ("in game")
                     Result.append ("(")
	                 Result.append (i.out)
	                 Result.append (".")
	                 Result.append (i2.out+")")
                end
                if debug_flag = true then
				    Result.append(", debug, error")
				else
				    Result.append(", normal, error")
				end
	        	    Result.append ("%N")
	        	    Result.append ("  Not enough resources to fire.")
	        	    flag.replace_blank  -- reset the flag
	        elseif flag ~ "lessresourcesspec" then
	        	Result.append ("state:")
                if in_game = false and setup_mode = false then
                	Result.append ("not started")
                else
                	Result.append (selected)
                end
                if in_game then
                	 --Result.append ("in game")
                     Result.append ("(")
	                 Result.append (i.out)
	                 Result.append (".")
	                 Result.append (i2.out+")")
                end
                if debug_flag = true then
				    Result.append(", debug, error")
				else
				    Result.append(", normal, error")
				end
	        	    Result.append ("%N")
	        	    Result.append ("  Not enough resources to use special.")
	        	    flag.replace_blank  -- reset the flag
	        elseif flag ~ "insetup" then
	        	Result.append ("state:")
                if in_game = false and setup_mode = false then
                	Result.append ("not started")
                else
                	Result.append (selected)
                end
                if in_game then
                	 --Result.append ("in game")
                     Result.append ("(")
	                 Result.append (i.out)
	                 Result.append (".")
	                 Result.append (i2.out+")")
                end
                if debug_flag = true then
				    Result.append(", debug, error")
				else
				    Result.append(", normal, error")
				end
	        	    Result.append ("%N")
	        	    Result.append ("  Already in setup mode.")
	        	    flag.replace_blank  -- reset the flag
	        elseif flag ~ "ingame" then
	        	Result.append ("state:")
                if in_game = false and setup_mode = false then
                	Result.append ("not started")
                else
                	Result.append (selected)
                end
                if in_game then
                	 --Result.append ("in game")
                     Result.append ("(")
	                 Result.append (i.out)
	                 Result.append (".")
	                 Result.append (i2.out+")")
                end
                if debug_flag = true then
				    Result.append(", debug, error")
				else
				    Result.append(", normal, error")
				end
	        	    Result.append ("%N")
	        	    Result.append ("  Already in a game. Please abort to start a new one.")
	        	    flag.replace_blank  -- reset the flag
	        elseif flag ~ "noorder" then
	        	Result.append ("state:")
                if in_game = false and setup_mode = false then
                	Result.append ("not started")
                else
                	Result.append (selected)
                end
                if in_game then
                	 --Result.append ("in game")
                     Result.append ("(")
	                 Result.append (i.out)
	                 Result.append (".")
	                 Result.append (i2.out+")")
                end
                if debug_flag = true then
				    Result.append(", debug, error")
				else
				    Result.append(", normal, error")
				end
	        	    Result.append ("%N")
	        	    Result.append ("  Threshold values are not non-decreasing.")
	        	    flag.replace_blank  -- reset the flag
		    else
				create Result.make_from_string ("  ")
				Result.append ("state:not started, normal, ok")
				Result.append ("%N")
				Result.append ("  Welcome to Space Defender Version 2.")
		   end
		end

end




