all:	zip2state.yaml state2tz.yaml US.pm

zip2state.yaml:
	./zip2state.pl > zip2state.yaml

state2tz.yaml:
	wget http://en.wikipedia.org/wiki/List_of_U.S._states_by_time_zone
	./state2tz.pl < List_of_U.S._states_by_time_zone > state2tz.yaml

US.pm:
	./generate_module.pl state2tz.yaml > US.pm

lib:	US.pm
	mkdir -p lib/DateTime/TimeZone/FromState
	cp US.pm lib/DateTime/TimeZone/FromState/US.pm

test:	lib
	prove -l t/test.t

clean:
	rm -r US.pm lib

distclean:
	rm -r US.pm lib *.yaml List_of_U.S._states_by_time_zone
