note
	description: "[
		This class represents the combination of test cases of units (classes) related to Lab1.
	]"
	author: "Jinho Hwang and Jackie Wang"
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT

inherit

	ES_SUITE -- testing via ESpec

create
	make

feature {NONE} -- Initialization

	make
			-- Run app
		do
			add_test (create {STARTER_TESTS}.make)

			show_browser
			run_espec
		end

end
