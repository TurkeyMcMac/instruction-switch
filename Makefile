executable = instrswitch

main = instrswitch.rb
other-sources = src/*.rb

$(executable): $(main) $(other-sources)
	awk -f generate-executable.awk $< > $@ && chmod +x $@

.PHONY: clean
clean:
	$(RM) $(executable)
